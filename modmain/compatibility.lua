---
--- @author zsh in 2023/1/14 20:26
---

local config_data = TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA;

-- 25/05/28: 兼容岛屿冒险
local function compatible_island_adventures()
    local ContainerReplica = require("components/container_replica")
    local old_WidgetSetup = ContainerReplica.WidgetSetup
    function ContainerReplica:WidgetSetup(prefab, data, ...)
        -- 岛屿冒险未进行判空处理
        if self.classified ~= nil and self.classified.InitializeBoatEquipSlots == nil then
            self.classified.InitializeBoatEquipSlots = function() end
        end
        old_WidgetSetup(self, prefab, data, ...)
    end
end

compatible_island_adventures()

--[[ Show Me ]]
do
    local comm = { "treasurechest", true };
    ---@type table<string,table[]>
    local t = {
        ["mone_waterchest"] = comm,

        ["mone_storage_bag"] = comm,
        ["mone_tool_bag"] = comm,
        ["mone_piggybag"] = comm,

        ["mone_backpack"] = comm,
        ["mone_piggyback"] = comm,
        ["mone_icepack"] = comm,
        ["mone_spicepack"] = comm,
        ["mone_candybag"] = comm,

        ["mone_wathgrithr_box"] = comm,
        ["mone_wanda_box"] = comm,

        ["mone_firesuppressor"] = comm,

        ["mone_treasurechest"] = comm,
        ["mone_dragonflychest"] = comm,
        ["mone_icebox"] = comm,
        ["mone_saltbox"] = comm,

        ["mone_wardrobe"] = comm,
        ["mone_arborist"] = comm,

        ["mone_nightspace_cape"] = comm,

        ["mone_seasack"] = comm,
        ["mone_seedpouch"] = comm,

        ["mone_skull_chest"] = comm,

        ["mie_granary_meats"] = comm,
        ["mie_granary_greens"] = comm,
        ["mie_watersource"] = comm,
        ["mie_sand_pit"] = comm,
        ["mie_bear_skin_cabinet"] = comm,
        ["mie_new_granary"] = comm,
        ["mie_fish_box"] = comm,
    };

    --遍历已开启的mod
    for _, mod in pairs(ModManager.mods) do
        if mod and mod.SHOWME_STRINGS then
            for k, v in pairs(t) do
                if v[2] then
                    mod.postinitfns.PrefabPostInit[k] = mod.postinitfns.PrefabPostInit[v[1]];
                end
            end
        end
    end

    TUNING.MONITOR_CHESTS = TUNING.MONITOR_CHESTS or {};
    for k, v in pairs(t) do
        if v[2] then
            TUNING.MONITOR_CHESTS[k] = true;
        end
    end
end


--[[ 智能小木牌 ]]
do
    local chests = { "mone_treasurechest", "mone_dragonflychest" };
    if config_data.chests_boxs_compatibility then
        table.insert(chests, "mone_icebox");
        table.insert(chests, "mone_saltbox");
    end
    --table.insert(chests, "mone_skull_chest");
    for _, p in ipairs(chests) do
        env.AddPrefabPostInit(p, function(inst)
            if not TheWorld.ismastersim then
                return inst;
            end
            if TUNING.SMART_SIGN_DRAW_ENABLE then
                SMART_SIGN_DRAW(inst);
            end
        end)
    end
end

--[[ 能力勋章 ]]
do
    STRINGS.NAMES[("mone_buff_bw_attack"):upper()] = "惠灵顿风干牛排";
    STRINGS.NAMES[("mone_buff_hhs_work"):upper()] = "蜜汁大肉棒";
end