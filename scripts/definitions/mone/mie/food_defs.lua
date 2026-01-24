---
--- @author zsh in 2023/2/20 8:55
---

local foods = {};

local config_data = TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA;



-- 蒸树枝，需要交易组件，故移除 mie_inf_food 标签，改用交易后还一个实现？
foods["mie_beefalofeed"] = {
    CanMake = config_data.mie_beefalofeed,
    name = "mie_beefalofeed",
    assets = {
        Asset("ANIM", "anim/cook_pot_food.zip"),
    },
    tags = { "mie_beefalofeed", "non_preparedfood", "mie_inf_roughage" },
    animdata = { bank = "cook_pot_food", build = "cook_pot_food", animation = "idle" },
    cs_fn = function(inst)
        inst.entity:AddMiniMapEntity();
        inst.MiniMapEntity:SetIcon("beefalofeed.tex");

        inst.AnimState:OverrideSymbol("swap_food", "cook_pot_food11", "beefalofeed");
    end,
    client_fn = function(inst)

    end,
    server_fn = function(inst)
        inst.components.inventoryitem.imagename = "beefalofeed";
        inst.components.inventoryitem.atlasname = "images/inventoryimages1.xml";

        -- 这是干嘛的？
        --inst:ListenForEvent("onputininventory", function(inst, owner)
        --    if owner ~= nil and owner:IsValid() then
        --        owner:PushEvent("learncookbookstats", inst.food_basename or inst.prefab)
        --    end
        --end)

        inst.components.edible.hungervalue = TUNING.CALORIES_MOREHUGE;
        inst.components.edible.sanityvalue = 0;
        inst.components.edible.healthvalue = TUNING.HEALING_MEDLARGE / 2;
        --inst.components.edible.foodtype = FOODTYPE.VEGGIE;
        inst.components.edible.foodtype = FOODTYPE.ROUGHAGE;
        inst.components.edible.secondaryfoodtype = FOODTYPE.WOOD;

        inst:RemoveComponent("stackable");
        inst:RemoveComponent("bait");
        --inst:RemoveComponent("tradable");

    end
}

return foods;