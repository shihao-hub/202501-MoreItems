local class = require("moreitems.lib.thirdparty.middleclass.middleclass").class

---@class HashMap
local HashMap = class("HashMap")

function HashMap:initialize()
    self._entries = {}
    self._size = 0
end

---
---添加或更新键值对
---
function HashMap:put(key, value)
    local exists = self._entries[key] ~= nil
    self._entries[key] = value
    if not exists then
        self._size = self._size + 1
    end
end

---
---获取值
---
function HashMap:get(key)
    return self._entries[key]
end

---
---是否包含键
---
function HashMap:containsKey(key)
    return self._entries[key] ~= nil
end

---
---删除键值对
---
function HashMap:remove(key)
    if self._entries[key] then
        self._entries[key] = nil
        self._size = self._size - 1
    end
end

---
---返回大小
---
function HashMap:size()
    return self._size
end

---
---清空
---
function HashMap:clear()
    self._entries = {}
    self._size = 0
end

---
---迭代器（遍历键值对）
---
function HashMap:entrySet()
    return pairs(self._entries)
end

if select("#", ...) == 0 then
    local map = HashMap()
    map:put("name", "Alice")
    map:put("age", 30)
    map:put("name", "Bob")  -- 更新值
    print(map:size())       -- 输出 2
    for k, v in map:entrySet() do
        print(k, v)         -- 输出 name Bob, age 30（顺序不确定）
    end
end

return HashMap