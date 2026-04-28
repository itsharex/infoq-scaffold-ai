# Docker Compose 部署说明

本文档以当前仓库的 `script/docker/docker-compose.yml` 为准，只保留现有工程真正可执行的部署入口。
当前文档对应项目基线版本为 `2.1.0`。

如果你需要的是完整部署前检查或非 Docker 的手动部署流程，请先阅读：

- [项目部署前准备](./deploy-prerequisites.md)
- [手动部署说明](./manual-deploy.md)

默认宿主机根目录是 `/infoq`。如果是在 macOS 本机配合 Docker Desktop 验证，建议先设置：

```bash
export INFOQ_DEPLOY_ROOT=/tmp/infoq-deploy
```

然后再执行后续脚本或 `docker compose` 命令。

## 1. 准备宿主机目录

先按 [script/docker/redis/data/README.md](../script/docker/redis/data/README.md) 创建 `${INFOQ_DEPLOY_ROOT:-/infoq}/...` 目录。

最少要有：

```text
/infoq/mysql/data
/infoq/mysql/conf
/infoq/redis/conf
/infoq/redis/data
/infoq/minio/data
/infoq/server/config
/infoq/server/logs
/infoq/server/temp
/infoq/nginx/cert
/infoq/nginx/conf
/infoq/nginx/log
/infoq/vue/logs
/infoq/react/logs
```

其中 `${INFOQ_DEPLOY_ROOT:-/infoq}/server/config/application-prod.yml` 会在首次执行 `bash script/bin/infoq.sh prepare` 时自动生成一份 Docker Compose 默认模板。
`bash script/bin/infoq.sh deploy` 会在启动 MySQL / Redis 后等待依赖就绪，并在检测到 `infoq` 库缺表时自动导入 `sql/infoq_scaffold_2.0.0.sql`。
同时会为本次部署生成一个 `INFOQ_QUARTZ_BOOTSTRAP_DEPLOY_ID`，默认格式为 `版本号-日期-序号`，例如 `2.1.0-20260427-001`，并注入到 `infoq-admin`，用于保证生产环境 `sysJobService.init()` 在同一批部署节点中只执行一次。

## 2. 首次部署后端

```bash
export INFOQ_DEPLOY_ROOT=/tmp/infoq-deploy
bash script/bin/infoq.sh prepare
bash script/bin/infoq.sh deploy
```

常用命令：

```bash
bash script/bin/infoq.sh status
bash script/bin/infoq.sh logs infoq-admin
bash script/bin/infoq.sh restart
bash script/bin/infoq.sh stop
```

后端服务端口：

- `infoq-admin`: `9090`

说明：

- 首次空数据目录启动时，MySQL 容器会自动执行 `sql/infoq_scaffold_2.0.0.sql`
- 如果数据目录已存在，但 `infoq` 库表未初始化，`deploy` / `start` 也会补导一次 SQL
- `deploy` 会生成新的 `INFOQ_QUARTZ_BOOTSTRAP_DEPLOY_ID`，格式为 `版本号-日期-序号`，表示一轮新的部署批次
- `start` 与 `restart` 只会复用现有容器环境，不会生成新的部署批次 ID；如果你需要触发“下一次部署只执行一次”的初始化语义，请使用 `deploy`，或显式提供新的 `INFOQ_QUARTZ_BOOTSTRAP_DEPLOY_ID`
- 如果同一版本在同一天需要再次发布，请由流水线或运维统一显式设置 `INFOQ_QUARTZ_BOOTSTRAP_DEPLOY_SEQUENCE=002`，或直接设置完整的 `INFOQ_QUARTZ_BOOTSTRAP_DEPLOY_ID=2.1.0-20260427-002`，并确保同一批节点保持一致

## 3. 首次部署前端

```bash
export INFOQ_DEPLOY_ROOT=/tmp/infoq-deploy
bash script/bin/deploy-frontend.sh prepare
bash script/bin/deploy-frontend.sh deploy
```

常用命令：

```bash
bash script/bin/deploy-frontend.sh status
bash script/bin/deploy-frontend.sh logs all
bash script/bin/deploy-frontend.sh restart
bash script/bin/deploy-frontend.sh stop
```

前端访问方式：

- 网关入口：`http://host/vue/`
- 网关入口：`http://host/react/`
- Vue 直连端口：`9091`
- React 直连端口：`9092`

前端日志目录：

- Vue：`/infoq/vue/logs`
- React：`/infoq/react/logs`
- 网关 Nginx：`/infoq/nginx/log`

## 4. 日常启动步骤

如果镜像已经构建过，且宿主机目录、数据库数据都还在，只需要执行启动命令，不必重新 `deploy`。

```bash
export INFOQ_DEPLOY_ROOT=/tmp/infoq-deploy

# 先启动后端依赖与 infoq-admin
bash script/bin/infoq.sh start

# 再启动 Vue / React / nginx-web
bash script/bin/deploy-frontend.sh start
```

启动完成后可访问：

- `http://host/vue/`
- `http://host/react/`
- `http://host/prod-api/`

说明：

- `bash script/bin/infoq.sh start` 适用于“启动已有容器”，不会触发新的部署批次。
- 如果你是发布新包、希望生产环境重新执行一次受控 Quartz reconcile，应执行 `bash script/bin/infoq.sh deploy`，或者在直接使用 `docker compose` 时显式设置新的 `INFOQ_QUARTZ_BOOTSTRAP_DEPLOY_ID`。

## 5. 日常停止步骤

建议先停前端和网关，再停后端与基础服务：

```bash
export INFOQ_DEPLOY_ROOT=/tmp/infoq-deploy

# 先停止 Vue / React / nginx-web
bash script/bin/deploy-frontend.sh stop

# 再停止 infoq-admin / mysql / redis / minio
bash script/bin/infoq.sh stop
```

## 6. 常用运维命令

查看状态：

```bash
export INFOQ_DEPLOY_ROOT=/tmp/infoq-deploy
bash script/bin/infoq.sh status
bash script/bin/deploy-frontend.sh status
```

查看日志：

```bash
export INFOQ_DEPLOY_ROOT=/tmp/infoq-deploy
bash script/bin/infoq.sh logs infoq-admin
bash script/bin/deploy-frontend.sh logs all
```

重启服务：

```bash
export INFOQ_DEPLOY_ROOT=/tmp/infoq-deploy
bash script/bin/infoq.sh restart
bash script/bin/deploy-frontend.sh restart
```

## 7. 如需直接使用 docker compose

```bash
export INFOQ_QUARTZ_BOOTSTRAP_DEPLOY_ID="2.1.0-20260427-001"
docker compose -f script/docker/docker-compose.yml up -d --build
docker compose -f script/docker/docker-compose.yml ps
docker compose -f script/docker/docker-compose.yml logs -f infoq-admin
```

直接使用 `docker compose` 时，建议保证 `${INFOQ_DEPLOY_ROOT:-/infoq}/mysql/data` 为空目录，以便 MySQL 首次启动时自动执行初始化 SQL。
如果是多节点部署，同一批节点必须使用相同的 `INFOQ_QUARTZ_BOOTSTRAP_DEPLOY_ID`。如果同一版本在同一天需要重复部署，建议递增最后三位序号，例如从 `2.1.0-20260427-001` 调整为 `2.1.0-20260427-002`。
