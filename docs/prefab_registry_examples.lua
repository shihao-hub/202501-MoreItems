---
--- prefab_registry 使用示例
---
--- 本文件展示如何使用新的 prefab_registry API 来添加新物品
---

local prefab_registry = require("more_items_utils")

-- ============================================================================
-- 示例 1: 基础用法（仅 prefab 文件 + PostInit）
-- ============================================================================

-- 旧版本（不推荐）：
-- prefab_registry.add_prefab_legacy(
--     env,
--     true,                    -- enabled
--     "mone_lureplant",        -- name
--     nil,                     -- assets
--     {"mone/game/lureplant"}, -- prefabfiles
--     nil,                     -- recipe
--     nil,                     -- reskin
--     nil,                     -- postinit_fn
--     nil                      -- game_data
-- )

-- 新版本（推荐）：
prefab_registry.add_prefab(env, {
    name = "mone_lureplant",
    prefabfiles = {"mone/game/lureplant"},
    postinit_file = "modmain/PostInit/prefabs/lureplant.lua",
})

-- ============================================================================
-- 示例 2: 包含配方和配置开关
-- ============================================================================

-- 假设 modtuning.lua 中有：
-- TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA.super_backpack = env.GetModConfigData("super_backpack")

-- 新版本 API：
prefab_registry.add_prefab(env, {
    name = "mone_super_backpack",
    config_key = "super_backpack",  -- 从配置读取开关
    prefabfiles = {"mone/containers/super_backpack"},
    assets = {
        Asset("ATLAS", "images/inventoryimages/mone_super_backpack.xml"),
        Asset("IMAGE", "images/inventoryimages/mone_super_backpack.tex"),
    },
    recipe = {
        name = "mone_super_backpack",
        ingredients = {
            Ingredient("papyrus", 4),
            Ingredient("rope", 2),
        },
        tech = TECH.SCIENCE_ONE,
        config = {
            atlas = "images/inventoryimages/mone_super_backpack.xml",
            image = "mone_super_backpack.tex",
        },
        filters = {"更多物品·稳定版"},
    },
})

-- ============================================================================
-- 示例 3: 复用游戏内 prefab + 自定义贴图
-- ============================================================================

-- 用于修改游戏内已有物品的属性，但使用自定义贴图
prefab_registry.add_prefab(env, {
    name = "mone_pig_coin",
    config_key = "pig_coin",
    prefabfiles = {"mone/game/pig_coin"},
    game_data = {
        source_prefab = "pig_coin",
        imagename = "mone_pig_coin.tex",
        atlasname = "images/inventoryimages/mone_pig_coin.xml",
    },
})

-- ============================================================================
-- 示例 4: 使用皮肤系统（复用原版贴图）
-- ============================================================================

-- 当你想使用原版物品的贴图，但创建一个新物品时
prefab_registry.add_prefab(env, {
    name = "mone_golden_pickaxe",
    config_key = "golden_pickaxe",
    prefabfiles = {"mone/tools/golden_pickaxe"},
    reskin = {
        source_name = "pickaxe",           -- 原版物品名称
        target_name = "mone_golden_pickaxe", -- 你的物品名称
        bank = "pickaxe",                   -- 动画 bank
        build = "mone_golden_pickaxe",     -- 动画 build
    },
    recipe = {
        name = "mone_golden_pickaxe",
        ingredients = {
            Ingredient("twigs", 2),
            Ingredient("goldnugget", 2),
        },
        tech = TECH.SCIENCE_ONE,
        config = {
            atlas = "images/inventoryimages/mone_golden_pickaxe.xml",
        },
    },
})

-- ============================================================================
-- 示例 5: 使用 PostInit 函数（直接传入函数）
-- ============================================================================

prefab_registry.add_prefab(env, {
    name = "mone_custom_item",
    config_key = "custom_item",
    prefabfiles = {"mone/items/custom_item"},
    postinit_fn = function(name)
        env.AddPrefabPostInit(name, function(inst)
            if not TheWorld.ismastersim then
                return
            end
            -- 自定义逻辑
            if inst.components.health then
                inst.components.health.maxhealth = 200
            end
        end)
    end,
})

-- ============================================================================
-- 示例 6: 批量添加多个物品
-- ============================================================================

local new_items = {
    {
        name = "mone_item_1",
        config_key = "item_1",
        prefabfiles = {"mone/items/item_1"},
        recipe = {
            name = "mone_item_1",
            ingredients = {Ingredient("twigs", 2)},
            tech = TECH.SCIENCE_ONE,
            config = {},
        },
    },
    {
        name = "mone_item_2",
        config_key = "item_2",
        prefabfiles = {"mone/items/item_2"},
        recipe = {
            name = "mone_item_2",
            ingredients = {Ingredient("grass", 2)},
            tech = TECH.SCIENCE_ONE,
            config = {},
        },
    },
    {
        name = "mone_item_3",
        config_key = "item_3",
        prefabfiles = {"mone/items/item_3"},
        recipe = {
            name = "mone_item_3",
            ingredients = {Ingredient("flint", 2)},
            tech = TECH.SCIENCE_ONE,
            config = {},
        },
    },
}

local count = prefab_registry.add_prefabs(env, new_items)
print(string.format("成功添加了 %d 个物品", count))

-- ============================================================================
-- 示例 7: 完整示例（包含所有功能）
-- ============================================================================

prefab_registry.add_prefab(env, {
    -- 基本信息
    name = "mone_ultimate_sword",
    config_key = "ultimate_sword",  -- 从 modinfo.lua 的配置读取

    -- 资源文件（可选）
    assets = {
        Asset("ATLAS", "images/inventoryimages/mone_ultimate_sword.xml"),
        Asset("IMAGE", "images/inventoryimages/mone_ultimate_sword.tex"),
        Asset("ANIM", "anim/mone_ultimate_sword.zip"),
    },

    -- Prefab 文件
    prefabfiles = {"mone/weapons/ultimate_sword"},

    -- 配方
    recipe = {
        name = "mone_ultimate_sword",
        ingredients = {
            Ingredient("sword", 1),
            Ingredient("nightmarefuel", 5),
            Ingredient("greengem", 1),
        },
        tech = TECH.ANCIENT_TWO,
        config = {
            atlas = "images/inventoryimages/mone_ultimate_sword.xml",
            image = "mone_ultimate_sword.tex",
            nounlock = false,  -- 是否需要解锁原型机
            numtogive = 1,     -- 制作数量
        },
    },

    -- 自定义配方标签（可选）
    recipe_filters = {"更多物品·稳定版", "武器"},

    -- 皮肤配置（如果使用原版贴图）
    -- reskin = {
    --     source_name = "spear",
    --     target_name = "mone_ultimate_sword",
    --     bank = "spear",
    --     build = "mone_ultimate_sword",
    -- },

    -- PostInit（二选一）
    postinit_file = "modmain/PostInit/prefabs/ultimate_sword.lua",
    -- 或直接传入函数：
    -- postinit_fn = function(name)
    --     env.AddPrefabPostInit(name, function(inst)
    --         if not TheWorld.ismastersim then return end
    --         -- 自定义逻辑
    --     end)
    -- end,

    -- 复用游戏内 prefab（可选）
    game_data = {
        source_prefab = "spear",  -- 如果需要复用原版 spear 的 fn
        -- imagename = "custom_image.tex",
        -- atlasname = "images/inventoryimages/custom.xml",
    },
})

-- ============================================================================
-- 示例 8: 在 enable_prefabs.lua 中的实际应用
-- ============================================================================

-- 替换原来的这种写法：
--[[
AddEnabledItem("lureplant", function()
    AddPrefabFiles(env, {
        "mone/game/lureplant",
    });
    env.modimport("modmain/PostInit/prefabs/lureplant.lua");
end);
]]

-- 简化为：
prefab_registry.add_prefab(env, {
    name = "mone_lureplant",
    config_key = "lureplant",
    prefabfiles = {"mone/game/lureplant"},
    postinit_file = "modmain/PostInit/prefabs/lureplant.lua",
})

-- 或者对于没有 PostInit 的物品：
prefab_registry.add_prefab(env, {
    name = "mone_pig_coin",
    config_key = "pig_coin",
    prefabfiles = {"mone/game/pig_coin"},
})
