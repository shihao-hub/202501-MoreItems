-- 克制蟾蜍腐烂 - 食物袋、保鲜袋，后续增加素石镶嵌者
for _, name in ipairs({"mone_spicepack", "mone_icepack", "mone_storage_bag"}) do
   env.AddPrefabPostInit(name, function(inst) inst:AddTag("portablestorage") end)
end
