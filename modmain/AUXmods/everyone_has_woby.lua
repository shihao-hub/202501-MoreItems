
-- 2025/06/28，太麻烦了，有技能树的存在，还有技能轮，看样子不好做到了
-- 除非有限的功能：有沃比，能打开，有晾肉架，能做零食，右键骑行

env.AddPlayerPostInit(function(inst)
	-- 排除沃尔特
	if inst.prefab == "walter" then
		return
	end
    if not TheWorld.ismastersim then
        return
    end


end)