---
--- @author zsh in 2023/3/2 10:24
---

local assertion = require("moreitems.main").shihao.assertion
local stl_table = require("moreitems.main").shihao.module.stl_table
local base = require("moreitems.main").shihao.base
local utils = require("moreitems.main").shihao.utils
local dst_utils = require("moreitems.main").dst.dst_utils

local inherit_when_change_character = dst_utils.get_mod_config_data("sanity_hamburger__inherit_when_change_character")

local interval = {
    get_persistent_data = dst_utils.get_persistent_data,
    set_persist_data = dst_utils.set_persist_data
}

------------------------------------------------------------------------------------------------------------------------

local constants = require("more_items_constants")

local addnum = 1;

local function oneatnum(self, eatnum)
    local inst = self.inst; -- player

    if inst.components.sanity and eatnum ~= 0 then
        inst.components.sanity.current = self.save_currentsanity;
        inst.components.sanity.max = self.save_maxsanity + eatnum * addnum;
        self:ForceUpdateHUD(true) --force update HUD

        if inst.components.talker then
            inst.components.talker:Say("当前最大理智值为： " .. inst.components.sanity.max)
        end
    end
end

local function _is_player_included(username)
    return stl_table.contains_value(constants.SANITY_HAMBURGER__INCLUDED_PLAYERS, username)
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
    self.save_currentsanity = persist_data.save_currentsanity
    self.save_maxsanity = persist_data.save_maxsanity

    base.log.info("set save_maxsanity field success!")
end

local SH = Class(function(self, inst)
    self.inst = inst;

    self.save_currentsanity = nil;
    self.save_maxsanity = nil;

    self.eatnum = 0;

    -- 换人保存逻辑
    if inherit_when_change_character then
        self.inst:DoTaskInTime(0, function()
            if not _is_player_included(self.inst.prefab) then
                return
            end

            assertion.assert_true(_is_player_included(self.inst.prefab))

            local old_save_maxsanity = self.save_maxsanity

            local filename = self:_get_persist_filename()
            if not filename then
                base.log.info("not in master shard, skip loading persistent data")
                return
            end

            local persist_data = interval.get_persistent_data(filename)

            utils.if_present(persist_data, function()
                -- 判断是否换人
                local is_changing_character = old_save_maxsanity ~= persist_data.save_maxsanity

                if not is_changing_character then
                    return
                end

                -- 如果是换人，才执行下面的逻辑。也就是继承之前保存的数据。
                local userid = self.inst.userid or "unknown"
                local prefab = self.inst.prefab or "unknown"
                base.log.info(string.format("[强san素食堡换人继承] 玩家:%s(%s) 理智值:%d->%d",
                    userid, prefab, old_save_maxsanity or 0, persist_data.save_maxsanity))
                _set_persist_data_on_init(self, persist_data)
                self:VitIncreaseOnLoad()
            end)
        end)
    end
end)

function SH:_get_persist_filename()
    -- 只在主服务器存储，避免上下洞数据分离
    if TheNet:GetIsServer() and TheShard and not TheShard:IsSecondary() then
        return "sanity_hamburger_" .. (self.inst.userid or "default")
    end
    return nil  -- 洞穴不使用文件存储
end

function SH:_character_has_eaten()
    return self.eatnum ~= 0
end

function SH:ForceUpdateHUD(overtime)
    self.inst.components.sanity:DoDelta(0, overtime, true);
end

function SH:VitIncrease()
    local inst = self.inst;
    self.eatnum = self.eatnum + 1;
    if inst.components.sanity then
        inst.components.sanity.current = inst.components.sanity.current;
        inst.components.sanity.max = inst.components.sanity.max + addnum;
        self:ForceUpdateHUD(true);

        -- 保存当前状态
        self.save_currentsanity = inst.components.sanity.current;
        self.save_maxsanity = inst.components.sanity.max;

        if inst.components.talker then
            inst.components.talker:Say("当前最大理智值为： " .. inst.components.sanity.max)
        end

        -- 同步到主服务器（通过 RPC）
        self:SyncToMaster()
    end
end

function SH:VitIncreaseOnLoad()
    local inst = self.inst;
    if inst.components.sanity and self.save_currentsanity and self.save_maxsanity then
        inst.components.sanity.current = self.save_currentsanity;
        inst.components.sanity.max = self.save_maxsanity;
        self:ForceUpdateHUD(true);
    end
end

--- 同步数据到主服务器
function SH:SyncToMaster()
    if self.eatnum > 0 and self.inst.userid then
        local rpc = require("moreitems.lib.shard.sync_rpc")
        rpc.SetSanityHamburgerData(
            self.inst.userid,
            self.eatnum,
            self.save_currentsanity,
            self.save_maxsanity
        )
        base.log.info("Synced sanity hamburger data to master for " .. tostring(self.inst.userid))
    end
end

function SH:OnSave()
    local data = {
        eatnum = self.eatnum,
        save_currentsanity = self.save_currentsanity,
        save_maxsanity = self.save_maxsanity,
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

function SH:OnLoad(data)
    if data then
        if data.eatnum and data.save_currentsanity and data.save_maxsanity then
            self.eatnum = data.eatnum;
            self.save_currentsanity = data.save_currentsanity;
            self.save_maxsanity = data.save_maxsanity;

            -- 没吃过就不会失效。
            if self:_character_has_eaten() then
                self:VitIncreaseOnLoad()
            end
        end
    end
end

return SH;
