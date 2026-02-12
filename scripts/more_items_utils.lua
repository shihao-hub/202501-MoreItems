---
--- DateTime: 2025/9/30 18:06
--- 创建 prefab 相关工具，主要目的是能快速创建新 prefab，提示：请尽量减少文件创建的数量
---

local this = {}

local _config_data = TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA

function this.get_config(config_name)
    return _config_data[config_name]
end

---
---根据参数生成 recipe 数据，因为 recipe table 的结构复杂，ide 也难以支持智能提示
---
---@param name string
---@param ingredients table[]
---@param tech any @ 形如 TECH.SCIENCE_ONE
---@param filters table[]
---@param config_atlas string @ 形如 "images/xxx"，images 是模组的 images 目录
---@param config_image string @ 形如 "{name}.tex"
---@param config_extras table @ config 的额外参数
function this.get_recipe_data(name, ingredients, tech, filters, config_atlas, config_image, config_extras)
    local config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atals = config_atlas,
        image = config_image,
    }
    if config_extras ~= nil then
        for k, v in pairs(config_extras) do
            config[k] = v
        end
    end
    return {
        name = name,
        ingredients = ingredients,
        tech = tech,
        config = config,
        filters = filters,
    }
end

---
---我的更多物品里的 reskin 函数，虽然这个函数当时也是试验出来的，毕竟贴图相关实在不懂
---
function this.reskin(source_name, target_name, bank, build)
    assert(source_name ~= "cane", "[unpopular] function not supported") -- 原函数里有不少关于 cane 的补丁，我忽略了，我开发的直接报错不支持，到时候再说

    local init_fn_name = source_name .. "_init_fn";
    local init_fn = rawget(_G, init_fn_name);
    if not init_fn then
        print(string.format("[unpopular] init_fn_name: %s cannot be found.", init_fn_name))
        return
    end

    local clear_fn_name = source_name .. "_clear_fn";
    local clear_fn = rawget(_G, clear_fn_name);
    if not clear_fn then
        print(string.format("[unpopular] clear_fn_name: %s cannot be found.", clear_fn_name))
        return ;
    end

    rawset(_G, init_fn_name, function(inst, build_name, def_build, ...)
        if inst.prefab ~= target_name then
            return init_fn(inst, build_name, def_build, ...)
        end
        inst.AnimState:SetBank(bank)
        basic_init_fn(inst, build_name, build, ...)
    end)

    rawset(_G, clear_fn_name, function(inst, def_build, ...)
        if inst.prefab ~= target_name then
            return clear_fn(inst, def_build, ...)
        end

        inst.AnimState:SetBank(bank)
        basic_clear_fn(inst, build, ...)
    end)

    -- 修改全局表，可以让制作物品页面可以选皮肤
    if ((rawget(_G, "PREFAB_SKINS") or {})[name] and (rawget(_G, "PREFAB_SKINS_IDS") or {})[name]) then
        for _, reskin_prefab in ipairs(prefabs) do
            PREFAB_SKINS[reskin_prefab] = PREFAB_SKINS[name];
            PREFAB_SKINS_IDS[reskin_prefab] = PREFAB_SKINS_IDS[name];
        end
    end
end

function this.generate_prefab_from_game_prefab(name, game_name)
    local game_prefab = Prefabs[game_name]
    assert(game_prefab ~= nil, string.format("错误，全局 Prefabs 表中没有 %s", game_name))
    return Prefab(name, game_prefab.fn, game_prefab.assets, game_prefab.deps, game_prefab.force_path_search)
end

---
---添加一个新预制物（新版本 API，推荐使用）
---使用配置表代替多个参数，提供更好的可读性和灵活性
---
---@param env table @ 全局环境 (env = GLOBAL.setmetatable(env, {__index = GLOBAL}) 的结果)
---@param config table @ 配置表，包含以下字段：
---   - name: string            [必填] prefab 名称
---   - enabled: boolean|nil    [可选] 是否启用，默认为 true
---   - config_key: string|nil  [可选] 从 TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA 读取配置的 key
---
---   以下为资源配置（二选一）：
---   - assets: table|nil       [可选] Asset 数组，直接添加到 env.Assets
---   - prefabfiles: table|nil  [可选] prefab 文件路径数组，形如 "mone/game/lureplant"
---
---   以下为配方配置：
---   - recipe: table|nil       [可选] 配方数据 {name, ingredients, tech, config, filters}
---   - recipe_filters: table|nil [可选] 配方标签筛选器，默认为 {"更多物品·稳定版"}
---
---   以下为皮肤配置（复用原版贴图）：
---   - reskin: table|nil       [可选] 皮肤配置 {source_name, target_name, bank, build}
---
---   以下为行为配置（二选一）：
---   - postinit_fn: function|nil  [可选] PostInit 函数，接收 name 参数
---   - postinit_file: string|nil  [可选] PostInit 文件路径，形如 "modmain/PostInit/prefabs/lureplant.lua"
---
---   以下为游戏内 prefab 复用配置：
---   - game_data: table|nil    [可选] 复用游戏内 prefab 的 fn
---       - source_prefab: string  [必填] 源 prefab 名称
---       - imagename: string|nil   [可选] inventoryitem.imagename
---       - atlasname: string|nil   [可选] inventoryitem.atlasname
---
---@return boolean @ 是否成功添加
---
---使用示例：
---```lua
---  -- 示例1: 基础用法（仅 prefab 文件）
---  prefab_registry.add_prefab(env, {
---      name = "mone_lureplant",
---      prefabfiles = {"mone/game/lureplant"},
---      postinit_file = "modmain/PostInit/prefabs/lureplant.lua",
---  })
---
---  -- 示例2: 包含配方
---  prefab_registry.add_prefab(env, {
---      name = "mone_super_backpack",
---      config_key = "super_backpack",  -- 从配置读取开关
---      prefabfiles = {"mone/containers/super_backpack"},
---      recipe = {
---          name = "mone_super_backpack",
---          ingredients = {Ingredient("papyrus", 4), Ingredient("rope", 2)},
---          tech = TECH.SCIENCE_ONE,
---          config = {atlas = "images/inventoryimages/mone_super_backpack.xml"},
---          filters = {"更多物品·稳定版"},
---      },
---  })
---
---  -- 示例3: 复用游戏内 prefab + 自定义贴图
---  prefab_registry.add_prefab(env, {
---      name = "mone_pig_coin",
---      prefabfiles = {"mone/game/pig_coin"},
---      game_data = {
---          source_prefab = "pig_coin",
---          imagename = "mone_pig_coin.tex",
---          atlasname = "images/inventoryimages/mone_pig_coin.xml",
---      },
---  })
---
---  -- 示例4: 使用皮肤系统（复用原版贴图）
---  prefab_registry.add_prefab(env, {
---      name = "mone_golden_pickaxe",
---      prefabfiles = {"mone/tools/golden_pickaxe"},
---      reskin = {
---          source_name = "pickaxe",
---          target_name = "mone_golden_pickaxe",
---          bank = "pickaxe",
---          build = "mone_golden_pickaxe",
---      },
---  })
---```
function this.add_prefab(env, config)
    -- 参数验证
    if type(config) ~= "table" then
        error("[prefab_registry] config 必须是 table")
    end
    if type(config.name) ~= "string" then
        error("[prefab_registry] config.name 必须是 string")
    end

    -- 检查是否启用
    local enabled = config.enabled
    if enabled == nil and config.config_key then
        -- 从配置读取
        enabled = TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA[config.config_key]
    end
    if enabled ~= true then
        return false
    end

    -- 初始化全局表
    if env.Assets == nil then
        env.Assets = {}
    end
    if env.PrefabFiles == nil then
        env.PrefabFiles = {}
    end

    -- 1. 处理 Assets
    if config.assets then
        for _, asset in ipairs(config.assets) do
            table.insert(env.Assets, asset)
        end
    end

    -- 2. 处理 PrefabFiles
    if config.prefabfiles then
        for _, prefabfile in ipairs(config.prefabfiles) do
            table.insert(env.PrefabFiles, prefabfile)
        end
    end

    -- 3. 处理配方
    if config.recipe then
        local recipe = config.recipe
        local filters = config.recipe_filters or {"更多物品·稳定版"}
        env.AddRecipe2(recipe.name, recipe.ingredients, recipe.tech, recipe.config, filters)
        env.RemoveRecipeFromFilter(recipe.name, "MODS")
    end

    -- 4. 处理皮肤
    if config.reskin then
        local reskin = config.reskin
        this.reskin(reskin.source_name, reskin.target_name, reskin.bank, reskin.build)
    end

    -- 5. 处理 PostInit
    if config.postinit_fn then
        config.postinit_fn(config.name)
    elseif config.postinit_file then
        env.modimport(config.postinit_file)
    end

    -- 6. 处理游戏内 prefab 复用
    if config.game_data then
        local game_data = config.game_data
        if game_data.source_prefab then
            -- 从源 prefab 复用 fn 并注册新 prefab
            local source_prefab = Prefabs[game_data.source_prefab]
            if source_prefab then
                -- 注册新 prefab（复用源 prefab 的 fn）
                -- 注意：这里假设 prefabfiles 中已经定义了实际的 prefab
                -- 如果需要完全复用，可以使用 GeneratePrefabFromGamePrefab
                Prefab(config.name, source_prefab.fn, source_prefab.assets, source_prefab.deps)
            end
        end

        -- 修改 inventoryitem 的贴图
        if game_data.imagename or game_data.atlasname then
            env.AddPrefabPostInit(config.name, function(inst)
                if not TheWorld.ismastersim then
                    return
                end
                if inst.components.inventoryitem == nil then
                    return
                end
                if game_data.imagename then
                    inst.components.inventoryitem.imagename = game_data.imagename
                end
                if game_data.atlasname then
                    inst.components.inventoryitem.atlasname = game_data.atlasname
                end
            end)
        end
    end

    return true
end

---
---批量添加 prefab
---
---@param env table @ 全局环境
---@param configs table[] @ 配置表数组
---@return number @ 成功添加的数量
function this.add_prefabs(env, configs)
    local count = 0
    for _, config in ipairs(configs) do
        if this.add_prefab(env, config) then
            count = count + 1
        end
    end
    return count
end

---
---【旧版本 API，已弃用，保留向后兼容】
---添加一个新预制物
---
---@deprecated 请使用 add_prefab(env, config) 新版本 API
---@param env env
---@param enabled boolean @ 是否开启
---@param name string @ prefab 名称
---@param assets table[] @ 元素为 Asset
---@param prefabfiles table[] @ 元素为文件路径，形如 a/b/c，a 是 scripts/prefabs 中的一级目录
---@param recipe table @ {name:str,ingredients:table,tech:table,config:table,filters:table}
---@param reskin table @ {source_name:str,target_name:str,bank:str,build:str}
---@param postinit_fn fun(name:string) @ 类似更多物品的 postinit 目录
---@param game_data table @ 如果 game_data 不为空，则代表 Prefab fn 将来自游戏本体的 Prefab 的 fn
function this.add_prefab_legacy(env, enabled, name, assets, prefabfiles, recipe, reskin, postinit_fn, game_data)
    if enabled ~= true then
        return
    end

    if env.Assets == nil then
        env.Assets = {}
    end
    if env.PrefabFiles == nil then
        env.PrefabFiles = {}
    end

    assets = assets or {}
    prefabfiles = prefabfiles or {}  -- 修复原 bug: assets = prefabfiles or {}

    -- assets.lua
    for _, asset in ipairs(assets) do
        table.insert(env.Assets, asset)
    end

    -- prefabfiles.lua
    for _, prefabfile in ipairs(prefabfiles) do
        table.insert(env.PrefabFiles, prefabfile)  -- 修复原 bug: table.insert(env.Assets, prefabfile)
    end

    -- recipes.lua
    if recipe ~= nil then
        env.AddRecipe2(recipe.name, recipe.ingredients, recipe.tech, recipe.config, recipe.filters)
        env.RemoveRecipeFromFilter(recipe.name, "MODS")
    end

    -- reskin.lua
    if reskin ~= nil then
        this.reskin(reskin.source_name, reskin.target_name, reskin.bank, reskin.build)
    end

    if postinit_fn ~= nil then
        postinit_fn(name)
    end

    -- game_data: { name:str, fn:function, inventoryitem:table }
    -- game_data.inventoryitem: { imagename:string, atlasname:string }，形如 "imagename" "images/?/?.xml"
    if game_data == nil then
        return
    end

    -- todo: 是否可以直接修改解析 imagename 和 atlasname 的那个函数呢？
    env.AddPrefabPostInit(name, function(inst)
        if not TheWorld.ismastersim then
            return
        end

        if inst.components.inventoryitem == nil then
            return
        end

        inst.components.inventoryitem.imagename = game_data.imagename
        inst.components.inventoryitem.atlasname = game_data.atlasname
    end)
end

if select("#", ...) == 0 then
    -- for test
end

return this