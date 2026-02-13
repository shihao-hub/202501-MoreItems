# 变更日志

## [当前版本] - 2024-02-13

### 新增
- feat(fertilizer-bot): 添加施肥机器人自动获取肥料功能
- feat(fertilizer-bot): 实现施肥瓦器人
- feat: 统一汉堡属性，暖胃和强san汉堡每次增加10点
- feat: 简易全球定位自动检测和弃用通告
- feat: 五格装备栏自动检测并禁用
- feat: 为五格装备栏添加弃用通告
- feat(assets): 支持条件判断的资源路径

### 修复
- fix(fertilizer-bot): 修复施肥机器人代码语法错误
- fix(fertilizer-bot): 修复施肥机器人只对移植植物施肥的问题
- fix(fertilizer_bot): 修复距离计算使用正确的 API
- fix(fertilizer_bot): 修复距离计算函数调用
- fix(fertilizer_bot): 修复 spawnpoint 初始化逻辑
- fix(fertilizer_bot): 修复回家逻辑并添加调试日志
- fix(fertilizer_bot): 注释掉 OnUpdateFueled 调用
- fix(fertilizer_bot): 修复 knownlocations 和物品贴图配置
- fix(fertilizer_bot): 修复 brain 中的 UnignoreItem 调用错误
- fix(fertilizer_bot): 删除 brain 中的 OnInitializationComplete 方法
- fix(fertilizer_bot): 使用正确的 knownlocations API
- fix(fertilizer_bot): 删除无用的 UnignoreItem 调用
- fix(fertilizer_bot): 恢复 INV_IMAGE Asset 配置
- fix(fertilizer_bot): 暂时注释掉缺失的 INV_IMAGE Asset
- fix(fertilizer_bot): 修复容器设置问题
- fix(fertilizer-bot): 修复 Brain 类定义缺失
- fix(containers): 修正施肥瓦器人的容器标签检查
- fix(hamburgers): 修复强san和暖胃汉堡字段映射错误
- fix(hamburgers): 尝试使用 SetCurrent 方法触发 sanity/hunger 事件
- fix(hamburgers): 使用 DoDelta 触发事件确保 save_fields 更新
- fix(hamburgers): 修复强san汉堡和暖胃汉堡换人数据丢失
- fix(hamburgers): 删除错误的硬编码配置行
- fix(hamburgers): 修复强san和暖胃汉堡换人继承功能
- fix: 修复暖胃汉堡包换人继承功能无效的bug
- fix: 修复动态方法定义语法错误
- fix(recipes): 修正资源文件 require 路径

### 重构
- refactor: 清理scripts/moreitems目录下的测试和文档文件
- refactor: 重命名__init__.lua为init.lua
- refactor: 第四轮大刀阔斧地重构
- refactor(项目结构): 第三轮大刀阔斧地重构
- refactor: 第二轮大刀阔斧地重构
- refactor: 第一轮大刀阔斧地重构
- refactor(recipes): 清理旧资源定义并重命名资源文件
- refactor(recipes): 完善配方资源文件，添加物品名称注释
- refactor(recipes): 提取配方资源到独立文件便于批量修改
- refactor: 抽取弃用功能通用模块

### 文档
- docs: 将 CLAUDE.md 翻译为中文
- docs: 更新 CLAUDE.md，添加常量系统和属性提升物品模式说明

### 构建/工具
- chore: 删除modmain/logger.lua文件
- chore: 添加.qoder到.gitignore排除列表
- chore: OpenCode + Kimi K2.5 Free + AGENTS.md
- chore: 忽略 Windows 特殊文件 nul

### 恢复
- Revert "fix(fertilizer_bot): 修复施肥动作不执行问题"
- Revert "fix(hamburgers): 修复强san和暖胃汉堡换人数据丢失问题"
- revert(fertilizer_bot): 恢复 INV_IMAGE Asset 配置