---
--- Created by zsh
--- DateTime: 2023/10/22 20:33
---

local config_data = TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA;

------------------------------------------------ 23/10/29 BEGIN NEW WORLD

morel_add_PrefabFiles({ "new_prefabs/more_items_instruction_book" })
env.modimport("modmain/newworld/postinit/more_items_instruction_book.lua")

-- Add new prefabs, but they are still incomplete.
morel_add_PrefabFiles({ "new_prefabs/prefabs_inspiration_1" })
env.modimport("modmain/newworld/postinit/prefabs_inspiration_1.lua")
------------------------------------------------ 23/10/29 END NEW WORLD


-- region 更多物品·拓展包
env.modimport("modmain/PostInit/prefabs/simplebooks.lua");
env.modimport("modmain/PostInit/prefabs/mie_bundle.lua");

if config_data.mie_wooden_drawer then
    table.insert(env.PrefabFiles, "mone/mie/mine/wooden_drawer");
end

if config_data.mie_relic_2 then
    table.insert(env.PrefabFiles, "mone/mie/mine/relic_2");
end

if config_data.mie_dummytarget then
    table.insert(env.PrefabFiles, "mone/mie/game/dummytarget");
end

if config_data.mie_waterpump then
    table.insert(env.PrefabFiles, "mone/mie/game/waterpump");
    env.modimport("modmain/PostInit/prefabs/waterpump.lua");
end

if config_data.mie_sand_pit then
    table.insert(env.PrefabFiles, "mone/mie/game/sand_pit");
end

if config_data.mie_icemaker then
    table.insert(env.PrefabFiles, "mone/mie/mine/icemaker");
end

if config_data.mie_ordinary_bundle then
    table.insert(env.PrefabFiles, "mone/mie/game/ordinary_bundle");
end
if config_data.mie_bundle then
    table.insert(env.PrefabFiles, "mone/mie/game/bundle");
end

if config_data.mie_fish_box then
    table.insert(env.PrefabFiles, "mone/mie/game/fish_box");
    env.modimport("modmain/PostInit/prefabs/fish_box.lua");
end

if config_data.mie_bushhat then
    env.modimport("modmain/PostInit/prefabs/bushhat.lua");
end

if config_data.mie_tophat then
    env.modimport("modmain/PostInit/prefabs/tophat.lua");
end

if config_data.mie_obsidianfirepit then
    table.insert(env.PrefabFiles, "mone/mie/mine/obsidianfirepit");
    table.insert(env.PrefabFiles, "mone/mie/mine/obsidianfirefire");
end

if config_data.mie_bear_skin_cabinet then
    table.insert(env.PrefabFiles, "mone/mie/mine/bear_skin_cabinet");
    env.modimport("modmain/PostInit/prefabs/bear_skin_cabinet.lua");
end

if config_data.mie_watersource then
    table.insert(env.PrefabFiles, "mone/mie/mine/watersource");
end

env.modimport("modmain/PostInit/prefabs/foods.lua");

-- endregion