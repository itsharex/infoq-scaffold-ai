---
name: infoq-version-bump
description: 在本仓库内统一升级项目版本，覆盖后端 Maven revision、前端 package 版本、Docker 镜像标签、发布文档与版本断言。适用于升级版本号、发布到指定 x.y.z、同步 README/docker/pom/package 版本等仓库级版本升级需求。默认策略保持现有 SQL 初始化文件名不变，除非用户明确提出独立 SQL 文件改名任务。
---

# Infoq 版本升级

## 执行

执行：

```bash
bash .agents/skills/infoq-version-bump/scripts/bump_version.sh 2.0.3
```

常用变体：

```bash
# Preview checks without editing files
bash .agents/skills/infoq-version-bump/scripts/bump_version.sh --dry-run 2.0.3

# Run against another checkout or a temporary fixture
bash .agents/skills/infoq-version-bump/scripts/bump_version.sh \
  --repo-root /path/to/infoq-scaffold-ai \
  2.0.3
```

## 本技能会修改什么

脚本仅更新仓库内受管的发布版本字段：

- `infoq-scaffold-backend/pom.xml`
- `infoq-scaffold-backend/infoq-core/infoq-core-bom/pom.xml`
- `infoq-scaffold-frontend-react/package.json`
- `infoq-scaffold-frontend-vue/package.json`
- `README.md` version badge
- `doc/docker-compose-deploy.md`
- `script/docker/docker-compose.yml`
- `infoq-scaffold-backend/infoq-plugin/infoq-plugin-doc/.../SpringDocConfigTest.java`
- `infoq-scaffold-backend/infoq-plugin/infoq-plugin-doc/.../SpringDocPropertiesTest.java`

## 默认 SQL 策略

- 从 `sql/infoq_scaffold_*.sql` 识别当前 SQL 初始化文件。
- 保持该文件名不变。
- 校验 README、部署文档、后端部署脚本、docker compose、项目参考仍指向同一 SQL 文件。
- 若 SQL 引用漂移，必须显式失败，禁止在用户不知情时改名 SQL 文件。

这是本仓库的明确策略：项目版本升级与 SQL 基线文件重命名是两个独立决策。

## 失败规则

以下任一条件成立时立即失败：

- 目标版本不符合 `x.y.z`
- 无法解析仓库根目录
- 缺少必需目标文件
- `sql/infoq_scaffold_*.sql` 文件数量为 0 或大于 1
- SQL 引用与识别出的 SQL 文件不一致
- 任一受管版本字段替换后无法校验

## 验证

真实执行后：

```bash
bash .agents/skills/infoq-version-bump/scripts/test_bump_version.sh
```

升级后可选的项目级检查：

```bash
rg -n "2\\.0\\.3" README.md doc script infoq-scaffold-backend infoq-scaffold-frontend-react infoq-scaffold-frontend-vue
mvn -pl infoq-plugin/infoq-plugin-doc -am -DskipTests=false -Dsurefire.failIfNoSpecifiedTests=false -Dtest=SpringDocConfigTest,SpringDocPropertiesTest test
```

## 参考资源

- 受管目标与护栏：`references/targets.md`
- 主脚本：`scripts/bump_version.sh`
- 脚本回归冒烟：`scripts/test_bump_version.sh`
