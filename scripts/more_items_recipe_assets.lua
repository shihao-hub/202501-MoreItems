---
--- @author zsh in 2025/02/13
--- 配方资源映射表
---
--- 用途：集中管理所有制作配方的 atlas（图集）和 image（贴图）路径
--- 修改后可直接在此文件批量更新，无需逐个修改 recipes.lua
---
--- 使用方式：
---   local recipe_assets = require("recipe_assets")
---   local assets = recipe_assets[prefab_name]
---   config.atlas = assets.atlas
---   config.image = assets.image
---

local M = {}

---------------------------------------------------------------------------------------------------
-- 便携容器类（背包、箱子等）
-- 注释格式：物品名称描述（由 ai 在 2026-02-13 标注，仅供参考）
---------------------------------------------------------------------------------------------------

-- 高级背包：升级版背包（12格）（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_backpack"] = {
    atlas = "images/DLC/inventoryimages1.xml",
    image = "backpack.tex"
}

-- 工具包：工具专用背包（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_tool_bag"] = {
    atlas = "images/inventoryimages/mandrake_backpack.xml",
    image = "mandrake_backpack.tex"
}

-- 糖果袋：糖果专用背包（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_candybag"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "candybag.tex"
}

-- 香料包：香料专用背包（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_spicepack"] = {
    atlas = "images/DLC/inventoryimages2.xml",
    image = "spicepack.tex"
}

-- 冰袋：保持食物新鲜（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_icepack"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "icepack.tex"
}

-- 猪猪包：小猪专用背包（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_piggybag"] = {
    atlas = "images/inventoryimages/mone_piggybag.xml",
    image = "mone_piggybag.tex"
}

-- 胖婆包：大容量背包（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_piggyback"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "piggyback.tex"
}

-- 保鲜包：保鲜储物箱（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_storage_bag"] = {
    atlas = "images/DLC0002/inventoryimages.xml",
    image = "thatchpack.tex"
}

-- 水箱物品：移动水源容器（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_waterchest_inv"] = {
    atlas = "images/DLC0002/inventoryimages.xml",
    image = "waterchest.tex"
}

-- 温蒂角色盒：角色专属物品包（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_wathgrithr_box"] = {
    atlas = "images/inventoryimages/mone_wathgrithr_box.xml",
    image = "mone_wathgrithr_box.tex"
}

-- 旺达角色盒：角色专属物品包（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_wanda_box"] = {
    atlas = "images/inventoryimages/mone_wanda_box.xml",
    image = "mone_wanda_box.tex"
}

---------------------------------------------------------------------------------------------------
-- 装备类（武器、防具、饰品）
---------------------------------------------------------------------------------------------------

-- 毒矛：带毒属性的长矛（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_spear_poison"] = {
    atlas = "images/DLC0002/inventoryimages.xml",
    image = "spear_poison.tex"
}

-- 火魔棒：基于汉堡棒的升级武器（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_hambat"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "hambat.tex"
}

-- 红灯笼：照明工具（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_redlantern"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "redlantern.tex"
}

-- 渔网：捕鱼工具（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_fishingnet"] = {
    atlas = "images/modules/uc/inventoryimages/uncompromising_fishingnet.xml",
    image = "uncompromising_fishingnet.tex"
}

-- 戟：长柄武器（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_halberd"] = {
    atlas = "images/DLC0003/inventoryimages.xml",
    image = "halberd.tex"
}

-- 行走杖：移动速度提升手杖（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_walking_stick"] = {
    atlas = "images/DLC0003/inventoryimages_2.xml",
    image = "walkingstick.tex"
}

-- 回旋镖：远程武器（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_boomerang"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "boomerang.tex"
}

-- 瞬移魔杖：橙色魔杖升级版（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_orangestaff"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "orangestaff.tex"
}

-- 收割镰刀：采集工具（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_harvester_staff"] = {
    atlas = "images/DLC0002/inventoryimages.xml",
    image = "machete.tex"
}

-- 黄金收割镰刀：采集工具升级版（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_harvester_staff_gold"] = {
    atlas = "images/DLC0002/inventoryimages.xml",
    image = "goldenmachete.tex"
}

-- 恐惧盾牌：泰拉瑞亚装备（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_shieldofterror"] = {
    atlas = "images/DLC/inventoryimages2.xml",
    image = "shieldofterror.tex"
}

-- 水气球：投掷武器（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_waterballoon"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "waterballoon.tex"
}

-- 灌木帽：伪装用帽子（由 ai 在 2026-02-13 标注，仅供参考）
M["mie_bushhat"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "bushhat.tex"
}

-- 高礼帽：经典单簧帽（由 ai 在 2026-02-13 标注，仅供参考）
M["mie_tophat"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "tophat.tex"
}

-- 尖顶帽：低级头部防具（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_pith"] = {
    atlas = "images/DLC0003/inventoryimages.xml",
    image = "pithhat.tex"
}

-- 脑果冻帽：特殊头部装备（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_brainjelly"] = {
    atlas = "images/DLC0002/inventoryimages.xml",
    image = "brainjellyhat.tex"
}

-- 猪头帽：防具兼装饰（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_gashat"] = {
    atlas = "images/DLC0003/inventoryimages.xml",
    image = "gashat.tex"
}

-- 双层雨伞：双人雨伞（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_double_umbrella"] = {
    atlas = "images/DLC0002/inventoryimages.xml",
    image = "double_umbrellahat.tex"
}

-- 蝙蝠帽：高级头部防具（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_bathat"] = {
    atlas = "images/DLC0003/inventoryimages.xml",
    image = "bathat.tex"
}

-- 邪恶面具：泰拉瑞亚装备（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_eyemaskhat"] = {
    atlas = "images/DLC/inventoryimages1.xml",
    image = "eyemaskhat.tex"
}

-- 金属板甲：身体防具（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_armor_metalplate"] = {
    atlas = "images/DLC0003/inventoryimages.xml",
    image = "armor_metalplate.tex"
}

-- 海难背包：防潮背心（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_seasack"] = function()
    local new_anim = TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA.mone_seasack_new_anim
    return {
        atlas = new_anim and "images/DLC/inventoryimages.xml" or "images/DLC0003/inventoryimages.xml",
        image = new_anim and "krampus_sack.tex" or "seasack.tex"
    }
end

-- 夜空披风：特殊身体装备（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_nightspace_cape"] = {
    atlas = "images/inventoryimages/ndnr_armorvortexcloak.xml",
    image = "ndnr_armorvortexcloak.tex"
}

-- 种子袋：携带种子用容器（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_seedpouch"] = {
    atlas = "images/DLC/inventoryimages2.xml",
    image = "seedpouch.tex"
}

-- 触手植物：诱饵植物建筑（由 ai 在 2026-02-13 标注，仅供参考）
M["rmi_lureplant"] = {
    atlas = "images/DLC/inventoryimages2.xml",
    image = "lureplantbulb.tex"
}

-- 木制抽屉柜：储物家具（由 ai 在 2026-02-13 标注，仅供参考）
M["mie_wooden_drawer"] = {
    atlas = "images/inventoryimages/tap_buildingimages.xml",
    image = "kyno_drawerchest.tex"
}

-- 熊皮保险柜：高级储物家具（由 ai 在 2026-02-13 标注，仅供参考）
M["mie_bear_skin_cabinet"] = {
    atlas = "images/inventoryimages/tap_buildingimages.xml",
    image = "kyno_safe.tex"
}

-- 鱼箱：储物容器（由 ai 在 2026-02-13 标注，仅供参考）
M["mie_fish_box"] = function()
    local config_data = TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA
    local animstate = config_data.mie_fish_box_animstate
    return {
        atlas = animstate and "images/DLC/inventoryimages2.xml" or "images/inventoryimages1.xml",
        image = animstate and "saltbox.tex" or "fish_box.tex"
    }
end

-- 水源建筑：取水设施（由 ai 在 2026-02-13 标注，仅供参考）
M["mie_watersource"] = {
    atlas = "images/inventoryimages/tap_buildingimages.xml",
    image = "kyno_bucket.tex"
}

-- 骷髅箱：储物箱（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_skull_chest"] = {
    atlas = "images/modules/architect_pack/tap_buildingimages.xml",
    image = "kyno_skullchest.tex"
}

-- 宝箱：普通宝箱（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_treasurechest"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "treasurechest.tex"
}

-- 龙鳞箱：高级宝箱（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_dragonflychest"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "dragonflychest.tex"
}

-- 冰箱：保鲜容器（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_icebox"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "icebox.tex"
}

-- 盐箱：保鲜容器升级版（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_saltbox"] = {
    atlas = "images/DLC/inventoryimages2.xml",
    image = "saltbox.tex"
}

-- 衣柜：存储服装（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_wardrobe"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "wardrobe.tex"
}

-- 遗物2：古代遗物装饰（由 ai 在 2026-02-13 标注，仅供参考）
M["mie_relic_2"] = {
    atlas = "images/DLC0003/inventoryimages.xml",
    image = "relic_2.tex"
}

-- 黑曜石火坑：特殊火堆（由 ai 在 2026-02-13 标注，仅供参考）
M["mie_obsidianfirepit"] = {
    atlas = "images/DLC0002/inventoryimages.xml",
    image = "obsidianfirepit.tex"
}

-- 假人：训练用假人（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_dummytarget"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "resurrectionstatue.tex"
}

-- 抽水泵：排水设施（由 ai 在 2026-02-13 标注，仅供参考）
M["mie_waterpump"] = {
    atlas = "images/DLC/inventoryimages3.xml",
    image = "waterpump_item.tex"
}

-- 沙坑：建筑设施（由 ai 在 2026-02-13 标注，仅供参考）
M["mie_sand_pit"] = {
    atlas = "images/inventoryimages/tall_pre.xml",
    image = "tall_pre.tex"
}

-- 制冰机：制造冰块（由 ai 在 2026-02-13 标注，仅供参考）
M["mie_icemaker"] = {
    atlas = "images/inventoryimages/icemaker.xml",
    image = "icemaker.tex"
}

-- 街灯：照明设施（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_city_lamp"] = {
    atlas = "images/DLC0003/inventoryimages.xml",
    image = "city_lamp.tex"
}

-- 单身狗：自动攻击犬塔（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_single_dog"] = {
    atlas = "images/DLC/inventoryimages1.xml",
    image = "chesspiece_clayhound.tex"
}

-- 大蒜建筑：大蒜放置物（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_garlic_structure"] = {
    atlas = "images/inventoryimages/garlic_bat.xml",
    image = "garlic_bat.tex"
}

-- 火炉：取暖设施（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_chiminea"] = {
    atlas = "images/DLC0002/inventoryimages.xml",
    image = "chiminea.tex"
}

-- 种植箱：自动种植建筑（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_arborist"] = {
    atlas = "images/DLC0002/inventoryimages.xml",
    image = "sand_castle.tex"
}

-- 月晷：显示月相（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_moondial"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "moondial.tex"
}

-- 龙蝇熔炉：高级火炉（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_dragonflyfurnace"] = {
    atlas = "images/DLC/inventoryimages1.xml",
    image = "dragonflyfurnace.tex"
}

-- 火焰压制器：灭火设施（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_firesuppressor"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "firesuppressor.tex"
}

-- 晾肉架：晾肉设施（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_meatrack"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "meatrack.tex"
}

-- 书写站：制作书籍（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_bookstation"] = {
    atlas = "images/DLC/inventoryimages1.xml",
    image = "bookstation.tex"
}

-- 兔王号角：召唤兔王（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_rabbitkinghorn"] = {
    atlas = "images/DLC/inventoryimages2_250801/inventoryimages2.xml",
    image = "rabbitkinghorn.tex"
}

-- 生命强心剂升级版：恢复生命值（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_lifeinjector_vb"] = {
    atlas = "images/foodimages/mone_lifeinjector_vb.xml",
    image = "mone_lifeinjector_vb.tex"
}

-- 暖胃汉堡：恢复饥饿值（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_stomach_warming_hamburger"] = {
    atlas = "images/foodimages/bs_food_33.xml",
    image = "bs_food_33.tex"
}

-- 理智汉堡：恢复理智值（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_sanity_hamburger"] = {
    atlas = "images/foodimages/bs_food_33.xml",
    image = "bs_food_33.tex"
}

-- 蜂蜜火腿棒：食物（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_honey_ham_stick"] = {
    atlas = "images/foodimages/bs_food_58.xml",
    image = "bs_food_58.tex"
}

-- 坎贝尔 Wellington：高级食物（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_beef_wellington"] = {
    atlas = "images/foodimages/mone_beef_wellington.xml",
    image = "mone_beef_wellington.tex"
}

-- 鸡汤：恢复食物（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_chicken_soup"] = {
    atlas = "images/foodimages/mone_chicken_soup.xml",
    image = "mone_chicken_soup.tex"
}

-- 钮格粪便食物：特殊食物（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_glommer_poop_food"] = {
    atlas = "images/DLC/inventoryimages1.xml",
    image = "bananajuice.tex"
}

-- 鳄梨酱：食物（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_guacamole"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "guacamole.tex"
}

-- 坎贝尔饲料：喂食牛用（由 ai 在 2026-02-13 标注，仅供参考）
M["mie_beefalofeed"] = {
    atlas = "images/DLC/inventoryimages1.xml",
    image = "beefalofeed.tex"
}

-- 费洛蒙石：吸引生物（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_pheromonestone"] = {
    atlas = "images/DLC0003/inventoryimages.xml",
    image = "pheromonestone.tex"
}

-- 费洛蒙石2：高级版本（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_pheromonestone2"] = {
    atlas = "images/DLC0003/inventoryimages.xml",
    image = "relic_5.tex"
}

-- 毒药瓶：毒药（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_poisonblam"] = {
    atlas = "images/DLC0003/inventoryimages.xml",
    image = "poisonbalm.tex"
}

-- 超级牛铃：召唤坎贝尔（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_beef_bell"] = {
    atlas = "images/inventoryimages/mone_beef_bell.xml",
    image = "mone_beef_bell.tex"
}

-- 猪鼻铸币：货币（由 ai 在 2026-02-13 标注，仅供参考）
M["rmi_pig_coin"] = {
    atlas = "images/DLC/inventoryimages2.xml",
    image = "pig_coin.tex"
}

-- 农场犁：农业工具（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_farm_plow_item"] = {
    atlas = "images/DLC/inventoryimages1.xml",
    image = "farm_plow_item.tex"
}

-- 普通打包材料：包装用品（由 ai 在 2026-02-13 标注，仅供参考）
M["mie_ordinary_bundle_state1"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "giftwrap.tex"
}

-- 打包材料：包装用品（由 ai 在 2026-02-13 标注，仅供参考）
M["mie_bundle_state1"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "bundlewrap.tex"
}

-- 养蚕书：农业书籍（由 ai 在 2026-02-13 标注，仅供参考）
M["mie_book_silviculture"] = {
    atlas = "images/inventoryimages/mie_book_silviculture.xml",
    image = "mie_book_silviculture.tex"
}

-- 园艺书：农业书籍（由 ai 在 2026-02-13 标注，仅供参考）
M["mie_book_horticulture"] = {
    atlas = "images/inventoryimages/mie_book_horticulture.xml",
    image = "mie_book_horticulture.tex"
}

---------------------------------------------------------------------------------------------------
-- 施肥瓦器人
---------------------------------------------------------------------------------------------------

-- 施肥瓦器人：自动施肥机器人（由 ai 在 2026-02-13 标注，仅供参考）
M["mone_fertilizer_bot"] = {
    atlas = "images/inventoryimages3.xml",
    image = "storage_robot.tex"
}

return M
