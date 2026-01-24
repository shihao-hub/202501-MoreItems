---
--- DateTime: 2025/11/4 17:34
---

--[[ 可以使用弹性空间制造器升级，但是升级后将无法被摧毁 ]]

local upgradable_chests = {
    "mone_treasurechest",
    "mone_dragonflychest",
    "mone_icebox",
    "mone_saltbox",
    "mie_bear_skin_cabinet",
    "mie_fish_box",
    "rmi_lureplant",
}


local function DoUpgradeVisuals(inst)
    if inst.prefab == "mone_treasurechest" then
        local skin_name = (inst.AnimState:GetSkinBuild() or ""):gsub("treasurechest_", "")
        inst.AnimState:SetBank("chest_upgraded")
        inst.AnimState:SetBuild("treasure_chest_upgraded")
        if skin_name ~= "" then
            skin_name = "treasurechest_upgraded_" .. skin_name
            inst.AnimState:SetSkin(skin_name, "treasure_chest_upgraded")
        end
    elseif inst.prefab == "mone_dragonflychest" then
        local skin_name = (inst.AnimState:GetSkinBuild() or ""):gsub("dragonflychest_", "")
        inst.AnimState:SetBank("dragonfly_chest_upgraded")
        inst.AnimState:SetBuild("dragonfly_chest_upgraded")
        if skin_name ~= "" then
            skin_name = "dragonflychest_upgraded_" .. skin_name
            inst.AnimState:SetSkin(skin_name, "dragonfly_chest_upgraded")
        end
    else
        -- do nothing
    end
end

local function regular_getstatus(inst, viewer)
    return inst._chestupgrade_stacksize and "UPGRADED_STACKSIZE" or nil
end

local function OnUpgrade(inst, performer, upgraded_from_item)
    local numupgrades = inst.components.upgradeable.numupgrades
    -- todo: 确定一下 numupgrades 在做什么
    if numupgrades == 1 then
        inst._upgrated = true
        inst._chestupgrade_stacksize = true
        if inst.components.container ~= nil then
            inst.components.container:Close()
            inst.components.container:EnableInfiniteStackSize(true)
            inst.components.inspectable.getstatus = regular_getstatus
        end

        -- 生成特效（万物打包打包的时候，特效会在原位置生成...）
        -- local x, y, z = inst.Transform:GetWorldPosition()
        -- local fx = SpawnPrefab("chestupgrade_stacksize_fx")
        -- fx.Transform:SetPosition(x, y, z)

        DoUpgradeVisuals(inst)

        -- 设置不允许被摧毁
        if inst.components.workable then
            local old_Destroy = inst.components.workable.Destroy
            function inst.components.workable:Destroy(destroyer)
                if self.inst._upgrated then
                    return
                end
                return old_Destroy(self, destroyer)
            end

            -- 设置了这个之后，上面的 Destroy 似乎没必要设置了
            inst.components.workable.workable = false
        end


        -- 设置名字
        local suffix = STRINGS.NAMES[string.upper(inst.prefab)] or "MISSING NAME"
        if inst.name and not string.find(inst.name, "弹性升级·") then
            suffix = inst.name
        end
        inst.components.named:SetName("弹性升级·".. suffix)
    end

    inst.components.upgradeable.upgradetype = nil

    if inst.components.lootdropper ~= nil then
        inst.components.lootdropper:SetLoot({ "alterguardianhatshard" })
    end
end

local function replaceOnSave(inst)
    local old = inst.OnSave
    inst.OnSave = function(inst, data)
        if old then old(inst, data) end
        data._upgrated = inst._upgrated
    end
end

local function replaceOnLoad(inst)
    local old = inst.OnLoad
    inst.OnLoad = function(inst, data)
        if old then old(inst, data) end
        if data == nil then return end
        inst._upgrated = data._upgrated
        if inst._upgrated then
            if inst.components.upgradeable ~= nil and inst.components.upgradeable.numupgrades > 0 then
                OnUpgrade(inst)
            end
        end
    end
end



for _, name in ipairs(upgradable_chests) do
    env.AddPrefabPostInit(name, function(inst)
        if not TheWorld.ismastersim then
            return
        end

        if inst.components.named == nil then
            inst:AddComponent("named")
        end

        local upgradeable = inst:AddComponent("upgradeable")
        upgradeable.upgradetype = UPGRADETYPES.CHEST
        upgradeable:SetOnUpgradeFn(OnUpgrade)

        inst._upgrated = nil

        replaceOnSave(inst)
        replaceOnLoad(inst)
    end)
end