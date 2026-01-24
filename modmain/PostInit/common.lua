---
--- @author zsh in 2023/6/9 13:36
---

env.AddPrefabPostInitAny(function(inst)
    if not TheWorld.ismastersim then
        return inst;
    end
    if inst.components.perishable then
        inst:AddTag("_perishable_mone");
    end
end)