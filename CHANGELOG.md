# Changelog

本文件记录项目的所有重要变更。

格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，
版本号遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

## [Unreleased]

### Added
- 为五格装备栏添加弃用通告功能
- 为简易全球定位添加自动检测和弃用通告功能
- 五格装备栏自动检测并禁用冲突功能
- 施肥机器人添加自动获取肥料功能
- 配方系统支持条件判断的资源路径加载
- 为 mie_ 开头的配方添加中文注释
- 为豪华箱子配方添加中文注释

### Changed
- 统一汉堡属性，暖胃和强san汉堡每次增加10点（之前不一致）
- 重构三种汉堡组件，合并重复代码
- 重命名 `__init__.lua` 为 `init.lua`
- 抽取弃用功能通用模块，统一弃用通告逻辑
- 提取配方资源到独立文件 `modmain/recipes_assets.lua` 便于批量修改
- 完善配方资源文件，添加物品名称注释
- 清理旧资源定义并重命名资源文件

### Removed
- 施肥机器人移除 fueled 组件和耐久系统
- 删除 `modmain/logger.lua` 文件
- 清理 `scripts/moreitems` 目录下的测试和文档文件
- 移除配方注册调试日志（开发完成后清理）

### Fixed
- 修复施肥机器人代码语法错误
- 修复施肥机器人只对移植植物施肥的问题（扩大到所有植物）
- 修复施肥机器人距离计算使用正确的 API
- 修复施肥机器人距离计算函数调用错误
- 修复施肥机器人 spawnpoint 初始化逻辑
- 修复施肥机器人回家逻辑
- 修复施肥机器人 Brain 类定义缺失
- 修复施肥机器人容器设置问题
- 修正施肥瓦器人的容器标签检查
- 修复施肥机器人 brain 中的 UnignoreItem 调用错误
- 修复施肥机器人 knownlocations 和物品贴图配置
- 修复施肥机器人使用正确的 knownlocations API
- 修复强san汉堡和暖胃汉堡换人数据丢失问题
- 修复强san和暖胃汉堡字段映射错误
- 修复暖胃汉堡包换人继承功能无效的bug
- 修复动态方法定义语法错误
- 修复资源文件 require 路径错误

### Docs
- 将 CLAUDE.md 翻译为中文
- 更新 CLAUDE.md，添加常量系统和属性提升物品模式说明
- 为 mone_ 开头的配方添加中文注释
- 为 rmi_ 开头的配方添加中文注释

### Refactor
- 第一轮大刀阔斧地重构项目结构
- 第二轮大刀阔斧地重构项目结构
- 第三轮大刀阔斧地重构项目结构（特别标注项目结构重构）
- 第四轮大刀阔斧地重构项目结构

### Chore
- 添加 `.qoder` 到 `.gitignore` 排除列表
- 添加 Windows 特殊文件 `nul` 到 `.gitignore`
- OpenCode + Kimi K2.5 Free + AGENTS.md 配置更新

---

## 版本说明

- **[Unreleased]** - 正在开发中，尚未发布的版本
- 每个版本号对应一个稳定发布版本

## 变更类型说明

- **Added** - 新增功能
- **Changed** - 功能变更
- **Deprecated** - 即将废弃的功能
- **Removed** - 已删除的功能
- **Fixed** - Bug 修复
- **Security** - 安全性相关修复
