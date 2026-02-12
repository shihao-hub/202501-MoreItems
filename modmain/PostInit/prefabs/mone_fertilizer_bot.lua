---
--- @author zsh in 2025/02/12
--- 施肥瓦器人 PostInit - 给肥料物品添加标签
---

-- 支持的肥料类型列表
local FERTILIZER_ITEMS = {
    "fertilizer",        -- 肥料
    "glommerfuel",       -- 钮格粘液
    "rottenegg",         -- 腐烂蛋
    "spoiled_food",       -- 变质食物
    "guano",             -- 鸟粪
    "poop",              -- 粪便
    "compostwrap",        -- 堆肥打包
}

for _, prefab in ipairs(FERTILIZER_ITEMS) do
    env.AddPrefabPostInit(prefab, function(inst)
        if not inst:HasTag("mone_fertilizer_bot_fertilizer") then
            inst:AddTag("mone_fertilizer_bot_fertilizer")
        end
    end)
end
