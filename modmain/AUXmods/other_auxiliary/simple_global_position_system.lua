---
--- @author zsh in 2023/5/13 2:27
---

-- 简易全球定位系统(GPS)：只在地图上面显示玩家图标和共享地图。

-- 检测独立模组是否已启用
local EnabledMods = getEnabledMods()
local function IsModEnabled(name)
    for k, v in pairs(EnabledMods) do
        if v and (k:match(name) or v:match(name)) then
            return true
        end
    end
    return false
end

-- 如果独立模组已启用，跳过此文件的所有逻辑
if IsModEnabled("3590648641") or IsModEnabled("简易全球定位") then
    print("[更多物品] 检测到【简易全球定位】独立模组已启用，自动关闭本模组的简易全球定位功能")
    return
end


local function compass(inst)
    inst:AddTag("compassbearer");

    if not TheWorld.ismastersim then
        return inst;
    end

    if inst.components.maprevealable then
        inst.components.maprevealable:AddRevealSource(inst, "compassbearer");
    end
end

local function sentryward(inst)
    inst:AddTag("maprevealer");

    if not TheWorld.ismastersim then
        return inst;
    end

    inst:AddComponent("maprevealer");
end

env.AddPlayerPostInit(function(inst)
    compass(inst);
    sentryward(inst);
end)

-- 关于地图共享，灵魂状态不应该可以共享地图吧？


-- 处理一下指南针
local function compass_optimization()
    env.AddPrefabPostInit("compass",function(inst)
        if not TheWorld.ismastersim then
            return inst;
        end

        local equippable = inst.components.equippable;

        if equippable then
            local old_onunequipfn = equippable.onunequipfn;
            equippable.onunequipfn=function(inst, owner,...)
                old_onunequipfn(inst, owner,...);

                if owner.components.maprevealable ~= nil then
                    owner.components.maprevealable:AddRevealSource(inst, "compassbearer")
                end
                owner:AddTag("compassbearer")
            end
        end
    end)
end
compass_optimization();

-- 定时通告：提示用户简易全球定位已过时
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
                TheNet:Announce("[简易全球定位] 此功能已过时，请订阅作者的【简易全球定位】独立模组（ID: 3590648641）以获得更好的体验")

                if announcement_count < max_announcements then
                    inst:DoTaskInTime(interval, send_announcement)
                end
            end

            inst:DoTaskInTime(interval, send_announcement)
        end
    end)
end)

