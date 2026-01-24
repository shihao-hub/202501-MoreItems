local class = require("moreitems.lib.thirdparty.middleclass.middleclass").class

---@class HashSet
local HashSet = class("HashSet ")

function HashSet:initialize()
    self._elements = {}
    self._size = 0
end

---
---添加元素
---
function HashSet:add(element)
    if not self._elements[element] then
        self._elements[element] = true
        self._size = self._size + 1
    end
end

---
---删除元素
---
function HashSet:remove(element)
    if self._elements[element] then
        self._elements[element] = nil
        self._size = self._size - 1
    end
end

---
---是否包含元素
---
function HashSet:contains(element)
    return self._elements[element] ~= nil
end

---
---返回集合大小
---
function HashSet:size()
    return self._size
end

---
---清空集合
---
function HashSet:clear()
    self._elements = {}
    self._size = 0
end

---
---迭代器（遍历所有元素）
---
function HashSet:iterator()
    return pairs(self._elements)
end

if select("#", ...) == 0 then
    local set = HashSet()
    set:add("apple")
    set:add("banana")
    set:add("apple")  -- 重复添加无效
    print(set:size()) -- 输出 2
    for k, _ in set:iterator() do
        print(k)      -- 输出 apple, banana（顺序不确定）
    end
end

return HashSet