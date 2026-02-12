---
--- @author zsh in 2023/8/9 1:14
---


-- 这里的代码就是一坨 shit，我当初怎么想的？
-- 果然，除了写代码以外还得多看书。。。叹气~

local Logger = print;
local CONFIG_DATA = TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA;
local EnabledItems = {};

-- 25/05/28: key 是去 TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA 取数据的
local function AddEnabledItem(key, fn, disabled, debug)
    if debug and not isDebug() or key == "" then
        return ;
    end
    key = string.match(key, "[^|]+") or key;
    local entry = {
        switch = CONFIG_DATA[key];
        disabled = disabled;
        fn = fn;
    }
    if key == "default" or key == "test" then
        entry.switch = true;
    end
    EnabledItems[key] = entry;
end

local function ExecuteEnabledItems()
    local cnt = 0;
    for k, v in pairs(EnabledItems) do
        if v.disabled ~= true and v.switch then
            cnt = cnt + 1;
            v.fn();
            --Logger(k .. " imported successfully!");
        end
    end
    --Logger(tostring(cnt) .. " items were successfully imported!");
end

-- 食人花宝箱
AddEnabledItem("lureplant", function()
    AddPrefabFiles(env, {
        "mone/game/lureplant",
    });
    env.modimport("modmain/PostInit/prefabs/lureplant.lua");
end);

-- 升级版·猪鼻铸币
AddEnabledItem("pig_coin", function()
    AddPrefabFiles(env, {
        "mone/game/pig_coin",
    });
end);

-- 升级版·挖洞兔角号
AddEnabledItem("rabbitkinghorn", function()
    AddPrefabFiles(env, {
        "mone/game/rabbitkinghorn",
        "mone/game/rabbitkinghorn_chest"
    });
end);

-- 升级版·晾肉架
AddEnabledItem("meatrack", function()
    AddPrefabFiles(env, {
        "mone/game/meatrack"
    });
    env.modimport("modmain/PostInit/prefabs/meatrack.lua");
end);

-- 超级牛铃
AddEnabledItem("beef_bell", function()
    AddPrefabFiles(env, {
        "mone/game/beef_bell"
    });
    env.modimport("modmain/PostInit/prefabs/beef_bell.lua");
end);

-- 升级版·蝙蝠棒
-- AddEnabledItem("batbat", function()
--     AddPrefabFiles(env, {
--         "mone/game/batbat"
--     });
--     env.modimport("modmain/PostInit/prefabs/batbat.lua");
-- end);


-- 升级版·晨星锤
-- AddEnabledItem("nightstick", function()
--     AddPrefabFiles(env, {
--         "mone/game/nightstick"
--     });
--     env.modimport("modmain/PostInit/prefabs/nightstick.lua");
-- end);


-- 升级版·三尾猫鞭
-- AddEnabledItem("whip", function()
--     AddPrefabFiles(env, {
--         "mone/game/whip"
--     });
--     env.modimport("modmain/PostInit/prefabs/whip.lua");
-- end);


-- 小食物袋
AddEnabledItem("spicepack", function()
    AddPrefabFiles(env, {
        "mone/game/spicepack"
    });
end);

-- 腐化火腿棒
AddEnabledItem("mone_hambat", function()
    AddPrefabFiles(env, {
        "mone/game/hambat"
    });
    env.modimport("modmain/PostInit/prefabs/hambat.lua");
end);

-- 单身狗
AddEnabledItem("single_dog", function()
    AddPrefabFiles(env, {
        "mone/mine/single_dog"
    });
end);

-- 渔网
AddEnabledItem("fishingnet", function()
    AddPrefabFiles(env, {
        "mone/game/fishingnet/fishingnet",
        "mone/game/fishingnet/fishingnetvisualizer"
    });
    env.modimport("modmain/PostInit/prefabs/fishingnet.lua");
end);


-- 临时加速手杖
AddEnabledItem("walking_stick", function()
    AddPrefabFiles(env, {
        "mone/mine/walking_stick"
    });
end);


-- 毒矛
AddEnabledItem("spear_poison", function()
    AddPrefabFiles(env, {
        "mone/mine/spear_poison"
    });
    env.modimport("modmain/PostInit/prefabs/spear_poison.lua");
end);


-- 收割者的砍刀系列
AddEnabledItem("harvester_staff", function()
    AddPrefabFiles(env, {
        "mone/mine/harvester_staff"
    });
end);


-- 多功能·戟
AddEnabledItem("halberd", function()
    AddPrefabFiles(env, {
        "mone/mine/halberd"
    });
end);


-- 智慧帽
AddEnabledItem("brainjelly", function()
    env.modimport("modmain/PostInit/prefabs/brainjelly.lua");
end);


-- 蝙蝠帽
AddEnabledItem("bathat", function()
    env.modimport("modmain/PostInit/prefabs/bathat.lua");
end);

-- 小书架
AddEnabledItem("bookstation", function()
    AddPrefabFiles(env, {
        "mone/game/bookstation"
    });
end);

AddEnabledItem("wathgrithr_box", function()
    AddPrefabFiles(env, {
        "mone/real_mine/wathgrithr_box"
    });
end);

AddEnabledItem("wanda_box", function()
    AddPrefabFiles(env, {
        "mone/real_mine/wanda_box"
    });
    env.modimport("modmain/PostInit/prefabs/wanda_box.lua");
end);

AddEnabledItem("candybag", function()
    AddPrefabFiles(env, {
        "mone/game/candybag"
    });
    env.modimport("modmain/PostInit/prefabs/candybag.lua");
end);

AddEnabledItem("storage_bag", function()
    AddPrefabFiles(env, {
        "mone/mine/storage_bag"
    });
    env.modimport("modmain/PostInit/prefabs/storage_bag.lua");
end);

AddEnabledItem("icepack", function()
    AddPrefabFiles(env, {
        "mone/game/icepack"
    });
    env.modimport("modmain/PostInit/prefabs/icepack.lua");
end);

AddEnabledItem("tool_bag", function()
    AddPrefabFiles(env, {
        "mone/mine/tool_bag"
    });
end);

AddEnabledItem("piggybag", function()
    AddPrefabFiles(env, {
        "mone/real_mine/piggybag"
    });
    env.modimport("modmain/PostInit/prefabs/piggybag.lua");
end);

AddEnabledItem("seasack", function()
    AddPrefabFiles(env, {
        "mone/mine/seasack"
    });
end);

AddEnabledItem("skull_chest", function()
    AddPrefabFiles(env, {
        "mone/mine/skull_chest"
    });
    env.modimport("modmain/PostInit/prefabs/skull_chest.lua");
end);

AddEnabledItem("nightspace_cape", function()
    AddPrefabFiles(env, {
        "mone/mine/nightspace_cape2"
    });
    env.modimport("modmain/PostInit/prefabs/nightspace_cape.lua");
end);

AddEnabledItem("waterchest", function()
    AddPrefabFiles(env, {
        "mone/mine/waterchest"
    });
    env.modimport("modmain/PostInit/prefabs/waterchest.lua");
end);

AddEnabledItem("mone_seedpouch", function()
    AddPrefabFiles(env, {
        "mone/game/seedpouch"
    });
end);

AddEnabledItem("chiminea", function()
    table.insert(env.PrefabFiles, "mone/mine/chiminea");
    env.modimport("modmain/PostInit/prefabs/chiminea.lua");
end);

AddEnabledItem("garlic_structure", function()
    table.insert(env.PrefabFiles, "mone/game/garlic_structure");
    env.modimport("modmain/PostInit/prefabs/garlic_structure.lua");
end);

AddEnabledItem("arborist", function()
    table.insert(env.PrefabFiles, "mone/mine/arborist2");
end);

AddEnabledItem("city_lamp", function()
    table.insert(env.PrefabFiles, "mone/mine/city_lamp");
end);

AddEnabledItem("chests_boxs", function()
    AddPrefabFiles(env, {
        "mone/game/treasurechest",
        "mone/game/dragonfly_chest",
        "mone/game/icebox",
        "mone/game/saltbox"
    });
    env.modimport("modmain/PostInit/prefabs/chests.lua");
    env.modimport("modmain/PostInit/prefabs/boxs.lua");
end);

AddEnabledItem("firesuppressor", function()
    table.insert(env.PrefabFiles, "mone/game/firesuppressor");
end);

AddEnabledItem("dragonflyfurnace", function()
    table.insert(env.PrefabFiles, "mone/game/dragonfurnace"); -- 这文件名没有ly...
    env.modimport("modmain/PostInit/prefabs/dragonfurnace.lua");
end);

AddEnabledItem("farm_plow", function()
    table.insert(env.PrefabFiles, "mone/game/farm_plow");
    env.modimport("modmain/PostInit/prefabs/farm_plow.lua");
end);

AddEnabledItem("moondial", function()
    table.insert(env.PrefabFiles, "mone/game/moondial");
    env.modimport("modmain/PostInit/prefabs/moondial.lua");
end);

AddEnabledItem("wardrobe", function()
    table.insert(env.PrefabFiles, "mone/game/wardrobe");
end);

AddEnabledItem("poisonblam", function()
    table.insert(env.PrefabFiles, "mone/mine/poisonblam");
    env.modimport("modmain/PostInit/prefabs/poisonblam.lua");
end);

AddEnabledItem("redlantern", function()
    table.insert(env.PrefabFiles, "mone/game/redlantern");
    env.modimport("modmain/PostInit/prefabs/redlantern.lua");
end);

AddEnabledItem("orangestaff", function()
    table.insert(env.PrefabFiles, "mone/game/orangestaff");
end);

AddEnabledItem("glommer_poop_food", function()
    table.insert(env.PrefabFiles, "mone/game/glommer_poop_food");
    env.modimport("modmain/PostInit/prefabs/glommer_poop_food.lua");
end);

AddEnabledItem("terraria", function()
    table.insert(env.PrefabFiles, "mone/game/terraria");
    env.modimport("modmain/PostInit/prefabs/terraria.lua");
end);

AddEnabledItem("armor_metalplate", function()
    table.insert(env.PrefabFiles, "mone/mine/armor_metalplate");
end);

AddEnabledItem("boomerang", function()
    table.insert(env.PrefabFiles, "mone/game/boomerang");
    env.modimport("modmain/PostInit/prefabs/boomerang.lua");
end);

AddEnabledItem("waterballoon", function()
    table.insert(env.PrefabFiles, "mone/game/waterballoon");
    env.modimport("modmain/PostInit/prefabs/waterballoon3.lua");
end);

AddEnabledItem("pheromonestone", function()
    table.insert(env.PrefabFiles, "mone/mine/pheromonestone");
    env.modimport("modmain/PostInit/prefabs/pheromonestone.lua");
end);

AddEnabledItem("pheromonestone2", function()
    table.insert(env.PrefabFiles, "mone/mine/pheromonestone2");
    env.modimport("modmain/PostInit/prefabs/pheromonestone2.lua");
end);

-- 施肥瓦器人
AddEnabledItem("mone_fertilizer_bot", function()
    table.insert(env.PrefabFiles, "mone/mine/mone_fertilizer_bot");
    env.modimport("modmain/PostInit/prefabs/mone_fertilizer_bot.lua");
end);

ExecuteEnabledItems();