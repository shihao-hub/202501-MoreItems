-- 清理 recipes.lua 中的旧 atlas 和 image 定义
local input_file = "modmain/recipes.lua"
local output_file = "modmain/recipes.lua"

local content = ""
local f = io.open(input_file, "r")
if f then
    content = f:read("*all")
    f:close()
end

-- 删除 atlas 和 image 行
content = content:gsub('%s+atlas = "[^"]+",", "")
content = content:gsub('%s+image = "[^"]+", "")

-- 清理多余的空行和逗号
content = content:gsub(',\n\s*}', '\n    }')
content = content:gsub('\n\n\n+', '\n\n')

local f = io.open(output_file, "w")
if f then
    f:write(content)
    f:close()
end

print("已清理 atlas 和 image 定义")
