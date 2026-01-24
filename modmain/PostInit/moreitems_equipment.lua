

local weapons = {"me_spiralspear","me_pithpike","me_forginghammer"}

for _, name in ipairs(weapons) do
	env.AddPrefabPostInit(name, function(inst) 
		if not TheWorld.ismastersim then
        	return
    	end
    	-- 修改默认的基础伤害 41
    	if inst.components.weapon then
            inst.components.weapon:SetDamage(41)
        end
    	-- 添加位面伤害 20
        inst:AddComponent("planardamage")
        inst.components.planardamage:SetBaseDamage(20)
	end)
end
