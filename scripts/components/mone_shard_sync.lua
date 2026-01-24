---
--- @author zsh in 2025/1/24
--- Mod RPC 跨服务器数据同步 - 世界组件
---

local base = require("moreitems.main").shihao.base
local dst_utils = require("moreitems.main").dst.dst_utils

local interval = {
    get_persistent_data = dst_utils.get_persistent_data,
    set_persist_data = dst_utils.set_persist_data
}

-- 数据存储（主服务器专用）
local SHARD_DATA = {
    lifeinjector = {},  -- [userid] = {eatnum, save_currenthealth, save_maxhealth}
    hamburger = {},    -- [userid] = {eatnum, save_currenthunger, save_maxhunger}
}

local SHARD_SYNC = Class(function(self, inst)
    self.inst = inst
end)

--- 获取强心素食堡数据
function SHARD_SYNC:GetLifeinjectorData(userid)
    local data = SHARD_DATA.lifeinjector[userid]
    if data then
        base.log.info("RPC: get_lifeinjector_data for " .. tostring(userid) .. " = " .. tostring(data.eatnum))
    else
        base.log.info("RPC: get_lifeinjector_data for " .. tostring(userid) .. " = nil")
    end
    return data
end

--- 设置强心素食堡数据
function SHARD_SYNC:SetLifeinjectorData(userid, eatnum, save_currenthealth, save_maxhealth)
    -- 只在主服务器存储
    if TheShard and TheShard:IsSecondary() then
        base.log.info("RPC: secondary shard rejected data storage")
        return false
    end

    local data = {
        eatnum = eatnum or 0,
        save_currenthealth = save_currenthealth,
        save_maxhealth = save_maxhealth
    }

    -- 更新内存数据
    SHARD_DATA.lifeinjector[userid] = data

    base.log.info("RPC: set_lifeinjector_data for " .. tostring(userid) .. " eatnum=" .. tostring(eatnum))

    -- 立即持久化到玩家的 PersistentString 文件
    -- 注意：这里使用玩家组件的文件名格式，确保玩家组件读取时是最新数据
    interval.set_persist_data("lifeinjector_vb_" .. (userid or "default"), data)
    base.log.info("Saved lifeinjector data to player's persistent file: lifeinjector_vb_" .. tostring(userid))

    -- 同时保存到世界组件的文件（用于世界重启时恢复内存数据）
    self:SaveLifeinjectorData()

    return true
end

--- 获取暖胃汉堡包数据
function SHARD_SYNC:GetHamburgerData(userid)
    local data = SHARD_DATA.hamburger[userid]
    if data then
        base.log.info("RPC: get_hamburger_data for " .. tostring(userid) .. " = " .. tostring(data.eatnum))
    else
        base.log.info("RPC: get_hamburger_data for " .. tostring(userid) .. " = nil")
    end
    return data
end

--- 设置暖胃汉堡包数据
function SHARD_SYNC:SetHamburgerData(userid, eatnum, save_currenthunger, save_maxhunger)
    -- 只在主服务器存储
    if TheShard and TheShard:IsSecondary() then
        base.log.info("RPC: secondary shard rejected data storage")
        return false
    end

    local data = {
        eatnum = eatnum or 0,
        save_currenthunger = save_currenthunger,
        save_maxhunger = save_maxhunger
    }

    -- 更新内存数据
    SHARD_DATA.hamburger[userid] = data

    base.log.info("RPC: set_hamburger_data for " .. tostring(userid) .. " eatnum=" .. tostring(eatnum))

    -- 立即持久化到玩家的 PersistentString 文件
    interval.set_persist_data("stomach_warming_hamburger_" .. (userid or "default"), data)
    base.log.info("Saved hamburger data to player's persistent file: stomach_warming_hamburger_" .. tostring(userid))

    -- 同时保存到世界组件的文件（用于世界重启时恢复内存数据）
    self:SaveHamburgerData()

    return true
end

--- 持久化强心素食堡数据到文件
function SHARD_SYNC:SaveLifeinjectorData()
    if TheShard and TheShard:IsSecondary() then
        return
    end

    interval.set_persist_data("mone_shard_sync_lifeinjector", SHARD_DATA.lifeinjector)
    base.log.info("Saved lifeinjector data to persistent storage")
end

--- 持久化暖胃汉堡包数据到文件
function SHARD_SYNC:SaveHamburgerData()
    if TheShard and TheShard:IsSecondary() then
        return
    end

    interval.set_persist_data("mone_shard_sync_hamburger", SHARD_DATA.hamburger)
    base.log.info("Saved hamburger data to persistent storage")
end

--- 从文件加载强心素食堡数据
function SHARD_SYNC:LoadLifeinjectorData()
    if TheShard and TheShard:IsSecondary() then
        return
    end

    local data = interval.get_persistent_data("mone_shard_sync_lifeinjector")
    if data then
        SHARD_DATA.lifeinjector = data
        base.log.info("Loaded lifeinjector data from persistent storage")
    end
end

--- 从文件加载暖胃汉堡包数据
function SHARD_SYNC:LoadHamburgerData()
    if TheShard and TheShard:IsSecondary() then
        return
    end

    local data = interval.get_persistent_data("mone_shard_sync_hamburger")
    if data then
        SHARD_DATA.hamburger = data
        base.log.info("Loaded hamburger data from persistent storage")
    end
end

--- 组件 OnSave：无需额外操作，数据已经在 Set 时持久化
function SHARD_SYNC:OnSave()
    -- 数据已在 Set 方法中实时持久化
    return SHARD_DATA
end

--- 组件 OnLoad：从文件加载数据
function SHARD_SYNC:OnLoad(data)
    if data then
        if data.lifeinjector then
            SHARD_DATA.lifeinjector = data.lifeinjector
        end
        if data.hamburger then
            SHARD_DATA.hamburger = data.hamburger
        end
        base.log.info("Loaded shard sync data from world save")
    else
        -- 如果没有保存的数据，从文件加载
        self:LoadLifeinjectorData()
        self:LoadHamburgerData()
    end
end

--- 组件初始化时加载持久化数据
function SHARD_SYNC:OnLoadPostPass()
    self:LoadLifeinjectorData()
    self:LoadHamburgerData()
end

return SHARD_SYNC
