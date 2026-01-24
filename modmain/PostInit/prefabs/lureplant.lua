---
--- DateTime: 2025/11/5 20:30
---

local function generate_GiveItem(old_fn)
    if old_fn == nil then
        return old_fn
    end
    return function(self, item, slot, src_pos, ...)
        if item == nil or not item:IsValid()
                or item.components.stackable == nil then
            return old_fn(self, item, slot, src_pos, ...)
        end

        TheWorld:PushEvent("rmi_collect_items", {
            item = item
        })

        -- 如果 item 是完完整整的塞到容器中的，即未发生质变，那么不必再执行了
        if item.rmi_is_unvaried_item then
            item.rmi_is_unvaried_item = nil
            return false
        end

        return old_fn(self, item, slot, src_pos, ...)
    end
end

env.AddPrefabPostInit("lureplant", function(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    -- 修改 inventory 组件的 GiveItem 函数，把物品直接塞到那个食人花宝箱里面（前提是还能塞进去）
    -- 由于我需要先触发事件，即需要先执行操作再进行 GiveItem，那么模组优先级是否存在影响呢？
    inst.components.inventory.GiveItem = generate_GiveItem(inst.components.inventory.GiveItem)
end)

