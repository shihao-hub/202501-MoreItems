---
--- @author zsh in 2023/3/2 10:24
--- 重构：合并三种汉堡的重复代码
---

local assertion = require("moreitems.main").shihao.assertion
local stl_table = require("moreitems.main").shihao.module.stl_table
local base = require("moreitems.main").shihao.base
local utils = require("moreitems.main").shihao.utils
local dst_utils = require("moreitems.main").dst.dst_utils
local constants = require("more_items_constants")

------------------------------------------------------------------------------------------------------------------------

local STAT_CONFIG = {
    stomach_warming_hamburger = {
        config_key = "stomach_warming_hamburger__inherit_when_change_character",
        allow_universal_config_key = "stomach_warming_hamburger__allow_universal_functionality_enable",
        component_name = "hunger",
        save_fields = {"save_currenthunger", "save_maxhunger"},
        add_num = constants.STOMACH_WARMING_HAMBURGER__PER_ADD_NUM,
        included_players = constants.STOMACH_WARMING_HAMBURGER__INCLUDED_PLAYERS,
        file_prefix = "stomach_warming_hamburger_",
        rpc_function = "SetHamburgerData",
        log_prefix = "[暖胃汉堡包换人继承]",
        say_format = "当前最大饥饿度为： %d",
        increase_method = "VitIncrease"
    },

    lifeinjector_vb = {
        config_key = "lifeinjector_vb__inherit_when_change_character",
        allow_universal_config_key = "lifeinjector_vb__allow_universal_functionality_enable",
        component_name = "health",
        save_fields = {"save_currenthealth", "save_maxhealth"},
        add_num = constants.LIFE_INJECTOR_VB__PER_ADD_NUM,
        included_players = constants.LIFE_INJECTOR_VB__INCLUDED_PLAYERS,
        file_prefix = "lifeinjector_vb_",
        rpc_function = "SetLifeinjectorData",
        log_prefix = "[强心素食堡换人继承]",
        say_format = "当前最大生命值为： %d",
        increase_method = "HPIncrease"
    },

    sanity_hamburger = {
        config_key = "sanity_hamburger__inherit_when_change_character",
        allow_universal_config_key = "sanity_hamburger__allow_universal_functionality_enable",
        component_name = "sanity",
        save_fields = {"save_currentsanity", "save_maxsanity"},
        add_num = constants.SANITY_HAMBURGER__PER_ADD_NUM,
        included_players = constants.SANITY_HAMBURGER__INCLUDED_PLAYERS,
        file_prefix = "sanity_hamburger_",
        rpc_function = "SetSanityHamburgerData",
        log_prefix = "[强san素食堡换人继承]",
        say_format = "当前最大理智值为： %d",
        increase_method = "VitIncrease"
    }
}

------------------------------------------------------------------------------------------------------------------------

local IncreaseStatBase = {}

function IncreaseStatBase.new(stat_type)
    local config = STAT_CONFIG[stat_type]
    if not config then
        error("Unknown stat type: " .. tostring(stat_type))
    end

    local inherit_when_change_character = dst_utils.get_mod_config_data(config.config_key)
    local allow_universal_functionality_enable = dst_utils.get_mod_config_data(config.allow_universal_config_key)
    local interval = {
        get_persistent_data = dst_utils.get_persistent_data,
        set_persist_data = dst_utils.set_persist_data
    }

    local function _is_player_included(username)
        return stl_table.contains_value(config.included_players, username)
    end

    local function _should_enable_for_player(prefab)
        return allow_universal_functionality_enable or _is_player_included(prefab)
    end

    local function _set_persist_data_on_init(component, persist_data)
        base.log.info("call _set_persist_data_on_init")

        local self = component
        local user = self.inst

        if not _should_enable_for_player(user.prefab) then
            return
        end

        persist_data = base.if_then_else(
            persist_data,
            function() return persist_data end,
            function() return interval.get_persistent_data(self:_get_persist_filename()) end
        )

        if not persist_data then
            return
        end

        if not persist_data.eatnum or persist_data.eatnum <= 0 then
            base.log.info("character hasn't eaten, skip inheritance")
            return
        end

        self.eatnum = persist_data.eatnum
        for _, field in ipairs(config.save_fields) do
            self[field] = persist_data[field]
        end

        base.log.info("set " .. config.save_fields[2] .. " field success!")
    end

    local ComponentClass = Class(function(self, inst)
        self.inst = inst
        self.eatnum = 0

        for _, field in ipairs(config.save_fields) do
            self[field] = nil
        end

        if inherit_when_change_character then
            self.inst:DoTaskInTime(0, function()
                if not _should_enable_for_player(self.inst.prefab) then
                    return
                end

                assertion.assert_true(_is_player_included(self.inst.prefab))

                local old_max_value = self[config.save_fields[2]]

                local filename = self:_get_persist_filename()
                if not filename then
                    base.log.info("not in master shard, skip loading persistent data")
                    return
                end

                local persist_data = interval.get_persistent_data(filename)

                utils.if_present(persist_data, function()
                    local is_changing_character = old_max_value ~= persist_data[config.save_fields[2]]

                    if not is_changing_character then
                        return
                    end

                    local userid = self.inst.userid or "unknown"
                    local prefab = self.inst.prefab or "unknown"
                    base.log.info(string.format("%s 玩家:%s(%s) %s:%d->%d",
                        config.log_prefix, userid, prefab,
                        config.component_name, old_max_value or 0, persist_data[config.save_fields[2]]))
                    _set_persist_data_on_init(self, persist_data)
                    self:_apply_stat_increase_on_load()
                end)
            end)
        end
    end)

    function ComponentClass:_get_persist_filename()
        if TheNet:GetIsServer() and TheShard and not TheShard:IsSecondary() then
            return config.file_prefix .. (self.inst.userid or "default")
        end
        return nil
    end

    function ComponentClass:_character_has_eaten()
        return self.eatnum ~= 0
    end

    function ComponentClass:ForceUpdateHUD(overtime)
        local component = self.inst.components[config.component_name]
        if config.component_name == "health" then
            component:ForceUpdateHUD(overtime)
        else
            component:DoDelta(0, overtime, true)
        end
    end

    function ComponentClass:_apply_stat_increase()
        local inst = self.inst
        local component = inst.components[config.component_name]

        if not component then
            return
        end

        self.eatnum = self.eatnum + 1

        if config.component_name == "health" then
            component:SetCurrentHealth(component.currenthealth)
            component.maxhealth = component.maxhealth + config.add_num
        else
            -- 尝试使用 SetCurrent 来触发 sanitydelta/hungerdelta 事件
            if component.SetCurrent then
                component:SetCurrent(component.current)
            else
                component.current = component.current
            end
            component.max = component.max + config.add_num
        end

        self:ForceUpdateHUD(true)

        local field_map = {
            save_currenthunger = "current",
            save_maxhunger = "max",
            save_currentsanity = "current",
            save_maxsanity = "max"
        }

        for _, field in ipairs(config.save_fields) do
            if config.component_name == "health" then
                if field == "save_currenthealth" then
                    self[field] = component.currenthealth
                elseif field == "save_maxhealth" then
                    self[field] = component.maxhealth
                end
            else
                self[field] = component[field_map[field] or field:gsub("save_", "")]
            end
        end

        if inst.components.talker then
            local max_value = config.component_name == "health" and component.maxhealth or component.max
            inst.components.talker:Say(string.format(config.say_format, max_value))
        end

        self:_sync_to_master()
    end

    function ComponentClass:_apply_stat_increase_on_load()
        local inst = self.inst
        local component = inst.components[config.component_name]

        if not component then
            return
        end

        local has_current = self[config.save_fields[1]] ~= nil
        local has_max = self[config.save_fields[2]] ~= nil

        if has_current and has_max then
            if config.component_name == "health" then
                component:SetCurrentHealth(self.save_currenthealth)
                component.maxhealth = self.save_maxhealth
            else
                -- 尝试使用 SetCurrent 来正确触发事件
                if component.SetCurrent then
                    component:SetCurrent(self[config.save_fields[1]])
                else
                    component.current = self[config.save_fields[1]]
                end
                component.max = self[config.save_fields[2]]
            end
            self:ForceUpdateHUD(true)
        end
    end

    function ComponentClass:_sync_to_master()
        if self.eatnum > 0 and self.inst.userid then
            local rpc = require("moreitems.lib.shard.sync_rpc")
            local rpc_func = rpc[config.rpc_function]

            if rpc_func then
                local args = {self.inst.userid, self.eatnum}
                for _, field in ipairs(config.save_fields) do
                    table.insert(args, self[field])
                end
                rpc_func(unpack(args))
                base.log.info("Synced data to master for " .. tostring(self.inst.userid))
            end
        end
    end

    function ComponentClass:OnSave()
        local data = {
            eatnum = self.eatnum
        }
        for _, field in ipairs(config.save_fields) do
            data[field] = self[field]
        end

        if self:_character_has_eaten() and _should_enable_for_player(self.inst.prefab) then
            local filename = self:_get_persist_filename()
            if filename then
                interval.set_persist_data(filename, data)
            end
        end

        return data
    end

    function ComponentClass:OnLoad(data)
        if data then
            local has_all_fields = true
            for _, field in ipairs(config.save_fields) do
                if not data[field] then
                    has_all_fields = false
                    break
                end
            end

            if data.eatnum and has_all_fields then
                self.eatnum = data.eatnum
                for _, field in ipairs(config.save_fields) do
                    self[field] = data[field]
                end

                if self:_character_has_eaten() then
                    self:_apply_stat_increase_on_load()
                end
            end
        end
    end

    -- 动态定义类函数，第一个参数为 self
    ComponentClass[config.increase_method] = function(self)
        self:_apply_stat_increase()
    end

    return ComponentClass
end

return IncreaseStatBase
