---
--- @author zsh in 2025/1/24
--- Mod RPC 跨服务器数据同步 - 世界组件
---

local base = require("moreitems.main").shihao.base

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

    SHARD_DATA.lifeinjector[userid] = {
        eatnum = eatnum or 0,
        save_currenthealth = save_currenthealth,
        save_maxhealth = save_maxhealth
    }

    base.log.info("RPC: set_lifeinjector_data for " .. tostring(userid) .. " eatnum=" .. tostring(eatnum))
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

    SHARD_DATA.hamburger[userid] = {
        eatnum = eatnum or 0,
        save_currenthunger = save_currenthunger,
        save_maxhunger = save_maxhunger
    }

    base.log.info("RPC: set_hamburger_data for " .. tostring(userid) .. " eatnum=" .. tostring(eatnum))
    return true
end

-- 添加 RPC Handlers
-- 注意：只有 Set 操作需要跨服务器 RPC
-- Get 操作直接从本地内存读取（主服务器）或使用玩家序列化数据（洞穴服务器）

AddModRPCHandler("more_items", "set_lifeinjector_data", function(inst, userid, eatnum, save_currenthealth, save_maxhealth)
    base.log.info("RPC: Received set_lifeinjector_data request for " .. tostring(userid))
    if inst.components.mone_shard_sync then
        local result = inst.components.mone_shard_sync:SetLifeinjectorData(userid, eatnum, save_currenthealth, save_maxhealth)
        return result
    end
    return false
end)

AddModRPCHandler("more_items", "set_hamburger_data", function(inst, userid, eatnum, save_currenthunger, save_maxhunger)
    base.log.info("RPC: Received set_hamburger_data request for " .. tostring(userid))
    if inst.components.mone_shard_sync then
        local result = inst.components.mone_shard_sync:SetHamburgerData(userid, eatnum, save_currenthunger, save_maxhunger)
        return result
    end
    return false
end)

base.log.info("Mod RPC shard sync handlers loaded")

return SHARD_SYNC

-- 将组件添加到世界
AddPrefabPostInit("world", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    if not inst.components.mone_shard_sync then
        inst:AddComponent("mone_shard_sync")
        base.log.info("Added mone_shard_sync component to world")
    end
end)
