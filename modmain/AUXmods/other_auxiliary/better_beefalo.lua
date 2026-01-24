---
--- @author zsh in 2023/4/14 10:45
---

-- 2025-07-07：功能改为超级牛铃
if true then
    return
end

local API = require("chang_mone.dsts.API");
local Debug = API.Debug;

---
---判断牛是否被绑定
---
local function binding(guy)
    if guy and guy:HasTag("beefalo") then
        local follower = guy and guy.replica and guy.replica.follower;
        local leader = follower and follower:GetLeader();
        return leader and (leader.prefab == "beef_bell" or leader.prefab == "shadow_beef_bell");
    end
end

local forceattack = env.GetModConfigData("Force_attack") -- 强制攻击
local notraptrigger = env.GetModConfigData("No_traptrigger") -- 不触发陷阱
local nomood = env.GetModConfigData("No_mood") -- 抑制发情
local noshared = env.GetModConfigData("No_shared") -- 无群体仇恨
local nohorn = env.GetModConfigData("No_horn") -- 不受号角影响
local nodecay = GetModConfigData("No_decay") -- 无衰退
local playerattack = GetModConfigData("Player_attack") -- 攻击不掉驯服
local beefalostake = GetModConfigData("Beefalo_stake") -- 牛桩

--[[ 只能被强制攻击 ok ]]
local combat_replica = require "components/combat_replica";
local old_IsAlly = combat_replica.IsAlly;
function combat_replica:IsAlly(guy, ...)
    if guy and guy:HasTag("beefalo") then
        return binding(guy);
    end
    return old_IsAlly(self, guy, ...);
end

--[[ 不会生成便便 ok ]]
env.AddPrefabPostInit("beefalo", function(inst)
    if not TheWorld.ismastersim then
        return inst;
    end
    if inst.components.periodicspawner then
        local old_spawntest = inst.components.periodicspawner.spawntest;
        if old_spawntest then
            inst.components.periodicspawner:SetSpawnTestFn(function(inst)
                if binding(inst) then
                    return false;
                end
                return old_spawntest and old_spawntest(inst);
            end);
        end
    end
end)


--[[ 不触发陷阱 ]]
env.AddPrefabPostInit("beefalo", function(inst) 
    if not TheWorld.ismastersim then
        return
    end

    inst:ListenForEvent("saddlechanged", function(inst, data)
        local obedience = inst.components.domesticatable and inst.components.domesticatable.obedience
        if data and data.saddle ~= nil then

        else
            if inst.components.follower and inst.components.follower.leader and inst.components.follower.leader:HasTag("bell") then
                inst:DoTaskInTime(0, function()
                    inst:AddTag("notraptrigger")
                end)
            end
        end
    end)

    inst:ListenForEvent("startfollowing", function(inst, data)
        if data.leader and data.leader:HasTag("bell") then
            inst:AddTag("notraptrigger")
        end
    end)

    inst:ListenForEvent("stopfollowing", function(inst, data)
        if data.leader and data.leader:HasTag("bell") then
            if inst.components.rideable and inst.components.rideable.saddle == nil then
                inst:RemoveTag("notraptrigger")
            end
        end
    end)
end)

--[[ 不会发情 ]]
---
---有训诫值
---
local function hasDomesticationValue(inst)
    return inst and inst.components and inst.components.domesticatable 
        and inst.components.domesticatable.domestication >= 0.01
end

local function GetMoodComponent(inst)
    local herd = inst.components.herdmember and inst.components.herdmember:GetHerd()
    if herd then
        return herd.components.mood
    end
end

env.AddPrefabPostInit("beefalo", function(inst) 
    if not TheWorld.ismastersim then
        return
    end

    inst:ListenForEvent("saddlechanged", function(inst, data)
        if inst.components.follower and inst.components.follower.leader and inst.components.follower.leader:HasTag("bell") then
            local mood = GetMoodComponent(inst)
            -- todo: 设置为有训诫值的才不发情
            if mood and hasDomesticationValue(inst) then
                mood:Enable(false)
            elseif inst:HasTag("scarytoprey") then
                inst:RemoveTag("scarytoprey")
                inst.AnimState:Hide("HEAT")
            end
        end
    end)

    inst:ListenForEvent("entermood", function(inst)
        if inst.components.follower and inst.components.follower.leader and inst.components.follower.leader:HasTag("bell") then
            local mood = GetMoodComponent(inst)
            if mood 
                and inst.components.follower and inst.components.follower.leader and inst.components.follower.leader:HasTag("bell") 
                and hasDomesticationValue(inst) then
                mood:Enable(false)
            end
        end
    end)
end)

--发情的骑行时间（临时解决办法）
-- TUNING.BEEFALO_BUCK_TIME_MOOD_MULT = 1

--[[ 不受群体仇恨影响 ]]
env.AddComponentPostInit("combat", function(self)
    local oldShareTarget = self.ShareTarget
    function self:ShareTarget(target, range, fn, maxnum, musttags)
        local function CustomFilter(targ)
            if targ.components.follower and targ.components.follower.leader and targ.components.follower.leader:HasTag("bell") then
                return false
            end
            return fn == nil or fn(targ)
        end
        oldShareTarget(self, target, range, CustomFilter, maxnum, musttags)
    end
end)

--[[ 不乱跑 ok ]]
env.AddPrefabPostInit("beef_bell", function(inst)
    if not TheWorld.ismastersim then
        return
    end 

    inst:DoPeriodicTask(0.1,function() 
        if inst.components.inventoryitem.owner == nil and inst:GetBeefalo() then
            local beef = inst:GetBeefalo()
            local x,y,z = inst.Transform:GetWorldPosition()
            local pos = Vector3(x,y,z)          
            if inst:GetDistanceSqToInst(beef) > 4 and beef.components.locomotor and beef.components.health and not beef.components.health:IsDead() then
                beef.components.locomotor:GoToPoint(pos, nil, true)
            elseif inst:GetDistanceSqToInst(beef) <= 4 then
                
            end
        end
    end)
end)


--[[ 驯服度不会自然下降 ok ]]
local function OnSaltChange(inst,data)
    inst:DoTaskInTime(.1,function ()
        if inst.components.domesticatable then
            inst.components.domesticatable.domesticationdecaypaused = true
        end
    end)
end

env.AddPrefabPostInit("beefalo", function(inst) 
    if not TheWorld.ismastersim then
        return
    end

    inst:ListenForEvent("startfollowing", function(inst, data)
        if data.leader and data.leader:HasTag("bell") then
            if inst.components.domesticatable then
                inst.components.domesticatable.domesticationdecaypaused = true
            end

            inst:ListenForEvent("saltchange", OnSaltChange)
        end
    end)

    inst:ListenForEvent("stopfollowing", function(inst, data)
        if data.leader and data.leader:HasTag("bell") then
            if inst.components.domesticatable and inst.components.saltlicker then
                if not inst.components.saltlicker.salted then
                    inst.components.domesticatable.domesticationdecaypaused = false
                end
            end

            inst:RemoveEventCallback("saltchange", OnSaltChange)
        end
    end)
end)

----------------------------------------------------------------------------------------------------
--[[ 似乎无法通过修改牛铃铛实现的内容？ ]]
----------------------------------------------------------------------------------------------------

--[[ 骑牛可以使用武器 ok ]]
env.AddStategraphPostInit('wilson', function(self)
    local fun_swap = self.states['attack'].onenter
    self.states['attack'].onenter = function(inst)
        local equip = inst.components.inventory:GetEquippedItem(_G.EQUIPSLOTS.HANDS)
        if equip and equip.prefab ~= "voidcloth_umbrella" and equip.prefab ~= "grass_umbrella" and equip.prefab ~= "umbrella" and not equip:HasTag('rangedweapon') then
            -- fixme: 此处武器被人拿了怎么办？
            equip:AddTag('rangedweapon')
            fun_swap(inst)
        else
            fun_swap(inst)
        end
    end
end)

--[[ 牛角帽无视顺从值上牛 ]]
local MOUNT_fn_old = ACTIONS.MOUNT.fn
ACTIONS.MOUNT.fn = function(act)
    if act.doer:HasTag("beefalo") then
        -- todo: 判断此处的合理性
        if act.target.components.domesticatable ~= nil and act.target.components.domesticatable:GetObedience() < act.target.components.domesticatable.maxobedience then
            act.target.components.domesticatable:DeltaObedience(1) 
        end
        if act.target.components.combat then
            act.target.components.combat:DropTarget()
        end
    end
    return MOUNT_fn_old(act)
end

--[[ 牛死后可用告密之心复活 ]]


--[[ 暗影传送 ]]


--[[ 不受号角影响 ]]

--[[ 甩掉的鞍具不会掉耐久 ]]
-- 2025-07-06： 算了，不加新东西了，浪费时间
-- local function RestoreDurability(inst)
--     inst:DoTaskInTime(0, function()
--         self.saddle.
--     end)
--     inst:RemoveEventCallback("on_landed", RestoreDurability)
-- end

-- -- 不好从 shake_off_saddle 下手
-- local Rideable = require("components/rideable")
-- if Rideable then
--     local oldSetSaddle = Rideable.SetSaddle
--     function Rideable:SetSaddle(doer, ...)
--         oldSetSaddle(self, doer , ...)
--         if self.saddle ~= nil then
--             if doer == nil then
--                 self.saddle:ListenForEvent("on_landed", RestoreDurability, inst)
--             end
--         end
--     end
-- end


--[[ 绑定后的牛铃铛显示牛的生命值 ]]
-- 2025-07-05：不生效，懒得测试了
-- env.AddClassPostConstruct("widgets/hoverer", function(self)
--     local old_SetString = self.text.SetString
--     self.text.SetString = function(text, str)
--         local target = TheInput:GetHUDEntityUnderMouse() -- NOTE:
--         if target ~= nil then
--             target = (target.widget ~= nil and target.widget.parent ~= nil) and target.widget.parent.item
--         else
--             target = TheInput:GetWorldEntityUnderMouse()
--         end
--         if target and target.entity ~= nil then
--             if target.prefab ~= nil then
--                 if target.prefab == "beef_bell" then
--                     local mone_hint_of_beef_bell = target.mone_hint_of_beef_bell
--                     if mone_hint_of_beef_bell and mone_hint_of_beef_bell ~= "" then
--                         -- 暂且只存储生命值
--                         str = str .. "\n" .. "生命值: " .. mone_hint_of_beef_bell
--                     end
--                 end
--             end
--         end
--         return old_SetString(text, str)
--     end
-- end)

-- env.AddPrefabPostInit("beef_bell", function(inst)
--     inst.net_mone_hint_of_beef_bell = _G.net_string(inst.GUID, "mone_hint_of_beef_bell.", "mone_hint_of_beef_belldirty")
--     if not TheWorld.ismastersim then
--         inst.mone_hint_of_beef_bell = nil

--         inst:ListenForEvent("mone_hint_of_beef_belldirty",function(inst)
--             inst.mone_hint_of_beef_bell = inst.net_mone_hint_of_beef_bell:value()
--         end)

--         return
--     end

--     local oldOnStopUsing = inst.OnStopUsing
--     inst.OnStopUsing = function(inst, beefalo)
--         inst.net_mone_hint_of_beef_bell:set("")
--         return oldOnStopUsing(inst, beefalo)
--     end
-- end)

-- env.AddPrefabPostInit("beefalo", function(inst) 
--     if not TheWorld.ismastersim then
--         return
--     end

--     inst:ListenForEvent("healthdelta", function(inst, data)
--         if inst.components.follower and inst.components.follower.leader and inst.components.follower.leader:HasTag("bell") then
--             local leader = inst.components.follower.leader
--             if leader.prefab~="beef_bell" then
--                 return
--             end
--             local currenthealth = inst.components.health.currenthealth
--             leader.net_mone_hint_of_beef_bell:set(tostring(currenthealth))
--         end
--     end)

-- end)

--[[ 被玩家攻击时不掉顺从度和驯服度 ]]


--[[ 绑定铃铛的牛可收入铃铛 ]]


--[[ 牛死后可用告密之心复活 ]]






