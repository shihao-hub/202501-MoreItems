# 待办事项追踪

> 本文档记录项目中所有待办事项的详细信息，作为完成项目任务的参考。

**最后更新：** 2026-02-02
**维护者：** 心悦卿兮

---

## 📚 待办文档索引

| 文档 | 路径 | 说明 |
|------|------|------|
| 主要待办列表 | [TODOLISTS.md](TODOLISTS.md) | 功能计划、新物品开发、架构优化 |
| 已知缺陷 | [DEFECTS.md](DEFECTS.md) | Bug 追踪 |
| 工具库待办 | [scripts/moreitems/lib/shihao2/todo.md](scripts/moreitems/lib/shihao2/todo.md) | 全局计数器 |
| 代码注释 | 代码中的 TODO/FIXME | 分散在各文件中的标记 |

---

## 1️⃣ 已知缺陷 (DEFECTS.md)

### 🔴 高优先级

| 问题 | 严重程度 | 解决方案 | 状态 |
|------|---------|---------|------|
| 万物打包打包的物品被食人花吃了后会直接消失 | 高 | 让食人花不能吃打包物品 | ⏳ 待处理 |

---

## 2️⃣ 工具库待办 (scripts/moreitems/lib/shihao2/todo.md)

### 功能开发

| 任务 | 描述 | 优先级 | 状态 |
|------|------|--------|------|
| 全局计数器 | 使用 debug 的方式统计记录函数的调用次数 | 中 | ⏳ 待处理 |

---

## 3️⃣ 代码注释中的 TODO/FIXME

### 📌 核心模块

#### modinfo.lua

| 位置 | 内容 | 优先级 | 状态 |
|------|------|--------|------|
| [L480](modinfo.lua#L480) | 升级版·雪球发射机需要重写/完善 (2023-02-17) | 中 | ⏳ 待处理 |
| [L1207](modinfo.lua#L1207) | 恶魔人相关功能 | 低 | ⏳ 待处理 |

#### modmain/modglobal.lua

| 位置 | 类型 | 描述 | 优先级 | 状态 |
|------|------|------|--------|------|
| [L260](modmain/modglobal.lua#L260) | TODO | 未实现的功能 | 低 | ⏳ 待处理 |
| [L324](modmain/modglobal.lua#L324) | FIXME | 需要修复的问题 | 中 | ⏳ 待处理 |
| [L358](modmain/modglobal.lua#L358) | FIXME | 需要修复的问题 | 中 | ⏳ 待处理 |
| [L363](modmain/modglobal.lua#L363) | FIXME | 需要修复的问题 | 中 | ⏳ 待处理 |
| [L518-520](modmain/modglobal.lua#L518-L520) | TODO/FIXME | 函数内存优化（未彻底测试） | 中 | ⏳ 待处理 |

> **说明：** modglobal.lua 的待办涉及全局函数 Hook 和内存优化，属于底层架构改进。

#### modmain/containers.lua

| 位置 | 内容 | 风险等级 | 状态 |
|------|------|----------|------|
| [L2338](modmain/containers.lua#L2338) | 使用了覆写法（risky） | 高 | ⏳ 待处理 |

> **说明：** 覆写法存在兼容性风险，可能与其他模组冲突，需要评估替代方案。

---

### 📌 容器与背包

#### modmain/PostInit/backpack_piggyback.lua

| 位置 | 内容 | 风险等级 | 状态 |
|------|------|----------|------|
| [L209](modmain/PostInit/backpack_piggyback.lua#L209) | 危险行为，依赖官方实现顺序 | 高 | ⏳ 待处理 |

> **说明：** 此代码依赖官方监听器的顺序，官方更新可能导致功能失效。

#### modmain/PostInit/upgraded_containers.lua

| 位置 | 内容 | 优先级 | 状态 |
|------|------|--------|------|
| [L46](modmain/PostInit/upgraded_containers.lua#L46) | 确定 `numupgrades` 的作用 | 低 | ⏳ 待处理 |

---

### 📌 功能增强

#### modmain/AUXmods/other_auxiliary/better_beefalo.lua

| 位置 | 内容 | 优先级 | 状态 |
|------|------|--------|------|
| [L120](modmain/AUXmods/other_auxiliary/better_beefalo.lua#L120) | 设置为有训诫值的才不发情 | 中 | ⏳ 待处理 |
| [L227](modmain/AUXmods/other_auxiliary/better_beefalo.lua#L227) | 武器被人拿了的处理 | 中 | ⏳ 待处理 |
| [L240](modmain/AUXmods/other_auxiliary/better_beefalo.lua#L240) | 判断此处的合理性 | 中 | ⏳ 待处理 |

#### modmain/AUXmods/other_auxiliary/simple_garbage_collection/simple_garbage_collection2.lua

| 位置 | 内容 | 优先级 | 状态 |
|------|------|--------|------|
| [L214](modmain/AUXmods/other_auxiliary/simple_garbage_collection/simple_garbage_collection2.lua#L214) | 游戏内增减待删除物品列表 | 中 | ⏳ 待处理 |

---

### 📌 新功能计划

#### modmain/AUXmods/never_finish_series/application2.lua

| 位置 | 内容 | 优先级 | 状态 |
|------|------|--------|------|
| [L270](modmain/AUXmods/never_finish_series/application2.lua#L270) | 添加新动作：给予料理调味粉末，拥有调味料理的能力 | 中 | ⏳ 待处理 |

#### modmain/AUXmods/other_auxiliary/extra_equip_slots.lua

| 位置 | 内容 | 优先级 | 状态 |
|------|------|--------|------|
| [L228](modmain/AUXmods/other_auxiliary/extra_equip_slots.lua#L228) | 学习 brain 和 sg 后实现 | 低 | ⏳ 待处理 |

> **说明：** brain = 行为树系统，sg = 状态机系统，两者是 DST 角色行为的核心。

#### scripts/widgets/redux/more_instruction_book_page.lua

| 位置 | 内容 | 优先级 | 状态 |
|------|------|--------|------|
| [L16](scripts/widgets/redux/more_instruction_book_page.lua#L16) | 自动化生成功能 | 中 | ⏳ 待处理 |

#### scripts/definitions/mone/debugcommands.lua

| 位置 | 内容 | 优先级 | 状态 |
|------|------|--------|------|
| [L6](scripts/definitions/mone/debugcommands.lua#L6) | 设置模块内部环境（Lua 5.1 与 5.3 的 _ENV 差异） | 低 | ⏳ 待处理 |

---

### 📌 工具库优化

#### scripts/dep_utils/utils.lua

| 位置 | 内容 | 优先级 | 状态 |
|------|------|--------|------|
| [L248](scripts/dep_utils/utils.lua#L248) | easing.lua 已提供类似功能，考虑去重 | 低 | ⏳ 待处理 |

#### scripts/dep_utils/getprefab.lua

| 位置 | 内容 | 优先级 | 状态 |
|------|------|--------|------|
| [L214](scripts/dep_utils/getprefab.lua#L214) | boss 专属恐惧组件 epicscare 研究 | 中 | ⏳ 待处理 |
| [L1071](scripts/dep_utils/getprefab.lua#L1071) | 识别地图等界面的点击行为、添加施法距离、TheCamera 影响 | 中 | ⏳ 待处理 |

---

### 📌 武器/装备

#### modmain/AUXmods/more_equipments/scripts/prefabs/reforged/forge_books.lua

| 位置 | 内容 | 优先级 | 状态 |
|------|------|--------|------|
| [L21](modmain/AUXmods/more_equipments/scripts/prefabs/reforged/forge_books.lua#L21) | 提取为公共函数 | 低 | ⏳ 待处理 |
| [L38](modmain/AUXmods/more_equipments/scripts/prefabs/reforged/forge_books.lua#L38) | 重命名 | 低 | ⏳ 待处理 |
| [L46](modmain/AUXmods/more_equipments/scripts/prefabs/reforged/forge_books.lua#L46) | booktype 与 name 匹配 | 低 | ⏳ 待处理 |
| [L60](modmain/AUXmods/more_equipments/scripts/prefabs/reforged/forge_books.lua#L60) | seedling/flytrap 独立资源时移除此 if | 低 | ⏳ 待处理 |
| [L92](modmain/AUXmods/more_equipments/scripts/prefabs/reforged/forge_books.lua#L92) | 移动到 sound table | 低 | ⏳ 待处理 |
| [L103](modmain/AUXmods/more_equipments/scripts/prefabs/reforged/forge_books.lua#L103) | 公开后移除 if 语句 | 低 | ⏳ 待处理 |

#### modmain/AUXmods/more_equipments/scripts/prefabs/head/clairvoyantcrown.lua

| 位置 | 内容 | 优先级 | 状态 |
|------|------|--------|------|
| [L38](modmain/AUXmods/more_equipments/scripts/prefabs/head/clairvoyantcrown.lua#L38) | 效果对旺达也生效 | 中 | ⏳ 待处理 |

#### modmain/AUXmods/more_equipments/scripts/prefabs/reforged/fx/reforged_fx.lua

| 位置 | 内容 | 优先级 | 状态 |
|------|------|--------|------|
| [L5, 10, 11](modmain/AUXmods/more_equipments/scripts/prefabs/reforged/fx/reforged_fx.lua#L5) | TODO rename | 低 | ⏳ 待处理 |
| [L60](modmain/AUXmods/more_equipments/scripts/prefabs/reforged/fx/reforged_fx.lua#L60) | 需要附加到实体？ | 低 | ⏳ 待处理 |
| [L91](modmain/AUXmods/more_equipments/scripts/prefabs/reforged/fx/reforged_fx.lua#L91) | 是否被使用 | 低 | ⏳ 待处理 |

#### modmain/AUXmods/more_equipments/scripts/prefabs/reforged/pithpike.lua

| 位置 | 内容 | 优先级 | 状态 |
|------|------|--------|------|
| [L26](modmain/AUXmods/more_equipments/scripts/prefabs/reforged/pithpike.lua#L26) | 目标受击时发光黄色效果 | 低 | ⏳ 待处理 |

---

## 4️⃣ 主要待办列表 (TODOLISTS.md 摘要)

### 项目架构优化
- [ ] 整理整个项目结构
- [ ] 实现 `add_new_prefab` 函数，简化新物品添加流程
- [ ] 整理 scripts 中的代码，统一目录结构
- [ ] 统一文件前缀（除了 mi 和 mie）

### 容器功能优化
- [ ] 容器支持官方自带的堆叠功能
- [ ] 整理功能需要支持堆叠
- [ ] 优化自动分拣机性能
- [ ] 优化一键整理功能的卡顿问题

### 物品优化与重构 ⚠️【正在计划重构中】
- [ ] 升级版·雪球发射机
- [ ] 升级版·月晷
- [ ] 升级版·龙鳞火炉
- [ ] 强san素食堡
- [ ] 强心素食堡
- [ ] 暖胃汉堡包

### 新物品开发
- [ ] 鞭子远程隔空取物
- [ ] 冰冻狗王（月圆给予特殊物品）
- [ ] 枕头可以制作
- [ ] 制裁新界
- [ ] 奶奶催熟的两本书
- [ ] 回血标秒杀恶液
- [ ] 加速料理
- [ ] 腐蚀新界

### 功能增强
- [ ] 超级牛铃：牛死亡掉肉的 bug 修复
- [ ] 排除 `spe_pet` 标签
- [ ] 储藏柜增加弹性空间升级
- [ ] 素荤石材料修改，逆转显示优化
- [ ] 毒矛真实伤害完善

---

## 5️⃣ 待办分类统计

### 按优先级分类

| 优先级 | 数量 | 主要内容 |
|--------|------|----------|
| 🔴 高 | 3 | 食人花 bug、覆写法风险、依赖官方顺序 |
| 🟡 中 | 15+ | 各种功能完善、bug 修复 |
| 🟢 低 | 20+ | 代码清理、重命名、文档完善 |

### 按模块分类

| 模块 | 待办数量 | 主要文件 |
|------|----------|----------|
| 核心模块 | 10+ | modinfo.lua, modglobal.lua, containers.lua |
| 容器系统 | 3 | backpack_piggyback.lua, upgraded_containers.lua |
| 功能增强 | 5+ | better_beefalo.lua, garbage_collection.lua |
| 新功能 | 4 | application2.lua, extra_equip_slots.lua |
| 工具库 | 3 | utils.lua, getprefab.lua |
| 武器装备 | 10+ | forge_books.lua, clairvoyantcrown.lua, reforged_fx.lua |

---

## 6️⃣ 使用说明

### 更新状态

完成任务后，在对应条目的状态栏更新：

- ✅ 已完成
- ⏳ 进行中
- 🔄 待审查
- ❌ 已取消
- 📅 已计划

### 添加新待办

1. **代码注释：** 在相关位置添加 `TODO` 或 `FIXME` 注释
2. **DEFECTS.md：** 添加新发现的 bug
3. **TODOLISTS.md：** 添加新功能计划
4. **本文档：** 运行检索命令更新分类统计

### 检索命令

```bash
# 搜索所有 TODO/FIXME 注释
grep -r "TODO\|FIXME" --include="*.lua" .
```

---

## 7️⃣ 附录：快速跳转

### 核心文档
- [项目说明](README.md)
- [开发指南](CLAUDE.md)
- [添加物品步骤](NOTES.md)
- [更新日志](UPDATELOGS.md)

### 待办相关
- [主要待办列表](TODOLISTS.md)
- [已知缺陷](DEFECTS.md)
- [工具库待办](scripts/moreitems/lib/shihao2/todo.md)

### 代码库
- [核心模块](modmain/)
- [物品定义](scripts/prefabs/)
- [组件系统](scripts/components/)
- [工具库](scripts/chang_mone/)

---

**注意：** 本文档由自动化工具生成，手动更新时请保持格式一致性。
