local class = require("moreitems.lib.thirdparty.middleclass.middleclass").class

local this = {}

---@class TestCase
local TestCase = class("TestCase")

function TestCase:initialize()

end

this.TestCase = TestCase

function this.main()
    local Test = class("Test", TestCase)
    function Test:test_main()
        print(123123)
        a = nil .. 1
    end
    local inspect = require("moreitems.lib.thirdparty.inspect.inspect")
    print(inspect(Test))
    for key, value in pairs(Test.__declaredMethods) do
        if type(value) == "function" and type(key) == "string" and string.sub(key, 1, 5) == "test_" then
            xpcall(value, function(msg)
                io.stderr:write(msg, "\n")
            end)
        end
    end
end

if select("#", ...) == 0 then
    this.main()
end

return this