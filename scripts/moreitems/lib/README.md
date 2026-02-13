# MoreItems 库目录结构说明

本文档介绍 `scripts/moreitems/lib` 目录下的文件结构和功能。

## 目录概述

`scripts/moreitems/lib` 目录包含五个主要子目录，每个目录都有其特定的功能和用途：

- **dst**: Don't Starve Together 相关的工具类和函数
- **shard**: 跨服务器(shard)通信相关功能
- **shihao**: 基础函数库和类库(第一版)
- **shihao2**: 基础函数库和类库(第二版，重构版)
- **thirdparty**: 第三方 Lua 库

## 各子目录功能详解

### 1. dst 目录
**功能**：提供 Don't Starve Together (DST) 游戏专用工具和类

**核心组件**：
- `dst_utils.lua`：服务器/客户端检测、预制体验证、配置管理
- `class/Prefab.lua` 和 `class/Recipe.lua`：游戏对象类定义
- `dst_service.lua`：DST 服务相关功能

**用途**：直接与 DST 游戏引擎交互的底层工具集

### 2. shard 目录
**功能**：处理多服务器环境（洞穴与主服务器）间的数据同步

**核心组件**：
- `sync_rpc.lua`：跨服务器 RPC 调用辅助函数

**用途**：解决 DST 多服务器环境下的数据同步问题，如玩家数据在跨服时的传输

### 3. shihao 目录
**功能**：基础函数库（第一版），提供类似 C++ STL 的功能

**核心组件**：
- `module/`：模块化功能库（字符串、表、协程处理等）
- `class/`：类库定义（命名元组、可选值、INI 解析器）
- `unittest.lua`：单元测试框架

**用途**：提供项目的基础功能和工具函数

### 4. shihao2 目录
**功能**：基础函数库（第二版，重构版），更模块化的设计

**核心组件**：
- `utils/`：各类工具函数（字符串、表、协程、调试）
- `instances/`：实例管理（单例模式）
- `prototypes/`：原型实现（HashMap、HashSet）
- `pythons/`：Python 特性的 Lua 实现

**用途**：shihao 库的升级版，提供更现代的模块化设计

### 5. thirdparty 目录
**功能**：集成第三方 Lua 库

**核心组件**：
- `lustache`：Mustache 模板引擎
- `inspect`：数据结构打印库
- `json` 和 `dkjson`：JSON 解析库
- `middleclass`：面向对象编程库
- `luafun`：函数式编程库

**用途**：为项目提供额外的功能支持

## 模块间依赖关系

```
thirdparty (最底层)
    ↑
shihao / shihao2 (基础功能层)
    ↑
dst / shard (应用层)
```

### 依赖详情
- **dst** 模块依赖: `shihao.base`, `thirdparty.inspect`, `thirdparty.middleclass`
- **shard** 模块依赖: `shihao.base`
- **shihao** 模块依赖: `thirdparty.lustache`, `thirdparty.inspect`
- **shihao2** 模块基本独立，但设计上可能依赖第三方库

### 避免循环依赖的设计
1. 父目录不允许依赖子目录
2. 同级目录间的共享代码放入 `__shared__.lua`
3. module 目录下的文件尽量只依赖 base.lua
4. 使用延迟 require 的方式避免循环依赖

## 架构特点

1. **模块化设计**: 清晰的模块划分和职责分离
2. **分层结构**: 从底层第三方库到上层应用功能的分层设计
3. **功能复用**: shihao/shihao2 提供基础功能，dst/shard 提供特定领域的功能
4. **测试友好**: 内置单元测试框架，便于模块测试

## 设计思想

1. **借鉴最佳实践**: 参考 Python 的包结构和命名约定
2. **关注依赖管理**: 特别强调避免循环依赖
3. **渐进式重构**: 从 shihao 到 shihao2 的演进
4. **文档完善**: 包含详细的 readme 和 todo 文件

## 总结

这个库目录展示了一个结构良好的 Lua 代码库，专门为 Don't Starve Together 模组开发提供支持。整体架构清晰，模块职责明确，特别关注依赖管理和代码复用。shihao 和 shihao2 的演进体现了作者对代码质量的持续追求，而丰富的第三方库集成则提供了强大的功能支持。

该架构设计对于类似的 Lua 项目具有良好的参考价值，特别是在模块化设计和依赖管理方面的实践经验。