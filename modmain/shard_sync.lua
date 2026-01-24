---
--- @author zsh in 2025/1/24
--- Mod RPC 跨服务器数据同步 - RPC 处理器注册
---

local base = require("moreitems.main").shihao.base

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


