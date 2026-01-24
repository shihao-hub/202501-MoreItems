---
--- @author zsh in 2025/1/24
--- Mod RPC 调用辅助函数
---
--- 核心机制：
--- 1. 玩家跨服时，OnSave/OnLoad 自动传输玩家数据（已有的 DST 机制）
--- 2. 洞穴中吃食物时，通过 RPC 同步数据到主服务器
--- 3. 主服务器持久化存储数据到 PersistentString
---

local MOD_RPC = "more_items"
local base = require("moreitems.main").shihao.base

local RPC = {}

-- 发送 RPC 到主服务器
local function send_to_master(rpc_name, ...)
    if TheShard and TheShard:IsSecondary() then
        -- 在洞穴服务器，通过 Shard RPC 发送到主服务器
        local shard_id = TheShard:GetShardId()
        if shard_id then
            base.log.info("[Shard RPC] Sending to master: " .. rpc_name)
            SendModRPCToShard(shard_id, MOD_RPC, rpc_name, TheWorld, ...)
        end
    end
end

--- 设置强心素食堡数据到主服务器
function RPC.SetLifeinjectorData(userid, eatnum, save_currenthealth, save_maxhealth)
    if TheWorld.ismastersim then
        if TheShard and not TheShard:IsSecondary() then
            -- 主服务器直接设置
            if TheWorld.components.mone_shard_sync then
                TheWorld.components.mone_shard_sync:SetLifeinjectorData(userid, eatnum, save_currenthealth, save_maxhealth)
            end
        else
            -- 洞穴服务器通过 RPC 发送（单向，不需要返回值）
            base.log.info("[Shard RPC] Sending lifeinjector data to master for " .. tostring(userid))
            send_to_master("set_lifeinjector_data", TheWorld, userid, eatnum, save_currenthealth, save_maxhealth)
        end
    end
end

--- 设置暖胃汉堡包数据到主服务器
function RPC.SetHamburgerData(userid, eatnum, save_currenthunger, save_maxhunger)
    if TheWorld.ismastersim then
        if TheShard and not TheShard:IsSecondary() then
            -- 主服务器直接设置
            if TheWorld.components.mone_shard_sync then
                TheWorld.components.mone_shard_sync:SetHamburgerData(userid, eatnum, save_currenthunger, save_maxhunger)
            end
        else
            -- 洞穴服务器通过 RPC 发送（单向，不需要返回值）
            base.log.info("[Shard RPC] Sending hamburger data to master for " .. tostring(userid))
            send_to_master("set_hamburger_data", TheWorld, userid, eatnum, save_currenthunger, save_maxhunger)
        end
    end
end

--- 从主服务器获取强心素食堡数据（仅用于主服务器本地读取）
function RPC.GetLifeinjectorData(userid)
    if TheWorld.ismastersim and TheShard and not TheShard:IsSecondary() then
        if TheWorld.components.mone_shard_sync then
            return TheWorld.components.mone_shard_sync:GetLifeinjectorData(userid)
        end
    end
    return nil
end

--- 从主服务器获取暖胃汉堡包数据（仅用于主服务器本地读取）
function RPC.GetHamburgerData(userid)
    if TheWorld.ismastersim and TheShard and not TheShard:IsSecondary() then
        if TheWorld.components.mone_shard_sync then
            return TheWorld.components.mone_shard_sync:GetHamburgerData(userid)
        end
    end
    return nil
end

return RPC
