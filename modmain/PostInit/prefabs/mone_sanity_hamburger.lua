---
--- @author zsh in 2023/3/2 10:27
---

local utils = require("moreitems.main").shihao.utils
local invoke = utils.invoke

local allow_universal_functionality_enable = TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA["sanity_hamburger__allow_universal_functionality_enable"]
local constants = require("more_items_constants")
allow_universal_functionality_enable=true
local config_data = TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA;

if not config_data.mone_sanity_hamburger then
    return
end

---@type table<any,boolean>
local INCLUDE_PLAYERS = invoke(function()
    local res = {}
    local included_players = constants.SANITY_HAMBURGER__INCLUDED_PLAYERS
    for _, v in ipairs(included_players) do
        res[v] = true
    end
    return res
end)

local function perform(inst)
    -- 给吃食物时使用的
    inst.mone_sh_non_ban = true;

    inst:DoTaskInTime(0, function(inst)
        inst:ListenForEvent("sanitydelta", function(inst, data)
            inst.components.mone_sanity_hamburger.save_currentsanity = inst.components.sanity.current;
            inst.components.mone_sanity_hamburger.save_maxsanity = inst.components.sanity.max;
        end);
    end)
end

env.AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:AddComponent("mone_sanity_hamburger")

    if allow_universal_functionality_enable
            or INCLUDE_PLAYERS[inst.prefab] then
        perform(inst)
    end
end)
