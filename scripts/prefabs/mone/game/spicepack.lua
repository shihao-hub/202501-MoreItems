local assets =
{
    Asset("ANIM", "anim/backpack.zip"),
    Asset("ANIM", "anim/swap_chefpack.zip"),
    Asset("ANIM", "anim/ui_icepack_2x3.zip"),
}

local prefabs =
{
    "ash",
}

local spicepack_auto_open = TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA.spicepack_auto_open;


local function ondropped(inst)
    if inst.components.container then
        inst.components.container:Close()
    end
end

local function onpickupfn(inst, pickupguy, src_pos)
    if inst.components.container and pickupguy then
        inst.components.container:Open(pickupguy);
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()


    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("backpack1")
    inst.AnimState:SetBuild("swap_chefpack")
    inst.AnimState:PlayAnimation("anim")

    inst.MiniMapEntity:SetIcon("spicepack.png")


    inst:AddTag("foodpreserver")
    inst:AddTag("nocool")


    inst.foleysound = "dontstarve/movement/foley/backpack"

    MakeInventoryFloatable(inst, "small", 0.15, 0.85)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        local old_OnEntityReplicated = inst.OnEntityReplicated
        inst.OnEntityReplicated = function(inst)
            if old_OnEntityReplicated then
                old_OnEntityReplicated(inst)
            end
            if inst and inst.replica and inst.replica.container then
                inst.replica.container:WidgetSetup("mone_spicepack");
            end
        end
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.cangoincontainer = true
    inst.components.inventoryitem:ChangeImageName("spicepack");
    inst.components.inventoryitem:SetOnDroppedFn(ondropped);
    if spicepack_auto_open then
        inst.components.inventoryitem:SetOnPickupFn(onpickupfn)
    end

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("mone_spicepack")
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true
    inst.components.container.onopenfn = function(inst)
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
    end
    inst.components.container.onclosefn = function(inst)
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
    end

    inst:AddComponent("preserver")
    inst.components.preserver:SetPerishRateMultiplier(0.75);

    MakeHauntableLaunchAndDropFirstItem(inst)

    return inst
end

return Prefab("mone_spicepack", fn, assets, prefabs)
