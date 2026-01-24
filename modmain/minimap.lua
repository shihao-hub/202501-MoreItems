---
--- @author zsh in 2023/1/9 2:19
---


local minimap = {
    "images/minimapimages/ndnr_armorvortexcloak.xml",
    "images/minimapimages/mone_piggybag.xml",
    "images/minimapimages/garlic_bat.xml",
    "images/minimapimages/mone_wathgrithr_box.xml",
    "images/minimapimages/mone_wanda_box.xml",
    
    "images/minimapimages/mie_book_horticulture.xml",
    "images/minimapimages/mie_book_silviculture.xml",
    "images/minimapimages/mone_beef_bell.xml",
    "images/minimapimages/mone_beef_bell_linked.xml",

    "images/inventoryimages/mandrake_backpack.xml",
    -- DLC0002
    "images/DLC0002/inventoryimages.xml",
    -- DLC0003
    "images/DLC0003/inventoryimages.xml",

    "images/modules/architect_pack/tap_minimapicons.xml",
    "images/modules/architect_pack/tap_buildingimages.xml",

    -- TEMP：这样不太好，之后在prefabs里直接用Asset("MINIMAP_IMAGE","picture_name")，但是这个图片记得导入！
    "images/inventoryimages.xml",
    "images/inventoryimages2.xml",

    "images/DLC/inventoryimages.xml",

    -- region 更多物品·拓展包
    "images/minimapimages/icemaker.xml",
    "images/minimapimages/tall_pre.xml",
    "images/minimapimages/water_bucket.xml",
    "images/minimapimages/tap_minimapicons.xml",

    "images/inventoryimages/tap_buildingimages.xml",

    -- 这样不好！
    "images/inventoryimages1.xml",
    -- endregion
}

for _, v in ipairs(minimap) do
    env.AddMinimapAtlas(v);
    table.insert(env.Assets, Asset("ATLAS", v));
end