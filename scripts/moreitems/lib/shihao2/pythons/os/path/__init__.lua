local this = {}

---@param path string
---@param paths list
---@overload fun(path:string,...)
function this.join(path, paths)
    local s, _ = path:find("\\+$")
    if s then
        path = path:sub(1, s - 1)
    end
    local sep = "\\"
    return path .. sep .. table.concat(paths, sep)
end

if select("#", ...) == 0 then
    local smoker = {}

    function smoker.test_join()
        this.join("aaaa\\\\", {})
    end

    for k, v in pairs(smoker) do
        if string.sub(k, 1, 5) == "test_" then
            v()
        end
    end
end

return this