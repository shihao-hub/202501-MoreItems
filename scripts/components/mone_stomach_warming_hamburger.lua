---
--- @author zsh in 2023/3/2 10:24
---

local assertion = require("moreitems.main").shihao.assertion
local stl_table = require("moreitems.main").shihao.module.stl_table
local base = require("moreitems.main").shihao.base
local utils = require("moreitems.main").shihao.utils
local dst_utils = require("moreitems.main").dst.dst_utils

local inherit_when_change_character = dst_utils.get_mod_config_data("stomach_warming_hamburger__inherit_when_change_character")

local interval = {
    get_persistent_data = dst_utils.get_persistent_data,
    set_persist_data = dst_utils.set_persist_data
}

------------------------------------------------------------------------------------------------------------------------

local constants = require("more_items_constants")

local addnum = 1;

local function oneatnum(self, eatnum)
    local inst = self.inst; -- player

    if inst.components.hunger and eatnum ~= 0 then
        inst.components.hunger.current = self.save_currenthunger;
        inst.components.hunger.max = self.save_maxhunger + eatnum * addnum;
        self:ForceUpdateHUD(true) --force update HUD

        if inst.components.talker then
            inst.components.talker:Say("当前最大饥饿度为： " .. inst.components.hunger.max)
        end
    end
end

local function _is_player_included(username)
    return stl_table.contains_value(constants.STOMACH_WARMING_HAMBURGER__INCLUDED_PLAYERS, username)
end

local function _set_persist_data_on_init(component, persist_data)
    base.log.info("call _set_persist_data_on_init")

    local self = component

    local user = self.inst
    if not _is_player_included(user.prefab) then
        return
    end

    persist_data = base.if_then_else(persist_data, function() return persist_data end, function() interval.get_persistent_data(self:_get_persist_filename()) end)
    if not persist_data then
        return
    end

    -- 检查是否吃过汉堡，没有吃过则不继承
    if not persist_data.eatnum or persist_data.eatnum <= 0 then
        base.log.info("character hasn't eaten hamburger, skip inheritance")
        return
    end

    self.eatnum = persist_data.eatnum
    self.save_currenthunger = persist_data.save_currenthunger
    self.save_maxhunger = persist_data.save_maxhunger

    base.log.info("set save_maxhunger field success!")
end

local SWH = Class(function(self, inst)
    self.inst = inst;

    self.save_currenthunger = nil;
    self.save_maxhunger = nil;

    self.eatnum = 0;

    -- 换人保存逻辑
    if inherit_when_change_character then
        self.inst:DoTaskInTime(0, function()
            if not _is_player_included(self.inst.prefab) then
                return
            end

            assertion.assert_true(_is_player_included(self.inst.prefab))

            local old_save_maxhunger = self.save_maxhunger

            local filename = self:_get_persist_filename()
            if not filename then
                base.log.info("not in master shard, skip loading persistent data")
                return
            end

            local persist_data = interval.get_persistent_data(filename)

            utils.if_present(persist_data, function()
                -- 判断是否换人
                local is_changing_character = old_save_maxhunger ~= persist_data.save_maxhunger

                if not is_changing_character then
                    base.log.info("not is_changing_character")
                    return
                end

                -- 如果是换人，才执行下面的逻辑。也就是继承之前保存的数据。
                _set_persist_data_on_init(self, persist_data)

                base.log.info("is_changing_character", old_save_maxhunger, persist_data.save_maxhunger)
                self:VitIncreaseOnLoad()
            end)
        end)
    end
end)

function SWH:_get_persist_filename()
    base.log.info("call _get_persist_filename")
    -- 只在主服务器存储，避免上下洞数据分离
    if TheNet:GetIsServer() and TheShard and not TheShard:IsSecondary() then
        return "stomach_warming_hamburger_" .. (self.inst.userid or "default")
    end
    return nil  -- 洞穴不使用文件存储
end

function SWH:_character_has_eaten()
    return self.eatnum ~= 0
end

function SWH:ForceUpdateHUD(overtime)
    self.inst.components.hunger:DoDelta(0, overtime, true);
end

function SWH:VitIncrease()
    local inst = self.inst;
    self.eatnum = self.eatnum + 1;
    if inst.components.hunger then
        inst.components.hunger.current = inst.components.hunger.current;
        inst.components.hunger.max = inst.components.hunger.max + addnum;
        self:ForceUpdateHUD(true);

        -- 保存当前状态
        self.save_currenthunger = inst.components.hunger.current;
        self.save_maxhunger = inst.components.hunger.max;

        if inst.components.talker then
            inst.components.talker:Say("当前最大饥饿度为： " .. inst.components.hunger.max)
        end

        -- 同步到主服务器（通过 RPC）
        self:SyncToMaster()
    end
end

function SWH:VitIncreaseOnLoad()
    local inst = self.inst;
    if inst.components.hunger and self.save_currenthunger and self.save_maxhunger then
        inst.components.hunger.current = self.save_currenthunger;
        inst.components.hunger.max = self.save_maxhunger;
        self:ForceUpdateHUD(true);
    end
end

--- 同步数据到主服务器
function SWH:SyncToMaster()
    if self.eatnum > 0 and self.inst.userid then
        local rpc = require("moreitems.lib.shard.sync_rpc")
        rpc.SetHamburgerData(
            self.inst.userid,
            self.eatnum,
            self.save_currenthunger,
            self.save_maxhunger
        )
        base.log.info("Synced hamburger data to master for " .. tostring(self.inst.userid))
    end
end

function SWH:OnSave()
    local data = {
        eatnum = self.eatnum,
        save_currenthunger = self.save_currenthunger,
        save_maxhunger = self.save_maxhunger,
    }
    -- 只在主服务器持久化到文件
    if self:_character_has_eaten() and _is_player_included(self.inst.prefab) then
        local filename = self:_get_persist_filename()
        if filename then
            interval.set_persist_data(filename, data)
        end
    end
    return data
end

function SWH:OnLoad(data)
    if data then
        if data.eatnum and data.save_currenthunger and data.save_maxhunger then
            self.eatnum = data.eatnum;
            self.save_currenthunger = data.save_currenthunger;
            self.save_maxhunger = data.save_maxhunger;

            -- 在主服务器上，优先从世界组件获取最新的跨服数据
            if TheWorld and TheWorld.components.mone_shard_sync and not (TheShard and TheShard:IsSecondary()) then
                local shard_data = TheWorld.components.mone_shard_sync:GetHamburgerData(self.inst.userid)
                if shard_data and shard_data.eatnum then
                    -- 使用世界组件的数据（可能包含洞穴中吃的食物）
                    self.eatnum = shard_data.eatnum
                    self.save_currenthunger = shard_data.save_currenthunger
                    self.save_maxhunger = shard_data.save_maxhunger
                    base.log.info("Loaded hamburger data from world sync component for " .. tostring(self.inst.userid))
                end
            end

            -- 没吃过就不会失效。
            if self:_character_has_eaten() then
                self:VitIncreaseOnLoad()
            end
        end
    end
end

return SWH;
