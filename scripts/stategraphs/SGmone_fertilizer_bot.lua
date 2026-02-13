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
    inst.Physics:SetMass(50)
end

local function PlaySectionSound(inst, sound, soundname)
    inst.SoundEmitter:PlaySound("qol1/collector_robot/"..sound, soundname)
end

--------------------------------------------------------------------------------

local states =
{
    State {
        name = "idle",
        tags = { "idle" },

        onenter = function(inst, busy)
            if busy then
                inst.sg:AddStateTag("busy")
            end

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
}

CommonStates.AddSinkAndWashAshoreStates(states, {washashore = "idle"})

CommonStates.AddWalkStates(
    states,
    nil,
    nil,
    true,
    nil,
    {
        startonenter = function(inst)
            inst.SoundEmitter:KillSound(ACTIVE_SOUNDNAME)

            if not inst.SoundEmitter:PlayingSound(WALK_SOUNDNAME) then
                PlaySectionSound(inst, "walk", WALK_SOUNDNAME)
            end
        end,

        endonexit = function(inst)
            inst.SoundEmitter:KillSound(WALK_SOUNDNAME)
            inst.SoundEmitter:KillSound(ACTIVE_SOUNDNAME)
        end,
    }
)

return StateGraph("mone_fertilizer_bot", states, events, "idle", actionhandlers)
