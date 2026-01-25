---
--- @author zsh in 2023/2/5 14:09
---

local prefabname = "mie_relic_2";

local assets = {
    Asset("ANIM", "anim/relics.zip")
}

local fns = {};

function fns._onopenfn(inst, data)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open");
end

local function genericFX(inst)
    local scale = 0.5;
    local fx = SpawnPrefab("collapse_big");
    local x, y, z = inst.Transform:GetWorldPosition();
    fx.Transform:SetNoFaced();
    fx.Transform:SetPosition(x, y, z);
    fx.Transform:SetScale(scale, scale, scale);
end

function fns._onclosefn(inst)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close");

    -- 特殊效果：批量赌博
    if inst.components.container:IsEmpty() then
        print("[倾家荡产赌博机] 容器为空，跳过赌博")
        return ;
    end

    local slots = inst.components.container.slots
    local success_count = 0
    local fail_count = 0
    local success_items = {}
    local fail_items = {}

    print(string.format("[倾家荡产赌博机] 开始赌博，共%d个格子", #slots))
    print(string.format("[倾家荡产赌博机] 赌博规则：1-55成功（55%%），56-100失败（45%%）"))

    -- 对每个格子分别进行赌博
    for slot_idx, item in pairs(slots) do
        if item:IsValid() and item.persists then
            local item_name = item.prefab or "unknown"
            local stack_size = item.components.stackable and item.components.stackable:StackSize() or 1
            local roll = math.random(1, 100)

            print(string.format("[倾家荡产赌博机] 格子%d: %s x%d，掷出%d点",
                slot_idx, item_name, stack_size, roll))

            local save_record = item:GetSaveRecord()
            local x, y, z = inst.Transform:GetWorldPosition()
            local offset_x = (slot_idx % 3) * 0.5 - 0.5
            local offset_y = math.floor(slot_idx / 3) * 0.5 - 0.5
            local drop_pos = Vector3(x + offset_x, y + 0.5, z + offset_y)

            if roll <= 55 then
                -- 赌博成功：翻倍（原物品掉落 + 创建副本）
                print(string.format("[倾家荡产赌博机] 格子%d: 成功！翻倍 %s x%d",
                    slot_idx, item_name, stack_size * 2))
                table.insert(success_items, string.format("%s x%d", item_name, stack_size * 2))
                genericFX(inst)
                -- 先从容器移除原物品并掉落
                local dropped_item = inst.components.container:RemoveItem(item, true)
                if dropped_item then
                    dropped_item.Transform:SetPosition(drop_pos.x, drop_pos.y, drop_pos.z)
                end
                -- 再创建副本掉落
                if save_record then
                    local spawned_item = SpawnSaveRecord(save_record)
                    if spawned_item then
                        spawned_item.Transform:SetPosition(drop_pos.x, drop_pos.y, drop_pos.z)
                    end
                end
                success_count = success_count + 1
            else
                -- 赌博失败：直接删除
                print(string.format("[倾家荡产赌博机] 格子%d: 失败！%s x%d 消失",
                    slot_idx, item_name, stack_size))
                table.insert(fail_items, string.format("%s x%d", item_name, stack_size))
                item:Remove()
                fail_count = fail_count + 1
            end
        end
    end

    -- 显示结果
    print(string.format("[倾家荡产赌博机] 赌博结束 - 成功:%d 失败:%d", success_count, fail_count))

    if success_count > 0 and fail_count == 0 then
        inst.components.talker:Say("󰀁运气爆棚！全部翻倍！󰀁")
    elseif success_count > 0 then
        inst.components.talker:Say(string.format("󰀁翻倍%d个，损失%d个󰀁", success_count, fail_count))
    else
        inst.components.talker:Say("󰀐运气太差了，全都没了󰀐")
    end

    -- 输出详细的损失统计
    if #success_items > 0 then
        print("[倾家荡产赌博机] 翻倍物品: " .. table.concat(success_items, ", "))
    end
    if #fail_items > 0 then
        print("[倾家荡产赌博机] 损失物品: " .. table.concat(fail_items, ", "))
    end
end

local function onhammered(inst)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    if inst.components.lootdropper then
        inst.components.lootdropper:DropLoot();
    end

    if inst.components.container then
        inst.components.container:DropEverything();
    end

    local fx = SpawnPrefab("collapse_big")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("relic_2.tex") -- More Items 本体导入过了

    inst:AddTag("structure")
    inst:AddTag("mie_relic_2")

    inst:SetPhysicsRadiusOverride(.1)
    MakeObstaclePhysics(inst, inst.physicsradiusoverride)

    inst.AnimState:SetBank("relic")
    inst.AnimState:SetBuild("relics")
    inst.AnimState:PlayAnimation("2")

    MakeSnowCoveredPristine(inst)

    inst:AddComponent("talker");

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        local old_OnEntityReplicated = inst.OnEntityReplicated
        inst.OnEntityReplicated = function(inst)
            if old_OnEntityReplicated then
                old_OnEntityReplicated(inst)
            end
            if inst and inst.replica and inst.replica.container then
                inst.replica.container:WidgetSetup("mie_relic_2");
            end
        end
        return inst
    end

    inst:AddComponent("inspectable");

    inst:AddComponent("container");
    inst.components.container:WidgetSetup("mie_relic_2");
    inst.components.container.onopenfn = fns._onopenfn;
    inst.components.container.onclosefn = fns._onclosefn;

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable:SetOnFinishCallback(onhammered)

    MakeSnowCovered(inst)

    return inst;
end

return Prefab(prefabname, fn, assets),
MakePlacer(prefabname .. "_placer", "relic", "relics", "2");