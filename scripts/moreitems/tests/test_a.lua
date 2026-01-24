---
--- DateTime: 2025/11/22 9:59
---

os.native = {}
os.native.status, os.native.ffi =  pcall(require, "ffi")

print(os.native.status)

local windows = package.config:sub(1, 1) ~= '/' and true or false

os.path = {}
os.path.sep = windows and '\\' or '/'
function os.path.norm(pathname)
    if windows then
        pathname = pathname:gsub('\\', '/')
    end
    if windows then
        pathname = pathname:gsub('/', '\\')
    end
    return pathname
end


print("D:\\Program Files (x86)\\Steam\\steamapps")
print(os.path.norm("D:\\Program Files (x86)\\Steam\\steamapps"))