---
--- @author zsh in 2023/3/24 13:31
---

-- modmain.lua 和 modworldgenmain.lua 的 env 是同一个！

TUNING.MORE_ITEMS_ON = true;

---
---parition: 分割，隔板
---
---不知道该如何命名...
---
local function get_parition_config(parition, target_key)
    return env.GetModConfigData(parition) and env.GetModConfigData(target_key) or false
end


--- 2025-07-01：复制过来的，不复用了
local moddir = KnownModIndex:GetModsToLoad(true)
local enablemods = {}

for k, dir in pairs(moddir) do
    local info = KnownModIndex:GetModInfo(dir)
    local name = info and info.name or "unknow"
    enablemods[dir] = name
end
-- MOD是否开启
local function IsModEnabled(name)
    for k, v in pairs(enablemods) do
        if v and (k:match(name) or v:match(name)) then
            return true
        end
    end
    return false
end

if IsModEnabled("2477889104") then

end

TUNING.MONE_TUNING = {
    ENV = env;
    DebugCommands = {
        PrintSeq = function(seq)
            for i, v in ipairs(seq) do
                print("", "[" .. tostring(i) .. "]: " .. tostring(v));
            end
        end
    },
    MY_MODULES = {
        MOBILE_ATTACK = {
            ENV = setmetatable({}, { __index = env })
        },
    },
    MI_MODULES = {
        HAMLET_GROUND = {
            ENV = setmetatable({}, { __index = env })
        },
        WORMHOLE_MARKS = {
            ENV = setmetatable({}, { __index = env })
        },
        WATHGRITHR_EXCLUSIVE_EQUIPMENTS = {
            ENV = setmetatable({}, { __index = env })
        }
    },
    WARDROBE_DISABLED = IsModEnabled("2039181790") or IsModEnabled("3191348907"),
    AUTO_SORTER = {
        whetherIsFull = env.GetModConfigData("auto_sorter_mode");
        nFullInterval = env.GetModConfigData("auto_sorter_is_full");
        auto_sorter_light = env.GetModConfigData("auto_sorter_light");
        auto_sorter_no_fuel = env.GetModConfigData("auto_sorter_no_fuel");
        auto_sorter_notags_extra = env.GetModConfigData("auto_sorter_notags_extra");
    };
    GET_MOD_CONFIG_DATA = {
        -- [[ 模组辅助功能 ]]
        container_removable = env.GetModConfigData("container_removable");
        current_date = env.GetModConfigData("current_date");
        backpack_arrange_button = env.GetModConfigData("backpack_arrange_button");
        klei_chests_arrangement_button = env.GetModConfigData("klei_chests_arrangement_button");
        klei_chests_storage_button = env.GetModConfigData("klei_chests_storage_button");
        compatible_with_maxwell = env.GetModConfigData("compatible_with_maxwell");


        --[[ 更多物品·便携容器 ]]
        mone_backpack_capacity = env.GetModConfigData("mone_backpack_capacity");
        mone_tool_bag_capacity = env.GetModConfigData("mone_tool_bag_capacity");
        mone_icepack_capacity = env.GetModConfigData("mone_icepack_capacity");
        mone_nightspace_cape_capacity = env.GetModConfigData("mone_nightspace_cape_capacity");
        mone_candybag_capacity = false;

        piggybag__change_image_enable = env.GetModConfigData("piggybag__change_image_enable"),
        piggybag__only_hold_container = env.GetModConfigData("piggybag__only_hold_container"),
        preserver_value = env.GetModConfigData("preserver_value");

        -- . 便携容器 总开关
        moreitems_portable_container = env.GetModConfigData("moreitems_portable_container");
        candybag = get_parition_config("moreitems_portable_container", "__candybag");
        backpack = get_parition_config("moreitems_portable_container", "__backpack");
        piggyback = get_parition_config("moreitems_portable_container", "__piggyback");
        piggybag = get_parition_config("moreitems_portable_container", "__piggybag");
        storage_bag = get_parition_config("moreitems_portable_container", "__storage_bag");
        icepack = get_parition_config("moreitems_portable_container", "__icepack");
        spicepack = get_parition_config("moreitems_portable_container", "__spicepack");
        tool_bag = get_parition_config("moreitems_portable_container", "__tool_bag");
        bookstation = get_parition_config("moreitems_portable_container", "__bookstation");
        waterchest = get_parition_config("moreitems_portable_container", "__waterchest");
        wathgrithr_box = get_parition_config("moreitems_portable_container", "__wathgrithr_box");
        wanda_box = get_parition_config("moreitems_portable_container", "__wanda_box");
        rabbitkinghorn = get_parition_config("moreitems_portable_container", "__rabbitkinghorn");


        --[[ 更多物品·箱子容器 ]]
        wardrobe_background = env.GetModConfigData("mone_wardrobe_background");
        mone_wardrobe_recovery_durability = env.GetModConfigData("mone_wardrobe_recovery_durability");

        mone_chests_boxs_capability = env.GetModConfigData("mone_chests_boxs_capability");
        chests_boxs_compatibility = env.GetModConfigData("chests_boxs_compatibility");

        -- . 箱子容器 总开关
        moreitems_chest_container = env.GetModConfigData("moreitems_chest_container");
        skull_chest = get_parition_config("moreitems_chest_container", "__skull_chest");
        chests_boxs = get_parition_config("moreitems_chest_container", "__chests_boxs");
        wardrobe = get_parition_config("moreitems_chest_container", "__wardrobe");
        mie_wooden_drawer = get_parition_config("moreitems_chest_container", "__mie_wooden_drawer");
        mie_fish_box = get_parition_config("moreitems_chest_container", "__mie_fish_box");
        mie_bear_skin_cabinet = get_parition_config("moreitems_chest_container", "__mie_bear_skin_cabinet");


        --[[ 更多物品·生活质量类 ]]
        -- . 生活质量类 总开关
        moreitems_living_quality = env.GetModConfigData("moreitems_living_quality");
        redlantern = get_parition_config("moreitems_living_quality", "__redlantern");
        harvester_staff = get_parition_config("moreitems_living_quality", "__harvester_staff");
        mone_hambat = get_parition_config("moreitems_living_quality", "__mone_hambat");

        city_lamp = get_parition_config("moreitems_living_quality", "__city_lamp");
        firesuppressor = get_parition_config("moreitems_living_quality", "__firesuppressor");
        meatrack = get_parition_config("moreitems_living_quality","__meatrack");
        chiminea = get_parition_config("moreitems_living_quality", "__chiminea");
        mie_sand_pit = get_parition_config("moreitems_living_quality","__mie_sand_pit");
        mie_watersource = get_parition_config("moreitems_living_quality","__mie_watersource");
        garlic_structure = get_parition_config("moreitems_living_quality", "__garlic_structure");

        poisonblam = get_parition_config("moreitems_living_quality", "__poisonblam");
        farm_plow = get_parition_config("moreitems_living_quality", "__farm_plow");
        mie_beefalofeed = get_parition_config("moreitems_living_quality","__mie_beefalofeed");
        
        mie_ordinary_bundle = get_parition_config("moreitems_living_quality","__mie_ordinary_bundle");
        beef_bell = get_parition_config("moreitems_living_quality", "__beef_bell");


        --[[ 更多物品·建筑 ]]
        -- . 建筑 总开关
        moreitems_structure = env.GetModConfigData("moreitems_structure");
        single_dog = get_parition_config("moreitems_structure", "__single_dog");
        arborist = get_parition_config("moreitems_structure", "__arborist");
        dragonflyfurnace = get_parition_config("moreitems_structure", "__dragonflyfurnace");
        moondial = get_parition_config("moreitems_structure", "__moondial");
        mie_icemaker = get_parition_config("moreitems_structure","__mie_icemaker");
        mie_dummytarget = get_parition_config("moreitems_structure","__mie_dummytarget");
        mie_relic_2 = get_parition_config("moreitems_structure","__mie_relic_2");
        mie_obsidianfirepit = get_parition_config("moreitems_structure","__mie_obsidianfirepit");
        mie_waterpump = get_parition_config("moreitems_structure","__mie_waterpump");

        mone_fertilizer_bot = get_parition_config("moreitems_structure", "__mone_fertilizer_bot");


        --[[ 更多物品·装备 ]]
        mone_boomerang_damage_multiple = env.GetModConfigData("mone_boomerang_damage_multiple");
        mone_seasack_capacity_increase = env.GetModConfigData("mone_seasack_capacity_increase");

        -- . 装备 总开关
        moreitems_equipment = env.GetModConfigData("moreitems_equipment");
        more_equipments = get_parition_config("moreitems_equipment", "more_equipments");

        spear_poison = get_parition_config("moreitems_equipment", "__spear_poison");
        fishingnet = get_parition_config("moreitems_equipment", "__fishingnet");
        halberd = get_parition_config("moreitems_equipment", "__halberd");
        walking_stick = get_parition_config("moreitems_equipment", "__walking_stick");
        boomerang = get_parition_config("moreitems_equipment", "__boomerang");
        orangestaff = get_parition_config("moreitems_equipment", "__telestaff");

        armor_metalplate = get_parition_config("moreitems_equipment", "__armor_metalplate");
        pith = get_parition_config("moreitems_equipment", "__pith");
        brainjelly = get_parition_config("moreitems_equipment", "__brainjelly");
        gashat = get_parition_config("moreitems_equipment", "__gashat");
        double_umbrella = get_parition_config("moreitems_equipment", "__double_umbrella");
        bathat = get_parition_config("moreitems_equipment", "__bathat");
        terraria = get_parition_config("moreitems_equipment", "__terraria");
        mie_bushhat = get_parition_config("moreitems_equipment","__mie_bushhat");
        mie_tophat = get_parition_config("moreitems_equipment","__mie_tophat");

        seasack = get_parition_config("moreitems_equipment", "__seasack");
        nightspace_cape = get_parition_config("moreitems_equipment", "__nightspace_cape");
        mone_seedpouch = get_parition_config("moreitems_equipment", "__mone_seedpouch");

        --[[ 更多物品· 其他 ]]
        greenamulet_pheromonestone = env.GetModConfigData("greenamulet_pheromonestone");
        multiple_drop_probability = 0.2;
        lifeinjector_vb__inherit_when_change_character = env.GetModConfigData("lifeinjector_vb__inherit_when_change_character");
        lifeinjector_vb__allow_universal_functionality_enable = env.GetModConfigData("lifeinjector_vb__allow_universal_functionality_enable");
        stomach_warming_hamburger__inherit_when_change_character = env.GetModConfigData("stomach_warming_hamburger__inherit_when_change_character");
        stomach_warming_hamburger__allow_universal_functionality_enable = env.GetModConfigData("stomach_warming_hamburger__allow_universal_functionality_enable");
        sanity_hamburger__inherit_when_change_character = env.GetModConfigData("sanity_hamburger__inherit_when_change_character");
        sanity_hamburger__allow_universal_functionality_enable = env.GetModConfigData("sanity_hamburger__allow_universal_functionality_enable");
        bundle_irreplaceable = env.GetModConfigData("bundle_irreplaceable");

        -- . 其他 总开关
        moreitems_other = env.GetModConfigData("moreitems_other");
        never_finish_series = get_parition_config("moreitems_other", "never_finish_series");

        pheromonestone = get_parition_config("moreitems_other", "__pheromonestone");
        pheromonestone2 = get_parition_config("moreitems_other", "__pheromonestone2");
        waterballoon = get_parition_config("moreitems_other", "__waterballoon");

        mone_chicken_soup = get_parition_config("moreitems_other", "__mone_chicken_soup");
        mone_lifeinjector_vb = get_parition_config("moreitems_other", "__mone_lifeinjector_vb");
        mone_stomach_warming_hamburger = get_parition_config("moreitems_other", "__mone_stomach_warming_hamburger");
        mone_sanity_hamburger = get_parition_config("moreitems_other", "__mone_sanity_hamburger");
        mone_honey_ham_stick = get_parition_config("moreitems_other", "__mone_honey_ham_stick");
        mone_guacamole = get_parition_config("moreitems_other", "__mone_guacamole");
        mone_beef_wellington = get_parition_config("moreitems_other", "__mone_beef_wellington");
        glommer_poop_food = get_parition_config("moreitems_other", "__glommer_poop_food");

        mie_bundle = get_parition_config("moreitems_other","__mie_bundle");
        mie_book_silviculture = get_parition_config("moreitems_other","__mie_book_silviculture");
        mie_book_horticulture = get_parition_config("moreitems_other","__mie_book_horticulture");

        pig_coin = get_parition_config("moreitems_other","__pig_coin");
        lureplant = get_parition_config("moreitems_other","__lureplant");


        -- [[ 其他辅助功能 ]]
        automatic_stacking = env.GetModConfigData("automatic_stacking");
        extra_equip_slots = env.GetModConfigData("extra_equip_slots");
        dont_drop_everything = env.GetModConfigData("dont_drop_everything");
        simple_global_position_system = env.GetModConfigData("simple_global_position_system");
        dont_drop_winter_feast_things = env.GetModConfigData("dont_drop_winter_feast_things");

        stackable_change_switch = env.GetModConfigData("stackable_change_switch");
        maxsize_change = env.GetModConfigData("maxsize_change");
        wortox_max_souls_change = env.GetModConfigData("wortox_max_souls_change");

        scroll_containers = env.GetModConfigData("scroll_containers");
        sc_candybag = env.GetModConfigData("sc_candybag");
        sc_seasack = env.GetModConfigData("sc_seasack");
        sc_nightspace_cape = env.GetModConfigData("sc_nightspace_cape");

        -- [[ 更多辅助功能（偏服务端） ]]
        trap_auto_reset = env.GetModConfigData("trap_auto_reset");
        spawn_wormholes_worldpostinit = env.GetModConfigData("spawn_wormholes_worldpostinit");


        --[[ 仅限于我自己使用的功能：彩虹虫洞给小王者和我自己留个入口，假如和朋友一起玩的时候好打开 ]]
        wormhole_marks = env.GetModConfigData("wormhole_marks");

        --[[ 正在开发中 ]]
        mie_fish_box_animstate = true;
        bundle_anything = false;







        --[[ 不再使用的功能 ]]
        -- . 拾取入袋
        item_go_into_waterchest_inv_or_piggyback = env.GetModConfigData("item_go_into_waterchest_inv_or_piggyback_new");

        -- . 量子消耗
        direct_consumption = env.GetModConfigData("direct_consumption_new");

        -- . 可能需要的开关
        containers_onpickupfn_cancel = env.GetModConfigData("containers_onpickupfn_cancel");
        storage_bag_auto_open = env.GetModConfigData("storage_bag_auto_open");
        tool_bag_auto_open = env.GetModConfigData("tool_bag_auto_open");
        icepack_auto_open = env.GetModConfigData("icepack_auto_open");
        spicepack_auto_open = env.GetModConfigData("spicepack_auto_open");
        wanda_box_auto_open = env.GetModConfigData("wanda_box_auto_open");
        containers_onpickupfn_piggybag = env.GetModConfigData("containers_onpickupfn_piggybag");

        -- . 物品优先进容器
        IGICF = env.GetModConfigData("IGICF");
        IGICF_perishable_backpack = env.GetModConfigData("IGICF_perishable_backpack");
        IGICF_mone_piggyback = env.GetModConfigData("IGICF_mone_piggyback");
        IGICF_waterchest_inv = env.GetModConfigData("IGICF_waterchest_inv");

        -- . 便携系列
        rewrite_storage_bag_45_slots = env.GetModConfigData("rewrite_storage_bag_45_slots");
        candybag_itemtestfn = env.GetModConfigData("candybag_itemtestfn");

        -- . 修改版
        original_items_modifications_data = {};
        original_items_modifications = env.GetModConfigData("original_items_modifications");
        batbat = env.GetModConfigData("batbat");
        nightstick = env.GetModConfigData("nightstick");
        whip = env.GetModConfigData("whip");
        wateringcan = env.GetModConfigData("wateringcan");
        premiumwateringcan = env.GetModConfigData("premiumwateringcan");
        hivehat = env.GetModConfigData("hivehat");

        -- . 更好的皮弗娄牛
        better_beefalo = env.GetModConfigData("better_beefalo");

        -- . 强制攻击才能打球状光虫
        forced_attack_lightflier = env.GetModConfigData("forced_attack_lightflier");

        -- . 人物改动
        wathgrithr_change_master_switch = env.GetModConfigData("wathgrithr_change_master_switch");
        wathgrithr_vegetarian = env.GetModConfigData("wathgrithr_vegetarian");

        wolfgang_change_master_switch = env.GetModConfigData("wolfgang_change_master_switch");
        wolfgang_mightiness = env.GetModConfigData("wolfgang_mightiness");
        wolfgang_mightiness_oneat = env.GetModConfigData("wolfgang_mightiness_oneat");

        willow_change_master_switch = env.GetModConfigData("willow_change_master_switch");
        willow_bernie = env.GetModConfigData("willow_bernie");
        willow_firestaff = env.GetModConfigData("willow_firestaff");
        willow_lighter = env.GetModConfigData("willow_lighter");
        willow_sewing_kit = env.GetModConfigData("willow_sewing_kit");
        willow_overheattemp = env.GetModConfigData("willow_overheattemp");
        willow_externaldamagemultiplier = env.GetModConfigData("willow_externaldamagemultiplier");
        willow_not_burning_loots = env.GetModConfigData("willow_not_burning_loots");

        -- . 个人向模组的适配和修改
        mods_modification_switch = env.GetModConfigData("mods_modification_switch");
        mods_ms_playerspawn = env.GetModConfigData("mods_ms_playerspawn");
        -- 能力勋章
        mods_nlxz_medal_box_ms_playerspawn = env.GetModConfigData("mods_nlxz_medal_box_ms_playerspawn");
        mods_nlxz_medal_box = env.GetModConfigData("mods_nlxz_medal_box");
        -- 更多物品
        mods_more_items_containers = env.GetModConfigData("mods_more_items_containers");

        -- . 简易垃圾清理
        simple_garbage_collection = env.GetModConfigData("simple_garbage_collection");
        sgc_delay_take_effect = env.GetModConfigData("sgc_delay_take_effect");
        sgc_interval = env.GetModConfigData("sgc_interval");


        -- [[ 废弃功能 ]]
        BALANCE = true; -- 该选项必定生效
        arborist_light = true; -- 该选项必定生效
        mone_seasack_new_anim = false; -- 25/06/02: 不要了
        pheromone_stone_balance = true; -- 25/06/02: 默认生效
        arrange_container = true; -- 25/06/02: 不需要了，多余
        chests_arrangement = false; -- 25/06/02: 删掉该功能，而且的发现好像确实失效了？
        all_items_one_recipetab = false; -- 25/06/02: 暂时取消该功能，因为不完美，而且当时只是为了给小王者用，我现在又要加个物品栏了
        mone_backpack_auto = true; -- 25/06/02: 多余的，不需要
        cane_gointo_mone_backpack = true; -- 25/06/02: 多余的，不需要
        mone_wanda_box_itemtestfn_extra1 = true; -- 25/06/02: 多余的，不需要
        mone_wanda_box_itemtestfn_extra2 = true; -- 25/06/02: 多余的，不需要
        creatures_stackable = false; -- 25/06/02: 早就删掉的，现在显式 false
        eyemaskhat = false; -- 25/06/02: 本来就不要了，这边显式 false
        shieldofterror = false; -- 25/06/02: 本来就不要了，这边显式 false
        backpacks_light = false; -- 25/06/01 删除
        hawk_eye_and_night_vision = false; -- 25/06/02: 早就删掉的，现在显式 false
        grass_umbrella = false; -- 25/05/31 这个我不要了
        winterometer = false; -- 25/05/31 这个我不要了
        more_equipments_debug = true; -- 25/06/05: 固定开启，当时是为了加个不稳定开关
        mone_piggbag_itemtestfn = false; -- 25/06/09: 忘了...
    };
};
