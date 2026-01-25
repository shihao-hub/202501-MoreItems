---
--- @author zsh in 2023/2/10 10:07
---

local L = (locale == "zh" or locale == "zht" or locale == "zhr") and true or false;

local function _get_description(content)
    local start_time = "2023-01-08"
    -- 淘宝的云服务器卖家没有导入其他文件，所以那边 modinfo.lua 会导入失败。
    local folder_name = folder_name or "workshop"

    content = content or ""
    return (L and "                                                  感谢你的订阅！\n"
            .. content .. "\n"
            .. "                                                【模组】：" .. folder_name .. "\n"
            .. "                                                【作者】：" .. author .. "\n"
            .. "                                                【版本】：" .. version .. "\n"
            .. "                                                【时间】：" .. start_time .. "\n"
            or "                                                Thanks for subscribing!\n"
            .. content .. "\n"
            .. "                                                【mod    】：" .. folder_name .. "\n"
            .. "                                                【author 】：" .. author .. "\n"
            .. "                                                【version】：" .. version .. "\n"
            .. "                                                【release】：" .. start_time .. "\n"
    )
end

local function option(description, data, hover)
    return {
        description = description or "",
        data = data,
        hover = hover or ""
    };
end

local function large_label(label)
    return {
        name = "",
        label = label or "",
        hover = "",
        options = {
            option("", 0)
        },
        default = 0
    }
end



-- emoji.lua + emoji_items.lua
local content = [[
    󰀜󰀝󰀀󰀞󰀘󰀁󰀟󰀠󰀡󰀂
    󰀃󰀄󰀢󰀅󰀣󰀆󰀇󰀈󰀤󰀙
    󰀰󰀉󰀚󰀊󰀋󰀌󰀍󰀥󰀎󰀏
    󰀦󰀐󰀑󰀒󰀧󰀱󰀨󰀓󰀔󰀩
    󰀪󰀕󰀫󰀖󰀛󰀬󰀭󰀮󰀗󰀯

    注意哈，这个模组还有个扩展包叫更多物品扩展包，模组编号：2928706576。
    配合使用，效果更佳。部分新物品和优化性内容也会在那个模组里更新的。

]]

name = L and "更多物品" or "More Items"
author = "心悦卿兮"
version = "6.0.7"
description = _get_description(content)

server_filter_tags = L and { "更多物品" } or { "More Items" }

client_only_mod = false
all_clients_require_mod = true

icon = "modicon.tex"
icon_atlas = "modicon.xml"

forumthread = ""
api_version = 10
priority = -2147483648

dont_starve_compatible = false
reign_of_giants_compatible = false
dst_compatible = true

if folder_name ~= nil and not folder_name:find("workshop%-") then
    name = name .. "·本地"
end

local function is_dev_branch()
    return folder_name ~= nil and not folder_name:find("2916137510")
end

-- 测试分支
if is_dev_branch() then
    if folder_name:find("MoreItems") then
        -- nothing
    else
        name = name .. "·测试版本"
        --version = version .. ".beta" -- 不可改版本号，因为创意工坊网页检测不了...
        icon = nil
        icon_atlas = nil
    end
end

local vars = {
    OPEN = "开启";
    CLOSE = "关闭";
};

local fns = {
    largeLabel = function(label)
        return {
            name = "",
            label = label or "",
            hover = "",
            options = {
                option("", 0)
            },
            default = 0
        }
    end,
    common_item = function(name, label, hover, default, option_hover)
        default = default ~= false and true or false;
        option_hover = option_hover or "";
        return {
            name = name;
            label = label or "";
            hover = hover or "";
            options = {
                option(vars.OPEN, true, option_hover),
                option(vars.CLOSE, false, option_hover),
            },
            default = default;
        }
    end,
    blank = function()
        return {
            name = "";
            label = "";
            hover = "";
            options = {
                option("", 0)
            },
            default = 0
        }
    end,
    partition = function(name)
        return {
            name = name,
            label = "",
            hover = "",
            options = {
                option("说明", 1),
            },
            default = 1
        }
    end,
    introduce = function(name, label, hover)
        return {
            name = name;
            label = label or "";
            hover = hover or "";
            options = {
                option("介绍", true)
            },
            default = true;
        }
    end
};

configuration_options = {
    fns.largeLabel("模组辅助功能"),
    {
        name = "container_removable",
        label = "容器 UI 可以移动",
        hover = "如果你开启了本地模组：UI拖拽缩放，该选项自动失效！可以订阅那个模组，挺好用的。\n注意：开启了能力勋章模组该选项也自动失效！因为功能冲突了。",
        options = {
            option(vars.OPEN, true, "右键按住可以移动，键盘 home 键复原"),
            option(vars.CLOSE, false, "右键按住可以移动，键盘 home 键复原"),
            option("该功能仍生效", 1, "请关闭 UI拖拽缩放 容器UI支持选项！"),
        },
        default = true
    },
    {
        name = "current_date",
        label = "屏幕上方显示当前时间",
        hover = "顾名思义，作者自己想用。",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
            option("左上角", 1),
        },
        default = true
    },
    {
        name = "backpack_arrange_button",
        label = "官方背包添加一键整理按钮",
        hover = "注意，请不要在游戏内将背包布局从分开模式切换成融合模式！\n虽然我处理了官方切换有按钮的背包布局时有概率崩溃的问题，但是还是要提个醒。",
        options = {
            option(vars.OPEN, true, "PS: 如果检测到背包的容量不是6/8/12/14，该功能自动失效。"),
            option(vars.CLOSE, false, "PS: 如果检测到背包的容量不是6/8/12/14，该功能自动失效。"),
        },
        default = true
    },
    {
        name = "klei_chests_arrangement_button",
        label = "官方容器添加一键整理按钮",
        hover = "箱子、龙鳞宝箱、冰箱、盐盒",
        options = {
            option(vars.OPEN, true, "PS: 如果检测到容器的容量不是9/12，该功能自动失效。"),
            option(vars.CLOSE, false, "PS: 如果检测到容器的容量不是9/12，该功能自动失效。"),
        },
        default = true
    },
    {
        name = "klei_chests_storage_button",
        label = "官方容器添加高级整理按钮",
        hover = "箱子、龙鳞宝箱、冰箱、盐盒",
        options = {
            option(vars.OPEN, true, "PS: 如果检测到容器的容量不是9/12，该功能自动失效。"),
            option(vars.CLOSE, false, "PS: 如果检测到容器的容量不是9/12，该功能自动失效。"),
        },
        default = true
    },
    {
        name = "compatible_with_maxwell",
        label = "避免人物释放技能时容器UI被隐藏",
        hover = "",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = true
    },


    fns.blank();
    fns.largeLabel("更多物品·便携容器类"),
    {
        name = "mone_backpack_capacity",
        label = "装备袋扩容",
        hover = "",
        options = {
            option("2x4", 1),
            option("3x4", 2),
            --option("3x5", 3,"开启该开关后，装备袋也可以存放工具袋的物品。"),
        },
        default = 2
    },
    {
        name = "mone_tool_bag_capacity",
        label = "工具袋扩容",
        hover = "",
        options = {
            option("2x4", 1),
            option("3x4", 2),
        },
        default = 2
    },
    {
        name = "mone_icepack_capacity",
        label = "食物袋扩容",
        hover = "",
        options = {
            option("2x3", 0),
            option("2x4", 1),
            option("3x4", 2),
        },
        default = 0
    },
    {
        name = "mone_nightspace_cape_capacity",
        label = "暗夜空间斗篷缩容",
        hover = "24格实在太大了，不是太方便。\n注意：变成 2x7 后，斗篷的滚动条容器功能失效。",
        options = {
            option("3x8", 1),
            option("2x7", 2),
        },
        default = 2
    },
    {
        name = "piggybag__only_hold_container",
        label = "猪猪袋只能存放容器",
        hover = "而且是无法被装备的容器，比如海钓杆会选择排除",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = false
    },
    {
        name = "piggybag__change_image_enable",
        label = "猪猪袋贴图更换并支持换皮肤",
        hover = "",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = false
    },
    {
        name = "preserver_value",
        label = "修改食物袋的保鲜效果",
        hover = "",
        options = {
            option(vars.CLOSE, false, "变态选项。不要开，这只是给某些玩家提供的开关。"),
            option("永久保鲜", 1, "变态选项。不要开，这只是给某些玩家提供的开关。"),
            option("缓慢返鲜", 2, "变态选项。不要开，这只是给某些玩家提供的开关。"),
        },
        default = false
    },

    fns.blank();
    {
        name = "containers_onpickupfn_cancel",
        label = "关闭容器的自动打开功能",
        hover = "按照作者的习惯是：装备袋、材料袋、猪猪袋始终保持开启状态，重载游戏后也会帮忙开启。\n鼠标拿起的时候也会自动开启。但是有玩家不习惯，所以设置了这个开关。",
        options = {
            option(vars.OPEN, true, "这是总开关！开启后相关内容全部关闭，包括下面的选项！"),
            option(vars.CLOSE, false, "这是总开关！开启后相关内容全部关闭，包括下面的选项！"),
        },
        default = false
    },
    {
        name = "storage_bag_auto_open",
        label = "保鲜袋可以自动开关",
        hover = "",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = true
    },
    {
        name = "tool_bag_auto_open",
        label = "工具袋可以自动开关",
        hover = "",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = true
    },
    {
        name = "spicepack_auto_open",
        label = "小食物袋可以自动开关",
        hover = "",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = true
    },
    {
        name = "icepack_auto_open",
        label = "食物袋可以自动开关",
        hover = "",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = true
    },
    {
        name = "wanda_box_auto_open",
        label = "旺达的钟表盒可以自动开关",
        hover = "",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = true
    },
    {
        name = "containers_onpickupfn_piggybag",
        label = "部分容器在猪猪袋内鼠标拿起就会自动开关",
        hover = "容器在猪猪袋内时：打开状态，拿起自动关闭。关闭状态，拿起自动打开。\n部分容器：工具袋、食物袋、保鲜袋、薇格弗德歌谣盒、第一本懒人书",
        options = {
            option(vars.OPEN, true, "个人觉得很方便"),
            option(vars.CLOSE, false, "个人觉得很方便"),
        },
        default = true
    },

    fns.blank();
    fns.common_item("moreitems_portable_container", "总开关"),
    fns.common_item("__backpack", "装备袋"),
    fns.common_item("__tool_bag", "工具袋"),
    fns.common_item("__candybag", "材料袋"),
    fns.common_item("__piggybag", "猪猪袋"),
    fns.common_item("__piggyback", "收纳袋"),
    fns.common_item("__storage_bag", "保鲜袋"),
    fns.common_item("__spicepack", "小食物袋"),
    fns.common_item("__icepack", "食物袋"),
    fns.common_item("__bookstation", "小书架"),
    fns.common_item("__waterchest", "海上箱子"),
    fns.common_item("__wanda_box", "旺达钟表盒"),
    fns.common_item("__wathgrithr_box", "薇格弗德歌谣盒"),

    fns.blank();
    fns.largeLabel("更多物品·箱子容器类"),
    {
        name = "mone_wardrobe_background",
        label = "你的装备柜 - 格子有背景图片",
        hover = "就是格子背景有图片，有用但不完全有用。",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = true
    },
    {
        name = "mone_wardrobe_recovery_durability",
        label = "你的装备柜 - 缓慢恢复内部装备耐久",
        hover = "一天大概16%，有新鲜度的不会恢复。",
        options = {
            option(vars.OPEN, true, "轻易不要开，莫要衰减游戏寿命！"),
            option(vars.CLOSE, false, "轻易不要开，莫要衰减游戏寿命！"),
        },
        default = false
    },

    fns.blank();
    {
        name = "mone_chests_boxs_capability",
        label = "豪华系列 - 容量设置",
        hover = "16 or 25 or 36",
        options = {
            option("4x4", 1),
            option("5x5", 2),
            option("6x6", 3),
        },
        default = 1
    },
    {
        name = "chests_boxs_compatibility",
        label = "豪华系列 - 兼容智能小木牌模组",
        hover = "默认兼容：箱子、龙鳞宝箱。开启该选项后，补充兼容：冰箱、盐盒",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = false
    },

    fns.blank();
    fns.common_item("moreitems_chest_container", "总开关"),
    fns.common_item("__skull_chest", "杂物箱"),
    fns.common_item("__chests_boxs", "豪华系列", "豪华箱子、豪华龙鳞宝箱、豪华冰箱、豪华盐箱"),
    fns.common_item("__wardrobe", "你的装备柜"),
    fns.common_item("__mie_wooden_drawer", "抽屉"),
    fns.common_item("__mie_fish_box", "贮藏室"),
    fns.common_item("__mie_bear_skin_cabinet", "熊皮保鲜柜"),


    fns.blank();
    fns.largeLabel("更多物品·生活质量类"),
    {
        name = "auto_sorter_mode",
        label = "升级版·雪球发射机 - 模式",
        hover = "全自动：每隔一段时间帮忙捡起周围的东西并转移物品\n半自动：点击按钮捡起，关闭容器分拣",
        options = {
            option("灵活自动", 1, "打开灭火器全自动；关闭灭火器半自动！(这有点白白耗燃料)"),
            option("全自动", 2),
            option("半自动", 3),
        },
        default = 1
    },
    {
        name = "auto_sorter_light",
        label = "升级版·雪球发射机 - 发光",
        hover = "夜晚自动发光，而且还能让作物在夜晚也能生长。",
        options = {
            option(vars.OPEN, true, "轻易不要开，莫要衰减游戏寿命！"),
            option(vars.CLOSE, false, "轻易不要开，莫要衰减游戏寿命！"),
        },
        default = false
    },
    {
        name = "auto_sorter_notags_extra",
        label = "升级版·雪球发射机 - 不熄灭火坑", -- TODO: 我觉得需要重写/完善一下(2023-02-17-10:38)
        hover = "这里用的也算是覆写法吧，假如未来某一天科雷给灭火器加了新内容，\n我这个灭火器倒不至于会崩溃，但是内容上肯定会少些东西。",
        options = {
            option(vars.OPEN, true, "此处功能其实不够完美"),
            option(vars.CLOSE, false, "此处功能其实不够完美"),
        },
        default = false
    },
    {
        name = "auto_sorter_no_fuel",
        label = "升级版·雪球发射机 - 不消耗燃料",
        hover = "即：不会扣除燃料。主要为了方便。",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = false
    },
    {
        name = "auto_sorter_is_full",
        label = "升级版·雪球发射机 - 全自动的时间间隔",
        hover = "间隔时间越长，越不占用电脑性能\n进一步优化：处在人物的加载范围内才会执行功能！",
        options = {
            option("1s", 1),
            option("3s" or "", 3),
            option("5s" or "", 5),
            option("10s" or "", 10),
            option("20s" or "", 20),
        },
        default = 5
    },

    fns.blank();
    fns.common_item("moreitems_living_quality", "总开关"),
    fns.common_item("__redlantern", "灯笼"),
    fns.common_item("__harvester_staff", "收割者的砍刀系列"),
    fns.common_item("__mone_hambat", "腐化火腿棒"),

    fns.common_item("__city_lamp", "路灯"),
    fns.common_item("__firesuppressor", "升级版·雪球发射机"),
    fns.common_item("__meatrack", "升级版·晾肉架"),
    fns.common_item("__chiminea", "腐化炉"),
    fns.common_item("__mie_sand_pit", "沙坑"),
    fns.common_item("__mie_watersource", "水桶"),
    fns.common_item("__garlic_structure", "大蒜·建筑"),

    fns.common_item("__poisonblam", "毒药膏"),
    fns.common_item("__farm_plow", "升级版·耕地机"),
    fns.common_item("__mie_beefalofeed", "绝对吃不完的蒸树枝"),
    
    fns.common_item("__mie_ordinary_bundle", "普通版·万物打包带"),
    fns.common_item("__beef_bell", "超级牛铃"), -- 待定，真的属于生活质量吗？

    fns.blank();
    fns.largeLabel("更多物品·建筑"),
    fns.common_item("moreitems_structure", "总开关"),
    fns.common_item("__single_dog", "单身狗"),
    fns.common_item("__arborist", "树木栽培家"),
    fns.common_item("__moondial", "升级版·月晷"),
    fns.common_item("__dragonflyfurnace", "升级版·龙鳞火炉"),
    fns.common_item("__mie_icemaker", "制冰机"),
    fns.common_item("__mie_dummytarget", "皮痒傀儡"),
    fns.common_item("__mie_relic_2", "倾家荡产赌博机"),
    fns.common_item("__mie_obsidianfirepit", "黑曜石火坑"),
    fns.common_item("__mie_waterpump", "升级版·消防泵"),


    fns.blank();
    fns.largeLabel("更多物品·装备"),
    {
        name = "mone_boomerang_damage_multiple",
        label = "升级版·回旋镖伤害倍数修改",
        hover = "",
        options = {
            option(vars.CLOSE, false),
            option("2倍", 2),
            option("3倍", 3),
            option("4倍", 4),
        },
        default = false
    },
    {
        name = "mone_seasack_capacity_increase",
        label = "海上背包扩容",
        hover = "16 -> 24",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = false
    },

    fns.blank();
    fns.common_item("moreitems_equipment", "总开关"),
    fns.common_item("more_equipments", "更多装备系列", "相关计划：使用熔炉系列物品的贴图，制作成新装备。比如释放技能的武器等。");

    fns.blank(),
    fns.common_item("__spear_poison", "毒矛"),
    fns.common_item("__fishingnet", "渔网"),
    fns.common_item("__halberd", "多功能·戟"),
    fns.common_item("__walking_stick", "临时加速手杖"),
    fns.common_item("__boomerang", "升级版·回旋镖"),
    fns.common_item("__telestaff", "升级版·懒人魔杖"),
    -- fns.common_item("__batbat", "升级版·蝙蝠棒"),
    -- fns.common_item("__nightstick", "升级版·晨星锤"),
    -- fns.common_item("__whip", "升级版·三尾猫鞭"),

    fns.blank(),
    fns.common_item("__armor_metalplate", "铁甲"),
    fns.common_item("__pith", "小草帽"),
    fns.common_item("__brainjelly", "智慧帽"),
    fns.common_item("__gashat", "燃气帽"),
    fns.common_item("__double_umbrella", "双层伞帽"),
    fns.common_item("__bathat", "蝙蝠帽·测试版"),
    fns.common_item("__terraria", "升级版·眼面具和恐怖盾牌"),
    fns.common_item("__mie_bushhat", "升级版·灌木从帽"),
    fns.common_item("__mie_tophat", "沃尔夫冈的高礼帽"),

    fns.blank(),
    fns.common_item("__seasack", "海上麻袋"),
    fns.common_item("__nightspace_cape", "暗夜空间斗篷"),
    fns.common_item("__mone_seedpouch", "妈妈放心种子袋"),

    fns.blank();
    fns.largeLabel("更多物品·其他"),
    {
        name = "greenamulet_pheromonestone",
        label = "素石可以对建造护符使用",
        hover = "虽然素石已经很过分了。但是对建造护符使用的话那就更过分了。",
        options = {
            option(vars.OPEN, true, "轻易不要开，莫要衰减游戏寿命！"),
            option(vars.CLOSE, false, "轻易不要开，莫要衰减游戏寿命！"),
        },
        default = false
    },
    -- 2025-07-13：将其设定为默认 20% 概率
    -- {
    --     name = "multiple_drop_probability",
    --     label = "蜜汁大肉棒新效果概率修改",
    --     hover = "新效果：击杀Boss的时候有一定概率触发双倍掉落效果。",
    --     options = {
    --         option("关闭", 0),
    --         option("50%", 0.5),
    --         option("75%", 0.75),
    --         option("100%", 1),
    --     },
    --     default = 0
    -- },
    {
        name = "lifeinjector_vb__inherit_when_change_character",
        label = "强心素食堡换人继承血量（原版人物）",
        hover = "25/06/02: 目前存在小 bug，后续有可能的话，重构强心素食堡",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = false
    },
    {
        name = "stomach_warming_hamburger__inherit_when_change_character",
        label = "暖胃汉堡包换人继承饥饿度（原版人物）",
        hover = "参考强心素食堡的换人继承功能，切换角色时保留已增加的饥饿度上限",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = false
    },
    {
        name = "sanity_hamburger__inherit_when_change_character",
        label = "强san素食堡换人继承理智值（原版人物）",
        hover = "参考强心素食堡的换人继承功能，切换角色时保留已增加的理智值上限",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = false
    },
    {
        name = "lifeinjector_vb__allow_universal_functionality_enable",
        label = "允许强心素食堡对所有人物使用（谨慎开启）",
        hover = "作者不对该功能造成的 bug 负责",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = false
    },
    {
        name = "bundle_irreplaceable",
        label = "万物打包带 - 被打包的物体无法被带下线",
        hover = "和眼骨一样，下线、上下地洞就掉落",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = false
    }, 

    fns.blank();
    fns.common_item("moreitems_other", "总开关"),
    fns.common_item("never_finish_series", "绝对吃不完系列", "此处动态批量生成了饥荒原版的几乎所有锅中料理。\n注意：开启此处后，扩展包的绝对吃不完系列完全失效。", true);

    fns.blank(),
    fns.common_item("__pheromonestone", "素石"),
    fns.common_item("__pheromonestone2", "荤石"),
    fns.common_item("__waterballoon", "生命水球"),

    fns.blank(),
    fns.common_item("__mone_chicken_soup", "馊鸡汤"),
    fns.common_item("__mone_lifeinjector_vb", "强心素食堡", "请不要和其他也改变人物血量上限的模组一起使用\n不然肯定会出现奇怪的现象"),
    fns.common_item("__mone_stomach_warming_hamburger", "暖胃汉堡包", "请不要和其他也改变人物饥饿值上限的模组一起使用\n不然肯定会出现奇怪的现象"),
    fns.common_item("__mone_sanity_hamburger", "强san素食堡", "请不要和其他也改变人物理智值上限的模组一起使用\n不然肯定会出现奇怪的现象"),
    fns.common_item("__mone_honey_ham_stick", "蜜汁大肉棒"),
    fns.common_item("__mone_guacamole", "超级鳄梨酱"),
    fns.common_item("__mone_beef_wellington", "惠灵顿风干牛排"),
    fns.common_item("__glommer_poop_food", "格罗姆拉肚子奶昔"),

    fns.blank(),
    fns.common_item("__mie_bundle", "万物打包带"),
    fns.common_item("__mie_book_silviculture", "《论如何做一个懒人》"),
    fns.common_item("__mie_book_horticulture", "《论如何做一个懒人+》"),

    fns.blank();
    fns.common_item("__pig_coin", "升级版·猪鼻铸币"),
    fns.common_item("__lureplant", "食人花宝箱", "收集所有食人花吞噬的物品"),
    fns.common_item("__rabbitkinghorn", "升级版·挖洞兔角号"),

    fns.blank();
    fns.largeLabel("其他辅助功能"),
    {
        name = "automatic_stacking",
        label = "自动堆叠",
        hover = "物品生成后的零点几秒，会检索周围一定范围内的同名物品，然后自动堆叠在一起。",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = false
    },
    {
        name = "extra_equip_slots",
        label = "五格装备栏",
        hover = "", --"说明：这是作者本人的五格装备栏，作者是完全够用的。如果你不够用，请另寻其他五格。\n修复了某些五格的bug，兼容了一大堆其他模组的物品，兼容了新版本威尔逊的胡子栏。",
        options = {
            option("旧五格", true, "此处是一直以来的较稳定普通版本(2023-05-15后更新了另外的高级版本)"),
            option("新四格", 4, "额外添加了一个背包栏，可以同时显示背包和护甲/护符。"),
            --option("新五格", 5, "测试版本：比如同时显示背包和护甲等"),
            option(vars.CLOSE, false),
        },
        default = false
    },
    {
        name = "dont_drop_everything",
        label = "物品不掉落",
        hover = "玩家溺水时物品不掉落、玩家死亡时物品不掉落\nPS: 若死亡的时候物品栏和背包满了，则会选择性地掉落一个物品，以腾出一格空间。",
        options = {
            option(vars.OPEN, true, "死亡时，物品栏或背包里的生命护符等复活类物品会掉落下来一个"),
            option(vars.CLOSE, false, "死亡时，物品栏或背包里的生命护符等复活类物品会掉落下来一个"),
        },
        default = false
    },
    {
        name = "simple_global_position_system",
        label = "简易全球定位",
        hover = "在地图上显示玩家的图标和共享地图，占用内存极少。\n该功能基本上等价于：指南针 + 月眼守卫",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = false
    },

    fns.blank();
    {
        name = "stackable_change_switch",
        label = "堆叠相关功能总开关",
        hover = "修改堆叠上限+修改小恶魔最大可携带的灵魂数量",
        options = {
            option(vars.OPEN, true, "请不要和其他同类型模组一起开启！"),
            option(vars.CLOSE, false, "请不要和其他同类型模组一起开启！"),
        },
        default = false
    },
    {
        name = "maxsize_change",
        label = "修改堆叠上限",
        hover = "",
        options = {
            option(vars.CLOSE, false),
            option("30", 30),
            option("40", 40),
            option("50", 50),
            option("60", 60),
            option("66", 66),
            option("80", 80),
            option("88", 88),
            option("99", 99),
            option("100", 100),
            option("200", 200),
            option("300", 300),
            option("500", 500),
            option("666", 666),
            option("888", 888),
            option("999", 999),
            option("1000", 1000),
            option("9999", 9999),
            option("10000", 10000),
            option("65535", 65535),
        },
        default = false
    },
    {
        name = "wortox_max_souls_change", -- 虽然按道理来说不需要开启`修改堆叠上限`选项，但是怎么说呢，我还是限制一下吧。
        label = "修改小恶魔最大可携带的灵魂的数量", -- 沃拓克斯
        hover = "该功能生效的前提是开启了`修改堆叠上限`的选项",
        options = {
            option(vars.CLOSE, false),
            option("30", 30),
            option("40", 40),
            option("50", 50),
            option("60", 60),
            option("66", 66),
            option("80", 80),
            option("88", 88),
            option("99", 99),
            option("100", 100),
            option("200", 200),
            option("300", 300),
            option("500", 500),
            option("666", 666),
            option("888", 888),
            option("999", 999),
            option("1000", 1000),
            option("9999", 9999),
            option("10000", 10000),
            option("65535", 65535),
        },
        default = false
    },

    fns.blank();
    {
        name = "scroll_containers",
        label = "滚动条容器总开关",
        hover = "给部分容器添加了滚动条。\n可以体验体验...有点鸡肋，食之无味弃之可惜？",
        options = {
            option(vars.OPEN, true, "食之无味，弃之有那么一点可惜..."),
            option(vars.CLOSE, false, "食之无味，弃之有那么一点可惜..."),
        },
        default = false
    },
    {
        name = "sc_candybag",
        label = "材料袋",
        hover = "3x2->3x(2+2)",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = true
    },
    {
        name = "sc_seasack",
        label = "海上背包",
        hover = "2x7->2x(4+4)",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = true
    },
    {
        name = "sc_nightspace_cape",
        label = "暗夜空间斗篷",
        hover = "3x8->2x(7+7)",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = true
    },

    fns.blank();
    fns.largeLabel("更多辅助功能（偏服务端）"),
    -- 2025-07-07：功能改为超级牛铃，此处暂且注释留存
    -- {
    --     name = "better_beefalo",
    --     label = "更好的被绑定的皮弗娄牛",
    --     hover = "",
    --     options = {
    --         option(vars.OPEN, true),
    --         option(vars.CLOSE, false),
    --     },
    --     default = false
    -- },
    -- fns.introduce("better_beefalo_introduce1", "详情", "只能被强制攻击 | 不会生成便便 | 不触发陷阱");
    -- fns.introduce("better_beefalo_introduce2", "详情", "不会发情 | 不乱跑 | 不受群体仇恨影响");
    -- fns.introduce("better_beefalo_introduce3", "详情", "驯服度不会自然下降 | 骑牛可以使用武器 | ");

    -- fns.blank();
    {
        name = "trap_auto_reset",
        label = "狗牙陷阱自动重置",
        hover = "狗牙陷阱触发后 3 秒自动重置",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = false
    },
    {
        name = "spawn_wormholes_worldpostinit",
        label = "生成指向月岛猴岛奶奶岛的三对虫洞",
        hover = "世界生成后，仍会额外生成三对虫洞，分别指向月岛、猴岛、奶奶岛。\n对应关系如下：月台-月岛、猪王-猴岛、绿洲-奶奶岛",
        options = {
            option(vars.OPEN, true, "这功能有点变态"),
            option(vars.CLOSE, false, "这功能有点变态"),
        },
        default = false
    },
    {
        name = "dont_drop_winter_feast_things",
        label = "不掉落冬季盛宴物品",
        hover = "禁止生物掉落冬季盛宴的饰品和食物（仅处理生物掉落，且保留特殊物品，如彩灯等）",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = false
    },

    fns.blank();
    fns.largeLabel("开发者模式（忽略即可）"),
    {
        name = "debug",
        label = "Debug",
        hover = "",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = true
    },
    {
        name = "looktietu",
        label = "looktietu",
        hover = "",
        options = {
            option("NO ANIM", 1),
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = 1
    },
    {
        name = "wormhole_marks",
        label = "wormhole_marks",
        hover = "Released",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = false
    },

    fns.blank();
    fns.largeLabel("正在开发中（玩家无效）"),
    fns.common_item("__ph", "升级版·猫尾鞭"),
    fns.common_item("__ph", "升级版·星晨锤"),

    fns.blank(),
    fns.common_item("__hivehat", "升级版·蜂王冠"),
    fns.common_item("__wateringcan", "升级版·空浇水壶"),
    fns.common_item("__premiumwateringcan", "升级版·空鸟嘴壶"),

    fns.blank(),
    fns.common_item("more_battlesongs", "更多歌谣系列");

    fns.blank(),
    fns.common_item("__ph__disguiser", "伪装者", "佩戴后，可以制作人物通用专属制作的物品"),
    fns.common_item("__ph", "施肥瓦器人","搜索周围目标，施肥"),

    fns.blank(),





}

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

local OIM_ONE = "当检测到`部分`同样修改了该原版物品的模组时，此处将不再生效。";
local OIM_TWO = "为了保证稳定性，如果开启了同类型模组，请关闭该选项啊！";

-- 这个功能怎么说呢，意义不大...
SgcCleanList = {
    { label = "狗牙", name = "houndstooth", default = true };
    { label = "蜂刺", name = "stinger", default = true };
    { label = "鸟屎", name = "guano", default = true };
    { label = "便便", name = "poop", default = true };
    { label = "蜘蛛腺", name = "spidergland", default = true };
    { label = "腐烂食物", name = "spoiled_food", default = true };
    { label = "鹅羽浮标的纸条", name = "tacklesketch", default = true };
    fns.blank();

    { label = "草", name = "cutgrass", default = false };
    { label = "木头", name = "log", default = false };
    { label = "树枝", name = "twigs", default = false };
    { label = "蜘蛛网", name = "silk", default = false };
    { label = "腐烂鸡蛋", name = "rottenegg", default = false };
    --{ label = "雕塑图纸", name = "", default = false, hover="三基佬的不会清除" };
    fns.blank();

    { label = "节日挂饰", name = "category_" .. "winter_ornament", default = true };
    { label = "豪华装饰", name = "category_" .. "winter_ornament_boss", default = true };
    { label = "冬季零食", name = "category_" .. "winter_food", default = true };
    { label = "圣诞彩灯", name = "category_" .. "winter_ornament_light", default = false };
    { label = "万圣节装饰", name = "category_" .. "halloween_ornament", default = true };
    { label = "万圣节糖果", name = "category_" .. "halloweencandy", default = true };

    --fns.blank();
    --{ label = "一些普通装备", name = "category_" .. "common_equipments", default = true, hover = "耐久低于20%的普通斧镐锤锄" };
}

local function genericSgcCleanListOption(id)
    local function getDataByID(id)
        for i = 1, #SgcCleanList do
            if i == id then
                return SgcCleanList[i];
            end
        end
    end

    local data = getDataByID(id);

    if data == nil then
        return ;
    end

    if data.name == "" then
        return fns.blank();
    end

    return {
        name = "sgc_" .. data.name,
        label = data.label,
        hover = data.hover or "",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = data.default
    };
end

local v1_configuration_options = {
    fns.blank();
    fns.blank();
    fns.largeLabel("【不再使用】作者本人不再使用的功能"),

    fns.largeLabel("模组内容设置"),
    {
        name = "item_go_into_waterchest_inv_or_piggyback_new",
        label = "拾取入袋",
        hover = "将收纳袋/海上箱子放在你的物品栏，捡起物品时（且身上塞不下时），\n如果容器内部有同名且可堆叠的物品，会直接塞进去！",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false)
        },
        default = false
    },
    {
        name = "direct_consumption_new",
        label = "量子消耗",
        hover = "仅开启`独行长路`模组的房间有效，模组ID：2657513551\n检索物品栏的全部收纳袋/海上箱子，不需要打开就能消耗其中的材料制作物品。",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false)
        },
        default = false
    },


    fns.blank();
    {
        name = "IGICF",
        label = "物品优先进容器",
        hover = "当物品打算进入物品栏时，会优先选择进入某些容器，最后才轮到物品栏。\n如果不习惯，可以选择关闭该选项。关闭该选项后`物品优先进容器`功能完全失效。",
        options = {
            option(vars.OPEN, true, "装备袋、保鲜袋、材料袋、猪猪袋等"),
            option(vars.CLOSE, false, "装备袋、保鲜袋、材料袋、猪猪袋等"),
        },
        default = true
    },
    {
        name = "IGICF_mone_piggyback",
        label = "收纳袋",
        hover = "物品也会优先进入收纳袋？",
        options = {
            option(vars.OPEN, true, "个人感觉不好用。懒得删除这个开关了。"),
            option(vars.CLOSE, false, "个人感觉不好用。懒得删除这个开关了。"),
        },
        default = false
    },
    {
        name = "IGICF_waterchest_inv",
        label = "海上箱子",
        hover = "物品也会优先进入海上箱子？",
        options = {
            option(vars.OPEN, true, "个人感觉不好用。懒得删除这个开关了。"),
            option(vars.CLOSE, false, "个人感觉不好用。懒得删除这个开关了。"),
        },
        default = false
    },

    fns.largeLabel("便携系列"),
    {
        name = "rewrite_storage_bag_45_slots",
        label = "保鲜袋兼容四十五格",
        hover = "开了四十五格模组的打开这个选项。",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = false
    },

    {
        name = "candybag_itemtestfn",
        label = "材料袋可以放更多材料",
        hover = "开启后可以放`精炼栏`的物品以及制作该物品所需的大部分材料\n注意：此处使用的是动态生成的算法，适配了所有模组，所以如果出现问题请及时反馈。",
        options = {
            option(vars.OPEN, true, ""),
            option(vars.CLOSE, false, ""),
        },
        default = false
    },

    fns.largeLabel("取消某件物品及其相关内容"),
    fns.common_item("original_items_modifications", "总开关", "这里的不是新物品！这是官方物品的修改版本！\n注意，并没有覆盖官方版本哈。在`更多物品·修改栏`制作即可。", false),
    fns.common_item("batbat", "修改版·蝙蝠棒", OIM_ONE, true, OIM_TWO),
    fns.common_item("hivehat", "修改版·蜂王冠", OIM_ONE, true, OIM_TWO),
    fns.common_item("nightstick", "修改版·晨星锤", OIM_ONE, true, OIM_TWO),
    fns.common_item("whip", "修改版·三尾猫鞭", OIM_ONE, true, OIM_TWO),
    fns.common_item("wateringcan", "修改版·空浇水壶", OIM_ONE, true, OIM_TWO),
    fns.common_item("premiumwateringcan", "修改版·空鸟嘴壶", OIM_ONE, true, OIM_TWO),

    fns.largeLabel("更多辅助功能（偏客户端）"),
    -- 待优化：我觉得至少是 ctrl+F 可以攻击才对
    {
        name = "forced_attack_lightflier",
        label = "强制攻击才能打球状光虫", -- 食人花、墙已经有本地模组了
        hover = "按住 ctrl 然后鼠标点击才能攻击",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = false
    },

    fns.largeLabel("人物改动"),
    {
        name = "wathgrithr_change_master_switch",
        label = "薇格弗德改动总开关",
        hover = "",
        options = {
            option(vars.OPEN, true, "所有改动仅该角色才会生效，其他任何方式都不会生效。"),
            option(vars.CLOSE, false, "所有改动仅该角色才会生效，其他任何方式都不会生效。")
        },
        default = false
    },
    {
        name = "wathgrithr_vegetarian",
        label = "可吃素",
        hover = "生存天数超过20天则失效(为了单人永不妥协)",
        options = {
            option("不会失效", 2),
            option(vars.OPEN, 1),
            option(vars.CLOSE, 0),
        },
        default = 0
    },
    fns.blank();
    {
        name = "wolfgang_change_master_switch",
        label = "沃尔夫冈改动总开关",
        hover = "",
        options = {
            option(vars.OPEN, true, "所有改动仅该角色才会生效，其他任何方式都不会生效。"),
            option(vars.CLOSE, false, "所有改动仅该角色才会生效，其他任何方式都不会生效。") -- 指能力勋章？
        },
        default = false
    },
    {
        name = "wolfgang_mightiness",
        label = "不掉力量值",
        hover = "普通：饥饿值高于100时，力量值不会减少。高级：力量值永远不会减少。",
        options = {
            option("高级", true),
            option("普通", 1),
            option(vars.CLOSE, false),
        },
        default = 1
    },
    {
        name = "wolfgang_mightiness_oneat",
        label = "吃东西增加力量值",
        hover = "增加的力量值等于食物回复的饥饿值的三分之一",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = true
    },
    -- TODO: 恶魔人
    fns.blank();
    {
        name = "willow_change_master_switch",
        label = "薇洛改动总开关",
        hover = "PS: 部分改动可能会被某些模组覆盖导致失效，但是概率极低。\n此处只是提个醒，我预测了这种可能性，但是如果真遇到了我觉得可以去买彩票了。",
        options = {
            option(vars.OPEN, true, "所有改动仅该角色才会生效，其他任何方式都不会生效。"),
            option(vars.CLOSE, false, "所有改动仅该角色才会生效，其他任何方式都不会生效。")
        },
        default = false
    },
    {
        name = "willow_bernie",
        label = "伯尼改动",
        hover = "伯尼现在将拥有尊贵的AOE伤害", -- +暗影生物对伯尼的伤害减半：0.5 好像是翻倍了，是不是应该 > 1 呢？
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = true
    },
    {
        name = "willow_firestaff",
        label = "火魔杖改动",
        hover = "薇洛使用火魔杖消耗的耐久更少(20×5)+有伤害(25)",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = true
    },
    {
        name = "willow_lighter",
        label = "打火机改动",
        hover = "薇洛使用打火机时不消耗耐久", -- +发光半径为1格地皮：没必要。
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = true
    },
    {
        name = "willow_sewing_kit",
        label = "针线包改动",
        hover = "薇洛使用针线包时不消耗耐久",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = true
    },
    {
        name = "willow_externaldamagemultiplier",
        label = "修改攻击倍数",
        hover = "默认攻击倍数为1.5，疯狂状态攻击倍数为2.0",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = false
    },
    {
        name = "willow_not_burning_loots",
        label = "不会烧掉战利品",
        hover = "",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = true
    },

    fns.largeLabel("个人向模组的适配和修改"),
    {
        name = "mods_modification_switch",
        label = "总开关",
        hover = "", --"作者本人一直都开启独行长路模组，有洞穴，但是效果上等价于无洞穴的世界。\n此处的功能在上述世界的使用中，并未发现问题。如果你出现了问题，请将该选项关闭。",
        options = {
            option(vars.OPEN, true, "此处是为了满足作者单人游戏的需求，不建议玩家开启。"),
            option(vars.CLOSE, false, "此处是为了满足作者单人游戏的需求，不建议玩家开启。"),
        },
        default = false
    },
    {
        name = "mods_nlxz_medal_box_ms_playerspawn",
        label = "能力勋章-开局就送勋章盒",
        hover = "人物第一次进入世界的时候赠送勋章盒（不包括换人）\n普通：一个勋章盒。高级：一个内部装有八个初级勋章的勋章盒。",
        options = {
            option(vars.CLOSE, false),
            option("普通", true),
            option("高级", 2),
            option("高级+", 3, "部分最高级别的勋章"),
            option("高级++", 4, "几乎全部最高级别的勋章"),
        },
        default = 2
    },
    {
        name = "mods_nlxz_medal_box",
        label = "能力勋章-勋章盒自动开关和整理",
        hover = "容器在猪猪袋内时",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = true
    },
    {
        name = "mods_more_items_containers",
        label = "更多物品-开局自带部分容器",
        hover = "猪猪袋(装备袋、工具袋、材料袋)(不包括换人)",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = true
    },
    fns.largeLabel("我的服务器使用的功能"),
    {
        name = "simple_garbage_collection",
        label = "简易垃圾清理总开关",
        hover = "饥荒是我家，环境靠大家！\n控制台输入`c_mi_sgc()`或`c_simple_garbage_collection()`立刻执行一次清理",
        options = {
            option(vars.OPEN, true, "注意，只会清理被丢在地上的物品！"),
            option(vars.CLOSE, false, "注意，只会清理被丢在地上的物品！"),
        },
        default = false
    },
    {
        name = "sgc_interval",
        label = "清理垃圾的时间间隔",
        hover = "", -- 注意，世界天数大于30天该功能才会生效。且只删除不在加载范围内的物品
        options = {
            option("5天", 5, "每隔5天清理一次"),
            option("10天", 10, "每隔10天清理一次"),
            option("15天", 15, "每隔15天清理一次"),
            option("20天", 20, "每隔20天清理一次"),
            option("25天", 25, "每隔25天清理一次"),
            option("30天", 30, "每隔30天清理一次"),
            option("INFINITE", 999999999, "仅手动清理：c_mi_sgc() 执行一次清理"),
        },
        default = 999999999
    },
    {
        name = "sgc_delay_take_effect",
        label = "垃圾清理功能延迟生效",
        hover = "开启后，世界天数大于30天该功能才会生效。这样应该能避免开荒的时候清理掉了地上的东西。",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = true
    },
    genericSgcCleanListOption(1); -- 遇到 nil 直接中断了...所以这部分应该放在末尾
    genericSgcCleanListOption(2);
    genericSgcCleanListOption(3);
    genericSgcCleanListOption(4);
    genericSgcCleanListOption(5);
    genericSgcCleanListOption(6);
    genericSgcCleanListOption(7);
    genericSgcCleanListOption(8);
    genericSgcCleanListOption(9);
    genericSgcCleanListOption(10);
    genericSgcCleanListOption(11);
    genericSgcCleanListOption(12);
    genericSgcCleanListOption(13);
    genericSgcCleanListOption(14);
    genericSgcCleanListOption(15);
    genericSgcCleanListOption(16);
    genericSgcCleanListOption(17);
    genericSgcCleanListOption(18);
    genericSgcCleanListOption(19);
    genericSgcCleanListOption(20);
    genericSgcCleanListOption(21);
    genericSgcCleanListOption(22);
    genericSgcCleanListOption(23);
    genericSgcCleanListOption(24);
    genericSgcCleanListOption(25);
}

for i = 1, #v1_configuration_options do
    configuration_options[#configuration_options + 1] = v1_configuration_options[i]
end
