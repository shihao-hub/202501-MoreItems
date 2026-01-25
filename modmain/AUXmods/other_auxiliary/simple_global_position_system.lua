---
--- @author zsh in 2023/5/13 2:27
---

-- 简易全球定位系统(GPS)：只在地图上面显示玩家图标和共享地图。

-- 检测独立模组是否已启用
local mi_deprecated_feature = require("mi_modules.mi_deprecated_feature")

-- 如果独立模组已启用，跳过此文件的所有逻辑
if mi_deprecated_feature.check_and_announce("简易全球定位", "3590648641", "简易全球定位", env) then
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