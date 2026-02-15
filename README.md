# More Items (更多物品)

一个全面的 Don't Starve Together 模组，添加了 100+ 新物品、增强容器、装备和生活质量功能。

## 基本信息

- **作者：** 心悦卿兮
- **当前版本：** 6.0.7
- **Steam Workshop ID：** 2916137510
- **扩展包 ID：** 2928706576
- **反馈群：** 592159151

## 项目简介

本模组为《饥荒：联机版》添加了大量新内容，包括：

- **新物品** - 100+ 种全新道具
- **增强容器** - 升级版箱子、背包等存储解决方案
- **新装备** - 武器、护甲、帽子
- **生活质量** - 自动整理、升级建筑等便利功能

## 项目结构

```
MoreItems/
├── modmain.lua           # 主入口
├── modinfo.lua           # 模组配置
├── modtuning.lua         # 运行时配置
├── modmain/              # 核心逻辑
│   ├── PostInit/         # 后初始化修改
│   ├── init/             # 初始化辅助
│   └── AUXmods/          # 条件加载模块
├── scripts/
│   ├── components/       # 自定义组件
│   ├── prefabs/          # 物品定义
│   ├── chang_mone/       # API 和工具
│   └── moreitems/        # 核心库
├── images/               # 资源文件
└── update_logs/          # 更新日志
└── docs/                 # 开发文档
└── .achieved_files/      # 历史文档
```

## 开发相关

- [CLAUDE.md](CLAUDE.md) - 项目开发指南和架构说明
- [docs/dst-mod-development-guide.md](docs/dst-mod-development-guide.md) - DST 模组开发最佳实践
- [.achieved_files/NOTES.md](.achieved_files/NOTES.md) - 添加新物品的步骤说明
- [.achieved_files/TODO_TRACKER.md](.achieved_files/TODO_TRACKER.md) - 待办事项追踪
- [.achieved_files/TODOLISTS.md](.achieved_files/TODOLISTS.md) - 功能计划
- [.achieved_files/UPDATELOGS.md](.achieved_files/UPDATELOGS.md) - 版本更新日志

## 最近更新

### v6.0.7 (当前版本)

完整更新日志请查看 [.achieved_files/UPDATELOGS.md](.achieved_files/UPDATELOGS.md)

## 许可证

本模组为 Don't Starve Together 的非官方修改，遵循 Klei Entertainment 的模组使用条款。
