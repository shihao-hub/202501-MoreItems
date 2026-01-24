---
--- @author zsh in 2023/1/10 17:52
---

local POISON_BASE_DAMAGE = 51

local function commonfn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "med", nil, 0.75)

    inst:AddTag("sharp")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst;
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(POISON_BASE_DAMAGE)

    inst:AddComponent("tradable")

    -------

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(150)
    inst.components.finiteuses:SetUses(150)

    inst.components.finiteuses:SetOnFinished(function()
        inst:Remove();
    end)

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(function(_inst, owner)
        owner.AnimState:OverrideSymbol("swap_object", "swap_spear", "swap_spear")
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")
    end)
    inst.components.equippable:SetOnUnequip(function(_inst, owner)
        owner.AnimState:Hide("ARM_carry")
        owner.AnimState:Show("ARM_normal")
    end)

    return inst
end

local function can_be_aoe_attacked(aoe_target, attacker, target)
    -- doc: attacker 是武器的拥有者，target 是攻击目标，v 是被范围攻击的目标。

    local is_valid = aoe_target and aoe_target:IsValid() and attacker and attacker:IsValid() and target and target:IsValid()
    local is_other_prefab = aoe_target ~= target
    local is_same_prefab = true -- aoe_target.prefab == target.prefab -- 针对 aoe 工具
    local is_valid_target = attacker.components.combat and attacker.components.combat:IsValidTarget(aoe_target)
    local aoe_target_is_follower = attacker.components.leader and attacker.components.leader:IsFollower(aoe_target)

    print(string.format("%s %s %s %s %s %s", aoe_target.prefab, target.prefab, tostring(is_valid), tostring(is_same_prefab), tostring(is_valid_target), tostring(not aoe_target_is_follower)))
    return is_valid and is_other_prefab and is_same_prefab and is_valid_target and not aoe_target_is_follower
end

---@param pos table[] @ x, y, z -> 1, 2, 3
local function spawn_fx(name, pos, scale)
    local fx = SpawnPrefab(name)
    scale = scale or 1
    if fx == nil then
        return
    end
    fx.Transform:SetScale(scale, scale, scale)
    fx.Transform:SetPosition(pos[1], pos[2], pos[3])
end

---
---计算攻击者造成的伤害（需要吃 buff 加成）
---
local function calc_attacker_damage(attacker)
    return POISON_BASE_DAMAGE * 3
end

local function poisonattack(inst, attacker, target, projectile)
    -- 被攻击者处生成特效
    spawn_fx("mone_reskin_tool_brush_explode_fx", { target.Transform:GetWorldPosition() }, 0.5)

    local x, y, z = target.Transform:GetWorldPosition()
    if x == nil or y == nil or z == nil then
        return
    end

    -- [2025-11-05] 搜索被攻击者周围的目标
    local DIST = 4 -- * 1.5
    local MUST_TAGS = { "_combat" }
    local CANT_TAGS = { "INLIMBO", "companion", "wall", "abigail", "shadowminion" }
    local ents = TheSim:FindEntities(x, y, z, DIST, MUST_TAGS, CANT_TAGS);
    for _, aoe_target in ipairs(ents) do
        if can_be_aoe_attacked(aoe_target, attacker, target) then
            aoe_target.rmi_from_spear_poison = true

            -- 大概是生成仇恨之类的，通知目标你被我攻击了
            attacker:PushEvent("onareaattackother", { target = aoe_target, weapon = inst, stimuli = nil })

            -- region - 该函数存在 damage 减免的情况，需要考虑一下真伤到底代表什么

            aoe_target.components.combat:GetAttacked(attacker, calc_attacker_damage(attacker), inst, nil)

            -- endregion

            spawn_fx("mone_reskin_tool_brush_explode_fx", { target.Transform:GetWorldPosition() }, 0.5)

            aoe_target.rmi_from_spear_poison = nil
        end
    end
end

local function onequippoison(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_spear_poison", "swap_spear")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local poison_assets = {
    Asset("ANIM", "anim/spear_poison.zip"),
    Asset("ANIM", "anim/swap_spear_poison.zip"),
}

local function poisonfn()
    local inst = commonfn()

    inst:AddTag("spear")

    inst.AnimState:SetBuild("spear_poison")
    inst.AnimState:SetBank("spear_poison")
    inst.AnimState:PlayAnimation("idle")

    if not TheWorld.ismastersim then
        return inst;
    end

    inst:AddComponent("inventoryitem")

    inst.components.inventoryitem.imagename = "spear_poison"
    inst.components.inventoryitem.atlasname = "images/DLC0002/inventoryimages.xml"

    inst.components.weapon:SetOnAttack(poisonattack)
    inst.components.equippable:SetOnEquip(onequippoison)

    inst.speartype = "poison"

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("mone_spear_poison", poisonfn, poison_assets);