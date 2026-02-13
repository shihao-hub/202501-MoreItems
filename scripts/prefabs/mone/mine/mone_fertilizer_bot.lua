---
--- @author zsh in 2025/02/12
--- 施肥瓦器人 - 可移动的自动施肥机器人
---

local assets =
{
    Asset("ANIM", "anim/storage_robot.zip"),
    Asset("ANIM", "anim/ui_chest_3x3.zip"),
    Asset("INV_IMAGE", "storage_robot"),
}

local prefabs =
{
    "collapse_small",
}

local brain = require "brains/mone_fertilizer_bot_brain"
local constants = require("more_items_constants")

local VISUAL_SCALE = 1.05

--- 扫描周围需要施肥的目标（移植的植物）
local function ScanForFertilizationTargets(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local targets = {}
    local range = constants.MONE_FERTILIZER_BOT__RANGE

    for _, ent in ipairs(TheSim:FindEntities(x, y, z, range)) do
        -- 只对移植的植物施肥（浆果丛、草、树枝等）
        if ent.components.pickable
           and ent.components.pickable.IsBarren
           and ent.components.pickable:IsBarren() then
            table.insert(targets, ent)
        end
    end

    -- 按距离排序
    table.sort(targets, function(a, b)
        return inst:GetDistanceSqToInst(a) < inst:GetDistanceSqToInst(b)
    end)

    return targets
end

--- 直接对目标施肥（只对移植植物）
local function FertilizeTarget(inst, target)
    if target == nil or not target:IsValid() then
        return false
    end

    -- 从容器中获取肥料
    local item = inst.components.container:FindItem(function(item)
        return item:HasTag("mone_fertilizer_bot_fertilizer")
    end)

    if not item then
        return false
    end

    -- 只对移植的植物施肥（浆果丛、草、树枝等）
    if not (target.components.pickable 
       and target.components.pickable.IsBarren 
       and target.components.pickable:IsBarren() 
       and target.components.pickable.Fertilize) then
        return false
    end

    local success = target.components.pickable:Fertilize(item, inst)

    if success then
        print(string.format("[MoneFertilizerBot] Fertilized %s", target.prefab or "unknown"))
        -- 只消耗肥料
        inst.components.container:ConsumeByName(item.prefab, 1)
    end

    return success
end

--- 放下时逻辑
local function DoOnDroppedLogic(inst)
    local drownable = inst.components.drownable
    if drownable and drownable:CheckDrownable() then
        return
    end

    -- 每次放下时更新出生点位置（home）
    if inst.components.knownlocations then
        local x, y, z = inst.Transform:GetWorldPosition()
        inst.components.knownlocations:RememberLocation("spawnpoint", Vector3(x, y, z))
    end

    inst.sg:GoToState("idle", true)
end

--- 放下回调
local function OnDropped(inst)
    inst:DoTaskInTime(0, DoOnDroppedLogic)
end

--- 拾起回调
local function OnPickup(inst)
    inst.sg:GoToState("idle", true)

    inst.components.locomotor:Stop()
    inst.components.locomotor:Clear()
    inst:ClearBufferedAction()
    inst.SoundEmitter:KillAllSounds()
end

--- 加载回调
local function OnLoad(inst, data)
    -- 不再需要处理破损状态
end

--- 睡眠时传送回家
local function DoSleepTeleport(inst)
    if inst._sleepteleporttask then
        inst._sleepteleporttask:Cancel()
        inst._sleepteleporttask = nil
    end

    if inst:IsInLimbo() or inst.sg:HasAnyStateTag("drowning", "falling") then
        return
    end

    -- 传送到出生点
    if inst.components.knownlocations and inst.components.knownlocations:GetLocation("spawnpoint") then
        local pos = inst.components.knownlocations:GetLocation("spawnpoint")
        inst.Physics:Teleport(pos.x, 0, pos.z)
    end
end

--- 实体睡眠回调
local function OnEntitySleep(inst)
    if inst:IsInLimbo() or inst.sg:HasAnyStateTag("drowning", "falling") then
        return
    end

    inst.SoundEmitter:KillAllSounds()

    if inst._sleepteleporttask == nil then
        inst._sleepteleporttask = inst:DoTaskInTime(0, DoSleepTeleport)
    end
end

--- 实体唤醒回调
local function OnEntityWake(inst)
    if inst._sleepteleporttask ~= nil then
        inst._sleepteleporttask:Cancel()
        inst._sleepteleporttask = nil
    end
end

--- 到达目的地回调
local function OnReachDestination(inst, data)
    if data.pos == nil or data.target == nil then
        return
    end

    if data.target.components.inventoryitem ~= nil and data.target.components.container == nil then
        local x, _, z = data.pos:Get()
        inst.Physics:Teleport(x, 0, z)
    end
end

--- 溺水伤害回调
local function OnTakeDrowningDamage(inst)
    if inst.components.knownlocations then
        local pos = inst.components.knownlocations:GetLocation("spawnpoint")
        if pos then
            inst.Transform:SetPosition(pos.x, 0, pos.z)
        end
    end
    inst.components.inventoryitem:MakeMoistureAtLeast(TUNING.MAX_WETNESS)
end

--- 容器物品变更回调（用于检查是否有肥料）
local function OnInventoryChange(inst)
    -- 可以在这里添加UI更新逻辑
end

--------------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 50, 0.4)

    inst.Transform:SetFourFaced()

    inst.MiniMapEntity:SetIcon("storage_robot.png")
    inst.MiniMapEntity:SetPriority(5)

    inst.DynamicShadow:SetSize(2.8, 1.7)

    inst:AddTag("companion")
    inst:AddTag("NOBLOCK")
    inst:AddTag("scarytoprey")
    inst:AddTag("mone_fertilizer_bot")
    inst:AddTag("irreplaceable")

    inst.AnimState:SetBank("storage_robot")
    inst.AnimState:SetBuild("storage_robot")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetScale(VISUAL_SCALE, VISUAL_SCALE)
    inst.AnimState:SetFinalOffset(1)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.ScanForFertilizationTargets = ScanForFertilizationTargets
    inst.FertilizeTarget = FertilizeTarget
    inst.OnInventoryChange = OnInventoryChange

    -- 组件
    inst:AddComponent("knownlocations")

    inst:AddComponent("inspectable")

    inst:AddComponent("drownable")
    inst.components.drownable:SetOnTakeDrowningDamageFn(OnTakeDrowningDamage)

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("mone_fertilizer_bot")

    inst:AddComponent("inventory")
    inst.components.inventory.maxslots = 1

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.nobounce = true
    inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
    inst.components.inventoryitem:SetOnPickupFn(OnPickup)
    inst.components.inventoryitem.imagename = "storage_robot"
    inst.components.inventoryitem.atlasname = "images/inventoryimages3.xml"

    inst:AddComponent("locomotor")
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = true }
    inst.components.locomotor.walkspeed = constants.MONE_FERTILIZER_BOT__WALK_SPEED

    inst:SetStateGraph("SGmone_fertilizer_bot")
    inst:SetBrain(brain)

    inst:ListenForEvent("onreachdestination", OnReachDestination)
    inst:ListenForEvent("itemget", OnInventoryChange)
    inst:ListenForEvent("itemlose", OnInventoryChange)
    inst.OnLoad = OnLoad
    inst.OnEntitySleep = OnEntitySleep
    inst.OnEntityWake = OnEntityWake

    MakeHauntable(inst)

    return inst
end

return Prefab("mone_fertilizer_bot", fn, assets, prefabs)
