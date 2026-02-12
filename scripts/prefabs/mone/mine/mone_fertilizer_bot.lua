---
--- @author zsh in 2025/02/12
--- 施肥瓦器人 - 可移动的自动施肥机器人
---

local assets =
{
    Asset("ANIM", "anim/storage_robot.zip"),
    Asset("ANIM", "anim/storage_robot_med.zip"),
    Asset("ANIM", "anim/storage_robot_small.zip"),
    Asset("ANIM", "anim/ui_chest_3x3.zip"),
    -- Asset("INV_IMAGE", "storage_robot"), -- TODO: 需要创建贴图文件
    Asset("MINIMAP_IMAGE", "storage_robot_broken"),
}

local prefabs =
{
    "collapse_small",
}

local brain = require "brains/mone_fertilizer_bot_brain"
local constants = require("more_items_constants")

local NUM_FUELED_SECTIONS = 5
local SECTION_MED = 2
local SECTION_SMALL = 1

local VISUAL_SCALE = 1.05
local LIGHT_LIGHTOVERRIDE = 0.5

--- 扫描周围需要施肥的目标
local function ScanForFertilizationTargets(inst)
    if inst.components.fueled:IsEmpty() then
        return {}
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    local targets = {}
    local range = constants.MONE_FERTILIZER_BOT__RANGE

    for _, ent in ipairs(TheSim:FindEntities(x, y, z, range)) do
        -- 判断是否需要施肥
        if (ent.components.pickable and ent.components.pickable:IsBarren()) or
           (ent.components.grower and ent.components.grower.cycles_left == 0) then
            table.insert(targets, ent)
        end
    end

    -- 按距离排序
    table.sort(targets, function(a, b)
        return inst:GetDistanceSqTo(a) < inst:GetDistanceSqTo(b)
    end)

    return targets
end

--- 直接对目标施肥
local function FertilizeTarget(inst, target)
    if not target.components.fertilizable then
        return false
    end

    -- 从容器中获取肥料
    local item = inst.components.container:FindItem(function(item)
        return item:HasTag("mone_fertilizer_bot_fertilizer")
    end)

    if not item then
        return false
    end

    -- 直接对目标使用肥料
    local success = target.components.fertilizable:Fertilize(item, inst)

    if success then
        -- 消耗肥料和耐久
        inst.components.container:ConsumeByName(item.prefab, 1)
        inst.components.fueled:DoDelta(-constants.MONE_FERTILIZER_BOT__FUEL_DRAIN_RATE)
        return true
    end

    return false
end

--- 设置为破损状态
local function SetBroken(inst)
    inst:AddTag("broken")
    RemovePhysicsColliders(inst)
    inst.MiniMapEntity:SetIcon("storage_robot_broken.png")
    inst.components.inventoryitem:ChangeImageName("storage_robot_broken")
end

--- 燃料耗尽回调
local function OnBroken(inst)
    inst:SetBroken()
    if not inst.components.inventoryitem:IsHeld() and inst.sg.currentstate.name ~= "washed_ashore" then
        inst.sg:GoToState("breaking")
    end
end

--- 修复回调
local function OnRepaired(inst)
    inst:RemoveTag("broken")
    if inst.sg:HasStateTag("broken") then
        inst.sg:GoToState(inst.components.inventoryitem:IsHeld() and "idle" or "repairing_pre")
    end
end

--- 获取状态文本
local function GetStatus(inst)
    return inst.components.fueled:IsEmpty() and "BROKEN" or nil
end

--- 定期更新燃料消耗率（基于潮湿度）
local function OnUpdateFueled(inst)
    local moisture = inst.components.inventoryitem:GetMoistureClamped()
    local moisture_pct = moisture / TUNING.MAX_WETNESS

    inst.components.fueled.rate = 1 + moisture_pct

    -- 潮湿时产生火花效果
    if moisture_pct <= 0 then
        return
    end

    if inst._last_spark_time == nil or
       (inst._last_spark_time + 3 + (1 - moisture_pct) * 7 <= GetTime()) then
        inst._last_spark_time = GetTime()
        SpawnPrefab("sparks").Transform:SetPosition(inst.Transform:GetWorldPosition())
    end
end

--- 燃料段变化回调
local function FueledSectionCallback(newsection, oldsection, inst)
    if newsection <= SECTION_SMALL then
        inst.AnimState:SetBuild("storage_robot_small")
        inst.components.locomotor.walkspeed = constants.MONE_FERTILIZER_BOT__WALK_SPEED * 0.6
        inst.Physics:SetMass(10)
    elseif newsection <= SECTION_MED then
        inst.AnimState:SetBuild("storage_robot_med")
        inst.components.locomotor.walkspeed = constants.MONE_FERTILIZER_BOT__WALK_SPEED * 0.8
        inst.Physics:SetMass(30)
    elseif newsection >= NUM_FUELED_SECTIONS then
        inst.components.locomotor.walkspeed = constants.MONE_FERTILIZER_BOT__WALK_SPEED
        inst.Physics:SetMass(50)
        ChangeToCharacterPhysics(inst)
        inst.MiniMapEntity:SetIcon("storage_robot.png")
        inst.components.inventoryitem:ChangeImageName()
        if not inst.sg:HasStateTag("broken") or inst.components.inventoryitem:IsHeld() then
            inst.AnimState:SetBuild("storage_robot")
        end
    end
end

--- 获取当前段质量
local function GetFueledSectionMass(inst)
    local section = inst.components.fueled:GetCurrentSection()
    if section <= SECTION_SMALL then
        return 10
    elseif section <= SECTION_MED then
        return 30
    else
        return 50
    end
end

--- 获取当前段后缀
local function GetFueledSectionSuffix(inst)
    local section = inst.components.fueled:GetCurrentSection()
    if section == SECTION_SMALL then
        return "_small"
    elseif section == SECTION_MED then
        return "_med"
    else
        return ""
    end
end

--- 放下时逻辑
local function DoOnDroppedLogic(inst)
    local drownable = inst.components.drownable
    if drownable and drownable:CheckDrownable() then
        return
    end

    inst.sg:GoToState(inst.components.fueled:IsEmpty() and "idle_broken" or "idle", true)
end

--- 放下回调
local function OnDropped(inst)
    inst:DoTaskInTime(0, DoOnDroppedLogic)
end

--- 拾起回调
local function OnPickup(inst)
    inst.sg:GoToState("idle", true)

    if inst.brain ~= nil then
        inst.brain:UnignoreItem()
    end

    inst.components.fueled:StopConsuming()
    inst.components.locomotor:Stop()
    inst.components.locomotor:Clear()
    inst:ClearBufferedAction()
    inst.SoundEmitter:KillAllSounds()
end

--- 加载回调
local function OnLoad(inst, data)
    if inst.components.fueled:IsEmpty() then
        inst:SetBroken()
        inst.sg:GoToState("idle_broken")
    end
end

--- 睡眠时传送回家
local function DoSleepTeleport(inst)
    if inst._sleepteleporttask then
        inst._sleepteleporttask:Cancel()
        inst._sleepteleporttask = nil
    end

    if inst:IsInLimbo() or inst.components.fueled:IsEmpty() or inst.sg:HasAnyStateTag("drowning", "falling") then
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
    if inst:IsInLimbo() or inst.components.fueled:IsEmpty() or inst.sg:HasAnyStateTag("drowning", "falling") then
        return
    end

    inst.components.fueled:StopConsuming()
    inst.SoundEmitter:KillAllSounds()

    if inst.brain ~= nil then
        inst.brain:UnignoreItem()
    end

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
        local x, y, z = data.pos:Get()
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
    inst.components.fueled:SetPercent(0)
    inst.sg:GoToState("idle_broken")
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
    inst.GetFueledSectionMass = GetFueledSectionMass
    inst.GetFueledSectionSuffix = GetFueledSectionSuffix
    inst.SetBroken = SetBroken
    inst.OnInventoryChange = OnInventoryChange

    -- 组件
    inst:AddComponent("knownlocations")

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus

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

    inst:AddComponent("locomotor")
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = true }
    inst.components.locomotor.walkspeed = constants.MONE_FERTILIZER_BOT__WALK_SPEED

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.MAGIC
    inst.components.fueled:InitializeFuelLevel(constants.MONE_FERTILIZER_BOT__BATTERY_MAX)
    inst.components.fueled:SetDepletedFn(OnBroken)
    inst.components.fueled:SetUpdateFn(OnUpdateFueled)
    inst.components.fueled:SetSectionCallback(FueledSectionCallback)
    inst.components.fueled:SetSections(NUM_FUELED_SECTIONS)
    inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)

    inst:AddComponent("forgerepairable")
    inst.components.forgerepairable:SetRepairMaterial(FORGEMATERIALS.WAGPUNKBITS)
    inst.components.forgerepairable:SetOnRepaired(OnRepaired)

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
