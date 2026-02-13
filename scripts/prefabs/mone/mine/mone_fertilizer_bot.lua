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
    Asset("INV_IMAGE", "storage_robot"),
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

-- 常见肥料列表（可以自动获取）
local COMMON_FERTILIZERS = {
    poop = true,           -- 便便
    guano = true,          -- 鸟粪
    rottenegg = true,      -- 臭蛋
    fertilizer = true,     -- 桶装便便
    compostwrap = true,    -- 堆肥包
}

--- 检查是否是常见肥料
local function IsCommonFertilizer(item)
    if item == nil or not item:IsValid() then
        return false
    end
    return COMMON_FERTILIZERS[item.prefab] == true
end

--- 检查容器是否可以被搜索
local function IsValidContainer(ent, inst)
    -- 必须有效且可见
    if ent == nil or not ent:IsValid() or ent:IsInLimbo() then
        return false
    end
    
    -- 必须有 container 组件
    if ent.components.container == nil then
        return false
    end
    
    -- 排除自己
    if ent == inst then
        return false
    end
    
    -- 排除玩家身上的容器（背包、物品栏等）
    if ent:HasTag("player") then
        return false
    end
    
    -- 排除被玩家持有的容器
    if ent.components.inventoryitem and ent.components.inventoryitem:IsHeld() then
        return false
    end
    
    -- 排除不可见的容器（如某些特殊容器）
    if ent:HasTag("NOCLICK") or ent:HasTag("FX") then
        return false
    end
    
    -- 排除私人容器
    if ent.components.container.opener ~= nil then
        return false
    end
    
    return true
end

--- 扫描周围需要施肥的目标（移植的植物）
local function ScanForFertilizationTargets(inst)
    if inst.components.fueled:IsEmpty() then
        return {}
    end

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

--- 扫描周围可用的容器并获取肥料
local function ScanAndFetchFertilizer(inst)
    if inst.components.fueled:IsEmpty() then
        return nil, nil
    end
    
    -- 检查自己的容器是否已满
    if inst.components.container:IsFull() then
        return nil, nil
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    local range = constants.MONE_FERTILIZER_BOT__RANGE
    
    -- 搜索周围容器
    local containers = {}
    for _, ent in ipairs(TheSim:FindEntities(x, y, z, range, nil, nil, {"structure", "chest"})) do
        if IsValidContainer(ent, inst) then
            table.insert(containers, ent)
        end
    end
    
    -- 按距离排序
    table.sort(containers, function(a, b)
        return inst:GetDistanceSqToInst(a) < inst:GetDistanceSqToInst(b)
    end)
    
    -- 遍历容器查找常见肥料
    for _, container in ipairs(containers) do
        local fertilizer = container.components.container:FindItem(IsCommonFertilizer)
        if fertilizer then
            return container, fertilizer
        end
    end
    
    return nil, nil
end

--- 从容器中取出肥料放入自己的容器
local function TakeFertilizerFromContainer(inst, container, fertilizer)
    if container == nil or fertilizer == nil then
        return false
    end
    
    if not container:IsValid() or not fertilizer:IsValid() then
        return false
    end
    
    -- 再次检查是否是常见肥料
    if not IsCommonFertilizer(fertilizer) then
        return false
    end
    
    -- 从容器中移除肥料
    local item = container.components.container:RemoveItem(fertilizer, false)
    if item == nil then
        return false
    end
    
    -- 放入自己的容器
    local success = inst.components.container:GiveItem(item)
    if not success then
        -- 如果放不进去，放回原容器
        container.components.container:GiveItem(item)
        return false
    end
    
    print(string.format("[MoneFertilizerBot] Fetched %s from %s", item.prefab, container.prefab or "container"))
    return true
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
        -- 消耗肥料和耐久
        inst.components.container:ConsumeByName(item.prefab, 1)
        inst.components.fueled:DoDelta(-constants.MONE_FERTILIZER_BOT__FUEL_DRAIN_RATE)
    end

    return success
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

    -- 每次放下时更新出生点位置（home）
    if inst.components.knownlocations then
        local x, y, z = inst.Transform:GetWorldPosition()
        inst.components.knownlocations:RememberLocation("spawnpoint", Vector3(x, y, z))
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
    inst.ScanAndFetchFertilizer = ScanAndFetchFertilizer
    inst.TakeFertilizerFromContainer = TakeFertilizerFromContainer
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
    inst.components.inventoryitem.imagename = "storage_robot"
    inst.components.inventoryitem.atlasname = "images/inventoryimages3.xml"

    inst:AddComponent("locomotor")
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = true }
    inst.components.locomotor.walkspeed = constants.MONE_FERTILIZER_BOT__WALK_SPEED

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.MAGIC
    inst.components.fueled:InitializeFuelLevel(constants.MONE_FERTILIZER_BOT__BATTERY_MAX)
    inst.components.fueled:SetDepletedFn(OnBroken)
    -- TODO: 检查潮湿加速机制是否需要
    -- inst.components.fueled:SetUpdateFn(OnUpdateFueled)
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
