local base = require("moreitems.lib.shihao2.base")

local this = {}

---
---默认移除空白字符，但你可以传入一个字符串，指定要移除的字符集。
---
---@overload fun(str:string)
function this.strip(str, chars)
    if chars then
        local pattern = base.f_string("^[{ chars }]*(.-)[{ chars }]*$", { chars = chars })
        return str:gsub(pattern, "%1")
    end
    return str:gsub("^%s*(.-)%s*$", "%1")
end

return this