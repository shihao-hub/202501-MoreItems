local singletons = {
    set = function(self, k, v)
        if self[k] then
            error("DuplicateKeyError: The singletons table prohibits multiple assignments to the same key (Code 409).", 2)
        end
        self[k] = v
    end,
    get = function(self, k)
        return self[k]
    end
}

singletons:set("a", 1)
print(singletons:get("a"))
--singletons:set("a", 2)
--singletons:set("set", "1")

function createOneTimeTable()
    local t = {}
    local setOnce = {}

    local mt = {
        __newindex = function(table, key, value)
            if setOnce[key] then
                error("Cannot set key '" .. tostring(key) .. "' more than once.")
            else
                rawset(table, key, value)
                setOnce[key] = true
            end
        end
    }

    setmetatable(t, mt)
    return t
end

-- 测试代码
local myTable = createOneTimeTable()

myTable["a"] = 1  -- 设置成功
print(myTable["a"])  -- 输出: 1

-- 尝试重新赋值
local success, err = pcall(function() myTable["a"] = 2 end)
if not success then
    print(err)  -- 输出: Cannot set key 'a' more than once.
end

myTable["b"] = 3  -- 设置成功
print(myTable["b"])  -- 输出: 3

-- 尝试重新赋值
success, err = pcall(function() myTable["b"] = 4 end)
if not success then
    print(err)  -- 输出: Cannot set key 'b' more than once.
end