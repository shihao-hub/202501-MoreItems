---
--- @author zsh in 2025/02/12
--- 施肥瓦器人 AI 大脑
---

require "behaviours/standstill"

local constants = require("more_items_constants")

local MoneFertilizerBotBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

--------------------------------------------------------------------------------

--- 寻找需要施肥的目标
local function FindFertilizationAction(inst)
    -- 检查是否有肥料
    local has_fertilizer = inst.components.container:FindItem(function(item)
        return item:HasTag("mone_fertilizer_bot_fertilizer")
    end)

    if not has_fertilizer then
        return nil
    end

    -- 扫描目标
    local targets = inst:ScanForFertilizationTargets()

    if #targets == 0 then
        return nil
    end

    -- 获取最近的目标
    local target = targets[1]

    return BufferedAction(inst, target, ACTIONS.WALKTO, nil, nil, nil, nil, nil, 1)
end

--- 对目标施肥
local function FertilizeAction(inst)
    -- 检查是否有肥料
    local has_fertilizer = inst.components.container:FindItem(function(item)
        return item:HasTag("mone_fertilizer_bot_fertilizer")
    end)

    if not has_fertilizer then
        return nil
    end

    -- 扫描目标
    local targets = inst:ScanForFertilizationTargets()

    if #targets == 0 then
        return nil
    end

    -- 获取最近的目标
    local target = targets[1]

    -- 走到目标附近
    local target_pos = target:GetPosition()
    local dist_sq = inst:GetDistanceSqToPoint(target_pos)
    
    if dist_sq > 4 then
        return BufferedAction(inst, target, ACTIONS.WALKTO, nil, nil, nil, nil, nil, 1)
    end

    -- 距离足够近，直接施肥
    inst:FertilizeTarget(target)
    
    return nil -- 返回nil让行为树继续下一个循环
end

--- 回到出生点
local function GoHomeAction(inst)
    if inst.components.knownlocations == nil then
        return nil
    end

    local spawnpoint = inst.components.knownlocations:GetLocation("spawnpoint")
    if spawnpoint == nil then
        return nil
    end

    -- 放下持有的物品
    local item = inst.components.inventory:GetFirstItemInAnySlot()
    if item then
        inst.components.inventory:DropItem(item, true, true)
    end

    -- 如果已经很近，不移动
    local dist_sq = inst:GetDistanceSqToPoint(spawnpoint.x, spawnpoint.y or 0, spawnpoint.z)
    if dist_sq < 0.25 then
        return nil
    end

    return BufferedAction(inst, nil, ACTIONS.WALKTO, nil, spawnpoint, nil, 0.2)
end

--------------------------------------------------------------------------------

function MoneFertilizerBotBrain:OnStart()
    local root = PriorityNode(
    {
        WhileNode(function() return not self.inst.sg:HasAnyStateTag("busy") end, "NO BRAIN WHEN BUSY",
            PriorityNode({
                DoAction(self.inst, FertilizeAction, "Fertilize Target", true),
                DoAction(self.inst, FindFertilizationAction, "Find Target", true),
                DoAction(self.inst, GoHomeAction, "Return Home", true),
                ParallelNode{
                    StandStill(self.inst),
                },
            }, .25)
        ),
    }, .25)

    self.bt = BT(self.inst, root)
end

return MoneFertilizerBotBrain
