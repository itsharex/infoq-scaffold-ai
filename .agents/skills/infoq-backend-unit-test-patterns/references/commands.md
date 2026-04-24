# 命令清单

## 定向类测试

```bash
mvn -pl infoq-modules/infoq-system -am \
  -DskipTests=false \
  -Dsurefire.failIfNoSpecifiedTests=false \
  -Dtest=<ClassNameTest> test
```

## 定向 Mapper XML 集成测试

```bash
mvn -pl infoq-modules/infoq-system -am \
  -DskipTests=false \
  -Dsurefire.failIfNoSpecifiedTests=false \
  -Dtest=Sys*MapperXmlIntegrationTest test
```

## 单个 Mapper XML 集成测试类

```bash
mvn -pl infoq-modules/infoq-system -am \
  -DskipTests=false \
  -Dsurefire.failIfNoSpecifiedTests=false \
  -Dtest=SysUserMapperXmlIntegrationTest test
```

## 多类联合测试

```bash
mvn -pl infoq-modules/infoq-system -am \
  -DskipTests=false \
  -Dsurefire.failIfNoSpecifiedTests=false \
  -Dtest=ClassATest,ClassBTest,ClassCTest test
```

## 模块全量测试

```bash
mvn -pl infoq-modules/infoq-system -am -DskipTests=false test
```

## 覆盖缺口扫描（类级）

```bash
python3 - <<'PY'
import pathlib
root = pathlib.Path('infoq-modules/infoq-system/src/main/java/cc/infoq/system')
test_root = pathlib.Path('infoq-modules/infoq-system/src/test/java/cc/infoq/system')
tests = {p.stem[:-4] for p in test_root.rglob('*Test.java') if p.stem.endswith('Test')}
for rel in ['controller', 'service/impl']:
    classes = [p.stem for p in (root / rel).rglob('*.java')]
    missing = sorted([c for c in classes if c not in tests])
    print(rel, 'missing=', len(missing))
    if missing:
        print('  ' + ', '.join(missing))
PY
```

## 打包与冒烟

```bash
mvn -pl infoq-modules/infoq-system -am clean package -P dev -DskipTests=false
bash .agents/skills/infoq-backend-smoke-test/scripts/run_smoke.sh
```
