---
--- @author zsh in 2025/1/24
--- Mod RPC 跨服务器数据同步 - RPC 处理器注册
---

local base = require("moreitems.main").shihao.base

-- 添加 Shard RPC Handlers
-- 注意：SendModRPCToShard 会将 shardid 作为第一个参数传递给 handler
-- 所以 handler 的参数签名是：function(shardid, userid, eatnum, ...) 而不是 function(userid, eatnum, ...)

AddShardModRPCHandler("more_items", "set_lifeinjector_data", function(shardid, userid, eatnum, save_currenthealth, save_maxhealth)
    print("[Shard RPC Handler] Received set_lifeinjector_data - shardid: " .. tostring(shardid) .. ", userid: " .. tostring(userid) .. ", eatnum: " .. tostring(eatnum))
    base.log.info("[Shard RPC Handler] Received set_lifeinjector_data - userid=" .. tostring(userid) .. ", eatnum=" .. tostring(eatnum))
    if TheWorld then
        print("[Shard RPC Handler] TheWorld exists")
        if TheWorld.components.mone_shard_sync then
            print("[Shard RPC Handler] Component exists, calling SetLifeinjectorData")
            local result = TheWorld.components.mone_shard_sync:SetLifeinjectorData(userid, eatnum, save_currenthealth, save_maxhealth)
            print("[Shard RPC Handler] Result: " .. tostring(result))
            return result
        else
            print("[Shard RPC Handler] ERROR: mone_shard_sync component not found!")
        end
    else
        print("[Shard RPC Handler] ERROR: TheWorld is nil!")
    end
    return false
end)

AddShardModRPCHandler("more_items", "set_hamburger_data", function(shardid, userid, eatnum, save_currenthunger, save_maxhunger)
    print("[Shard RPC Handler] Received set_hamburger_data - shardid: " .. tostring(shardid) .. ", userid: " .. tostring(userid) .. ", eatnum: " .. tostring(eatnum))
    base.log.info("[Shard RPC Handler] Received set_hamburger_data - userid=" .. tostring(userid) .. ", eatnum=" .. tostring(eatnum))
    if TheWorld and TheWorld.components.mone_shard_sync then
        local result = TheWorld.components.mone_shard_sync:SetHamburgerData(userid, eatnum, save_currenthunger, save_maxhunger)
        return result
    end
    return false
end)

base.log.info("Mod RPC shard sync handlers loaded")

-- 将组件添加到世界
AddPrefabPostInit("world", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    if not inst.components.mone_shard_sync then
        inst:AddComponent("mone_shard_sync")
        base.log.info("Added mone_shard_sync component to world")
        print("[Shard Sync] Added mone_shard_sync component to world")
    end
end)


