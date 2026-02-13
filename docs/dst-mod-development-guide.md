# DST 模组开发指南

本指南提供了开发 Don't Starve Together (DST) 模组的最佳实践和约定。

## 项目结构

DST 模组通常遵循以下结构：

```
mod_name/
├── modinfo.lua           # 模组元数据和配置
├── modmain.lua           # 主入口文件
├── modtuning.lua         # 运行时配置
├── modmain/              # 核心逻辑目录
│   ├── PostInit/         # 后初始化修改
│   ├── components/       # 自定义组件
│   ├── prefabs/          # 预制体定义
│   └── recipes/          # 配方定义
├── scripts/              # 脚本目录
│   ├── components/       # 自定义组件
│   ├── prefabs/          # 预制体定义
│   └── stategraphs/      # 状态图
└── assets/               # 资源文件
    ├── anim/             # 动画
    ├── images/           # 图像
    └── bigportraits/     # 大头像
```

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

### 导入模式

```lua
-- 标准导入模式 - 文件顶部
local brain = require "brains/mone_fertilizer_bot_brain"
local constants = require("more_items_constants")
local API = require("chang_mone.dsts.API")

-- 使用 env.modimport 导入模组文件
env.modimport("modtuning.lua")
env.modimport("modmain/containers.lua")
```

### 文件结构

1. 头部注释 (作者和日期)
2. Assets 表 (如果是预制体)
3. Prefabs 表 (依赖项)
4. Requires (常量、工具、API)
5. 本地常量 (大写字母和下划线)
6. 辅助函数
7. 主要预制体/组件函数
8. 返回语句

### 格式规范

- 缩进: 4 个空格 (不使用制表符)
- 行长度: 最大约 100 个字符
- 注释: 优先使用中文，文档注释使用 `---`
- 逻辑部分之间保留空行

## 常量系统

**始终使用 `scripts/more_items_constants.lua` 中的常量**:

```lua
local constants = require("more_items_constants")
-- 使用: constants.MONE_FERTILIZER_BOT__RANGE
-- 不要使用硬编码数字
```

## 错误处理

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

## PostInit 模式

```lua
-- 全局修改
env.AddPrefabPostInitAny(function(inst)
    -- 应用于所有预制体
end)

-- 特定预制体修改
env.AddPrefabPostInit("specific_prefab", function(inst)
    -- 在这里修改特定预制体行为
    -- 不要在 scripts/prefabs 中实现 (那里只是骨架)
end)
```

## 容器增强模式

```lua
container_params = {
    widget = {
        slot_bg = true/false,
        -- 自定义按钮在这里
    }
}
```

## 添加新物品 (9 步)

1. `modinfo.lua` - 添加配置选项
2. `modtuning.lua` - 添加运行时配置
3. `modmain/PostInit/prefabs/[name].lua` - 特殊行为
4. `modmain/enable_prefabs.lua` - 开关、资源、预制体文件
5. `scripts/languages/mone/loc.lua` - 本地化
6. `modmain/init/init_tooltips.lua` - 提示信息
7. `modmain/recipes.lua` - 配方和标签
8. `modmain/reskin.lua` - 皮肤 (如果使用原版纹理)
9. `scripts/prefabs/mone/[category]/[name].lua` - 预制体定义

## 关键约束

- **绝不**修改投射物堆叠限制 (反向堆叠错误)
- 容器整理按钮仅适用于特定槽数: 6/8/12/14
- 检测到冲突模组时功能自动禁用
- 对实体操作前始终检查 `inst:IsValid()`
- PostInit 文件实现行为，预制体文件定义结构

## 调试

```lua
-- 添加到 modinfo.lua
debug = true

-- 带前缀打印
print(string.format("[MoreItems] %s", message))

-- 检查模组冲突
local IsModEnabled = function(name)
    -- 按文件夹或 modinfo 名称检查
end
```