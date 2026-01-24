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
---添加一个新预制物
---
---@param env env
---@param enabled boolean @ 是否开启
---@param assets table[] @ 元素为 Asset
---@param prefabfiles table[] @ 元素为文件路径，形如 a/b/c，a 是 scripts/prefabs 中的一级目录
---@param recipe table @ {name:str,ingredients:table,tech:table,config:table,filters:table}
---@param reskin table @ {source_name:str,target_name:str,bank:str,build:str}
---@param postinit_fn fun(name:string) @ 类似更多物品的 postinit 目录
---@param game_data table @ 如果 game_data 不为空，则代表 Prefab fn 将来自游戏本体的 Prefab 的 fn
function this.add_prefab(env, enabled, name, assets, prefabfiles, recipe, reskin, postinit_fn, game_data)
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
    assets = prefabfiles or {}

    -- assets.lua
    for _, asset in ipairs(assets) do
        table.insert(env.Assets, asset)
    end

    -- prefabfiles.lua
    for _, prefabfile in ipairs(prefabfiles) do
        table.insert(env.Assets, prefabfile)
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

    -- [2025-11-04] 考虑使用游戏本体 Prefab 的 fn（待定吧，直接复制老实说最省事也最稳定吧？）
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