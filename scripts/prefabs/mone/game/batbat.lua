local easing = require("easing")
local assets =
{
    Asset("ANIM", "anim/batbat.zip"),
    Asset("ANIM", "anim/swap_batbat.zip"),
}

local assets_bats =
{
    Asset("ANIM", "anim/bat_tree_fx.zip"),
    Asset("PKGREF", "anim/dynamic/batbat_scythe.dyn"),
}

local function onequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_batbat", inst.GUID, "swap_batbat")
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_batbat", "swap_batbat")
    end
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end
end

local function IsLifeDrainable(target)
	return not target:HasAnyTag(NON_LIFEFORM_TARGET_TAGS) or target:HasTag("lifedrainable")
end

local function onattack(inst, owner, target)
    local skin_fx = SKIN_FX_PREFAB[inst:GetSkinName()]
    if skin_fx ~= nil and skin_fx[1] ~= nil and target ~= nil and target.components.combat ~= nil and target:IsValid() then
        local fx = SpawnPrefab(skin_fx[1])
        if fx ~= nil then
            fx.entity:SetParent(target.entity)
            fx.entity:AddFollower():FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0, 0)
            if fx.OnFXSpawned ~= nil then
                fx:OnFXSpawned(inst)
            end
        end
    end
	if owner.components.health and owner.components.health:IsHurt() and IsLifeDrainable(target) then
        owner.components.health:DoDelta(TUNING.BATBAT_DRAIN, false, "mone_batbat")
		if owner.components.sanity ~= nil then
	        owner.components.sanity:DoDelta(-.5 * TUNING.BATBAT_DRAIN)
		end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("batbat")
    inst.AnimState:SetBuild("batbat")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("dull")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

	--shadowlevel (from shadowlevel component) added to pristine state for optimization
	inst:AddTag("shadowlevel")

    local swap_data = {sym_build = "swap_batbat"}
    MakeInventoryFloatable(inst, "large", 0.05, {0.8, 0.35, 0.8}, true, -27, swap_data)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.BATBAT_DAMAGE)
    inst.components.weapon.onattack = onattack

    -------

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.BATBAT_USES)
    inst.components.finiteuses:SetUses(TUNING.BATBAT_USES)

    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

	inst:AddComponent("shadowlevel")
	inst.components.shadowlevel:SetDefaultLevel(TUNING.BATBAT_SHADOW_LEVEL)

    MakeHauntableLaunch(inst)

    return inst
end


return Prefab("mone_batbat", fn, assets)
