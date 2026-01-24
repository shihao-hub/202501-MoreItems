---
--- @author zsh in 2025/1/24
--- Mod RPC 跨服务器数据同步 - RPC 处理器注册
---

local base = require("moreitems.main").shihao.base

-- 添加 Shard RPC Handlers
-- 注意：AddShardModRPCHandler 用于跨服务器 RPC，handler 函数不接收 inst 参数

AddShardModRPCHandler("more_items", "set_lifeinjector_data", function(userid, eatnum, save_currenthealth, save_maxhealth)
    base.log.info("[Shard RPC] Received set_lifeinjector_data request for " .. tostring(userid))
    if TheWorld and TheWorld.components.mone_shard_sync then
        local result = TheWorld.components.mone_shard_sync:SetLifeinjectorData(userid, eatnum, save_currenthealth, save_maxhealth)
        return result
    end
    return false
end)

AddShardModRPCHandler("more_items", "set_hamburger_data", function(userid, eatnum, save_currenthunger, save_maxhunger)
    base.log.info("[Shard RPC] Received set_hamburger_data request for " .. tostring(userid))
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
    end
end)


