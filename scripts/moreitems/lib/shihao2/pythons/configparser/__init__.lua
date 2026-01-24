local class = require("moreitems.lib.thirdparty.middleclass.middleclass").class

local string_extensions = require("moreitems.lib.shihao2.string_extensions")

local this = {}

---@class ConfigParser
local ConfigParser = class("ConfigParser")

function ConfigParser:initialize()
    self._config = {}
end

---@param filenames list|string
function ConfigParser:read(filenames)
    if type(filenames) == "string" then
        filenames = { filenames }
    end

    for _, filename in ipairs(filenames) do
        local current_section -- 值得学习，ai 确实是个好工具

        for line in io.lines(filename) do
            line = string_extensions.strip(line)

            -- 忽略空行和注释：`.ini` 的注释好像是 ; 和 #
            if line ~= "" and not line:match("^[;#]") then
                -- match 在匹配到之后会返回匹配到的内容，而不是 find 那样返回索引
                local section = line:match("^%[(.-)%]$")
                if section then
                    current_section = section
                    self._config[current_section] = self._config[current_section] or {}
                else
                    -- 收集键值对
                    local key, value = line:match("^(.-)%s*=%s*(.-)$")
                    if key and value then
                        -- 将匹配到的替换成捕获的 %1
                        key = key:gsub("^%s*(.-)%s*$", "%1")
                        value = value:gsub("^%s*(.-)%s*$", "%1")
                        self._config[current_section][key] = value
                    end
                end
            end
        end
    end
end

function ConfigParser:get(section, option)
    return self._config[section][option]
end

this.ConfigParser = ConfigParser

if select("#", ...) == 0 then
    local testcases = {}

    function testcases.test_ConfigParser()
        local os_path = require("moreitems.lib.shihao2.pythons.os.path.__init__")

        local settings = require("moreitems.settings")

        local config = require("moreitems.lib.shihao2.pythons.configparser.__init__").ConfigParser()

        config:read(os_path.join(settings.SOURCE_DIR, { "moreitems", "lib", "shihao2", "resources", "tests", "config.ini" }))
        if config:get("settings", "ai_api_mode") ~= "deepseek-reasoner" then
            error("500")
        end
    end

    testcases.test_ConfigParser()
end

return this