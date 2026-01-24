local base = require("moreitems.lib.shihao2.base")


local this = {}

---
---根据 sep 切割字符串。如果 sep 为空，则默认赋值为 ":"，如果 sep 为空字符串。
---
---@overload fun(str:string)
---@param str string
---@param sep string|nil
---@return table[]
function this.split(str, sep)
    -- 如果 sep 为空字符串，则返回字符列表
    if sep == "" then
        local res = {}
        for i = 1, #str do
            res[i] = string.sub(str, i, i)
        end
        return res
    end

    sep = sep or ":"

    local fields = {}
    local pattern = string.format("([^%s]+)", sep)
    string.gsub(str, pattern, function(c)
        -- fields 可以理解为 输出参数 或者是 C 语言中的指针参数
        fields[#fields + 1] = c
    end)
    return fields
end

function this.startswith(str, prefix)
    return string.sub(str, 1, string.len(prefix)) == prefix
end

function this.endswith(str, suffix)
    return string.sub(str, -string.len(suffix), -1) == suffix
end

---
---默认移除空白字符，但你可以传入一个字符串，指定要移除的字符集。
---
---@overload fun(str:string)
function this.strip(str, chars)
    if chars then
        -- NOTE: Lua 的模式匹配值得深入学习，在我的记忆中，它并不是正则表达式，而是自己实现的，代码量不多，功能足够强大
        local pattern = base.f_string("^[{ chars }]*(.-)[{ chars }]*$", { chars = chars })
        return str:gsub(pattern, "%1")
    end
    return str:gsub("^%s*(.-)%s*$", "%1")
end

return this