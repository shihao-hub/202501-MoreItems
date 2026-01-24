---
--- @author zsh in 2023/2/10 12:30
---


local function state1()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.entity:AddMiniMapEntity();
    inst.MiniMapEntity:SetIcon("giftwrap.tex");

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("gift")
    inst.AnimState:SetBuild("gift")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("mie_ordinary_bundle_state1");


    MakeInventoryFloatable(inst, "med")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "giftwrap"
    inst.components.inventoryitem.atlasname = "images/inventoryimages.xml"

    inst:AddComponent("mie_ordinary_bundle_action")

    return inst
end

local function ondeployfn(inst, pt, deployer)
    inst.components.mie_bundle:Deploy(pt);
    if deployer and deployer.components.inventory then
        local state1 = SpawnPrefab("mie_ordinary_bundle_state1", inst.linked_skinname, inst.skin_id)
        deployer.components.inventory:GiveItem(state1);
    end
    inst:Remove()
end

local function state2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.entity:AddMiniMapEntity();
    inst.MiniMapEntity:SetIcon("gift_large1.tex");

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("gift")
    inst.AnimState:SetBuild("gift")
    inst.AnimState:PlayAnimation("idle_large1")

    inst:AddTag("mie_ordinary_bundle_state2");

    -- 不允许带下线、不允许打包
    if TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA.bundle_irreplaceable then
        inst:AddTag("irreplaceable")
    end
    inst:AddTag("nonpotatable")
    inst:AddTag("bundle")
    inst:AddTag("nobundling")

    MakeInventoryFloatable(inst, "med")

    -- 主客机交互
    inst._name = net_string(inst.GUID, "mie_ordinary_bundle_state2._name")
    inst.displaynamefn = function(inst)
        if #inst._name:value() > 0 then
            return "被普通打包的 " .. inst._name:value();
        else
            return "未知打包物";
        end
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:ChangeImageName("gift_large1")

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeployfn;
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.NONE)

    inst:AddComponent("mie_bundle")
    inst.components.mie_bundle.ordinary_packaging = true

    return inst
end

return Prefab("mie_ordinary_bundle_state1", state1), Prefab("mie_ordinary_bundle_state2", state2),
MakePlacer("mie_ordinary_bundle_state2_placer", "gift", "gift", "idle_large");