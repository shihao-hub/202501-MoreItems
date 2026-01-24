---
--- DateTime: 2025/11/5 20:24
---

local assets = {
    Asset("ANIM", "anim/eyeplant_trap.zip"),
    Asset("ANIM", "anim/meat_rack_food.zip"),
    Asset("SOUND", "sound/plant.fsb"),
    Asset("MINIMAP_IMAGE", "eyeplant"),
}

local prefabs = {
    "eyeplant",
    "lureplantbulb",
    "plantmeat",
}

---
---事件监听，收集食人花肚子内的物资
---
local function collect_items(inst, data)
    if data == nil then
        return
    end
    local item = data.item

    -- 由于是事件驱动，最好加个这个判断
    if item == nil or not item:IsValid() then
        return
    end

    -- 主要目的是，不想要存放不可堆叠的物品，因为空间有限
    if item.components.stackable == nil then
        return
    end

    -- 最重要的判断：如果 item 是完完整整的塞到容器中的，即未发生质变，那么对于它的操作都应该终止（这个太绕了...）
    if item.rmi_is_unvaried_item then
        return
    end

    local container = inst.components.container

    local can_accept_count = container:CanAcceptCount(item)
    local item_stacksize = item.components.stackable ~= nil and item.components.stackable:StackSize() or 1

    if can_accept_count <= 0 then
        return
    end

    if can_accept_count >= item_stacksize then
        -- 如果存的下，就塞到容器中，这里存在以下情况：
        -- 1. item 全部 Put 到容器中本就有的物品上，那么 item 属于 Remove 状态
        -- 2. item 并没有全部 Put 到容器中本来就有的物品上，最终仍独占一格，此时 item 只是数量发生了变化
        item.rmi_is_unvaried_item = true
        container:GiveItem(item)
        if item == nil or not item:IsValid() then
            if item ~= nil then
                item.rmi_is_unvaried_item = nil
            end
        end
    else
        -- 如果存不下，取出来能存下的部分，剩下的 item 无需处理，让它正常走下去
        if item.components.stackable ~= nil then
            local can_accept_item = item.components.stackable:Get(can_accept_count)
            container:GiveItem(can_accept_item)
        end
    end

end

local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    inst.components.lootdropper:DropLoot()
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
    end
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("eyeplant.png")

    inst.AnimState:SetBank("eyeplant_trap")
    inst.AnimState:SetBuild("eyeplant_trap")
    inst.AnimState:PlayAnimation("idle_hidden", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        local old_OnEntityReplicated = inst.OnEntityReplicated

        inst.OnEntityReplicated = function(inst)
            if old_OnEntityReplicated then
                old_OnEntityReplicated(inst)
            end
            if inst and inst.replica and inst.replica.container then
                inst.replica.container:WidgetSetup("rmi_lureplant")
            end
        end
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("rmi_lureplant")

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)

    inst:ListenForEvent("rmi_collect_items", function(world, data)
        collect_items(inst, data, world)
    end, TheWorld)

    return inst
end

return Prefab("rmi_lureplant", fn, assets, prefabs),
MakePlacer("rmi_lureplant_placer", "eyeplant_trap", "eyeplant_trap", "idle_hidden")