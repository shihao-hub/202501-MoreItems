local class = require("moreitems.lib.thirdparty.middleclass.middleclass").class

---@class Prefab
local Prefab = class("Prefab")

---@param recipe Recipe
function Prefab:initialize(recipe, data)
    self.recipe = recipe

    ---@type string
    self.name = data.name
end

return Prefab