---
--- @author zsh in 2023/2/19 1:10
---

local config_data = TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA;

local inf_on = config_data.mie_beefalofeed;

if not inf_on then
    return
end

env.AddPrefabPostInit("greenstaff", function(inst)
    if not TheWorld.ismastersim then
        return inst;
    end
    if inst.components.spellcaster then
        local old_spell = inst.components.spellcaster.spell;
        inst.components.spellcaster.spell = function(inst, target, pos, doer, ...)
            if target:HasTag("mie_inf_food") or target:HasTag("mie_inf_roughage") then
                -- DoNothing
                if doer.components.talker then
                    doer.components.talker:Say("我根本拆不掉它！");
                end
                return ;
            end

            if old_spell then
                old_spell(inst, target, pos, doer, ...);
            end
        end
    end
end)

env.AddPrefabPostInit("mie_beefalofeed", function(inst)
    if not TheWorld.ismastersim then
        return inst;
    end
    -- 监听删除动作？
end)

-- 修改交易组件
if config_data.mie_beefalofeed then
    env.AddComponentPostInit("trader", function(self)
        local old_AcceptGift = self.AcceptGift;
        function self:AcceptGift(giver, item, ...)
            if item and item:HasTag("mie_inf_roughage") and giver:HasTag("player") then
                local item_save_record = item:GetSaveRecord();
                local result = old_AcceptGift(self, giver, item, ...);
                if not (item and item:IsValid()) then
                    if item_save_record then
                        giver.components.inventory:GiveItem(SpawnSaveRecord(item_save_record));
                    end
                end
                return result;
            end
            return old_AcceptGift(self, giver, item, ...);
        end
    end)
end
