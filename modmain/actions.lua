---
--- @author zsh in 2023/1/8 20:31
---

local API = require("chang_mone.dsts.API");
local locale = LOC.GetLocaleCode();
local L = (locale == "zh" or locale == "zht" or locale == "zhr") and true or false;
local old_actions_fn = require("definitions.mone.old_actions_fn");
local config_data = TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA

local function consumMaterials(invobject)
    if invobject then
        if invobject.components.stackable then
            invobject.components.stackable:Get():Remove()
        else
            invobject:Remove() --显然此处是主机代码
        end
        TheFocalPoint.SoundEmitter:PlaySound("dontstarve/HUD/collect_resource")
    end
end

local function containValue(tab, value)
    if tab and type(tab) == "table" then
        for k, _ in pairs(tab) do
            if k == value then
                return true;
            end
        end
    end
end

STRINGS.CHARACTERS.GENERIC.ACTIONFAIL.MIE_ORDINARY_BUNDLE_ACTION = {
    NOPT = "释放坐标点非法，无法释放！",
    CANNOT = "警告：非法目标，不允许打包！",
    BUSY = "目标很忙，请稍后再试！",
    SUCCESS = "打包成功！请注意保护好它，避免物品损失！"
}

STRINGS.CHARACTERS.GENERIC.ACTIONFAIL.MIE_BUNDLE_ACTION = {
    NOPT = "释放坐标点非法，无法释放！",
    CANNOT = "警告：非法目标，不允许打包！",
    BUSY = "目标很忙，请稍后再试！",
    SUCCESS = "打包成功！请注意保护好它，避免物品损失！"
}

local custom_actions = {
    ["MONE_REPAIR_OBJECT"] = {
        execute = true,
        id = "MONE_REPAIR_OBJECT",
        str = "修复",
        fn = function(act)
            if act.target and act.target.mone_repair_materials and act.invobject and act.doer
                    and act.target:HasTag("mone_can_be_repaired") then
                local amount;
                for pf, num in pairs(act.target.mone_repair_materials) do
                    if pf == act.invobject.prefab then
                        amount = num;
                        break ;
                    end
                end
                --print(tostring(amount));
                if not (amount == nil) then
                    local function repair(target, amount, invobject, doer)
                        if target.components.fueled then
                            local percent = target.components.fueled:GetPercent() + amount
                            local max_precent = percent <= 1 and percent or 1
                            target.components.fueled:SetPercent(max_precent)
                        elseif target.components.finiteuses then
                            local percent = target.components.finiteuses:GetPercent() + amount
                            local max_precent = percent <= 1 and percent or 1
                            target.components.finiteuses:SetPercent(max_precent)
                        elseif target.components.armor then
                            --armor组件中SetCondition()最大值就是最大值
                            local percent = target.components.armor:GetPercent() + amount
                            local max_precent = percent <= 1 and percent or 1
                            target.components.armor:SetPercent(max_precent)
                        elseif target.components.perishable then
                            --需要吗？
                            local percent = target.components.perishable:GetPercent() + amount
                            local max_precent = percent <= 1 and percent or 1
                            target.components.perishable:SetPercent(max_precent)
                        else
                            return ;
                        end
                        consumMaterials(invobject);
                    end
                    if act.target.components.fueled then
                        repair(act.target, amount, act.invobject, act.doer)
                    elseif act.target.components.finiteuses then
                        repair(act.target, amount, act.invobject, act.doer)
                    elseif act.target.components.armor then
                        repair(act.target, amount, act.invobject, act.doer)
                    elseif act.target.components.perishable then
                        repair(act.target, amount, act.invobject, act.doer)
                    end
                end
                return true;
            end
        end,
        state = "dolongaction"
    },
    ["MONE_PHEROMONESTONE_INFINITE"] = {
        execute = true,
        id = "MONE_PHEROMONESTONE_INFINITE",
        str = "进阶",
        fn = function(act)
            local function exclude(target)
                local items = {};
                if not TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA.greenamulet_pheromonestone then
                    table.insert(items, "greenamulet");
                end
                --table.insert(items, "mie_bushhat"); -- 排除升级版·灌木丛帽
                for _, v in ipairs(items) do
                    if target and target.prefab == v then
                        return true;
                    end
                end
            end

            if act.doer and act.invobject and act.target then
                if act.target:HasTag("mone_pheromonestone_infinite") then
                    if exclude(act.target) then
                        if act.doer.components.talker then
                            act.doer.components.talker:Say("不合理目标，无法使用！")
                        end
                        return true;
                    end
                    -- 正常执行
                    act.target.components.mone_pheromonestone_infinite:MakeInfinite(act.invobject);
                    return true;
                end
            end
            --return true; -- 只有 return ture 人物才不会说我做不到！
        end,
        state = "dolongaction"
    },
    ["MONE_PHEROMONESTONE_ETERNITY"] = {
        execute = true,
        id = "MONE_PHEROMONESTONE_ETERNITY",
        str = "逆转",
        fn = function(act)
            if act.doer and act.invobject and act.target then
                if act.target:HasTag("mone_pheromonestone_eternity") then
                    act.target.components.mone_pheromonestone_eternity:Main(act.invobject);
                    return true;
                end
            end
        end,
        state = "dolongaction"
    },
    ["MONE_BATHAT"] = {
        execute = true,
        id = "MONE_BATHAT",
        str = "起飞",
        fn = function(act)
            --主客机通用代码
            local function isFlying(player)
                return player and player:HasTag("mone_bathat_fly");
            end

            if act.doer and act.target and act.target:HasTag("player") and act.target.components.mone_bathat_fly then
                if isFlying(act.doer) then
                    act.doer.components.mone_bathat_fly:Land(act.doer)
                elseif not isFlying(act.doer) then
                    act.doer.components.mone_bathat_fly:Fly(act.doer)

                    -- debuff
                    if act.doer.components.sanity then
                        act.doer.components.sanity:DoDelta(-act.doer.components.sanity.current / 3);
                    end
                end
                return true
            end
            return false
        end,
        state = "doshortaction"
    },
    ["MONE_WATERCHEST_HAMMER"] = {
        execute = true,
        id = "MONE_WATERCHEST_HAMMER",
        str = "徒手拆卸",
        fn = function(act)
            local target, doer = act.target, act.doer;
            if target and doer and target.onhammered then
                target.onhammered(target, doer);
                return true;
            end
        end,
        state = "domediumaction"
    },
    ["MONE_POISONBLAM_ROTTEN"] = {
        execute = true,
        id = "MONE_POISONBLAM_ROTTEN",
        str = "腐朽",
        fn = function(act)
            if act.target and act.target.components.perishable then
                local cper = act.target.components.perishable:GetPercent();
                act.target.components.perishable:ReducePercent(cper);
                -- 消耗
                if act.invobject then
                    if act.invobject.components.stackable then
                        act.invobject.components.stackable:Get():Remove();
                    else
                        act.invobject:Remove();
                    end
                end
                return true;
            end
        end,
        state = "dolongaction"
    },
    ["MONE_FEED_GLOMMER"] = {
        execute = true,
        id = "MONE_FEED_GLOMMER",
        str = "喂食",
        fn = function(act)
            if act.doer
                    and act.invobject and act.invobject.prefab == "mone_glommer_poop_food"
                    and act.target and act.target.prefab == "glommer" then
                if act.target.components.periodicspawner then
                    act.target.components.periodicspawner:TrySpawn();
                end

                local item = act.invobject;
                if item.components.stackable then
                    item.components.stackable:Get():Remove();
                else
                    item:Remove();
                end
                return true;
            end
        end,
        state = "give",
        actiondata = {
            priority = 10;
        }
    },
    -- region 更多物品·拓展包
    ["MIE_BOOK_SILVICULTURE_ACTION"] = {
        execute = config_data.mie_book_silviculture,
        id = "MIE_BOOK_SILVICULTURE_ACTION",
        str = "打开/关闭", -- "全部掉落",
        fn = function(act)
            -- 任何一个 _inventoryitem 的预制物都可以对着这个书使用，使其内部物品全部掉落。
            local target = act and act.target;
            local doer = act and act.doer;
            if target and doer and target.components.container then
                if not target.components.container:IsOpen() then
                    target.components.container:Open(doer);
                else
                    target.components.container:Close();
                end
            end
            return true;
        end,
        actiondata = {
            strfn = function(act)
                local target = act and act.target;
                return target:HasTag("mie_simplebooks_open") and "CLOSE" or "OPEN";
            end
        },
        state = "doshortaction" --"dolongaction"
    },

    ["MIE_ORDINARY_BUNDLE_ACTION"] = {
        execute = config_data.mie_ordinary_bundle,
        id = "MIE_ORDINARY_BUNDLE_ACTION",
        str = "普通打包",
        fn = function(act)
            local target = act.target
            local invobject = act.invobject
            local doer = act.doer
            if target and invobject and doer then
                local targetpos = target:GetPosition();
                if not (targetpos.x and targetpos.y and targetpos.z) then
                    return false, "NOPT";
                end


                local mie_bundle_state2 = SpawnPrefab("mie_ordinary_bundle_state2", invobject.linked_skinname, invobject.skin_id);

                if not mie_bundle_state2.components.mie_bundle:IsLegitimateTarget(target) then
                    mie_bundle_state2:Remove();
                    return false, "CANNOT";
                end

                if target.components.teleporter and target.components.teleporter:IsBusy() then
                    mie_bundle_state2:Remove()
                    return false, "BUSY";
                end

                -- 开始执行
                mie_bundle_state2.components.mie_bundle:Main(target, invobject, doer);
                mie_bundle_state2.Transform:SetPosition(targetpos:Get());

                return true, "SUCCESS"; --成功并不会说话
            end

        end,
        actiondata = {},
        state = "dolongaction"
    },

    ["MIE_BUNDLE_ACTION"] = {
        execute = config_data.mie_bundle,
        id = "MIE_BUNDLE_ACTION",
        str = "打包",
        fn = function(act)
            local target = act.target
            local invobject = act.invobject
            local doer = act.doer
            if target and invobject and doer then
                local targetpos = target:GetPosition();
                if not (targetpos.x and targetpos.y and targetpos.z) then
                    return false, "NOPT";
                end


                local mie_bundle_state2 = SpawnPrefab("mie_bundle_state2", invobject.linked_skinname, invobject.skin_id);

                if not mie_bundle_state2.components.mie_bundle:IsLegitimateTarget(target) then
                    mie_bundle_state2:Remove();
                    return false, "CANNOT";
                end

                if target.components.teleporter and target.components.teleporter:IsBusy() then
                    mie_bundle_state2:Remove()
                    return false, "BUSY";
                end

                -- 开始执行
                mie_bundle_state2.components.mie_bundle:Main(target, invobject, doer);
                mie_bundle_state2.Transform:SetPosition(targetpos:Get());

                return true, "SUCCESS"; --成功并不会说话
            end

        end,
        actiondata = {},
        state = "dolongaction"
    },
    -- endregion
}

-- testfn： 满足条件后加入动作队列。
local component_actions = {
    {
        actiontype = "SCENE",
        component = "mone_waterchest_structure", --? 耕地机有这个组件(workable)吗？肯定没有的啊。
        tests = {
            {
                execute = custom_actions["MONE_WATERCHEST_HAMMER"].execute,
                id = "MONE_WATERCHEST_HAMMER",
                testfn = function(inst, doer, actions, right)
                    return inst and inst:HasTag("mone_waterchest_structure") and right;
                end
            }
        }
    },
    {
        actiontype = "USEITEM",
        component = "inventoryitem",
        tests = {
            {
                execute = custom_actions["MONE_REPAIR_OBJECT"].execute,
                id = "MONE_REPAIR_OBJECT",
                testfn = function(inst, doer, target, actions, right)
                    -- 打个补丁吧，懒得修改了。
                    -- target.mone_repair_materials == nil 代表客机没有添加或者是压根不能修复！
                    if target and target:HasTag("mone_can_be_repaired_modify_nightstick")
                            and target.mone_repair_materials == nil then
                        target.mone_repair_materials = { transistor = 0.5 };
                    end

                    return inst and target and containValue(target.mone_repair_materials, inst.prefab) and target:HasTag("mone_can_be_repaired") and right;
                end
            }
        }
    },
    {
        actiontype = "USEITEM",
        component = "mone_pheromonestone",
        tests = {
            {
                execute = custom_actions["MONE_PHEROMONESTONE_INFINITE"].execute,
                id = "MONE_PHEROMONESTONE_INFINITE",
                testfn = function(inst, doer, target, actions, right)
                    local function IsValidTarget(targ)
                        if table.contains({
                            "autotrap_book", "xinhua_dictionary", "closed_book", "immortal_book", "unsolved_book",
                            "medal_naughtybell", "medal_spacetime_crystalball", "monster_book",
                        }, targ.prefab) then
                            return true;
                        end

                        if string.find(targ.prefab, "wx78module_") then
                            return true;
                        end

                        return targ:HasTag("_equippable")
                                or targ:HasTag("book")
                                or targ:HasTag("guitar")
                                or targ:HasTag("pheromonestone_target");
                    end

                    return inst and inst.prefab == "mone_pheromonestone" and
                            target and target:HasTag("mone_pheromonestone_infinite")
                            and IsValidTarget(target) and right;
                end
            }
        }
    },
    {
        actiontype = "USEITEM",
        component = "mone_pheromonestone2",
        tests = {
            {
                execute = custom_actions["MONE_PHEROMONESTONE_ETERNITY"].execute,
                id = "MONE_PHEROMONESTONE_ETERNITY",
                testfn = function(inst, doer, target, actions, right)
                    return inst and inst.prefab == "mone_pheromonestone2" and target and target:HasTag("mone_pheromonestone_eternity") and right;
                end
            }
        }
    },
    {
        actiontype = "USEITEM",
        component = "mone_poisonblam",
        tests = {
            {
                execute = custom_actions["MONE_POISONBLAM_ROTTEN"].execute,
                id = "MONE_POISONBLAM_ROTTEN",
                testfn = function(inst, doer, target, actions, right)
                    return target and target:HasTag("mone_poisonblam_perishable_target") and right;
                end
            }
        }
    },
    {
        actiontype = "SCENE",
        component = "mone_bathat_fly",
        tests = {
            {
                execute = custom_actions["MONE_BATHAT"].execute,
                id = "MONE_BATHAT",
                testfn = function(inst, doer, actions, right)
                    return inst and doer and inst == doer and inst:HasTag("mone_bathat_fly_isEquiped") and right;
                end
            }
        }
    },
    {
        actiontype = "USEITEM",
        component = "mone_glommer_poop_food",
        tests = {
            {
                execute = custom_actions["MONE_FEED_GLOMMER"].execute,
                id = "MONE_FEED_GLOMMER",
                testfn = function(inst, doer, target, actions, right)
                    return doer:HasTag("player") and target.prefab == "glommer";
                end
            }
        }
    },
    -- region 更多物品·拓展包
    {
        actiontype = "USEITEM",
        component = "mie_ordinary_bundle_action",
        tests = {
            {
                execute = custom_actions["MIE_ORDINARY_BUNDLE_ACTION"].execute,
                id = "MIE_ORDINARY_BUNDLE_ACTION",
                testfn = function(inst, doer, target, actions, right)
                    return inst and inst:HasTag("mie_ordinary_bundle_state1") and target and not target:HasTag("INLIMBO") and right;
                end
            }
        }
    },
    {
        actiontype = "USEITEM",
        component = "mie_bundle_action",
        tests = {
            {
                execute = custom_actions["MIE_BUNDLE_ACTION"].execute,
                id = "MIE_BUNDLE_ACTION",
                testfn = function(inst, doer, target, actions, right)
                    return inst and inst:HasTag("mie_bundle_state1") and target and not target:HasTag("INLIMBO") and right;
                end
            }
        }
    },
    {
        actiontype = "USEITEM",
        component = "mie_book_silviculture_action", -- 拥有这个组件的物品，对着目标。。。
        tests = {
            {
                execute = custom_actions["MIE_BOOK_SILVICULTURE_ACTION"].execute,
                id = "MIE_BOOK_SILVICULTURE_ACTION",
                testfn = function(inst, doer, target, actions, right)
                    return inst and target and target:HasTag("mie_book_silviculture") and right;
                end
            }
        }
    },
    -- endregion
}

local old_actions = {
    {
        execute = true, id = "PICK", -- 采集
        actiondata = {

        },
        state = {
            testfn = function(doer, action)
                if doer:HasTag("mone_fast_picker") or doer:HasTag("mone_orangestaff_fast_picker") then
                    return true;
                end
            end,
            deststate = function(doer, action)
                return "attack" --原：doshortaction
            end
        }
    },
    {
        execute = true, id = "HARVEST", -- 收获
        actiondata = {

        },
        state = {
            testfn = function(doer, action)
                if doer:HasTag("mone_fast_picker") or doer:HasTag("mone_orangestaff_fast_picker") then
                    return true
                end
            end,
            deststate = function(doer, action)
                return "attack"
            end
        }
    },
    {
        execute = true, id = "TAKEITEM", -- 拿东西
        actiondata = {

        },
        state = {
            testfn = function(doer, action)
                if doer:HasTag("mone_fast_picker") or doer:HasTag("mone_orangestaff_fast_picker") then
                    return true
                end
            end,
            deststate = function(doer, action)
                return "attack"
            end
        }
    },
}


--[[ FLY 限制飞行时的行为 ]]
if TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA.bathat and false then
    local FLY_CANT_ACTIONS_ID = { "PICK", "HARVEST", "TAKEITEM" }

    table.insert(FLY_CANT_ACTIONS_ID, "PICKUP"); -- 捡起
    table.insert(old_actions, { execute = true, id = "PICKUP" });
    table.insert(FLY_CANT_ACTIONS_ID, "MOUNT"); -- 骑牛
    table.insert(old_actions, { execute = true, id = "MOUNT" });
    table.insert(FLY_CANT_ACTIONS_ID, "MIGRATE");
    table.insert(old_actions, { execute = true, id = "MIGRATE" });
    table.insert(FLY_CANT_ACTIONS_ID, "HAUNT");
    table.insert(old_actions, { execute = true, id = "HAUNT" });
    table.insert(FLY_CANT_ACTIONS_ID, "JUMPIN");
    table.insert(old_actions, { execute = true, id = "JUMPIN" });

    -- 保存老动作的 fn
    for _, act in ipairs(old_actions) do
        old_actions_fn[act.id] = ACTIONS[act.id].fn;
    end

    for _, id in ipairs(FLY_CANT_ACTIONS_ID) do
        if ACTIONS[id] then
            if STRINGS.CHARACTERS.GENERIC.ACTIONFAIL[id] == nil then
                STRINGS.CHARACTERS.GENERIC.ACTIONFAIL[id] = {};
            end
            STRINGS.CHARACTERS.GENERIC.ACTIONFAIL[id].MONE_FAIL = L and "飞行中，请降落！" or "In flight, please land!";
        end
    end

    local function seqContainsValue(list, val)
        for _, v in ipairs(list) do
            if v == val then
                return true;
            end
        end
    end
    -- 限制飞行动作
    for _, data in ipairs(old_actions) do
        if seqContainsValue(FLY_CANT_ACTIONS_ID, data.id) then
            local old_fn = data.actiondata and data.actiondata.fn;
            data.actiondata = {
                fn = function(act)
                    if act.doer and act.doer:HasTag("mone_bathat_fly") then
                        return false, "MONE_FAIL";
                    else
                        return (old_fn and old_fn(act)) or old_actions_fn[data.id](act);
                    end
                end
            }
        end
    end
end

API.addCustomActions(env, custom_actions, component_actions);
API.modifyOldActions(env, old_actions);


-- 设置修复动作(我的动作)的优先级高于存放动作
if ACTIONS["STORE"] and ACTIONS["MONE_REPAIR_OBJECT"] then
    ACTIONS["MONE_REPAIR_OBJECT"].priority = ACTIONS["STORE"].priority + 1;
end

-- 腐化动作优先级高于存放动作
if ACTIONS["STORE"] and ACTIONS["MONE_POISONBLAM_ROTTEN"] then
    ACTIONS["MONE_POISONBLAM_ROTTEN"].priority = ACTIONS["STORE"].priority + 1;
end

-- 进阶动作优先级高于存放动作
if ACTIONS["STORE"] and ACTIONS["MONE_PHEROMONESTONE_INFINITE"] then
    ACTIONS["MONE_PHEROMONESTONE_INFINITE"].priority = ACTIONS["STORE"].priority + 1;
end

-- 逆转动作优先级高于存放动作
if ACTIONS["STORE"] and ACTIONS["MONE_PHEROMONESTONE_ETERNITY"] then
    ACTIONS["MONE_PHEROMONESTONE_ETERNITY"].priority = ACTIONS["STORE"].priority + 1;
end

-- region 更多物品·拓展包

-- 修改优先级
if ACTIONS.MIE_ORDINARY_BUNDLE_ACTION and ACTIONS.STORE then
    ACTIONS.MIE_ORDINARY_BUNDLE_ACTION.priority = ACTIONS.STORE.priority + 1;
end

if ACTIONS.MIE_BUNDLE_ACTION and ACTIONS.STORE then
    ACTIONS.MIE_BUNDLE_ACTION.priority = ACTIONS.STORE.priority + 1;
end

if ACTIONS.MIE_BOOK_SILVICULTURE_ACTION and ACTIONS.STORE then
    ACTIONS.MIE_BOOK_SILVICULTURE_ACTION.priority = ACTIONS.STORE.priority + 1;
end

-- stings 动作的定义要在动作加载之后
STRINGS.ACTIONS.MIE_BOOK_SILVICULTURE_ACTION = {
    EXCEPTION = "EXCEPTION",
    OPEN = "打开容器",
    CLOSE = "关闭容器"
}

--- endregion

-- 修一个我也不知道为什么会报错的bug？
--[[
    [00:32:38]: MOD_COMPONENT_ACTIONS is

    [00:32:38]: [string "scripts/componentactions.lua"]:2512: attempt to index a nil value
    LUA ERROR stack traceback:
        scripts/componentactions.lua:2512 in (method) HasActionComponent (Lua) <2501-2523>
        scripts/actions.lua:813 in () ? (Lua) <812-821>
        =(tail call):-1 in ()  (tail) <-1--1>
        scripts/bufferedaction.lua:63 in (method) GetActionString (Lua) <50-64>
        scripts/widgets/hoverer.lua:63 in (method) OnUpdate (Lua) <30-146>
        scripts/frontend.lua:836 in (method) Update (Lua) <657-854>
        scripts/update.lua:92 in () ? (Lua) <33-135>

    2023-02-20-15:36 确定了一点，以下函数已经调用了
    local function ModComponentWarning(self, modname)
        print("ERROR: Mod component actions are out of sync for mod "..(modname or "unknown")..". This is likely a result of your mod's calls to AddComponentAction not happening on both the server and the client.")
        print("self.modactioncomponents is\n"..(dumptable(self.modactioncomponents) or ""))
        print("MOD_COMPONENT_ACTIONS is\n"..(dumptable(MOD_COMPONENT_ACTIONS) or ""))
    end

    所以我如果 return {} 是不是并没有什么大的影响？因为以下函数中已经判空了！
    function EntityScript:HasActionComponent(name)
        local id = ACTION_COMPONENT_IDS[name]
        if id ~= nil then
            for i, v in ipairs(self.actioncomponents) do
                if v == id then
                    return true
                end
            end
        end
        if self.modactioncomponents ~= nil then
            for modname, cmplist in pairs(self.modactioncomponents) do
                id = CheckModComponentIds(self, modname)[name]
                if id ~= nil then -- NOTE: 此处判空了！所以应该没问题吧？
                    for i, v in ipairs(cmplist) do
                        if v == id then
                            return true
                        end
                    end
                end
            end
        end
        return false
    end

]]

--[[ 兼容黑化动作行为学 ]]
do
    local ActionQueuer = ({ pcall(function()
        return require("components/actionqueuer");
    end) })[2];
    if isTab(ActionQueuer) then
        local QueuerActions = {
            ["MONE_FEED_GLOMMER"] = "allclick";
        }
        if AddActionQueuerAction and next(QueuerActions) then
            for k, v in pairs(QueuerActions) do
                AddActionQueuerAction(v, k, true)
            end
        end
    end
end

if true --[[ 保证默认开启 ]] then
    local function GetLocalFn(fn, fn_name)
        local level = 1;
        local MAX_LEVEL = 20;
        for i = 1, math.huge do
            local name, value = debug.getupvalue(fn, level);
            if name and name == fn_name then
                if value and type(value) == "function" then
                    return value, level;
                end
                break ;
            end
            level = level + 1;
            if level > MAX_LEVEL then
                break ;
            end
        end
    end

    -- 必须在调用 GetLocalFn 找到后，再调用该函数！
    local function SetLocalFn(fn, up, value)
        debug.setupvalue(fn, up, value);
    end

    -- 已知神话书说、太真等模组会触发。后面发现我的 海上背包 居然也会触发。
    if EntityScript then
        local old_HasActionComponent = EntityScript.HasActionComponent;
        local CheckModComponentIds, up = GetLocalFn(old_HasActionComponent, "CheckModComponentIds");
        --print("", "", tostring(CheckModComponentIds), tostring(up));
        if CheckModComponentIds and up then
            SetLocalFn(old_HasActionComponent, up, function(self, modname, ...)
                -- self 应该是绑定的预制物
                --do
                --    -- TEST
                --    print("SetLocalFn: " .. tostring(self) .. " " .. tostring(modname));
                --    print("CheckModComponentIds(self, modname): " .. tostring(CheckModComponentIds(self, modname)));
                --    print();
                --end

                local message = "self: " .. tostring(self) .. ", self.prefab: " .. tostring(self.prefab);

                --print("test: " .. message);

                -- 2023-04-22：这样解决也不是个事，未来试试彻底解决吧！
                ---- 鼠标快速移动上去触发？
                local result = CheckModComponentIds(self, modname, ...);
                if result == nil then
                    print("ChangNote: This is a ChangNote about an inexplicable bug.");
                    print("Message: " .. message);
                end
                return result or {};
            end)
        end
    end

    -- 处理一个类似的问题，反正只能不让客户端报错，具体为什么不知道怎么解决。已知：花样风滚草+能力勋章
    --if EntityScript then
    --    local old_RegisterComponentActions = EntityScript.RegisterComponentActions;
    --    function EntityScript:RegisterComponentActions(name, ...)
    --        if (self.modactioncomponents == nil) or (self.actionreplica and self.actionreplica.modactioncomponents == nil) then
    --            return ;
    --        end
    --        if old_RegisterComponentActions then
    --            old_RegisterComponentActions(self, name, ...);
    --        end
    --    end
    --end
end

--local function GetLocalFn(fn, fn_name)
--    local level = 1;
--    local MAX_LEVEL = 20;
--    for i = 1, math.huge do
--        local name, value = debug.getupvalue(fn, level);
--        if name and name == fn_name then
--            if value and type(value) == "function" then
--                return value, level;
--            end
--            break ;
--        end
--        level = level + 1;
--        if level > MAX_LEVEL then
--            break ;
--        end
--    end
--end
--
--local function SetLocalFn(fn, up, value)
--    debug.setupvalue(fn, up, value);
--end
--
--if EntityScript then
--    local old_HasActionComponent = EntityScript.HasActionComponent;
--    local CheckModComponentIds, up = GetLocalFn(old_HasActionComponent, "CheckModComponentIds");
--    if CheckModComponentIds and up then
--        SetLocalFn(old_HasActionComponent, up, function(self, modname)
--            local result = CheckModComponentIds(self, modname);
--            return result or {};
--        end)
--    end
--end
