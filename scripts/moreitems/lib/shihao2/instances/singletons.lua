--[[
### 功能说明
- 用于存储全局唯一遍历，要求 key 值均为 uuid？

]]

local this = {}
local data = {}

function this.set(key, value_fn)
    if data[key] ~= nil then
        -- to record warnings
        return
    end
    data[key] = value_fn()
end

function this.get(key)
    return data[key]
end

if select("#", ...) == 0 then
    this.set("1", function() return 100 end)
    print(this.get("1"))
    this.set("1", function() return 200 end)
    print(this.get("1"))

    -- 文件处理
    local settings = require("moreitems.settings")
    local os_path = require("moreitems.lib.shihao2.pythons.os.path.init")
    local f = io.open(os_path.join(settings.SOURCE_DIR, { "moreitems", "lib", "shihao2", "instances", "uuids.txt" }))
    local lines = f:lines()
    --for line in lines do
    --    print(line)
    --end
    print(lines())
    print(lines())
end

return this