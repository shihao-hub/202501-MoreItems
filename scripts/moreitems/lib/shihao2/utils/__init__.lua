local this = {
    coroutine_utils = require("moreitems.lib.shihao2.utils.coroutine_utils")
}

---@return table
function this.create_set(list)
    local res = {}
    for i in table.maxn(list) do
        res[list[i]] = true
    end
    return res
end

return this