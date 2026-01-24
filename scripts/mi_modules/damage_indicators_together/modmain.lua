local dst_utils = require("moreitems.main").dst.dst_utils
local base = require("moreitems.main").shihao.base

if dst_utils.oneof_mod_enabled("543945797", "Damage Indicators Together") then
    base.log.info("Damage Indicators Together has been enabled, my module will be disabled.")
    return
end

