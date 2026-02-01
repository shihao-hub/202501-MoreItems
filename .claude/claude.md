我希望你在每次修改后，使用 git 提交一下（git 未初始化则初始化和创建 .gitignore 文件 | 用中文 commit），格式可参考：

````markdown
# Git Commit Message 规范

## 格式

```
<type>(<scope>): <subject>

<body>

<footer>
```

## Type 类型

| 类型 | 说明 | 示例 |
|------|------|------|
| `feat` | 新功能 | feat(metrics): 集成 Prometheus 指标收集 |
| `fix` | Bug 修复 | fix(auth): 修复 JWT 过期时间计算错误 |
| `docs` | 文档变更 | docs(api): 更新接口文档 |
| `style` | 代码格式（不影响功能） | style: 格式化代码 |
| `refactor` | 重构（非新功能、非修复） | refactor(creator): 重构达人查询逻辑 |
| `perf` | 性能优化 | perf(db): 优化批量查询性能 |
| `test` | 测试相关 | test(service): 添加 TiktokCreatorService 单元测试 |
| `chore` | 构建/工具变更 | chore(deps): 升级 LangChain 依赖 |
| `ci` | CI/CD 配置 | ci: 添加 GitHub Actions 工作流 |
| `revert` | 回滚提交 | revert: 回滚 feat(xxx) |

## Scope 作用域

基于项目模块划分：

| Scope | 说明 |
|-------|------|
| `creator` | 达人模块 |
| `product` | 商品模块 |
| `ads` | 广告模块 |
| `market` | 市场洞察模块 |
| `favorites` | 收藏模块 |
| `submission` | 达人提报模块 |
| `collection` | 采集模块 |
| `auth` | 认证授权 |
| `db` | 数据库相关 |
| `redis` | Redis 缓存 |
| `metrics` | 监控指标 |
| `middleware` | 中间件 |
| `config` | 配置相关 |
| `deps` | 依赖管理 |
| `api` | API 接口 |
| `worker` | Celery 任务 |

## Subject 标题

- 使用中文描述
- 不超过 50 个字符
- 不以句号结尾
- 使用祈使语气（动词开头）

**动词参考**：添加、修复、优化、重构、移除、更新、升级、集成

## Body 正文

- 使用中文
- 每行不超过 72 个字符
- 说明 **是什么** 和 **为什么**，而非 **怎么做**
- 使用 `-` 列表格式

## 示例

### 新功能

```
feat(metrics): 集成 Prometheus 指标收集

- 新增 /metrics 端点暴露 Prometheus 格式指标
- 在请求日志中间件中自动收集 API 请求指标
- 在 ORM 装饰器中自动收集数据库查询指标
- 新增运维接入文档 docs/prometheus_metrics.md
```

### Bug 修复

```
fix(creator): 修复达人列表分页查询总数错误

- 修复 count 查询未应用筛选条件的问题
- 添加单元测试覆盖边界情况
```

### 重构

```
refactor(submission): 重构提报任务状态机

- 将状态流转逻辑抽离到独立的 StateMachine 类
- 简化 Service 层代码，提高可测试性
- 保持 API 接口签名不变
```

### 性能优化

```
perf(db): 优化达人批量查询性能

- 使用 IN 查询替代多次单条查询
- 添加复合索引 (platform, status)
- 查询耗时从 2s 降低到 200ms
```

### 文档

```
docs(api): 更新达人提报接口文档

- 补充请求/响应示例
- 添加错误码说明
```

## 特殊情况

### 多模块变更

当变更涉及多个模块时，scope 可省略或使用通用词：

```
feat: 添加读写分离架构支持

- Product 模块迁移到只读数据源
- Creator 模块迁移到只读数据源
- 新增 get_tec_holo_readonly_db 依赖注入
```

### Breaking Change

在 footer 中标注：

```
feat(api)!: 重构达人列表接口响应格式

- 将 items 字段重命名为 data
- 添加 pagination 对象

BREAKING CHANGE: 响应格式变更，前端需同步更新
```

### 关联 Issue

```
fix(auth): 修复登录超时问题

- 延长 token 有效期到 24 小时

Closes #123
```


````

---

我希望你在每次修改后，更新项目的 README.md 文件（没有则创建）

---

我希望你在每次修改后，根据当前项目的结构，考虑是否需要更新 .gitignore 文件

---

我希望你尽量用中文回答问题

---



