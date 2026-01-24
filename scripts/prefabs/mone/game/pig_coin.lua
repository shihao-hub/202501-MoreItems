--[[
猪鼻铸币可以被玩家随时使用，使用时会随机召唤并雇佣一只精英猪 10 秒。 

修改后：

随机召唤并雇佣一只精英猪 30 秒，再此期间是无敌的！

猪也无法被冰冻

等。。。

link: https://dontstarve.huijiwiki.com/wiki/%E7%8C%AA%E9%BC%BB%E9%93%B8%E5%B8%81

]]

-- todo: 新增一个背包
-- todo: 修复自动进入容器之背包进不去（可能是四格的原因，需要单独兼容）
-- todo: light 可以放入工具袋


local assets =
{
    Asset("ANIM", "anim/pig_coin.zip"),
}

local prefabs =
{
    "cointosscastfx",
    "cointosscastfx_mount",
    "pigelitefighter1",
    "pigelitefighter2",
    "pigelitefighter3",
    "pigelitefighter4",
}

local function shine(inst)
    if not inst.AnimState:IsCurrentAnimation("sparkle") then
        inst.AnimState:PlayAnimation("sparkle")
        inst.AnimState:PushAnimation("idle", false)
    end
    inst:DoTaskInTime(4 + math.random() * 5, shine)
end

local function spellfn(inst, target, pos, caster)
    if caster ~= nil then
        local pos = caster:GetPosition()

        -- region - 修改这个 elite

        -- 消失时间修改
        local old_PIG_ELITE_FIGHTER_DESPAWN_TIME = TUNING.PIG_ELITE_FIGHTER_DESPAWN_TIME
        TUNING.PIG_ELITE_FIGHTER_DESPAWN_TIME = TUNING.TOTAL_DAY_TIME / 2
        local elite = SpawnPrefab("pigelitefighter"..math.random(4))
        TUNING.PIG_ELITE_FIGHTER_DESPAWN_TIME = old_PIG_ELITE_FIGHTER_DESPAWN_TIME

        elite.Transform:SetPosition(pos.x, (caster.components.rider ~= nil and caster.components.rider:IsRiding()) and 3 or 0, pos.z)
        elite.components.follower:SetLeader(caster)

        -- 血量修改


        -- endregion

        local theta = math.random() * PI2
        local offset = FindWalkableOffset(pos, theta, 2.5, 16, true, true, nil, false, true)
                or FindWalkableOffset(pos, theta, 2.5, 16, false, false, nil, false, true)
                or Vector3(0, 0, 0)

        pos.x, pos.y, pos.z = pos.x + offset.x, 0, pos.z + offset.z
        elite.sg:GoToState("spawnin", { dest = pos })
    end

    inst.components.finiteuses:Use(1)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("pig_coin")
    inst.AnimState:SetBuild("pig_coin")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst, "small")

    inst:AddTag("cointosscast") -- for coint toss casting

    inst.scrapbook_specialinfo = "PIGCOIN"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.fxcolour = {248/255, 248/255, 198/255}
    inst.castsound = "dontstarve/pig/mini_game/cointoss"

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(10)
    inst.components.finiteuses:SetUses(10)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(spellfn)
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canusefrominventory = true
    inst.components.spellcaster.canonlyuseonlocomotorspvp = true

    inst:AddComponent("tradable")

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "pig_coin"
    inst.components.inventoryitem.atlasname = "images/DLC/inventoryimages2.xml"

    MakeHauntableLaunch(inst)

    shine(inst)

    return inst
end

return Prefab("rmi_pig_coin", fn, assets, prefabs)
