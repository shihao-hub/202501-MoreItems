# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

**More Items（更多物品）** 是一个全面的《饥荒：联机版》(Don't Starve Together) 模组，使用 Lua 编写，遵循 Klei 的 DST 模组架构。

**版本：** 6.0.7
**作者：** 心悦卿兮
**Steam Workshop ID：** 2916137510
**扩展包 ID：** 2928706576
**反馈群：** 592159151

### 项目特色

- 添加了 100+ 种全新物品
- 增强容器（升级版箱子、背包等）
- 新装备（武器、护甲、帽子）
- 生活质量功能（自动整理、升级建筑等）

## 架构

### 入口文件

- **modinfo.lua** - 模组元数据、配置选项（60+ 设置）和创意工坊展示信息
- **modmain.lua** - 主初始化协调器，加载所有子系统
- **modtuning.lua** - modinfo 和代码之间的运行时配置桥接

### 初始化顺序

```
modmain.lua 执行顺序：
1. 环境设置（GLOBAL 访问的 metatable）
2. new_modmain_preload.lua（新世界特性）
3. modtuning.lua（TUNING.MONE_TUNING 配置）
4. modmain/preload.lua
5. modmain/modglobal.lua & modmain/global.lua
6. modmain/Optimization/main.lua
7. modmain/compatibility.lua
8. modmain/prefabfiles.lua & modmain/assets.lua
9. languages/mone/loc.lua（本地化）
10. modmain/containers.lua
11. modmain/init/init_tooltips.lua
12. modmain/recipes.lua, minimap.lua, actions.lua, reskin.lua
13. modmain/shard_sync.lua（跨服数据同步）
14. AUXmods（条件功能模块）
15. PostInit 模块（prefab 修改）
```

### 目录结构

```
MoreItems/
├── modmain/                    # 核心模组逻辑
│   ├── AUXmods/               # 辅助功能（条件加载）
│   ├── PostInit/              # 后初始化修改
│   │   ├── prefabs/          # Prefab 行为修改
│   │   └── *.lua             # 全局 PostInit 钩子
│   ├── init/                  # 初始化辅助
│   ├── OriginalItemsModifications/  # 原版物品修改
│   └── *.lua                  # 核心系统文件
├── scripts/                    # 高级功能
│   ├── components/            # 自定义 DST 组件
│   ├── prefabs/               # Prefab 定义（mone/, mie/, mi_modules/）
│   ├── moreitems/             # 核心工具和库
│   │   ├── chang_mone/        # API 和工具
│   │   ├── lib/               # 第三方库和自定义库
│   │   │   ├── shihao/        # 通用工具库
│   │   │   ├── shihao2/       # 新一代工具库
│   │   │   ├── dst/           # DST 特定工具
│   │   │   └── thirdparty/    # 第三方库
│   │   ├── definitions/       # 定义文件
│   │   ├── languages/mone/    # 本地化（中文）
│   │   └── new_scripts/       # 新脚本系统
│   └── lib/                    # 底层库
├── images/                     # 资源文件（.tex, .xml, .scml, .zip）
└── texts/                      # 文本资源
```

## 添加新物品

按照 **.achieved_files/NOTES.md** 中定义的顺序：

1. **modinfo.lua** - 添加配置选项
2. **modtuning.lua** - 添加运行时配置访问
3. **modmain/PostInit/prefabs/[name].lua** - PostInit 实现特殊行为（基于 `env.AddPrefabPostInit`）
4. **modmain/enable_prefabs.lua** - 开关、assets 和 prefabfiles 导入
5. **scripts/languages/mone/loc.lua** - 添加本地化字符串
6. **modmain/init/init_tooltips.lua** - 物品描述提示
7. **modmain/recipes.lua** - 制作配方和标签
8. **modmain/reskin.lua** - 皮肤支持（如果使用原版贴图）
9. **scripts/prefabs/mone/[category]/[name].lua** - 实际的 prefab 定义

### 命名规范

- `mone_` 前缀 - 核心模组物品
- `mie_` 前缀 - 扩展包物品
- `rmi_` 前缀 - 特殊配方物品
- PostInit 文件使用小写字母和下划线

## 配置系统

### modinfo.lua 配置模式

配置使用辅助函数以保持一致性：

```lua
-- 通用开关模式
fns.common_item(name, label, hover, default, option_hover)

-- 分区配置（主开关 + 子选项）
get_parition_config("moreitems_portable_container", "__backpack")

-- 存储到 TUNING.MONE_TUNING
TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA.[option_name] = env.GetModConfigData("option_name")
```

### 功能分类

- **便携容器** - 背包、袋子、猪猪包
- **箱子容器** - 带整理按钮的升级存储
- **生活质量** - 自动整理、升级建筑
- **装备** - 武器、护甲、帽子
- **其他** - 食物物品、特殊工具

## 关键模式

### 容器增强模式

容器支持：
- 拾取时自动打开/关闭
- 可滚动 UI（scroll_containers 选项）
- 一键整理按钮
- 堆叠大小修改

```lua
-- 容器参数模式
container_params = {
    widget = {
        slot_bg = true/false,
        -- 添加自定义按钮
    }
}
```

### PostInit 模式

```lua
-- 全局修改
env.AddPrefabPostInitAny(function(inst)
    -- 应用于所有 prefab
end)

-- 特定 prefab 修改
env.AddPrefabPostInit("specific_prefab", function(inst)
    -- 修改特定 prefab
    -- 这里实现特殊行为
    -- 区别于 scripts/prefabs 中定义的 fn（仅骨架）
end)
```

### 配方系统模式

```lua
-- 自定义制作标签
"更多物品·稳定版" (Stable)
"更多物品·测试版" (Testing)

-- 在 recipes.lua 中注册配方
AddRecipe2(
    prefab_name,
    {ingredients},
    tech_tree,
    {config_params}
)
```

### 组件系统

`scripts/components/` 中的自定义组件：
- 打包系统（`mie_bundle.lua`, `mie_bundle_action.lua`）
- 装备行为（`mone_bathat_fly.lua`, `mone_teraria.lua`）
- 特殊能力（`mone_pheromonestone_infinite.lua`）
- 食物效果（`mone_stomach_warming_hamburger.lua`）

## 工具函数

### moreitems.main

项目工具库入口，提供以下模块：

```lua
local moreitems = require("moreitems.main")

-- shihao: 通用工具库
moreitems.shihao.utils      -- 通用工具函数
moreitems.shihao.base       -- 基础函数和日志
moreitems.shihao.assertion  -- 断言工具
moreitems.shihao.module     -- 模块化工具

-- dst: DST 特定工具
moreitems.dst.dst_utils     -- DST 工具函数
moreitems.dst.dst_service   -- DST 服务
moreitems.dst.class         -- DST 类定义

-- thirdparty: 第三方库
moreitems.thirdparty.inspect    -- 调试输出
moreitems.thirdparty.luafun     -- 函数式编程
moreitems.thirdparty.middleclass -- 面向对象
```

### chang_mone API

用于常见 DST 操作的扩展工具库：

```lua
local API = require("moreitems.chang_mone.dsts.API")

API.reskin(original_prefab, build_name, {new_prefabs})  -- 皮肤支持
API.arrangeContainer(inst)                             -- 容器整理
```

## 常量系统

**scripts/more_items_constants.lua** 集中管理魔法数字和配置：

```lua
local constants = require("more_items_constants")

-- 模式：FEATURE__PARAM_NAME = value
LIFE_INJECTOR_VB__PER_ADD_NUM = 10
STOMACH_WARMING_HAMBURGER__PER_ADD_NUM = 10
SANITY_HAMBURGER__PER_ADD_NUM = 10

-- 在 recipes.lua 中使用：
Ingredient("spoiled_food", 10 * constants.LIFE_INJECTOR_VB__PER_ADD_NUM)
```

**添加属性提升物品时：**
1. 在 `more_items_constants.lua` 中添加 `FEATURE__PER_ADD_NUM` 常量
2. 添加 `FEATURE__INCLUDED_PLAYERS` 数组用于角色兼容性
3. 在组件配置和配方中引用常量

## 属性提升食物模式

三种属性汉堡（生命/饥饿/理智）使用统一的基础组件：

**组件：** `scripts/components/mone_increase_stat_base.lua`
- 处理最大属性提升、换人继承和跨服同步
- 通过使用常量的 `STAT_CONFIG` 表配置
- 每种食物类型有专用组件包装器（如 `mone_stomach_warming_hamburger.lua`）

**添加类似物品的模式：**
1. 在 `more_items_constants.lua` 中定义常量
2. 在 `mone_increase_stat_base.lua` 的 STAT_CONFIG 中创建配置条目
3. 在 `scripts/components/` 中创建组件包装器
4. 在 `modmain/recipes.lua` 中使用常量添加配方进行材料计算

**配方难度缩放：**
- 使用常量关联成本和效果：`Ingredient("material", multiplier * constants.FEATURE__PER_ADD_NUM)`
- 示例：10 个腐烂食物 × 10 点 = 100 总计（或调整倍数以平衡）

## 跨服数据同步

**modmain/shard_sync.lua** 实现 Mod RPC 跨服务器数据同步：

```lua
-- 注册 RPC 处理器
AddShardModRPCHandler("more_items", "rpc_name", function(shardid, userid, ...)
    -- 处理来自其他服务器的数据
end)

-- 发送 RPC
SendModRPCToShard(SHARDID, "more_items", "rpc_name", userid, ...)
```

**世界组件：** `scripts/components/mone_shard_sync.lua`
- 统一管理跨服数据存储
- 支持主服务器/洞穴架构
- 自动同步玩家属性数据

## 重要约束

- 永远不要修改子弹/投射物的堆叠限制（反向堆叠 bug）
- 容器整理按钮仅适用于特定格子数（6/8/12/14）
- 某些功能在检测到冲突模组时自动禁用
- PostInit 文件实现行为，prefab 文件定义结构
- 始终使用 `more_items_constants.lua` 中的常量作为物品参数

## 开发注意事项

### 无创意工坊本地测试

模组支持本地测试 - 检查 `folder_name` 是否有 "workshop-" 前缀，并为非创意工坊构建调整名称/图标。

### 调试模式

在 modinfo.lua 中启用：`debug = true`

### 兼容性检查

```lua
local IsModEnabled = function(name)
    -- 通过文件夹名或 modinfo 名称检查已启用的模组
end
```

### 语言支持

主要语言是中文（`locale == "zh" or "zht" or "zhr"`）。提供英文字符串，但中文是重点。

## 已知问题和路线图

查看 `.achieved_files/` 中的文档：
- **TODO_TRACKER.md** - 所有待办事项的详细追踪
- **TODOLISTS.md** - 功能计划和架构优化
- **UPDATELOGS.md** - 版本更新记录

## 开发文档

- **docs/dst-mod-development-guide.md** - DST 模组开发最佳实践

## 代码约定

### 命名规范

- **文件名**: 使用小写字母和下划线 (snake_case)
- **函数名**:
  - 导出函数使用 PascalCase (如 `MyFunction`)
  - 本地函数使用 snake_case (如 `local_function`)
- **变量名**: 使用 snake_case (如 `local_variable`)
- **常量**: 使用大写字母和下划线 (如 `CONSTANT_NAME`)
- **预制体前缀**:
  - `mone_` - 核心模组物品
  - `mie_` - 扩展包物品
  - `rmi_` - 特殊配方物品

### 格式规范

- 缩进: 4 个空格 (不使用制表符)
- 行长度: 最大约 100 个字符
- 注释: 优先使用中文，文档注释使用 `---`
- 逻辑部分之间保留空行

### 错误处理

```lua
-- 对风险操作使用 pcall
xpcall(function()
    risky_operation()
end, function(msg)
    print("[MoreItems] Error: " .. msg)
end)

-- 检查组件存在性
if inst.components.fueled and not inst.components.fueled:IsEmpty() then
    -- 可以安全使用
end
```

### 调试技巧

```lua
-- 添加到 modinfo.lua
debug = true

-- 带前缀打印
print(string.format("[MoreItems] %s", message))

-- 使用 base.log
local base = require("moreitems.main").shihao.base
base.log.info("message")
base.log.warn("warning")
base.log.error("error")
```

## 本地化系统

**scripts/more_items_language_loc.lua** 集中管理所有文本：

```lua
local TEXT = {
    prefabsInfo = {
        ["prefab_name"] = {
            names = "物品名称",
            describe = "物品描述",
            recipe_desc = "配方描述"
        }
    },
    HARVESTER_STAFF_USES = 100,
    -- 其他常量...
}
```

## 资源管理

### Asset 声明

在 `modmain/assets.lua` 中声明资源：

```lua
Asset("ANIM", "anim/anim_name.zip")
Asset("IMAGE", "images/inventoryimages/item.tex")
Asset("ATLAS", "images/inventoryimages/item.xml")
Asset("ATLAS_BUILD", "images/inventoryimages/item.xml", 256)
```

### Prefab Files

在 `modmain/prefabfiles.lua` 中声明预制体文件路径：

```lua
env.PrefabFiles = {
    "mone/category/item_name",
}
```

### Minimap Atlas

在 `modmain/minimap.lua` 中添加小地图图标：

```lua
env.AddMinimapAtlas("images/minimapimages/item.xml")
```
