local assets =
{
    Asset("ANIM", "anim/ham_bat.zip"),
    Asset("ANIM", "anim/swap_ham_bat.zip"),
}

local HAMBAT_MAX_DAMAGE_MODIFIER = 1.5
local HAMBAT_MAX_DAMAGE = HAMBAT_MAX_DAMAGE_MODIFIER * TUNING.HAMBAT_DAMAGE

-- print(Remap(0, 68, 0,68, 68*1.5))

local function UpdateDamage(inst)
    if inst.components.perishable and inst.components.weapon then
        local dmg = TUNING.HAMBAT_DAMAGE * inst.components.perishable:GetPercent()
        dmg = Remap(dmg, TUNING.HAMBAT_DAMAGE, 0, TUNING.HAMBAT_DAMAGE, HAMBAT_MAX_DAMAGE_MODIFIER * TUNING.HAMBAT_DAMAGE)
        inst.components.weapon:SetDamage(dmg)
    end
end

local function OnLoad(inst, data)
    UpdateDamage(inst)
end

local function onequip(inst, owner)
    UpdateDamage(inst)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_ham_bat", inst.GUID, "swap_ham_bat")
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_ham_bat", "swap_ham_bat")
    end

    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    UpdateDamage(inst)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("ham_bat")
    inst.AnimState:SetBuild("ham_bat")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("show_spoilage")
    inst:AddTag("icebox_valid")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    local swap_data = {sym_build = "swap_ham_bat", bank = "ham_bat"}
    MakeInventoryFloatable(inst, "med", nil, {1.0, 0.5, 1.0}, true, -13, swap_data)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.HAMBAT_DAMAGE)
    inst.components.weapon:SetOnAttack(UpdateDamage)

    inst:AddComponent("forcecompostable")
    inst.components.forcecompostable.green = true

    inst.OnLoad = OnLoad


    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "hambat"
    inst.components.inventoryitem.atalsname = "images/inventoryimages.xml"

    MakeHauntableLaunchAndPerish(inst)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    return inst
end

return Prefab("mone_hambat", fn, assets)