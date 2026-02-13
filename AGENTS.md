# AGENTS.md

Coding guidelines for AI agents working on the MoreItems Don't Starve Together mod.

## Project Overview

This is a **Don't Starve Together (DST) mod** written in Lua, adding 100+ new items, enhanced containers, and quality-of-life features. It follows Klei's DST mod architecture.

- **Language**: Lua 5.1 (DST embedded)
- **Primary Language**: Chinese (zh/zht/zhr), with English fallback
- **Version**: 6.0.2
- **Author**: 心悦卿兮

## Build/Test Commands

This project has no traditional build system. Testing is done via custom framework:

```bash
# Run all unit tests (from DST console)
require("moreitems.lib.shihao.module.unittest").run_unittests(module)

# Run specific test file (from DST console)
require("moreitems.lib.shihao.module.__unittests__.stl_string")

# Run unittests for specific module
require("moreitems.lib.shihao.module.unittest").run_unittests(require("moreitems.lib.shihao.module.stl_string"))

# Debug logging (add to modinfo.lua)
debug = true
```

**No linting tools configured.** Follow style guidelines below manually.

## Code Style Guidelines

### Naming Conventions

- **Prefixes**: 
  - `mone_` - Core mod items
  - `mie_` - Expansion pack items  
  - `rmi_` - Special recipe items
- **PostInit files**: lowercase with underscores (e.g., `waterballoon.lua`)
- **Constants**: `FEATURE__PARAM_NAME` (double underscore separator)
- **Local variables**: `local_variable_name` (snake_case)
- **Functions**: `FunctionName` (PascalCase for exported, `local_function` for private)

### Imports

```lua
-- Standard pattern at top of file
local brain = require "brains/mone_fertilizer_bot_brain"
local constants = require("more_items_constants")
local API = require("chang_mone.dsts.API")

-- Use env.modimport for mod files
env.modimport("modtuning.lua")
env.modimport("modmain/containers.lua")
```

### File Structure

1. **Header comment** with author and date
2. **Assets** table (if prefab)
3. **Prefabs** table (dependencies)
4. **Requires** (constants, utils, APIs)
5. **Local constants** (CAPS_WITH_UNDERSCORES)
6. **Helper functions**
7. **Main prefab/component function**
8. **Return statement**

### Formatting

- Indent: 4 spaces (no tabs)
- Line length: ~100 chars max
- Comments: Chinese preferred, use `---` for documentation
- Empty lines between logical sections

### Constants System

**Always use constants from `scripts/more_items_constants.lua`**:

```lua
local constants = require("more_items_constants")
-- Use: constants.MONE_FERTILIZER_BOT__RANGE
-- Not: hardcoded numbers
```

### Error Handling

```lua
-- Use pcall for risky operations
xpcall(function()
    risky_operation()
end, function(msg)
    print("[MoreItems] Error: " .. msg)
end)

-- Check component existence
if inst.components.fueled and not inst.components.fueled:IsEmpty() then
    -- safe to use
end
```

### PostInit Pattern

```lua
-- Global modification
env.AddPrefabPostInitAny(function(inst)
    -- applies to all prefabs
end)

-- Specific prefab modification  
env.AddPrefabPostInit("specific_prefab", function(inst)
    -- modify specific prefab behavior here
    -- NOT in scripts/prefabs (that's just skeleton)
end)
```

### Container Enhancement Pattern

```lua
container_params = {
    widget = {
        slot_bg = true/false,
        -- custom buttons here
    }
}
```

### Adding New Items (9 Steps)

1. `modinfo.lua` - Add config option
2. `modtuning.lua` - Add runtime config
3. `modmain/PostInit/prefabs/[name].lua` - Special behavior
4. `modmain/enable_prefabs.lua` - Switch, assets, prefabfiles
5. `scripts/languages/mone/loc.lua` - Localization
6. `modmain/init/init_tooltips.lua` - Tooltips
7. `modmain/recipes.lua` - Recipe & tags
8. `modmain/reskin.lua` - Skins (if using vanilla textures)
9. `scripts/prefabs/mone/[category]/[name].lua` - Prefab definition

## Critical Constraints

- **NEVER** modify projectile stack limits (reverse stacking bug)
- Container organize buttons only work with specific slot counts: 6/8/12/14
- Features auto-disable when conflicting mods detected
- Always check `inst:IsValid()` before operations on entities
- PostInit files implement BEHAVIOR, prefab files define STRUCTURE

## Git Commit Format

```
<type>(<scope>): <subject> (Chinese, ≤50 chars, verb start, no period)

- Type: feat, fix, docs, style, refactor, perf, test, chore, ci, revert
- Scope: fertilizer-bot, containers, recipes, etc.
- Body: What and why (optional, ≤72 chars per line, use `-` list)

Example:
fix(fertilizer-bot): 修复施肥机器人只对移植植物施肥的问题

- 优化施肥动作执行逻辑，简化代码结构
- 移除调试日志，清理代码
```

## Architecture

**Entry Points**:
- `modinfo.lua` - Metadata & 60+ config options
- `modmain.lua` - Main init coordinator
- `modtuning.lua` - Runtime config bridge

**Key Directories**:
- `modmain/` - Core logic, PostInit, AUXmods
- `scripts/prefabs/mone/` - Core items
- `scripts/components/` - Custom DST components
- `scripts/chang_mone/dsts/API.lua` - Utility library
- `scripts/more_items_constants.lua` - All constants

## Debugging

```lua
-- Add to modinfo.lua
debug = true

-- Print with prefix
print(string.format("[MoreItems] %s", message))

-- Check mod conflicts
local IsModEnabled = function(name)
    -- check by folder or modinfo name
end
```
