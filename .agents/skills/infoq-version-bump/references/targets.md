# 受管目标

## 版本字段更新范围

- `infoq-scaffold-backend/pom.xml`
  - 根 `<revision>`
- `infoq-scaffold-backend/infoq-core/infoq-core-bom/pom.xml`
  - BOM `<revision>`
- `infoq-scaffold-frontend-react/package.json`
  - 顶层 `"version"`
- `infoq-scaffold-frontend-vue/package.json`
  - 顶层 `"version"`
- `README.md`
  - `![Version](https://img.shields.io/badge/Version-x.y.z-...)`
- `doc/docker-compose-deploy.md`
  - `当前文档对应项目基线版本为 \`x.y.z\`。`
- `script/docker/docker-compose.yml`
  - `infoq/infoq-admin:x.y.z`
  - `infoq/infoq-frontend-vue:x.y.z`
  - `infoq/infoq-frontend-react:x.y.z`
- `infoq-scaffold-backend/infoq-plugin/infoq-plugin-doc/src/test/java/cc/infoq/common/doc/config/SpringDocConfigTest.java`
  - `info.setVersion("x.y.z")`
  - `assertEquals("x.y.z", openAPI.getInfo().getVersion())`
- `infoq-scaffold-backend/infoq-plugin/infoq-plugin-doc/src/test/java/cc/infoq/common/doc/config/properties/SpringDocPropertiesTest.java`
  - `info.setVersion("x.y.z")`
  - `assertEquals("x.y.z", properties.getInfo().getVersion())`

## SQL 文件名护栏

此技能不会自动重命名 SQL 文件。

它会校验以下文件是否仍引用当前实际存在的 SQL 初始化文件：

- `README.md`
- `doc/docker-compose-deploy.md`
- `script/bin/infoq.sh`
- `script/docker/docker-compose.yml`
- `.agents/skills/infoq-project-reference/references/project-reference.md`

若这些引用与 `sql/` 下真实文件不一致，脚本会失败，并要求显式后续任务处理。

## 非目标

- 不重命名 `sql/infoq_scaffold_*.sql`
- 不更新依赖版本（如第三方包或框架版本）
- 不修改 lockfile
- 不执行 release、deploy 或镜像推送步骤
