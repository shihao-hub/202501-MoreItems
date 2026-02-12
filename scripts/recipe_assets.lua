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
---------------------------------------------------------------------------------------------------

M["mone_backpack"] = {
    atlas = "images/DLC/inventoryimages1.xml",
    image = "backpack.tex"
}

M["mone_tool_bag"] = {
    atlas = "images/inventoryimages/mandrake_backpack.xml",
    image = "mandrake_backpack.tex"
}

M["mone_candybag"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "candybag.tex"
}

M["mone_spicepack"] = {
    atlas = "images/DLC/inventoryimages2.xml",
    image = "spicepack.tex"
}

M["mone_icepack"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "icepack.tex"
}

M["mone_piggybag"] = {
    atlas = "images/inventoryimages/mone_piggybag.xml",
    image = "mone_piggybag.tex"
}

M["mone_piggyback"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "piggyback.tex"
}

M["mone_storage_bag"] = {
    atlas = "images/DLC0002/inventoryimages.xml",
    image = "thatchpack.tex"
}

M["mone_waterchest_inv"] = {
    atlas = "images/DLC0002/inventoryimages.xml",
    image = "waterchest.tex"
}

M["mone_wathgrithr_box"] = {
    atlas = "images/inventoryimages/mone_wathgrithr_box.xml",
    image = "mone_wathgrithr_box.tex"
}

M["mone_wanda_box"] = {
    atlas = "images/inventoryimages/mone_wanda_box.xml",
    image = "mone_wanda_box.tex"
}

---------------------------------------------------------------------------------------------------
-- 装备类（武器、防具、饰品）
---------------------------------------------------------------------------------------------------

M["mone_spear_poison"] = {
    atlas = "images/DLC0002/inventoryimages.xml",
    image = "spear_poison.tex"
}

M["mone_hambat"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "hambat.tex"
}

M["mone_redlantern"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "redlantern.tex"
}

M["mone_fishingnet"] = {
    atlas = "images/modules/uc/inventoryimages/uncompromising_fishingnet.xml",
    image = "uncompromising_fishingnet.tex"
}

M["mone_halberd"] = {
    atlas = "images/DLC0003/inventoryimages.xml",
    image = "halberd.tex"
}

M["mone_walking_stick"] = {
    atlas = "images/DLC0003/inventoryimages_2.xml",
    image = "walkingstick.tex"
}

M["mone_boomerang"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "boomerang.tex"
}

M["mone_orangestaff"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "orangestaff.tex"
}

M["mone_harvester_staff"] = {
    atlas = "images/DLC0002/inventoryimages.xml",
    image = "machete.tex"
}

M["mone_harvester_staff_gold"] = {
    atlas = "images/DLC0002/inventoryimages.xml",
    image = "goldenmachete.tex"
}

M["mone_shieldofterror"] = {
    atlas = "images/DLC/inventoryimages2.xml",
    image = "shieldofterror.tex"
}

M["mone_waterballoon"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "waterballoon.tex"
}

---------------------------------------------------------------------------------------------------
-- 头部装备
---------------------------------------------------------------------------------------------------

M["mie_bushhat"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "bushhat.tex"
}

M["mie_tophat"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "tophat.tex"
}

M["mone_pith"] = {
    atlas = "images/DLC0003/inventoryimages.xml",
    image = "pithhat.tex"
}

M["mone_brainjelly"] = {
    atlas = "images/DLC0002/inventoryimages.xml",
    image = "brainjellyhat.tex"
}

M["mone_gashat"] = {
    atlas = "images/DLC0003/inventoryimages.xml",
    image = "gashat.tex"
}

M["mone_double_umbrella"] = {
    atlas = "images/DLC0002/inventoryimages.xml",
    image = "double_umbrellahat.tex"
}

M["mone_bathat"] = {
    atlas = "images/DLC0003/inventoryimages.xml",
    image = "bathat.tex"
}

M["mone_eyemaskhat"] = {
    atlas = "images/DLC/inventoryimages1.xml",
    image = "eyemaskhat.tex"
}

---------------------------------------------------------------------------------------------------
-- 身体装备
---------------------------------------------------------------------------------------------------

M["mone_armor_metalplate"] = {
    atlas = "images/DLC0003/inventoryimages.xml",
    image = "armor_metalplate.tex"
}

M["mone_seasack"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "krampus_sack.tex"
}

M["mone_nightspace_cape"] = {
    atlas = "images/inventoryimages/ndnr_armorvortexcloak.xml",
    image = "ndnr_armorvortexcloak.tex"
}

M["mone_seedpouch"] = {
    atlas = "images/DLC/inventoryimages2.xml",
    image = "seedpouch.tex"
}

---------------------------------------------------------------------------------------------------
-- 建筑类（箱子、火炉、灯具等）
---------------------------------------------------------------------------------------------------

M["rmi_lureplant"] = {
    atlas = "images/DLC/inventoryimages2.xml",
    image = "lureplantbulb.tex"
}

M["mie_wooden_drawer"] = {
    atlas = "images/inventoryimages/tap_buildingimages.xml",
    image = "kyno_drawerchest.tex"
}

M["mie_bear_skin_cabinet"] = {
    atlas = "images/inventoryimages/tap_buildingimages.xml",
    image = "kyno_safe.tex"
}

M["mie_fish_box"] = {
    atlas = "images/DLC/inventoryimages2.xml",
    image = "saltbox.tex"
}

M["mie_watersource"] = {
    atlas = "images/inventoryimages/tap_buildingimages.xml",
    image = "kyno_bucket.tex"
}

M["mone_skull_chest"] = {
    atlas = "images/modules/architect_pack/tap_buildingimages.xml",
    image = "kyno_skullchest.tex"
}

M["mone_treasurechest"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "treasurechest.tex"
}

M["mone_dragonflychest"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "dragonflychest.tex"
}

M["mone_icebox"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "icebox.tex"
}

M["mone_saltbox"] = {
    atlas = "images/DLC/inventoryimages2.xml",
    image = "saltbox.tex"
}

M["mone_wardrobe"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "wardrobe.tex"
}

M["mie_relic_2"] = {
    atlas = "images/DLC0003/inventoryimages.xml",
    image = "relic_2.tex"
}

M["mie_obsidianfirepit"] = {
    atlas = "images/DLC0002/inventoryimages.xml",
    image = "obsidianfirepit.tex"
}

M["mone_dummytarget"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "resurrectionstatue.tex"
}

M["mie_waterpump"] = {
    atlas = "images/DLC/inventoryimages3.xml",
    image = "waterpump_item.tex"
}

M["mie_sand_pit"] = {
    atlas = "images/inventoryimages/tall_pre.xml",
    image = "tall_pre.tex"
}

M["mie_icemaker"] = {
    atlas = "images/inventoryimages/icemaker.xml",
    image = "icemaker.tex"
}

M["mone_city_lamp"] = {
    atlas = "images/DLC0003/inventoryimages.xml",
    image = "city_lamp.tex"
}

M["mone_single_dog"] = {
    atlas = "images/DLC/inventoryimages1.xml",
    image = "chesspiece_clayhound.tex"
}

M["mone_garlic_structure"] = {
    atlas = "images/inventoryimages/garlic_bat.xml",
    image = "garlic_bat.tex"
}

M["mone_chiminea"] = {
    atlas = "images/DLC0002/inventoryimages.xml",
    image = "chiminea.tex"
}

M["mone_arborist"] = {
    atlas = "images/DLC0002/inventoryimages.xml",
    image = "sand_castle.tex"
}

M["mone_moondial"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "moondial.tex"
}

M["mone_dragonflyfurnace"] = {
    atlas = "images/DLC/inventoryimages1.xml",
    image = "dragonflyfurnace.tex"
}

M["mone_firesuppressor"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "firesuppressor.tex"
}

M["mone_meatrack"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "meatrack.tex"
}

---------------------------------------------------------------------------------------------------
-- 食物类
---------------------------------------------------------------------------------------------------

M["mone_lifeinjector_vb"] = {
    atlas = "images/foodimages/mone_lifeinjector_vb.xml",
    image = "mone_lifeinjector_vb.tex"
}

M["mone_stomach_warming_hamburger"] = {
    atlas = "images/foodimages/bs_food_33.xml",
    image = "bs_food_33.tex"
}

M["mone_sanity_hamburger"] = {
    atlas = "images/foodimages/bs_food_33.xml",
    image = "bs_food_33.tex"
}

M["mone_honey_ham_stick"] = {
    atlas = "images/foodimages/bs_food_58.xml",
    image = "bs_food_58.tex"
}

M["mone_beef_wellington"] = {
    atlas = "images/foodimages/mone_beef_wellington.xml",
    image = "mone_beef_wellington.tex"
}

M["mone_chicken_soup"] = {
    atlas = "images/foodimages/mone_chicken_soup.xml",
    image = "mone_chicken_soup.tex"
}

M["mone_glommer_poop_food"] = {
    atlas = "images/DLC/inventoryimages1.xml",
    image = "bananajuice.tex"
}

M["mone_guacamole"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "guacamole.tex"
}

M["mie_beefalofeed"] = {
    atlas = "images/DLC/inventoryimages1.xml",
    image = "beefalofeed.tex"
}

---------------------------------------------------------------------------------------------------
-- 其他物品
---------------------------------------------------------------------------------------------------

M["mone_pheromonestone"] = {
    atlas = "images/DLC0003/inventoryimages.xml",
    image = "pheromonestone.tex"
}

M["mone_pheromonestone2"] = {
    atlas = "images/DLC0003/inventoryimages.xml",
    image = "relic_5.tex"
}

M["mone_poisonblam"] = {
    atlas = "images/DLC0003/inventoryimages.xml",
    image = "poisonbalm.tex"
}

M["mone_beef_bell"] = {
    atlas = "images/inventoryimages/mone_beef_bell.xml",
    image = "mone_beef_bell.tex"
}

M["rmi_pig_coin"] = {
    atlas = "images/DLC/inventoryimages2.xml",
    image = "pig_coin.tex"
}

M["mone_farm_plow_item"] = {
    atlas = "images/DLC/inventoryimages1.xml",
    image = "farm_plow_item.tex"
}

M["mie_ordinary_bundle_state1"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "giftwrap.tex"
}

M["mie_bundle_state1"] = {
    atlas = "images/DLC/inventoryimages.xml",
    image = "bundlewrap.tex"
}

M["mie_book_silviculture"] = {
    atlas = "images/inventoryimages/mie_book_silviculture.xml",
    image = "mie_book_silviculture.tex"
}

M["mie_book_horticulture"] = {
    atlas = "images/inventoryimages/mie_book_horticulture.xml",
    image = "mie_book_horticulture.tex"
}

M["mone_bookstation"] = {
    atlas = "images/DLC/inventoryimages1.xml",
    image = "bookstation.tex"
}

M["mone_rabbitkinghorn"] = {
    atlas = "images/DLC/inventoryimages2_250801/inventoryimages2.xml",
    image = "rabbitkinghorn.tex"
}

---------------------------------------------------------------------------------------------------
-- 施肥瓦器人
---------------------------------------------------------------------------------------------------

M["mone_fertilizer_bot"] = {
    atlas = "images/inventoryimages3.xml",
    image = "storage_robot.tex"
}

return M