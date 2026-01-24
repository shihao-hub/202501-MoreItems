---
--- Created by zsh
--- DateTime: 2023/9/11 16:17
---

local config_data = TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA
local mdp = config_data.multiple_drop_probability
if mdp == 0 then
    return
end

local isValid = isValid;
local TUNING = TUNING;

local function tabContainNull(t, ...)
    assert(type(t) == "table");
    local args = { ... };
    local n = select("#", ...);
    for i = 1, n do
        if args[i] ~= nil and t[args[i]] == nil then
            return true;
        end
    end
    return false;
end

local function isExpectantTarget(inst)
    return not tabContainNull(inst.components, "health", "combat", "lootdropper")
            and not inst:HasTag("player")
            and inst:HasTag("epic");
end

local function inBuff(inst, data)
    local afflicter = data and data.afflicter;
    return afflicter and afflicter:HasTag("player") and afflicter:HasTag("mone_honey_ham_stick_buffer");
end

local function onDeath(inst, data)
    if isValid(inst) and inBuff(inst, data) then
        local afflicter = data.afflicter;
        if math.random() < mdp then
            if afflicter then afflicter.components.talker:Say("触发双倍掉落效果！"); end
            inst.components.lootdropper:DropLoot(inst:GetPosition());
        else
            if afflicter then afflicter.components.talker:Say("没有触发双倍掉落效果！"); end
        end
    end
end


env.AddPrefabPostInitAny(function(inst)
    if not TheWorld.ismastersim then return inst; end
    if isExpectantTarget(inst) then
        inst:ListenForEvent("death", onDeath);
    end
end)
