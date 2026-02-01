# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is "More Items" (更多物品) - a comprehensive Don't Starve Together mod that adds 100+ new items, enhanced containers, equipment, and quality-of-life features. The mod is written in Lua and follows Klei's DST modding architecture.

**Version:** 6.0.2
**Author:** 心悦卿兮
**Steam Workshop ID:** 2916137510
**Expansion Pack ID:** 2928706576

## Architecture

### Entry Points

- **modinfo.lua** - Mod metadata, configuration options (60+ settings), and workshop display info
- **modmain.lua** - Main initialization orchestrator, loads all subsystems
- **modmain2.lua** & **modmain3.lua** - Additional modular entry points
- **modtuning.lua** - Runtime configuration bridge between modinfo and code

### Initialization Sequence

```
modmain.lua execution order:
1. Environment setup (metatable for GLOBAL access)
2. new_modmain_preload.lua (new world features)
3. modtuning.lua (TUNING.MONE_TUNING configuration)
4. modmain/preload.lua
5. modmain/modglobal.lua & modmain/global.lua
6. modmain/Optimization/main.lua
7. modmain/compatibility.lua
8. modmain/prefabfiles.lua & modmain/assets.lua
9. languages/mone/loc.lua (localization)
10. modmain/containers.lua
11. modmain/init/init_tooltips.lua
12. modmain/recipes.lua, minimap.lua, actions.lua, reskin.lua
13. AUXmods (conditional feature modules)
14. PostInit modules (prefab modifications)
```

### Directory Structure

```
MoreItems/
├── modmain/                    # Core mod logic
│   ├── AUXmods/               # Auxiliary features (conditionally loaded)
│   ├── PostInit/              # Post-initialization modifications
│   │   ├── prefabs/          # Prefab behavior modifications
│   │   └── *.lua             # Global PostInit hooks
│   ├── init/                  # Initialization helpers
│   ├── OriginalItemsModifications/  # Vanilla item modifications
│   └── *.lua                  # Core system files
├── scripts/                    # Advanced functionality
│   ├── components/            # Custom DST components
│   ├── prefabs/               # Prefab definitions (mone/, mie/, mi_modules/)
│   ├── chang_mone/            # API and utilities
│   ├── moreitems/             # Core utilities and libraries
│   └── languages/mone/        # Localization (Chinese)
├── images/                     # Asset files (.tex, .xml, .scml, .zip)
└── texts/                      # Text assets
```

## Adding New Items

Follow the sequence defined in **NOTES.md**:

1. **modinfo.lua** - Add configuration option
2. **modtuning.lua** - Add runtime config access
3. **modmain/PostInit/prefabs/[name].lua** - PostInit for special behaviors (based on `env.AddPrefabPostInit`)
4. **modmain/enable_prefabs.lua** - Toggle, assets, and prefabfiles import
5. **scripts/languages/mone/loc.lua** - Add localized strings
6. **modmain/init/init_tooltips.lua** - Item description tooltips
7. **modmain/recipes.lua** - Crafting recipe and tab
8. **modmain/reskin.lua** - Skin support (if using vanilla textures)
9. **scripts/prefabs/mone/[category]/[name].lua** - Actual prefab definition

### Naming Conventions

- `mone_` prefix - Core mod items
- `mie_` prefix - Expansion pack items
- `rmi_` prefix - Special recipe items
- PostInit files use lowercase with underscores

## Configuration System

### modinfo.lua Configuration Pattern

Configuration uses helper functions for consistency:

```lua
-- Common toggle pattern
fns.common_item(name, label, hover, default, option_hover)

-- Partition config (master switch + sub-options)
get_parition_config("moreitems_portable_container", "__backpack")

-- Storage in TUNING.MONE_TUNING
TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA.[option_name] = env.GetModConfigData("option_name")
```

### Feature Categories

- **Portable containers** - Backpacks, bags, piggybag
- **Chest containers** - Upgraded storage with sorting buttons
- **Living quality** - Auto-sorters, upgraded structures
- **Equipment** - Weapons, armor, hats
- **Other** - Food items, special tools

## Key Patterns

### Container Enhancement Pattern

Containers support:
- Auto-open/close on pickup
- Scrollable UI (scroll_containers option)
- One-tidy arrange buttons
- Stack size modifications

```lua
-- Container parameter pattern
container_params = {
    widget = {
        slot_bg = true/false,
        -- Add custom buttons
    }
}
```

### PostInit Pattern

```lua
-- Global modifications
env.AddPrefabPostInitAny(function(inst)
    -- Apply to all prefabs
end)

-- Specific prefab modifications
env.AddPrefabPostInit("specific_prefab", function(inst)
    -- Modify specific prefab
    -- This is where special behaviors are implemented
    --区别于 scripts/prefabs 中定义的 fn (skeleton only)
end)
```

### Recipe System Pattern

```lua
-- Custom crafting tabs
"更多物品·稳定版" (Stable)
"更多物品·测试版" (Testing)

-- Recipe registration in recipes.lua
AddRecipe2(
    prefab_name,
    {ingredients},
    tech_tree,
    {config_params}
)
```

### Component System

Custom components in `scripts/components/`:
- Bundle systems (`mie_bundle.lua`, `mie_bundle_action.lua`)
- Equipment behavior (`mone_bathat_fly.lua`, `mone_teraria.lua`)
- Special abilities (`mone_pheromonestone_infinite.lua`)
- Food effects (`mone_stomach_warming_hamburger.lua`)

## Utility Functions

### more_items_utils.lua

Provides `add_prefab()` function for streamlined item creation.

### scripts/chang_mone/dsts/API.lua

Extensive utility library for common DST operations.

## Development Notes

### Testing Without Workshop

The mod supports local testing - checks `folder_name` for "workshop-" prefix and adjusts name/icon accordingly for non-workshop builds.

### Debug Mode

Enable in modinfo.lua: `debug = true`

### Compatibility Checks

```lua
local IsModEnabled = function(name)
    -- Checks enabled mods by folder name or modinfo name
end
```

### Language Support

Primary language is Chinese (`locale == "zh" or "zht" or "zhr"`). English strings are provided but Chinese is the focus.

## Constants System

**scripts/more_items_constants.lua** centralizes magic numbers and configuration:

```lua
local constants = require("more_items_constants")

-- Pattern: FEATURE__PARAM_NAME = value
LIFE_INJECTOR_VB__PER_ADD_NUM = 10
STOMACH_WARMING_HAMBURGER__PER_ADD_NUM = 10
SANITY_HAMBURGER__PER_ADD_NUM = 10

-- Use in recipes.lua:
Ingredient("spoiled_food", 10 * constants.LIFE_INJECTOR_VB__PER_ADD_NUM)
```

**When adding new stat-increasing items:**
1. Add `FEATURE__PER_ADD_NUM` constant to `more_items_constants.lua`
2. Add `FEATURE__INCLUDED_PLAYERS` array for character compatibility
3. Reference constant in both component config and recipe

## Stat-Increasing Food Pattern

The three stat hamburgers (health/hunger/sanity) use a unified base component:

**Component:** `scripts/components/mone_increase_stat_base.lua`
- Handles max stat increases, character swap inheritance, and shard sync
- Configured via `STAT_CONFIG` table using constants
- Each food type has dedicated component wrapper (e.g., `mone_stomach_warming_hamburger.lua`)

**Pattern when adding similar items:**
1. Define constant in `more_items_constants.lua`
2. Create config entry in `mone_increase_stat_base.lua` STAT_CONFIG
3. Create component wrapper in `scripts/components/`
4. Add recipe in `modmain/recipes.lua` using constant for ingredient calculation

**Recipe difficulty scaling:**
- Use constants to link cost to effect: `Ingredient("material", multiplier * constants.FEATURE__PER_ADD_NUM)`
- Example: 10 spoiled food × 10 points = 100 total (or adjust multiplier for balance)

## Important Constraints

- Never modify stack limits for bullets/projectiles (reverse stacking bug)
- Container arrange buttons only work with specific slot counts (6/8/12/14)
- Some features disable automatically when conflicting mods are detected
- PostInit files implement behaviors, prefab files define structure
- Always use constants from `more_items_constants.lua` for item parameters

## Known Issues

See **DEFECTS.md** for tracked bugs (e.g., bundle items disappearing when eaten by lureplant).

## Roadmap

See **TODOLISTS.md** for planned features and refactor tasks.
