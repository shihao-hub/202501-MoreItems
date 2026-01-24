#### 如何新增新物品

本来我想实现一个函数，只通过那个函数就能新增物品的，但是我直接记个笔记，按顺序添加不就行了？

modinfo.lua
modtuning.lua
modmain/PostInit/prefabs/*.lua: post_init_fn 主要是基于 env.Add?PostInit 之类的方法，去实现目标物品的特殊效果（区别于 scripts/prefabs 中定义的 fn，那只能算是骨架）
modmain/enable_prefabs.lua: 是否开启、assets 和 prefabfiles 导入


scripts/languages/mone/loc.lua
modmain/init/init_tooltips.lua: 物品栏描述

modmain/recipes.lua: 制作栏配方
modmain/reskin.lua: 是否支持原版换皮肤效果（因为我的很多物品都是原版物品贴图）
