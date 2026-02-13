---
--- @author zsh in 2025-01-26
--- 弃用功能通用处理模块
---

local mi_deprecated_feature = {}

-- 获取已启用的模组列表
local function getEnabledMods()
    local EnabledMods = {}
    for _, dir in pairs(KnownModIndex:GetModsToLoad(true)) do
        local info = KnownModIndex:GetModInfo(dir)
        local name = info and info.name or "unknown"
        EnabledMods[dir] = name
    end
    return EnabledMods
end

local EnabledMods = getEnabledMods()

-- 检测模组是否已启用
function mi_deprecated_feature.IsModEnabled(name)
    for k, v in pairs(EnabledMods) do
        if v and (k:match(name) or v:match(name)) then
            return true
        end
    end
    return false
end

---
--- 检测独立模组并处理弃用功能
--- @param feature_name string - 功能名称（中文）
--- @param standalone_mod_id string - 独立模组的ID
--- @param standalone_mod_name string - 独立模组的名称（中文）
--- @param env table - 环境变量（通常传入 env）
--- @return boolean - 如果独立模组已启用返回 true（应该跳过当前功能），否则返回 false
---
function mi_deprecated_feature.check_and_announce(feature_name, standalone_mod_id, standalone_mod_name, env)
    -- 检测独立模组是否已启用
    if mi_deprecated_feature.IsModEnabled(standalone_mod_id) or mi_deprecated_feature.IsModEnabled(standalone_mod_name) then
        print("[更多物品] 检测到【" .. standalone_mod_name .. "】模组已启用，自动关闭本模组的" .. feature_name .. "功能")
        return true
    end

    -- 添加定时通告
    env.AddPlayerPostInit(function(inst)
        if not inst.components.health then
            return
        end

        inst:DoTaskInTime(0, function()
            if TheWorld and TheWorld.ismastersim then
                local announcement_count = 0
                local max_announcements = 3
                local interval = 8 * 60 -- 8分钟

                local function send_announcement()
                    announcement_count = announcement_count + 1
                    TheNet:Announce("[" .. feature_name .. "] 此功能已过时，请订阅作者的【" .. standalone_mod_name .. "】模组（ID: " .. standalone_mod_id .. "）以获得更好的体验")

                    if announcement_count < max_announcements then
                        inst:DoTaskInTime(interval, send_announcement)
                    end
                end

                inst:DoTaskInTime(interval, send_announcement)
            end
        end)
    end)

    return false
end

return mi_deprecated_feature
