---
--- @author zsh in 2023/1/20 14:27
---

local assertion = require("moreitems.main").shihao.assertion
local stl_table = require("moreitems.main").shihao.module.stl_table
local base = require("moreitems.main").shihao.base
local utils = require("moreitems.main").shihao.utils
local dst_utils = require("moreitems.main").dst.dst_utils

local inherit_when_change_character = dst_utils.get_mod_config_data("lifeinjector_vb__inherit_when_change_character")

local interval = {
    get_persistent_data = dst_utils.get_persistent_data,
    set_persist_data = dst_utils.set_persist_data
}

------------------------------------------------------------------------------------------------------------------------

local constants = require("more_items_constants")

local addnum = constants.LIFE_INJECTOR_VB__PER_ADD_NUM

local function _is_player_included(username)
    return stl_table.contains_value(constants.LIFE_INJECTOR_VB__INCLUDED_PLAYERS, username)
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

    -- 检查是否吃过强心素食堡，没有吃过则不继承
    if not persist_data.eatnum or persist_data.eatnum <= 0 then
        base.log.info("character hasn't eaten lifeinjector_vb, skip inheritance")
        return
    end

    self.eatnum = persist_data.eatnum
    self.save_currenthealth = persist_data.save_currenthealth
    self.save_maxhealth = persist_data.save_maxhealth

    base.log.info("set save_maxhealth field success!")
end

local VB = Class(function(self, inst)
    self.inst = inst;

    self.save_currenthealth = nil;
    self.save_maxhealth = nil;

    self.eatnum = 0;

    -- 换人保存逻辑
    if inherit_when_change_character then
        self.inst:DoTaskInTime(0, function()
            if not _is_player_included(self.inst.prefab) then
                return
            end

            assertion.assert_true(_is_player_included(self.inst.prefab))

            local old_save_maxhealth = self.save_maxhealth

            local filename = self:_get_persist_filename()
            if not filename then
                base.log.info("not in master shard, skip loading persistent data")
                return
            end

            local persist_data = interval.get_persistent_data(filename)

            utils.if_present(persist_data, function()
                -- 判断是否换人
                local is_changing_character = old_save_maxhealth ~= persist_data.save_maxhealth

                if not is_changing_character then
                    return
                end

                -- 如果是换人，才执行下面的逻辑。也就是继承之前保存的数据。
                local userid = self.inst.userid or "unknown"
                local prefab = self.inst.prefab or "unknown"
                base.log.info(string.format("[强心素食堡换人继承] 玩家:%s(%s) 血量:%d->%d",
                    userid, prefab, old_save_maxhealth or 0, persist_data.save_maxhealth))
                _set_persist_data_on_init(self, persist_data)
                self:HPIncreaseOnLoad()
            end)
        end)
    end
end)

function VB:_get_persist_filename()
    -- 只在主服务器存储，避免上下洞数据分离
    if TheNet:GetIsServer() and TheShard and not TheShard:IsSecondary() then
        return "lifeinjector_vb_" .. (self.inst.userid or "default")
    end
    return nil  -- 洞穴不使用文件存储
end

function VB:_character_has_eaten()
    return self.eatnum ~= 0
end

function VB:HPIncrease()
    local inst = self.inst;
    self.eatnum = self.eatnum + 1;
    if inst.components.health then
        inst.components.health:SetCurrentHealth(inst.components.health.currenthealth);
        inst.components.health.maxhealth = inst.components.health.maxhealth + addnum;
        inst.components.health:ForceUpdateHUD(true) --force update HUD

        -- 保存当前状态
        self.save_currenthealth = inst.components.health.currenthealth;
        self.save_maxhealth = inst.components.health.maxhealth;

        if inst.components.talker then
            inst.components.talker:Say("当前最大生命值为： " .. inst.components.health.maxhealth)
        end

        -- 同步到主服务器（通过 RPC）
        self:SyncToMaster()
    end
end

function VB:HPIncreaseOnLoad()
    local inst = self.inst;
    if inst.components.health and self.save_currenthealth and self.save_maxhealth then
        inst.components.health:SetCurrentHealth(self.save_currenthealth);
        inst.components.health.maxhealth = self.save_maxhealth;
        inst.components.health:ForceUpdateHUD(true)
    end
end

--- 同步数据到主服务器
function VB:SyncToMaster()
    if self.eatnum > 0 and self.inst.userid then
        local rpc = require("moreitems.lib.shard.sync_rpc")
        rpc.SetLifeinjectorData(
            self.inst.userid,
            self.eatnum,
            self.save_currenthealth,
            self.save_maxhealth
        )
        base.log.info("Synced lifeinjector data to master for " .. tostring(self.inst.userid))
    end
end

function VB:OnSave()
    local data = {
        eatnum = self.eatnum,
        save_currenthealth = self.save_currenthealth,
        save_maxhealth = self.save_maxhealth,
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

function VB:OnLoad(data)
    if data then
        if data.eatnum and data.save_currenthealth and data.save_maxhealth then
            self.eatnum = data.eatnum;
            self.save_currenthealth = data.save_currenthealth;
            self.save_maxhealth = data.save_maxhealth;

            -- 没吃过就不会失效。
            if self:_character_has_eaten() then
                self:HPIncreaseOnLoad()
            end
        end
    end
end

return VB;
