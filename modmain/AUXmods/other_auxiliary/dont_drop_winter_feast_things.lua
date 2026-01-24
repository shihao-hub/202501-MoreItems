local LootDropper = require("components/lootdropper")
local old_DropLoot = LootDropper.DropLoot

local _in_effect = false

local hooked_env = setmetatable({
	IsSpecialEventActive = function(special_event)
		if special_event == SPECIAL_EVENTS.WINTERS_FEAST then
			return false
		else
			return GLOBAL.IsSpecialEventActive(special_event)
		end
	end
},{ __index = getfenv(old_DropLoot) })


env.AddPrefabPostInit("world", function()
	if IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) then
		-- old_DropLoot 会调用 IsSpecialEventActive 方法，通过 setfenv 这种方式保证足够的兼容性
		setfenv(old_DropLoot, hooked_env)

		LootDropper.DropLoot = function(self, pt, ...)
			local prefabname = string.upper(self.inst.prefab)
			local num_decor_loot = self.GetWintersFeastOrnaments ~= nil and self.GetWintersFeastOrnaments(self.inst) or TUNING.WINTERS_FEAST_TREE_DECOR_LOOT[prefabname] or nil
			if num_decor_loot ~= nil then
				if num_decor_loot.special ~= nil then
					self:SpawnLootPrefab(num_decor_loot.special, pt)
				end
			end
		
			return old_DropLoot(self, pt, ...)
		end
	end
end)