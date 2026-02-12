---
--- @author zsh in 2023/1/8 17:34
---

local API = require("chang_mone.dsts.API");
local constants = require("more_items_constants")
local recipe_assets = require("recipe_assets")  -- 配方资源映射表（atlas 和 image）

local config_data = TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA;

local all_items_one_recipetab = config_data.all_items_one_recipetab;

---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
-- 添加新的制作栏
local RecipeTabs = {};

-- 新贴图的除食物类的物品
local key1 = "more_items1";
RecipeTabs[key1] = {
    filter_def = {
        name = "MONE_MORE_ITEMS1",
    },
    index = nil
}
STRINGS.UI.CRAFTING_FILTERS[RecipeTabs[key1].filter_def.name] = "更多物品·稳定版"
AddRecipeFilter(RecipeTabs[key1].filter_def, RecipeTabs[key1].index)

local key2 = "more_items2";
RecipeTabs[key2] = {
    filter_def = {
        name = "MONE_MORE_ITEMS2",
    },
    index = nil
}
STRINGS.UI.CRAFTING_FILTERS[RecipeTabs[key2].filter_def.name] = "更多物品·测试版"
AddRecipeFilter(RecipeTabs[key2].filter_def, RecipeTabs[key2].index)

-- greenamulet

---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------

local Recipes = {}
local Recipes_Locate = {};


---------------------------------------------------------------------------------------------------------------
--[[ 更多物品·便携容器 ]]
---------------------------------------------------------------------------------------------------------------
Recipes_Locate["mone_backpack"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.backpack,
    name = "mone_backpack",
    ingredients = {
        Ingredient("cutgrass", 12), Ingredient("twigs", 12), Ingredient("goldnugget", 4),
    },
    tech = TECH.SCIENCE_ONE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_tool_bag"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.tool_bag,
    name = "mone_tool_bag",
    ingredients = {
        Ingredient("cutgrass", 12), Ingredient("twigs", 12), Ingredient("goldnugget", 4),
    },
    tech = TECH.SCIENCE_ONE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_candybag"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.candybag,
    name = "mone_candybag",
    ingredients = {
        Ingredient("cutgrass", 12), Ingredient("twigs", 12), Ingredient("goldnugget", 4),
    },
    tech = TECH.SCIENCE_ONE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_spicepack"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.spicepack,
    name = "mone_spicepack",
    ingredients = {
        Ingredient("cutgrass", 12), Ingredient("twigs", 12), Ingredient("goldnugget", 4),
    },
    tech = TECH.SCIENCE_ONE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_icepack"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.icepack,
    name = "mone_icepack",
    ingredients = {
        Ingredient("goldnugget", 8), Ingredient("gears", 4), Ingredient("furtuft", 15)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_piggybag"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.piggybag,
    name = "mone_piggybag",
    ingredients = {
        Ingredient("pigskin", 4), Ingredient("silk", 6), Ingredient("rope", 2)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_piggyback"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.piggyback,
    name = "mone_piggyback",
    ingredients = {
        Ingredient("pigskin", 30), Ingredient("silk", 30), Ingredient("rope", 30)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_bookstation"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.bookstation,
    name = "mone_bookstation",
    ingredients = {
        Ingredient("livinglog", 2), Ingredient("papyrus", 4), Ingredient("featherpencil", 1),
        Ingredient("greengem", 1)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_rabbitkinghorn"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.rabbitkinghorn,
    name = "mone_rabbitkinghorn",
    ingredients = {
        Ingredient("carrot", 10), Ingredient("papyrus", 3)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS2"
    }
};

Recipes_Locate["mone_storage_bag"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.storage_bag,
    name = "mone_storage_bag",
    ingredients = {
        Ingredient("papyrus", 30), Ingredient("petals", 30),
        Ingredient("purplegem", 6), Ingredient("furtuft", 30)
    },
    tech = TECH.ANCIENT_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "CRAFTING_STATION" -- MONE_MORE_ITEMS1
    }
};

Recipes_Locate["mone_waterchest_inv"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.waterchest,
    name = "mone_waterchest_inv",
    ingredients = {
        Ingredient("boards", 40), Ingredient("bluegem", 20), Ingredient("redgem", 20), Ingredient("minotaurhorn", 2)
    },
    tech = TECH.ANCIENT_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = true, -- 所以这个到底啥意思？nounlock？锁住？感觉没啥用呀。
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "CRAFTING_STATION"
    }
};

Recipes_Locate["mone_wathgrithr_box"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.wathgrithr_box,
    name = "mone_wathgrithr_box",
    ingredients = {
        Ingredient("wathgrithrhat", 2), Ingredient("papyrus", 2), Ingredient("featherpencil", 2)
    },
    tech = TECH.NONE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = "battlesinger",
    },
    filters = {
        "CHARACTER"
    }
};

Recipes_Locate["mone_wanda_box"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.wanda_box,
    name = "mone_wanda_box",
    ingredients = {
        Ingredient("twigs", 12), Ingredient("cutgrass", 12), Ingredient("goldnugget", 4)
    },
    tech = TECH.NONE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = "clockmaker",
    },
    filters = {
        "CHARACTER"
    }
};


---------------------------------------------------------------------------------------------------------------
--[[ 更多物品·装备 ]]
---------------------------------------------------------------------------------------------------------------

-- HAND

Recipes_Locate["mone_spear_poison"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.spear_poison,
    name = "mone_spear_poison",
    ingredients = {
        Ingredient("spear", 2), Ingredient("goldnugget", 5)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

--Recipes_Locate["mone_spear_poison"] = true;
--Recipes[#Recipes + 1] = {
--    CanMake = config_data.spear_poison,
--    name = "mone_spear_poison",
--    ingredients = {
--        Ingredient("spear", 2), Ingredient("goldnugget", 5), Ingredient("purplegem", 1)
--    },
--    tech = TECH.SCIENCE_TWO,
--    config = {
--        placer = nil,
--        min_spacing = nil,
--        nounlock = nil,
--        numtogive = nil,
--        builder_tag = nil,
--        atlas = "images/DLC0002/inventoryimages.xml",
--        image = "spear_poison.tex"
--    },
--    filters = {
--        "MONE_MORE_ITEMS2"
--    }
--};

Recipes_Locate["mone_hambat"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.mone_hambat,
    name = "mone_hambat",
    ingredients = {
        Ingredient("monstermeat", 4),
        Ingredient("hambat", 1)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = 1,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_redlantern"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.redlantern,
    name = "mone_redlantern",
    ingredients = {
        Ingredient("twigs", 3), Ingredient("rope", 2), Ingredient("lightbulb", 2)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_fishingnet"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.fishingnet,
    name = "mone_fishingnet",
    ingredients = {
        Ingredient("rope", 2), Ingredient("silk", 3)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = 1,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_halberd"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.halberd,
    name = "mone_halberd",
    ingredients = {
        Ingredient("goldenaxe", 1), Ingredient("goldenpickaxe", 1), Ingredient("hammer", 1),
        Ingredient("marble", 5)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_walking_stick"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.walking_stick,
    name = "mone_walking_stick",
    ingredients = {
        Ingredient("cutgrass", 4), Ingredient("twigs", 4), Ingredient("goldnugget", 2)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_boomerang"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.boomerang,
    name = "mone_boomerang",
    ingredients = {
        Ingredient("boomerang", 1), Ingredient("greengem", 1)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = 1,
        builder_tag = nil,
        atlas = "images/DLC/inventoryimages.xml", -- inventoryimages2
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_orangestaff"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.orangestaff,
    name = "mone_orangestaff",
    ingredients = {
        Ingredient("orangestaff", 1), Ingredient("greengem", 1), Ingredient("nightmarefuel", 40)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = 1,
        builder_tag = nil,
        atlas = "images/DLC/inventoryimages.xml", -- inventoryimages2
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_harvester_staff"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.harvester_staff,
    name = "mone_harvester_staff",
    ingredients = {
        Ingredient("twigs", 4), Ingredient("cutgrass", 4)
    },
    tech = TECH.NONE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_harvester_staff_gold"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.harvester_staff,
    name = "mone_harvester_staff_gold",
    ingredients = {
        Ingredient("twigs", 6), Ingredient("cutgrass", 6), Ingredient("goldnugget", 2)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_shieldofterror"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.terraria,
    name = "mone_shieldofterror",
    ingredients = {
        Ingredient("shieldofterror", 1), Ingredient("purplegem", 8),
        Ingredient("greengem", 2), Ingredient("opalpreciousgem", 1)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = 1,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_waterballoon"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.waterballoon,
    name = "mone_waterballoon",
    ingredients = {
        Ingredient("greengem", 1)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = 6,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

-- HEAD

Recipes_Locate["mie_bushhat"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.mie_bushhat,
    name = "mie_bushhat",
    ingredients = {
        Ingredient("dug_berrybush", 10) -- 一个大地图变异的大概39个，没变异的213、150个。。。
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mie_tophat"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.mie_tophat,
    name = "mie_tophat",
    ingredients = {
        Ingredient("tophat", 2), Ingredient("walrushat", 2), Ingredient("purplegem", 4), Ingredient("greengem", 2)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_pith"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.pith,
    name = "mone_pith",
    ingredients = {
        Ingredient("cutgrass", 4), Ingredient("twigs", 4)
    },
    tech = TECH.NONE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_brainjelly"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.brainjelly,
    name = "mone_brainjelly",
    ingredients = {
        Ingredient("walrushat", 2), Ingredient("beefalohat", 2), Ingredient("beargervest", 2),
        Ingredient("greengem", 2), Ingredient("opalpreciousgem", 2)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_gashat"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.gashat,
    name = "mone_gashat",
    ingredients = {
        Ingredient("nightmarefuel", 6), Ingredient("silk", 8),
        Ingredient("green_cap", 15),
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_double_umbrella"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.double_umbrella,
    name = "mone_double_umbrella",
    ingredients = {
        Ingredient("goose_feather", 15), Ingredient("umbrella", 1), Ingredient("strawhat", 1)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_bathat"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.bathat,
    name = "mone_bathat",
    ingredients = {
        Ingredient("batwing", 60), Ingredient("silk", 60)
    },
    tech = TECH.ANCIENT_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = true,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "CRAFTING_STATION"
    }
};

Recipes_Locate["mone_eyemaskhat"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.terraria,
    name = "mone_eyemaskhat",
    ingredients = {
        Ingredient("eyemaskhat", 1), Ingredient("purplegem", 4), Ingredient("greengem", 2)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = 1,
        builder_tag = nil,
        atlas = "images/DLC/inventoryimages1.xml", -- inventoryimages2
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

-- BODY
Recipes_Locate["mone_armor_metalplate"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.armor_metalplate,
    name = "mone_armor_metalplate",
    ingredients = {
        Ingredient("marble", 3), Ingredient("rope", 2)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};


-- BACK

local new_anim = config_data.mone_seasack_new_anim;
Recipes_Locate["mone_seasack"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.seasack,
    name = "mone_seasack",
    ingredients = {
        Ingredient("kelp", 40), Ingredient("rope", 10)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_nightspace_cape"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.nightspace_cape,
    name = "mone_nightspace_cape",
    ingredients = {
        Ingredient("armorskeleton", 2), Ingredient("malbatross_feather", 20), Ingredient("greengem", 2)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_seedpouch"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.mone_seedpouch,
    name = "mone_seedpouch",
    ingredients = {
        Ingredient("bundlewrap", 2), Ingredient("gears", 4), Ingredient("seeds", 10),
        Ingredient("goldnugget", 5)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};


---------------------------------------------------------------------------------------------------------------
--[[ 更多物品·建筑 ]]
---------------------------------------------------------------------------------------------------------------


Recipes_Locate["rmi_lureplant"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.lureplant,
    name = "rmi_lureplant",
    ingredients = {
        Ingredient("lureplantbulb", 2), Ingredient("boards", 5), Ingredient("purplegem", 2)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = "rmi_lureplant_placer",
        min_spacing = 1,
        nounlock = nil,
        numtogive = 1,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS2"
    }
};

-- CHEST

Recipes_Locate["mie_wooden_drawer"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.mie_wooden_drawer,
    name = "mie_wooden_drawer",
    ingredients = {
        Ingredient("boards", 3)
    },
    tech = TECH.SCIENCE_ONE,
    config = {
        placer = "mie_wooden_drawer_placer",
        min_spacing = 1,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mie_bear_skin_cabinet"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.mie_bear_skin_cabinet,
    name = "mie_bear_skin_cabinet",
    ingredients = {
        Ingredient("bearger_fur", 1), Ingredient("bundlewrap", 3),
        Ingredient("opalpreciousgem", 1)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = "mie_bear_skin_cabinet_placer",
        min_spacing = 1.5,
        nounlock = nil, -- true
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mie_fish_box"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.mie_fish_box,
    name = "mie_fish_box",
    ingredients = {
        Ingredient("bearger_fur", 1), Ingredient("cutreeds", 40), Ingredient("boards", 20),
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = "mie_fish_box_placer",
        min_spacing = 1.5,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mie_watersource"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.mie_watersource,
    name = "mie_watersource",
    ingredients = {
        Ingredient("shovel", 1), Ingredient("farm_hoe", 1), Ingredient("hammer", 1),
        Ingredient("boards", 4)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = "mie_watersource_placer",
        min_spacing = 1.5,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_skull_chest"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.skull_chest,
    name = "mone_skull_chest",
    ingredients = {
        Ingredient("boards", 3)
    },
    tech = TECH.SCIENCE_ONE,
    config = {
        placer = "mone_skull_chest_placer",
        min_spacing = 1,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

local MCB_capability = TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA.mone_chests_boxs_capability;

local mone_treasurechest_ingredients = { Ingredient("boards", 6) };
if MCB_capability == 2 then
    mone_treasurechest_ingredients = { Ingredient("boards", 9) }
elseif MCB_capability == 3 then
    mone_treasurechest_ingredients = { Ingredient("boards", 12) }
end

Recipes_Locate["mone_treasurechest"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.chests_boxs,
    name = "mone_treasurechest",
    ingredients = mone_treasurechest_ingredients,
    tech = TECH.SCIENCE_ONE,
    config = {
        placer = "mone_treasurechest_placer",
        min_spacing = 1,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

local mone_dragonflychest_ingredients = { Ingredient("dragon_scales", 1), Ingredient("boards", 6), Ingredient("goldnugget", 10) };
if MCB_capability == 2 then
    mone_dragonflychest_ingredients = { Ingredient("dragon_scales", 2), Ingredient("boards", 8), Ingredient("goldnugget", 20) }
elseif MCB_capability == 3 then
    mone_dragonflychest_ingredients = { Ingredient("dragon_scales", 3), Ingredient("boards", 10), Ingredient("goldnugget", 30) }
end

Recipes_Locate["mone_dragonflychest"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.chests_boxs,
    name = "mone_dragonflychest",
    ingredients = mone_dragonflychest_ingredients,
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = "mone_dragonflychest_placer",
        min_spacing = 1.5,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

local mone_icebox_ingredients = { Ingredient("goldnugget", 4), Ingredient("gears", 2), Ingredient("cutstone", 2) };
if MCB_capability == 2 then
    mone_icebox_ingredients = { Ingredient("goldnugget", 6), Ingredient("gears", 3), Ingredient("cutstone", 3) }
elseif MCB_capability == 3 then
    mone_icebox_ingredients = { Ingredient("goldnugget", 8), Ingredient("gears", 4), Ingredient("cutstone", 4) }
end

Recipes_Locate["mone_icebox"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.chests_boxs,
    name = "mone_icebox",
    ingredients = mone_icebox_ingredients,
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = "mone_icebox_placer",
        min_spacing = 1.5,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

local mone_saltbox_ingredients = { Ingredient("saltrock", 20), Ingredient("bluegem", 2), Ingredient("cutstone", 2) };
if MCB_capability == 2 then
    mone_saltbox_ingredients = { Ingredient("saltrock", 30), Ingredient("bluegem", 3), Ingredient("cutstone", 3) }
elseif MCB_capability == 3 then
    mone_saltbox_ingredients = { Ingredient("saltrock", 40), Ingredient("bluegem", 4), Ingredient("cutstone", 4) }
end

Recipes_Locate["mone_saltbox"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.chests_boxs,
    name = "mone_saltbox",
    ingredients = mone_saltbox_ingredients,
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = "mone_saltbox_placer",
        min_spacing = 1.5,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_wardrobe"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.wardrobe,
    name = "mone_wardrobe",
    ingredients = {
        Ingredient("boards", 8), Ingredient("cutgrass", 3)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = "mone_wardrobe_placer",
        min_spacing = 1.5,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

-- OTHER

Recipes_Locate["mie_relic_2"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.mie_relic_2,
    name = "mie_relic_2",
    ingredients = {
        Ingredient("redgem", 2), Ingredient("goldnugget", 10)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = "mie_relic_2_placer",
        min_spacing = 1,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mie_obsidianfirepit"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.mie_obsidianfirepit,
    name = "mie_obsidianfirepit",
    ingredients = {
        Ingredient("redgem", 1), Ingredient("charcoal", 20), Ingredient("rocks", 20)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = "mie_obsidianfirepit_placer",
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_dummytarget"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.mie_dummytarget,
    name = "mone_dummytarget",
    ingredients = {
        Ingredient("boards", 10), Ingredient("goldnugget", 10),
        Ingredient(CHARACTER_INGREDIENT.HEALTH, 50)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = "mone_dummytarget_placer",
        min_spacing = 1,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mie_waterpump"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.mie_waterpump,
    name = "mie_waterpump",
    ingredients = {
        Ingredient("rope", 5), Ingredient("boards", 5), Ingredient("goldnugget", 5),
        Ingredient("gears", 5)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = "mie_waterpump_placer",
        min_spacing = 1,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mie_sand_pit"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.mie_sand_pit,
    name = "mie_sand_pit",
    ingredients = {
        Ingredient("boards", 2), Ingredient("cutstone", 1),
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = "mie_sand_pit_placer",
        min_spacing = 1.5,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mie_icemaker"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.mie_icemaker,
    name = "mie_icemaker",
    ingredients = {
        Ingredient("gears", 2), Ingredient("boards", 5), Ingredient("cutstone", 5),
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = "mie_icemaker_placer",
        min_spacing = 1.5,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_city_lamp"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.city_lamp,
    name = "mone_city_lamp",
    ingredients = {
        Ingredient("lantern", 1), Ingredient("transistor", 2), Ingredient("cutstone", 2)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = "mone_city_lamp_placer",
        min_spacing = 1,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_single_dog"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.single_dog,
    name = "mone_single_dog",
    ingredients = {
        Ingredient("greengem", 1),
        Ingredient("houndstooth", 200)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = "mone_single_dog_placer",
        min_spacing = 1,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_garlic_structure"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.garlic_structure,
    name = "mone_garlic_structure",
    ingredients = {
        -- Ingredient("garlic", 5), Ingredient("garlic_seeds", 3), Ingredient("beeswax", 1)
        Ingredient("garlic", 1), Ingredient("beeswax", 1)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = "mone_garlic_structure_placer",
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_chiminea"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.chiminea,
    name = "mone_chiminea",
    ingredients = {
        Ingredient("boards", 4), Ingredient("cutstone", 2)
    },
    tech = TECH.SCIENCE_ONE,
    config = {
        placer = "mone_chiminea_placer",
        min_spacing = nil, -- 默认应该是大于 1.5 的...
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS2"
    }
};

Recipes_Locate["mone_arborist"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.arborist,
    name = "mone_arborist",
    ingredients = {
        Ingredient("pinecone", 20), Ingredient("acorn", 20), Ingredient("marblebean", 10)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = "mone_arborist_placer",
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_moondial"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.moondial,
    name = "mone_moondial",
    ingredients = {
        Ingredient("bluemooneye", 1), Ingredient("bluegem", 2), Ingredient("ice", 10)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = "mone_moondial_placer",
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_dragonflyfurnace"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.dragonflyfurnace,
    name = "mone_dragonflyfurnace",
    ingredients = {
        Ingredient("redmooneye", 1), Ingredient("redgem", 2), Ingredient("charcoal", 10)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = "mone_dragonflyfurnace_placer",
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_firesuppressor"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.firesuppressor,
    name = "mone_firesuppressor",
    ingredients = {
        Ingredient("gears", 2), Ingredient("transistor", 2), Ingredient("boards", 10)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = "mone_firesuppressor_placer",
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_meatrack"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.meatrack,
    name = "mone_meatrack",
    ingredients = {
        Ingredient("twigs", 3), Ingredient("charcoal", 2), Ingredient("cutgrass", 3)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = "mone_meatrack_placer",
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

---------------------------------------------------------------------------------------------------------------
--[[ 更多物品·其他 ]]
---------------------------------------------------------------------------------------------------------------
local pheromone_tech = TECH.ANCIENT_TWO;
if config_data.pheromone_stone_balance then
    pheromone_tech = TECH.LUNARFORGING_TWO;
end


-- FOOD

Recipes_Locate["mone_lifeinjector_vb"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.mone_lifeinjector_vb,
    name = "mone_lifeinjector_vb",
    ingredients = {
        Ingredient("spoiled_food", 10 * constants.LIFE_INJECTOR_VB__PER_ADD_NUM) -- 20
    },
    tech = TECH.NONE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = 1,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

--Recipes[#Recipes + 1] = {
--    CanMake = config_data.mone_lifeinjector_vb,
--    name = "mone_lifeinjector_vb_copy",
--    ingredients = {
--        Ingredient("spoiled_food", 100 * constants.LIFE_INJECTOR_VB__PER_ADD_NUM)
--    },
--    tech = TECH.NONE,
--    config = {
--        product = "mone_lifeinjector_vb",
--        placer = nil,
--        min_spacing = nil,
--        nounlock = nil,
--        numtogive = 10,
--        builder_tag = nil,
--        atlas = "images/foodimages/mone_lifeinjector_vb.xml",
--        image = "mone_lifeinjector_vb.tex"
--    },
--    filters = {
--        "MONE_MORE_ITEMS2"
--    }
--};

Recipes_Locate["mone_stomach_warming_hamburger"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.mone_stomach_warming_hamburger,
    name = "mone_stomach_warming_hamburger",
    ingredients = {
        Ingredient("spoiled_food", 50)
    },
    tech = TECH.NONE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = 1,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_sanity_hamburger"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.mone_sanity_hamburger,
    name = "mone_sanity_hamburger",
    ingredients = {
        Ingredient("spoiled_food", 50)
    },
    tech = TECH.NONE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = 1,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};
--Recipes[#Recipes + 1] = {
--    CanMake = config_data.mone_stomach_warming_hamburger,
--    name = "mone_stomach_warming_hamburger_copy",
--    ingredients = {
--        Ingredient("spoiled_food", 50)
--    },
--    tech = TECH.NONE,
--    config = {
--        product = "mone_stomach_warming_hamburger",
--        placer = nil,
--        min_spacing = nil,
--        nounlock = nil,
--        numtogive = 10,
--        builder_tag = nil,
--        atlas = "images/foodimages/bs_food_33.xml",
--        image = "bs_food_33.tex"
--    },
--    filters = {
--        "MONE_MORE_ITEMS2"
--    }
--};

Recipes_Locate["mone_honey_ham_stick"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.mone_honey_ham_stick,
    name = "mone_honey_ham_stick",
    ingredients = {
        Ingredient("meat", 5), Ingredient("honey", 10)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = 5,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS2"
    }
};

Recipes_Locate["mone_beef_wellington"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.mone_beef_wellington,
    name = "mone_beef_wellington",
    ingredients = {
        Ingredient("cookedmeat", 20), Ingredient("beefalowool", 20), Ingredient("horn", 1)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = 4,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_chicken_soup"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.mone_chicken_soup,
    name = "mone_chicken_soup",
    ingredients = {
        Ingredient("drumstick", 1)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = 5,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_glommer_poop_food"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.glommer_poop_food,
    name = "mone_glommer_poop_food",
    ingredients = {
        Ingredient("cave_banana", 4)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = 1,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_guacamole"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.mone_guacamole,
    name = "mone_guacamole",
    ingredients = {
        Ingredient("mole", 1), Ingredient("lightbulb", 30)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = 5,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mie_beefalofeed"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.mie_beefalofeed,
    name = "mie_beefalofeed",
    ingredients = {
        Ingredient("beefalofeed", 50)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

-- OTHER


Recipes_Locate["mone_pheromonestone"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.pheromonestone,
    name = "mone_pheromonestone",
    ingredients = {
        Ingredient("opalpreciousgem", 2), Ingredient("greengem", 4),
        Ingredient("bluegem", 20), Ingredient("redgem", 20),
    },
    tech = pheromone_tech,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = true,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "CRAFTING_STATION"
    }
};

Recipes_Locate["mone_pheromonestone2"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.pheromonestone2,
    name = "mone_pheromonestone2",
    ingredients = {
        Ingredient("opalpreciousgem", 3), Ingredient("greengem", 4),
        Ingredient("orangegem", 10), Ingredient("yellowgem", 10),
    },
    tech = pheromone_tech,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = true,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "CRAFTING_STATION"
    }
};

Recipes_Locate["mone_poisonblam"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.poisonblam,
    name = "mone_poisonblam",
    ingredients = {
        Ingredient(CHARACTER_INGREDIENT.HEALTH, 10)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = 1,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

-- 超级牛铃
Recipes_Locate["mone_beef_bell"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.beef_bell,
    name = "mone_beef_bell",
    ingredients = {
        Ingredient("goldnugget", 3), Ingredient("flint", 1)
    },
    tech = TECH.SCIENCE_ONE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = 1,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS2"
    }
};



-- 猪鼻铸币
Recipes_Locate["rmi_pig_coin"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.pig_coin,
    name = "rmi_pig_coin",
    ingredients = {
        Ingredient("pigskin", 5), Ingredient("goldnugget", 10), Ingredient("purplegem", 2)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = 1,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS2"
    }
};

Recipes_Locate["mone_farm_plow_item"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.farm_plow,
    name = "mone_farm_plow_item",
    ingredients = {
        Ingredient("twigs", 4), Ingredient("goldnugget", 2)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = 1,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mie_ordinary_bundle_state1"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.mie_ordinary_bundle,
    name = "mie_ordinary_bundle_state1",
    ingredients = {
        Ingredient("purplegem", 1), Ingredient("rope", 4)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mie_bundle_state1"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.mie_bundle,
    name = "mie_bundle_state1",
    ingredients = {
        Ingredient("opalpreciousgem", 3), Ingredient("rope", 4)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mie_book_silviculture"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.mie_book_silviculture,
    name = "mie_book_silviculture",
    ingredients = {
        Ingredient("papyrus", 10), Ingredient("rope", 10), Ingredient("goldnugget", 10)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mie_book_horticulture"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.mie_book_horticulture,
    name = "mie_book_horticulture",
    ingredients = {
        Ingredient("papyrus", 15), Ingredient("rope", 15), Ingredient("goldnugget", 15)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

---------------------------------------------------------------------------------------------------------------
--[[ MONE_MORE_ITEMS2 ]]
---------------------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------------------
--[[ MONE_MORE_ITEMS3 ]]
---------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
-- 施肥瓦器人
Recipes_Locate["mone_fertilizer_bot"] = true;
Recipes[#Recipes + 1] = {
    CanMake = config_data.mone_fertilizer_bot,
    name = "mone_fertilizer_bot",
    ingredients = {
        Ingredient("transistor", 2), Ingredient("poop", 5), Ingredient("boards", 4),
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

for _, v in pairs(Recipes) do
    if v.CanMake then
        -- 从资源映射表中获取 atlas 和 image（如果存在）
        local assets = recipe_assets[v.name]
        if assets then
            -- 支持函数形式（用于条件判断）
            if type(assets) == "function" then
                assets = assets()
            end
            if assets.atlas then
                v.config.atlas = assets.atlas
            end
            if assets.image then
                v.config.image = assets.image
            end
        end

        if all_items_one_recipetab then
            if not table.contains(v.filters, "CHARACTER")
                    and not table.contains(v.filters, "CRAFTING_STATION")
            then
                v.filters = { "MONE_MORE_ITEMS1" };
            end
        end
        env.AddRecipe2(v.name, v.ingredients, v.tech, v.config, v.filters);
    end
end

for _, v in pairs(Recipes) do
    if v.CanMake then
        env.RemoveRecipeFromFilter(v.name, "MODS");
    end
end