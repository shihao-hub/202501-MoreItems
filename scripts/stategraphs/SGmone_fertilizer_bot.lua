---
--- @author zsh in 2025/02/12
--- 施肥瓦器人状态机
---

require("stategraphs/commonstates")

local events =
{
    CommonHandlers.OnLocomote(false, true),
    CommonHandlers.OnSink(),
    CommonHandlers.OnFallInVoid(),
}

local actionhandlers =
{
    ActionHandler(ACTIONS.WALKTO, "walk"),
}

local WALK_SOUNDNAME = "walk_loop"
local ACTIVE_SOUNDNAME = "active_loop"

local function _ReturnToIdle(inst)
    if inst.AnimState:AnimDone() then
        inst.sg:GoToState("idle")
    end
end

local idle_on_animover = { EventHandler("animover", _ReturnToIdle) }

--------------------------------------------------------------------------------

local function MakeImmovable(inst)
    inst.Physics:SetMass(99999)
end

local function RestoreMobility(inst)
    inst.Physics:SetMass(inst:GetFueledSectionMass())
end

local function PlaySectionSound(inst, sound, soundname)
    inst.SoundEmitter:PlaySound("qol1/collector_robot/"..sound..inst:GetFueledSectionSuffix(), soundname)
end

--------------------------------------------------------------------------------

local states =
{
    State {
        name = "idle",
        tags = { "idle" },

        onenter = function(inst, busy)
            if inst.components.fueled:IsEmpty() then
                inst.sg:GoToState("idle_broken")
                return
            end

            if busy then
                inst.sg:AddStateTag("busy")
            end

            inst.components.fueled:StopConsuming()
            inst.components.locomotor:StopMoving()

            inst.SoundEmitter:KillSound(WALK_SOUNDNAME)
            inst.SoundEmitter:KillSound(ACTIVE_SOUNDNAME)

            if not inst.AnimState:IsCurrentAnimation("idle") then
                inst.AnimState:PlayAnimation("idle", true)
            end

            inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("idle")
        end,
    },

    State{
        name = "idle_broken",
        tags = { "busy", "broken" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("idle_broken", false)
            inst.SoundEmitter:KillAllSounds()
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:IsCurrentAnimation("idle_broken") then
                    inst.AnimState:PlayAnimation("idle_broken", false)
                end
            end),
        },
    },

    State{
        name = "fertilizing",
        tags = { "busy", "working" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("pickup")
            inst.SoundEmitter:KillSound(WALK_SOUNDNAME)
            PlaySectionSound(inst, "idle", ACTIVE_SOUNDNAME)
            inst.SoundEmitter:PlaySound("dontstarve/common/together/portable/spicer/lid_open")

            MakeImmovable(inst)
        end,

        timeline =
        {
            FrameEvent(27, function(inst)
                inst:PerformBufferedAction()
            end),
        },

        events = idle_on_animover,
        onexit = RestoreMobility,
    },

    State {
        name = "repairing_pre",
        tags = { "busy" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("repair_pre", false)
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("repairing")
            end),
        },

        onexit = function(inst)
            inst.AnimState:SetBuild("storage_robot")
        end,
    },

    State {
        name = "repairing",
        tags = { "busy" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("repair", false)
            inst.SoundEmitter:PlaySound("qol1/collector_robot/repair")
        end,

        events = idle_on_animover,
    },

    State {
        name = "breaking",
        tags = { "busy", "broken" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.inventory:DropEverything()
            inst.AnimState:PlayAnimation("breaking")
            inst.SoundEmitter:KillAllSounds()
            inst.SoundEmitter:PlaySound("qol1/collector_robot/breakdown")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle_broken")
            end),
        },
    },
}

CommonStates.AddSinkAndWashAshoreStates(states, {washashore = "idle_broken"})

CommonStates.AddWalkStates(
    states,
    nil,
    nil,
    true,
    nil,
    {
        startonenter = function(inst)
            inst.components.fueled:StartConsuming()
            inst.SoundEmitter:KillSound(ACTIVE_SOUNDNAME)

            if not inst.SoundEmitter:PlayingSound(WALK_SOUNDNAME) then
                PlaySectionSound(inst, "walk", WALK_SOUNDNAME)
            end
        end,

        endonexit = function(inst)
            inst.components.fueled:StopConsuming()
            inst.SoundEmitter:KillSound(WALK_SOUNDNAME)
            inst.SoundEmitter:KillSound(ACTIVE_SOUNDNAME)
        end,
    }
)

return StateGraph("mone_fertilizer_bot", states, events, "idle", actionhandlers)
