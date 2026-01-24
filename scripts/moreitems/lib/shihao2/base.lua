local this = {}

---
---Python f-string。将形如 { a } { b } 等格式的字符串全部替换为 tostring(a) 和 tostring(b)。
---
---@param template string
---@param context table
function this.f_string(template, context)
    return (string.gsub(template, "{ *([a-zA-Z_]+) * }", function(matched)
        return tostring(context[matched])
    end))
end

return this