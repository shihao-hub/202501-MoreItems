-- 添加 普通版·万物打包所需的标签
-- 功能：
-- 		1.允许打包所有能被摧毁的类建筑目标
env.AddPrefabPostInitAny(function(inst)
    if not TheWorld.ismastersim then
        return
    end

    if inst.components.health and not (inst.prefab == "eyeturret") then
    	return
    end

    if inst:HasTag("structure") 
        or inst.components.workable
        or inst.prefab == "wormlight_plant"
        or inst.prefab == "worm"
        or inst.prefab == "eyeturret" -- 眼球塔
        or string.find(inst.prefab, "^flower_cave") then
        inst:AddTag("mie_ordinary_bundle_legitimate_target")
    end
end)


