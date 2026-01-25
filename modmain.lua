---
--- @author zsh in 2023/1/8 5:50
---

GLOBAL.setmetatable(env, { __index = function(_, k)
    return GLOBAL.rawget(GLOBAL, k);
    -- 下面这一行是怎么 C stack overflow 的，没看出来为什么呀。
    -- 说实话，我感觉写饥荒模组实在是太浪费时间了。一个小时很有可能半个小时都是无意义的重启游戏。
    --if getmetatable(GLOBAL).__declared[k] then
    --    return GLOBAL[k]
    --else
    --    return GLOBAL.rawget(GLOBAL, k)
    --end
end });

-- NEW WORLD: must be imported at the head.
env.modimport("new_modmain_preload.lua")

env.modimport("modtuning.lua"); -- PS: 我应该将我的客户端和服务端部分代码区分一下的。

-- 230912：这个不对？和 kleiloadlua 造成的环境出问题了？有空研究一下...是不是 xpcall 会隔离环境啊？
-- 用 setfenv(fn, fnenv) 应该可以解决
--env.modimport = function(...)
--    local args = { ... };
--    local n = select("#", ...);
--    local ret = {};
--    xpcall(function()
--        ret = { env.modimport(unpack(args, 1, n)) };
--    end, function(msg) print("error(more items): " .. msg); end)
--    return unpack(ret, 1, table.maxn(ret));
--end


local API = require("chang_mone.dsts.API");
local config_data = TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA;

env.modimport("modmain/preload.lua");

env.modimport("modmain/modglobal.lua"); -- must be imported with the highest priority
env.modimport("modmain/global.lua"); -- must be imported after "modmain/modglobal.lua"
--env.modimport("modmain/logger.lua"); -- temp garbage



env.modimport("modmain/Optimization/main.lua");

env.modimport("modmain/compatibility.lua");

env.modimport("modmain/prefabfiles.lua");
env.modimport("modmain/assets.lua");

require("languages.mone.loc"); -- 2023-05-20：找机会处理一下这里，太难看了

env.modimport("modmain/containers.lua");

env.modimport("modmain/init/init_tooltips.lua");

env.modimport("modmain/recipes.lua");
env.modimport("modmain/minimap.lua");
env.modimport("modmain/actions.lua");
env.modimport("modmain/shard_sync.lua"); -- Mod RPC 跨服务器数据同步
env.modimport("modmain/reskin.lua");

env.modimport("modmain/AUXmods/more_equipments/application.lua"); -- 关闭后可以等价于未导入
env.modimport("modmain/PostInit/moreitems_equipment.lua"); -- 关闭后可以等价于未导入
env.modimport("modmain/AUXmods/never_finish_series/application.lua"); -- 关闭后可以等价于未导入

env.modimport("modmain/OriginalItemsModifications/main.lua"); -- 关闭后可以等价于未导入


--[[添加新物品
    init/init_tooltips.lua
    languages.mone.loc
    enable_prefabs.lua
    recipes.lua

    containers.lua
    minimap.lua
    reskin.lua
]]

--[[todolist
    玩家建议：“希望能融合 智能灭火器/(冷)火坑mod 这样就不怕忘记添加燃料了，也不用开无限燃料那么极端”

]]


--[[ Prefabs ]]
do
    env.modimport("modmain/enable_prefabs.lua");

    if config_data.backpack or config_data.piggyback then
        env.modimport("modmain/PostInit/prefabs/backpack_piggyback.lua");

        if config_data.mone_backpack_auto ~= false then
            if config_data.mone_backpack_auto == 1 then
                env.modimport("modmain/PostInit/backpack_piggyback.lua");
            else
                env.modimport("modmain/PostInit/backpack_piggyback2.lua");
            end
        end

        if config_data.backpack then
            table.insert(env.PrefabFiles, "mone/game/backpack");
            env.modimport("modmain/PostInit/prefabs/piggyback.lua");
        end
        if config_data.piggyback then
            table.insert(env.PrefabFiles, "mone/game/piggyback");
        end
    end
end

--[[ PostInit ]]
do
    -- 2023-05-03：此处有注释的文件，我已经看过了，相关功能关闭后，几乎可以的等价于未生效的，问题不大。

    --[[ prefabs ]]
    env.modimport("modmain/PostInit/prefabs/wardrode.lua"); -- 关闭后可以等价于未导入

    env.modimport("modmain/PostInit/prefabs/mone_lifeinjector_vb.lua"); -- 关闭后可以等价于未导入
    env.modimport("modmain/PostInit/prefabs/mone_stomach_warming_hamburger.lua"); -- 关闭后可以等价于未导入
    env.modimport("modmain/PostInit/prefabs/mone_sanity_hamburger.lua"); -- 关闭后可以等价于未导入
    env.modimport("modmain/PostInit/prefabs/mone_guacamole.lua"); -- 关闭后可以等价于未导入

    --[[ root ]]
    env.modimport("modmain/PostInit/common.lua"); -- 关闭后可以大致等价于未导入

    env.modimport("modmain/PostInit/containers_commonly.lua"); -- \\\\此处是一堆对内容的修改\\\\

    env.modimport("modmain/PostInit/convenient_piggyback2.lua"); -- 关闭后可以大致等价于未导入

    env.modimport("modmain/PostInit/containers_onpickupfn_cancel.lua"); -- 关闭后可以等价于未导入
    env.modimport("modmain/PostInit/containers_onpickupfn_piggybag.lua"); -- 关闭后可以等价于未导入

    env.modimport("modmain/PostInit/keeponitems.lua"); -- 关闭后可以等价于未导入

    -- 25/06/09 待测试
    -- env.modimport("modmain/PostInit/toadstool_sporecloud.lua"); -- 关闭后可以等价于未导入

    -- 2023-09-??
    if config_data.mone_honey_ham_stick then
        env.modimport("modmain/PostInit/prefabs/multiple_drop.lua");
    end

    -- [2025-11-14]
    env.modimport("modmain/PostInit/upgraded_containers.lua");
end

--[[ AUXmods ]]
do
    env.modimport("modmain/sundry.lua"); -- 关闭后可以等价于未导入

    env.modimport("modmain/AUXmods/find_best_container.lua"); -- \\\\此处会必定导入\\\\
    env.modimport("modmain/AUXmods/button_containers2.lua"); -- \\\\此处会必定导入\\\\
    env.modimport("modmain/AUXmods/article_introduction.lua"); -- \\\\此处会必定导入\\\\

    env.modimport("modmain/AUXmods/reference.lua"); -- 2023-05-02：此处目前没有内容

    local function AUXmods()
        local c = config_data;
        local root = "modmain/AUXmods/";
        local oa = root .. "other_auxiliary/";
        local files_path_and_switch = {
            { root .. "container_removable", c.container_removable }, -- true、false、1
            { root .. "scroll_containers", c.scroll_containers }, -- 滚动条容器
            { root .. "chests_arrangement", c.chests_arrangement }, -- 箱子整理
            { root .. "current_date", c.current_date }, -- 当前时间
            { root .. "mods_modification", c.mods_modification_switch },

            { oa .. "trap_auto_reset", c.trap_auto_reset }, -- 狗牙陷阱自动重置
            { oa .. "better_beefalo", c.better_beefalo }, -- 更好的牛牛
            { oa .. "spawn_wormholes_worldpostinit", c.spawn_wormholes_worldpostinit }, -- 虫洞生成
            { oa .. "backpacks_light", c.backpacks_light }, -- 背包发光
            { oa .. "automatic_stacking", c.automatic_stacking }, -- 自动堆叠
            { oa .. "dont_drop_everything2", c.dont_drop_everything }, -- 物品不掉落
            { oa .. "simple_global_position_system", c.simple_global_position_system }, -- 简易全球定位
            { oa .. "dont_drop_winter_feast_things", c.dont_drop_winter_feast_things },
            { oa .. "simple_garbage_collection/simple_garbage_collection2", c.simple_garbage_collection }, -- 简易垃圾清理

        }
        for _, v in ipairs(files_path_and_switch) do
            if v[2] then
                env.modimport(v[1]);
            end
        end
    end
    AUXmods();


    -- 五格装备栏
    local function extra_equip_slots()
        -- 检测四格装备栏模组是否已启用（ID: 3574405615）
        if IsModEnabled("3574405615") or IsModEnabled("四格装备栏") then
            print("[更多物品] 检测到【四格装备栏】模组已启用，自动关闭本模组的五格装备栏功能")
            return
        end

        if config_data.extra_equip_slots then
            if config_data.extra_equip_slots == 4 then
                env.modimport("modmain/AUXmods/other_auxiliary/extra_equip_slots/four_slots.lua");
            elseif config_data.extra_equip_slots == 5 then
                -- 五格护甲和护符不好处理的吧...算了，五格仍用之前的吧！我暂时想把四格先完善好...
                --env.modimport("modmain/AUXmods/other_auxiliary/extra_equip_slots/five_slots.lua");
                env.modimport("modmain/AUXmods/other_auxiliary/extra_equip_slots.lua");
            else
                env.modimport("modmain/AUXmods/other_auxiliary/extra_equip_slots.lua");
            end

            -- COMMON CONTENT
            local function extra_equip_slots_optimization()
                -- 230621：兼容一下黑化行为学[2325441848]，行为学搜索背包用的是 GetEquippedItem(EQUIPSLOTS.BODY) 函数
                local ActionQueuer = ({ pcall(function()
                    return require("components/actionqueuer");
                end) })[2];
                if isTab(ActionQueuer) then
                    local function Replace(old_fn)
                        if not isFn(old_fn) then
                            return old_fn;
                        end
                        return function(...)
                            local body = EQUIPSLOTS.BODY;
                            EQUIPSLOTS.BODY = EQUIPSLOTS.BACK or EQUIPSLOTS.BODY;
                            local res = { old_fn(...) };
                            EQUIPSLOTS.BODY = body;
                            return unpack(res, 1, table.maxn(res));
                        end
                    end

                    local old_GetNewActiveItem = ActionQueuer.GetNewActiveItem;
                    if old_GetNewActiveItem then
                        ActionQueuer.GetNewActiveItem = Replace(old_GetNewActiveItem);
                    end

                    local old_GetNewEquippedItemInHand = ActionQueuer.GetNewEquippedItemInHand;
                    if old_GetNewEquippedItemInHand then
                        ActionQueuer.GetNewEquippedItemInHand = Replace(old_GetNewEquippedItemInHand);
                    end
                end
            end
            extra_equip_slots_optimization();

            -- 定时通告：提示用户五格装备栏已过时
            env.AddPlayerPostInit(function(inst)
                if not inst.components.health then
                    return
                end

                inst:DoTaskInTime(0, function()
                    if TheWorld and TheWorld.ismastersim then
                        local announcement_count = 0
                        local max_announcements = 3
                        local interval = 8 * 60 -- 8分钟

                        local function send_announcement()
                            announcement_count = announcement_count + 1
                            TheNet:Announce("[五格装备栏] 此功能已过时，请订阅作者的【四格装备栏】模组（ID: 3574405615）以获得更好的体验")

                            if announcement_count < max_announcements then
                                inst:DoTaskInTime(interval, send_announcement)
                            end
                        end

                        inst:DoTaskInTime(interval, send_announcement)
                    end
                end)
            end)
        end
    end
    extra_equip_slots();


    -- 堆叠修改
    local function stackable_change()
        if config_data.stackable_change_switch then
            -- 修改堆叠上限
            if config_data.maxsize_change then
                env.modimport("modmain/AUXmods/other_auxiliary/maxsize_change.lua");
            end
            -- 生物堆叠+其他堆叠：2023-06-22：想删掉...
            -- 2024-10-30：删除该功能
            --if config_data.creatures_stackable then
            --    env.modimport("modmain/AUXmods/other_auxiliary/creatures_stackable.lua");
            --end
        end
    end
    stackable_change();

end

--[[ Characters Change ]]
do
    env.modimport("modmain/enable_characters_change.lua");
end

--[[ Debug ]]
do
    if config_data.wormhole_marks then
        env.modimport("scripts/mi_modules/wormhole_marks/modmain.lua");
    end

    if API.isDebug(env) then
        -- looktietu
        if env.GetModConfigData("looktietu") then
            env.modimport("modmain/AUXmods/looktietu.lua");
        end
    end
end


-- must be imported
env.modimport("new_modmain.lua")

-- 2024-12-05-16:35 创建
-- 2025-01-12 更新后，创意工坊总是卡在 modmain2.lua，不知为何。
--env.modimport("modmain2.lua")

-- [2025-11-04]
env.modimport("modmain3.lua")


