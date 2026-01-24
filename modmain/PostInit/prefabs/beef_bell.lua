---
--- @author zsh in 2023/4/14 10:45
---

local API = require("chang_mone.dsts.API");
local Debug = API.Debug;

local forceattack = env.GetModConfigData("Force_attack") -- 强制攻击
local notraptrigger = env.GetModConfigData("No_traptrigger") -- 不触发陷阱
local nomood = env.GetModConfigData("No_mood") -- 抑制发情
local noshared = env.GetModConfigData("No_shared") -- 无群体仇恨
local nohorn = env.GetModConfigData("No_horn") -- 不受号角影响
local nodecay = GetModConfigData("No_decay") -- 无衰退
local playerattack = GetModConfigData("Player_attack") -- 攻击不掉驯服
local beefalostake = GetModConfigData("Beefalo_stake") -- 牛桩

---
---命名不算合适
---
local function bellBinding(inst)
    return inst and type(inst) == "table" 
        and inst.components 
        and inst.components.follower 
        and inst.components.follower.leader 
        and inst.components.follower.leader:HasTag("mone_bell")
end

--[[ 只能被强制攻击 ok todo: 建议设置成无法被攻击... ]]
---
---判断牛是否被绑定（此处要求被 mone_bell 绑定）
---
local function binding(guy)
    if guy and guy:HasTag("beefalo") then
        local follower = guy and guy.replica and guy.replica.follower;
        local leader = follower and follower:GetLeader();
        return leader and leader:HasTag("mone_bell");
    end
end

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
            if bellBinding(inst) then
                inst:DoTaskInTime(0, function()
                    inst:AddTag("notraptrigger")
                end)
            end
        end
    end)

    inst:ListenForEvent("startfollowing", function(inst, data)
        if data.leader and data.leader:HasTag("mone_bell") then
            inst:AddTag("notraptrigger")
        end
    end)

    inst:ListenForEvent("stopfollowing", function(inst, data)
        if data.leader and data.leader:HasTag("mone_bell") then
            if inst.components.rideable and inst.components.rideable.saddle == nil then
                inst:RemoveTag("notraptrigger")
            end
        end
    end)
end)

--[[ 有训诫值不会发情 ]]
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
        if bellBinding(inst) then
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
        if bellBinding(inst) then
            local mood = GetMoodComponent(inst)
            if mood and hasDomesticationValue(inst) then
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
            if bellBinding(targ) then
                return false
            end
            return fn == nil or fn(targ)
        end
        oldShareTarget(self, target, range, CustomFilter, maxnum, musttags)
    end
end)

--[[ 不乱跑 ok ]]
env.AddPrefabPostInit("mone_beef_bell", function(inst)
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
        if data.leader and data.leader:HasTag("mone_bell") then
            if inst.components.domesticatable then
                inst.components.domesticatable.domesticationdecaypaused = true
            end

            inst:ListenForEvent("saltchange", OnSaltChange)
        end
    end)

    inst:ListenForEvent("stopfollowing", function(inst, data)
        if data.leader and data.leader:HasTag("mone_bell") then
            if inst.components.domesticatable and inst.components.saltlicker then
                if not inst.components.saltlicker.salted then
                    inst.components.domesticatable.domesticationdecaypaused = false
                end
            end

            inst:RemoveEventCallback("saltchange", OnSaltChange)
        end
    end)
end)

--[[ 骑牛可以使用武器 ok ]]
local function is_weapon(inst)
    return inst:HasTag("weapon") 
        and inst.components.weapon 
        and inst.components.weapon.damage >= 34 -- 算了，直接认为大于等于 34 的才是武器
        -- and not string.find(inst.prefab, "cane") -- 排除步行手杖（手杖没特别标签欸）
        -- and not string.find(inst.prefab, "staff") -- 排除法杖（法杖没特别标签欸）
end

local function add_rangedweapon_tag(inst)
    if inst == nil or not is_weapon(inst) then
        return
    end
    -- 如果没有 rangedweapon 标签
    if not inst:HasTag("rangedweapon") then
        inst:AddTag("rangedweapon")
        inst:AddTag("mone_rangedweapon_flag")
    end
end

local function remove_rangedweapon_tag(inst)
    -- 不需要添加 not is_weapon(inst) 判定，因为都将使用 mone_rangedweapon_flag 标签进行判定
    if inst == nil then
        return
    end
    if inst:HasTag("mone_rangedweapon_flag") then
        inst:RemoveTag("rangedweapon")
        inst:RemoveTag("mone_rangedweapon_flag")
    end
end

env.AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then
        return
    end

    -- 骑牛事件监听
    inst:ListenForEvent("mounted", function(inst, data)
        local target = data and data.target
        if target == nil or not target:HasTag("mone_beef_bell_beefalo") then
            return
        end
        add_rangedweapon_tag(inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS))
    end)
    
    -- 下牛事件监听
    inst:ListenForEvent("dismounted", function(inst, data)
        remove_rangedweapon_tag(inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS))
    end)

    inst:ListenForEvent("equip", function(inst, data)
        local item = data and data.item
        if item == nil then
            return
        end

        -- 如果处于骑行状态
        local mount = inst.components.rider:GetMount()
        if inst.components.rider:IsRiding() and mount and mount:HasTag("mone_beef_bell_beefalo") then
            add_rangedweapon_tag(item)
        end
    end)

    inst:ListenForEvent("unequip", function(inst, data)
        local item = data and data.item
        if item == nil then
            return
        end
        remove_rangedweapon_tag(item)
    end)
end)


--[[ 戴牛角帽无视顺从值直接上牛且回满顺从值 ok ]]
env.AddPrefabPostInit("beefalo", function(inst) 
    if not TheWorld.ismastersim then
        return
    end
    inst:ListenForEvent("startfollowing", function(inst, data)
        if data.leader and data.leader:HasTag("mone_bell") then
            inst:AddTag("mone_beef_bell_beefalo")
        end
    end)

    inst:ListenForEvent("stopfollowing", function(inst, data)
        if data.leader and data.leader:HasTag("mone_bell") then
            inst:RemoveTag("mone_beef_bell_beefalo")
        end
    end)
end)

local MOUNT_fn_old = ACTIONS.MOUNT.fn
ACTIONS.MOUNT.fn = function(act)
    if act.doer:HasTag("beefalo") and act.target:HasTag("mone_beef_bell_beefalo") then
        if act.target.components.domesticatable ~= nil and act.target.components.domesticatable:GetObedience() < act.target.components.domesticatable.maxobedience then
            -- todo: 判断此处的合理性
            act.target.components.domesticatable:DeltaObedience(1)
        end
        if act.target.components.combat then
            act.target.components.combat:DropTarget()
        end
    end
    return MOUNT_fn_old(act)
end


--[[ 防击飞 ]]
env.AddStategraphPostInit("wilson", function(sg)
    local oldknockback = sg.events["knockback"].fn
    sg.events["knockback"].fn = function(inst, data, ...)
        if inst.components.rider 
            and inst.components.rider:IsRiding() 
            and inst.components.rider:GetSaddle() 
            and inst.components.rider:GetMount()
            and inst.components.rider:GetMount():HasTag("mone_beef_bell_beefalo") then
            if inst.sg and inst.sg:HasStateTag('frozen') then -- 解除冻结
                inst.sg:GoToState("idle")
            end
            return
        else
            oldknockback(inst, data, ...)
        end
    end
end)




--[[ 死亡可以复活 ]]
local function ShadowBell_OnDischarged(inst)
    inst:AddTag("oncooldown")

end

local function ShadowBell_OnCharged(inst)
    inst:RemoveTag("oncooldown")
end


env.AddPrefabPostInit("mone_beef_bell", function(inst)
    inst:AddTag("shadowbell")

    if not TheWorld.ismastersim then return end

    inst:AddComponent("rechargeable")
    inst.components.rechargeable:SetOnDischargedFn(ShadowBell_OnDischarged)
    inst.components.rechargeable:SetOnChargedFn(ShadowBell_OnCharged)

end)

env.AddPrefabPostInit("beefalo", function(inst) 
    if not TheWorld.ismastersim then
        return
    end

    -- 解绑的时候，如果已经死亡，则彻底死亡
    inst:ListenForEvent("stopfollowing", function(inst, data)
        if data.leader and data.leader:HasTag("mone_bell") then
            if inst:HasTag("deadcreature") and inst.components.lootdropper then
                -- 这个真的需要吗？
                -- inst.components.lootdropper:DropLoot(pt)
            end
        end
    end)
end)

--[[ 重生护符复活牛 ]]
local MONE_REVIVE_BEEFALO = Action({ priority = 10 })
MONE_REVIVE_BEEFALO.id = "MONE_REVIVE_BEEFALO"
MONE_REVIVE_BEEFALO.str = STRINGS.ACTIONS.GIVE.GENERIC
MONE_REVIVE_BEEFALO.fn = function(act)
    local reviver = act.invobject
    local target = act.target
    local doer = act.doer
    if not (reviver and doer and target) then return false end
    SpawnAt("carnival_streamer_fx", target, {2,2,2}, Vector3(0, 0, 0))
    target:OnRevived()
    reviver:Remove()
    
    if doer.components.talker then
        doer:DoTaskInTime(0,function ()
            doer.components.talker:Say(STRINGS.CHARACTERS.WINONA.DESCRIBE.SHADOW_BEEF_BELL)
        end)
    end
    return true
end

env.AddAction(MONE_REVIVE_BEEFALO)

env.AddStategraphActionHandler("wilson", ActionHandler(MONE_REVIVE_BEEFALO, "doshortaction"))
env.AddStategraphActionHandler("wilson_client", ActionHandler(MONE_REVIVE_BEEFALO, "doshortaction"))

env.AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right)
    if inst.prefab == "amulet"
        and target.prefab == "beefalo" 
        and target:HasTag("mone_beef_bell_beefalo")
        and target:HasTag("deadcreature") then
        table.insert(actions, MONE_REVIVE_BEEFALO)
    end
end)


--[[ 牛可以飞渡过河 ]]
do
    -- 2025-07-07：不生效... 虽然代码好似没问题，但是我目前看来缺少进入状态的动作？还是说什么其他问题吗？
    -- GoToState：进入状态
    if true then
        return
    end
    local LEAP_MAX_DIST = 18
    local LEAP_MIN_DIST = 3
    local LEAP_MAX_SPEED = 30
    local LEAP_MIN_SPEED = LEAP_MAX_SPEED * LEAP_MIN_DIST / LEAP_MAX_DIST
    local LEAP_MAX_DIST_SQ = LEAP_MAX_DIST * LEAP_MAX_DIST
    local LEAP_MIN_DIST_SQ = LEAP_MIN_DIST * LEAP_MIN_DIST

    local leap_action = AddAction("MONE_BEEF_LEAP", "渡河", function(act)
        print("MONE_BEEF_LEAP aaa")
        if act.doer ~= nil and act.doer.sg ~= nil 
            and act.doer.sg.currentstate.name == "mone_beef_leap_pre" then
            print("MONE_BEEF_LEAP bbb")
            local beef = act.doer.components.rider:GetMount()
            if beef == nil or not beef:HasTag("mone_beef_bell_beefalo") then
                return false
            end

            act.doer.sg:GoToState("mone_beef_leap", { pos = act.pos })

            -- todo: 验证此种方法实现 CD 的可行性
            beef:AddTag("mone_leaping")
            beef:DoTaskInTime(10,function()
                if beef and beef:IsValid() then
                    beef:RemoveTag("mone_leaping")
                end
            end)
            return true
        end
    end)

    leap_action.priority = 1
    leap_action.rmb = true
    leap_action.mount_valid = true
    leap_action.distance = 36

    local function onsetowner(inst)
        inst:DoTaskInTime(0,function() 
            if inst.components.playeractionpicker == nil then
                return
            end
            local _pointspecialactionsfn = inst.components.playeractionpicker.pointspecialactionsfn
            inst.components.playeractionpicker.pointspecialactionsfn = function(inst, pos, useitem, right)
                if inst.replica.rider 
                    and inst.replica.rider:IsRiding() 
                    and inst.replica.rider:GetMount() 
                    and inst.replica.rider:GetMount():HasTag("mone_leaping") 
                    and not inst.replica.rider:GetMount():HasTag("mone_leaping") 
                    and not inst.replica.rider:GetMount():HasTag("koalefant") then
                    if inst.replica.inventory:Has("wortox_soul",1) then
                        if right and inst.components.playercontroller 
                            and inst.components.playercontroller:IsControlPressed(GLOBAL.CONTROL_FORCE_INSPECT) then
                            return {ACTIONS.MONE_BEEF_LEAP}
                        end             
                    else
                        if right and inst.components.playercontroller
                         and inst.components.playercontroller:IsControlPressed(GLOBAL.CONTROL_FORCE_INSPECT) then
                            return {ACTIONS.MONE_BEEF_LEAP}
                        end
                    end
                end
                return _pointspecialactionsfn ~= nil and _pointspecialactionsfn(inst, pos, useitem, right) or {}
            end
        end)
    end

    env.AddPlayerPostInit(function(inst)
        inst:ListenForEvent("setowner", onsetowner)
    end)

    env.AddStategraphState("wilson", State{
        name = "mone_beef_leap_pre",
        tags = { "doing", "busy", "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("boat_jump_pre")
            local x, y, z = inst.Transform:GetWorldPosition()
            
            inst:DoTaskInTime(0.2,function() 
            local fx = SpawnPrefab("spider_heal_ground_fx")
            inst.SoundEmitter:PlaySound("dontstarve/common/deathpoof")
            if fx ~= nil  then
                fx.Transform:SetScale(.6, .6, .6)
                fx.Transform:SetPosition(x, 0, z)

            end
            end)
            
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    if inst.bufferedaction ~= nil then
                        inst:PerformBufferedAction()
                    else
                        inst.sg:GoToState("idle")
                    end
                end
            end),
        },
    })

    local function ToggleOffPhysics(inst)
        inst.sg.statemem.isphysicstoggle = true
        inst.Physics:ClearCollisionMask()
        inst.Physics:CollidesWith(COLLISION.GROUND)
    end

    local function ToggleOnPhysics(inst)
        inst.sg.statemem.isphysicstoggle = nil
        inst.Physics:ClearCollisionMask()
        inst.Physics:CollidesWith(COLLISION.WORLD)
        inst.Physics:CollidesWith(COLLISION.OBSTACLES)
        inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
        inst.Physics:CollidesWith(COLLISION.CHARACTERS)
        inst.Physics:CollidesWith(COLLISION.GIANTS)
    end

    env.AddStategraphState("wilson", State{
        name = "mone_beef_leap",
        tags = { "doing", "busy", "canrotate", "nopredict", "nomorph" },

        onenter = function(inst, data)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("boat_jump_loop")

            local dist
            if data ~= nil and data.pos ~= nil then
                
                         local pos = data.pos:GetPosition()
                         inst:ForceFacePoint(pos.x, 0, pos.z)
            
                local distsq = inst:GetDistanceSqToPoint(pos)
                if distsq <= LEAP_MIN_DIST_SQ then
                    dist = LEAP_MIN_DIST
                    inst.sg.statemem.speed = LEAP_MIN_SPEED
                elseif distsq >= LEAP_MAX_DIST_SQ then
                    dist = LEAP_MAX_DIST
                    inst.sg.statemem.speed = LEAP_MAX_SPEED
                else
                    dist = math.sqrt(distsq)
                    inst.sg.statemem.speed = LEAP_MAX_SPEED * dist / LEAP_MAX_DIST
                end
            else
                inst.sg.statemem.speed = LEAP_MAX_SPEED
                dist = LEAP_MAX_DIST
            end

            local x, y, z = inst.Transform:GetWorldPosition()
            local angle = inst.Transform:GetRotation() * DEGREES
            if GLOBAL.TheWorld.Map:IsPassableAtPoint(x + dist * math.cos(angle), 0, z - dist * math.sin(angle)) then
                ToggleOffPhysics(inst)
            end

            inst.Physics:SetMotorVel(inst.sg.statemem.speed, 0, 0)

            PlayFootstep(inst)

            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(false)
            end
        end,

        onupdate = function(inst)
            if inst.sg.statemem.isphysicstoggle then
                local x, y, z = inst.Transform:GetWorldPosition()
                local angle = inst.Transform:GetRotation() * DEGREES
                local radius = .5
                x = x + .75 * radius * math.cos(angle)
                z = z - .75 * radius * math.sin(angle)
                local ents = TheSim:FindEntities(x, 0, z, radius, { "wall" })
                for i, v in ipairs(ents) do
                    if v.components.health ~= nil and v.components.health:GetPercent() > .5 then
                        ToggleOnPhysics(inst)
                        return
                    end
                end
            end
        end,

        timeline =
        {
            TimeEvent(.5 * FRAMES, function(inst)
                inst.Physics:SetMotorVel(inst.sg.statemem.speed * .75, 0, 0)
            end),
            TimeEvent(1 * FRAMES, function(inst)
                inst.Physics:SetMotorVel(inst.sg.statemem.speed, 0, 0)
            end),
            TimeEvent(19 * FRAMES, function(inst)
                inst.Physics:SetMotorVel(inst.sg.statemem.speed * .25, 0, 0)
                inst.SoundEmitter:PlaySound("dontstarve/movement/bodyfall_dirt")



                local fx = SpawnPrefab("spider_heal_ground_fx")
                inst.SoundEmitter:PlaySound("dontstarve/common/deathpoof")
                if fx ~= nil then
                    fx.Transform:SetScale(.6, .6, .6)
                    local x, y, z = inst.Transform:GetWorldPosition()
                    local angle = inst.Transform:GetRotation() * DEGREES
                    fx.Transform:SetPosition(x + .25 * math.cos(angle), 0, z - .25 * math.sin(angle))
                end
            end),
            TimeEvent(20 * FRAMES, function(inst)
                inst.Physics:Stop()
                inst.sg:GoToState("idle", true)
            end),
        },

        onexit = function(inst)
            if inst.sg.statemem.isphysicstoggle then
                ToggleOnPhysics(inst)
            end

            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(true)
            end
        end,
    })

    env.AddStategraphState("wilson_client", State{
        name = "mone_beef_leap_pre", -- todo: 确定如何才能进入这个状态！
        tags = { "doing", "busy", "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("boat_jump_pre")
            inst.AnimState:PushAnimation("boat_jump_loop", false)
            
            local x, y, z = inst.Transform:GetWorldPosition()
            inst:DoTaskInTime(0.2,function() 
            local fx = SpawnPrefab("spider_heal_ground_fx")
            inst.SoundEmitter:PlaySound("dontstarve/common/deathpoof")
            if fx ~= nil  then
                fx.Transform:SetScale(.6, .6, .6)
                fx.Transform:SetPosition(x, 0, z)

            end
            end)
            
            inst:PerformPreviewBufferedAction()
            inst.sg:SetTimeout(2)
        end,

        onupdate = function(inst)
            if inst:HasTag("doing") then
                if inst.entity:FlattenMovementPrediction() then
                    inst.sg:GoToState("idle", "noanim")
                end
            elseif inst.bufferedaction == nil then
                inst.sg:GoToState("idle")
            end
        end,

        ontimeout = function(inst)
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle")
        end,
    })

    env.AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.MONE_BEEF_LEAP, function(inst)
        print("MONE_BEEF_LEAP 111")
        return not inst.sg:HasStateTag("busy")
            and (inst.sg:HasStateTag("moving") or inst.sg:HasStateTag("idle"))
            and "mone_beef_leap_pre"
            or nil
    end))

    env.AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.MONE_BEEF_LEAP, function(inst)
        print("MONE_BEEF_LEAP 222")
        return not (inst.sg:HasStateTag("busy") or inst:HasTag("busy"))
            and inst.entity:CanPredictMovement()
            and (inst.sg:HasStateTag("moving") or inst.sg:HasStateTag("idle"))
            and "mone_beef_leap_pre"
            or nil
    end))
end