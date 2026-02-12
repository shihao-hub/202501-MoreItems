---
--- @author zsh in 2025/02/12
--- 施肥瓦器人 AI 大脑
---

require "behaviours/standstill"

local constants = require("more_items_constants")

local MoneFertilizerBotBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function ShouldIgnoreItem(item)
    return false
end

local function IgnoreItem(inst, item)
    -- 可以在这里添加忽略逻辑
end

local function UnignoreItem(inst)
    -- 取消忽略
end

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

    inst.brain:UnignoreItem()

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
    if inst:GetDistanceSqTo(target) > 4 then
        return BufferedAction(inst, target, ACTIONS.WALKTO, nil, nil, nil, nil, nil, 1)
    end

    -- 施肥
    inst.brain:UnignoreItem()

    -- 检查目标是否可施肥
    if not target.components.fertilizable then
        return nil
    end

    -- 创建施肥动作
    local action = BufferedAction(inst, target, ACTIONS.DEPLOY) -- 使用DEPLOY动作作为施肥动作
    action:AddSuccessAction(function()
        inst:FertilizeTarget(target)
    end)

    return action
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

    inst.brain:UnignoreItem()

    -- 放下持有的物品
    local item = inst.components.inventory:GetFirstItemInAnySlot()
    if item then
        inst.components.inventory:DropItem(item, true, true)
    end

    -- 如果已经很近，不移动
    if inst:GetDistanceSqToPoint(spawnpoint.x, 0, spawnpoint.z) < 0.25 then
        return nil
    end

    return BufferedAction(inst, nil, ACTIONS.WALKTO, nil, spawnpoint, nil, 0.2)
end

--------------------------------------------------------------------------------

function MoneFertilizerBotBrain:OnStart()
    local root = PriorityNode(
    {
        WhileNode(function() return not self.inst.sg:HasAnyStateTag("busy", "broken") end, "NO BRAIN WHEN BUSY OR BROKEN",
            PriorityNode({
                DoAction(self.inst, FertilizeAction, "Fertilize Target", true),
                DoAction(self.inst, FindFertilizationAction, "Find Target", true),
                DoAction(self.inst, GoHomeAction, "Return Home", true),
                ParallelNode{
                    StandStill(self.inst),
                    SequenceNode{
                        ParallelNodeAny{
                            WaitNode(6),
                            ConditionWaitNode(function()
                                return self.inst.components.fueled:GetPercent() < 0.2
                            end),
                        },
                        ActionNode(function()
                            self.inst:PushEvent("sleepmode")
                        end),
                    },
                },
            }, .25)
        ),
    }, .25)

    self.bt = BT(self.inst, root)
end

function MoneFertilizerBotBrain:OnStop()
    self:UnignoreItem()
end

function MoneFertilizerBotBrain:OnInitializationComplete()
    -- 初始化出生点
    if self.inst.components.knownlocations then
        local x, y, z = self.inst.Transform:GetWorldPosition()
        self.inst.components.knownlocations:AddLocation("spawnpoint", x, y, z)
    end
end

return MoneFertilizerBotBrain
