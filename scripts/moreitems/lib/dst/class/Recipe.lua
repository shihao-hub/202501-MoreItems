local class = require("moreitems.lib.thirdparty.middleclass.middleclass").class

-- 2025-02-02
--  我认为，Lua 应该就适合 OP 编程，虽然 Lua 可以模拟 OO，但是我总会觉得很别扭？
--  饥荒的 components、widgets 等就是类，能熟练使用这些应该就够了，不需要我自己编写额外类。
--  用函数和 table 就够了吧？

---@class Recipe
local Recipe = class("Recipe")

---@param data table
function Recipe:initialize(data)
    ---@type string
    self.name = data.name

    ---@type table[]
    self.ingredients = data.ingredients

    ---@type table
    self.tech = data.tech

    ---@type table
    self.config = data.config

    ---@type table[]
    self.filters = data.filters
end

---@param env env
function Recipe:add_recipe(env)
    env.AddRecipe2(self.name, self.ingredients, self.tech, self.config, self.filters)
end

return Recipe