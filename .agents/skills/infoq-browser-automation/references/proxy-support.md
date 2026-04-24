# 代理支持

用于地理测试、规避限流与企业网络环境的代理配置说明。

**关联文档**：[commands.md](commands.md)（全局参数），[SKILL.md](../SKILL.md)（快速入口）。

## 目录

- 基础代理配置
- 认证代理
- SOCKS 代理
- 代理绕过
- 常见使用场景
- 验证代理连接
- 故障排查
- 最佳实践

## 基础代理配置

使用 `--proxy` 参数或通过环境变量设置代理：

```bash
# 通过 CLI 参数
agent-browser --proxy "http://proxy.example.com:8080" open https://example.com

# 通过环境变量
export HTTP_PROXY="http://proxy.example.com:8080"
agent-browser open https://example.com

# HTTPS 代理
export HTTPS_PROXY="https://proxy.example.com:8080"
agent-browser open https://example.com

# 同时设置 HTTP/HTTPS
export HTTP_PROXY="http://proxy.example.com:8080"
export HTTPS_PROXY="http://proxy.example.com:8080"
agent-browser open https://example.com
```

## 认证代理

适用于需要鉴权的代理：

```bash
# 在 URL 中包含鉴权信息
export HTTP_PROXY="http://username:password@proxy.example.com:8080"
agent-browser open https://example.com
```

## SOCKS 代理

```bash
# SOCKS5 代理
export ALL_PROXY="socks5://proxy.example.com:1080"
agent-browser open https://example.com

# 带鉴权的 SOCKS5
export ALL_PROXY="socks5://user:pass@proxy.example.com:1080"
agent-browser open https://example.com
```

## 代理绕过

可通过 `--proxy-bypass` 或 `NO_PROXY` 为特定域名绕过代理：

```bash
# 通过 CLI 参数
agent-browser --proxy "http://proxy.example.com:8080" --proxy-bypass "localhost,*.internal.com" open https://example.com

# 通过环境变量
export NO_PROXY="localhost,127.0.0.1,.internal.company.com"
agent-browser open https://internal.company.com  # 直连
agent-browser open https://external.com          # 走代理
```

## 常见使用场景

### 地理位置测试

```bash
#!/bin/bash
# 使用地理代理测试不同地区访问效果

PROXIES=(
    "http://us-proxy.example.com:8080"
    "http://eu-proxy.example.com:8080"
    "http://asia-proxy.example.com:8080"
)

for proxy in "${PROXIES[@]}"; do
    export HTTP_PROXY="$proxy"
    export HTTPS_PROXY="$proxy"

    region=$(echo "$proxy" | grep -oP '^\w+-\w+')
    echo "测试区域: $region"

    agent-browser --session "$region" open https://example.com
    agent-browser --session "$region" screenshot "./screenshots/$region.png"
    agent-browser --session "$region" close
done
```

### 轮换代理抓取

```bash
#!/bin/bash
# 轮换代理池以规避限流

PROXY_LIST=(
    "http://proxy1.example.com:8080"
    "http://proxy2.example.com:8080"
    "http://proxy3.example.com:8080"
)

URLS=(
    "https://site.com/page1"
    "https://site.com/page2"
    "https://site.com/page3"
)

for i in "${!URLS[@]}"; do
    proxy_index=$((i % ${#PROXY_LIST[@]}))
    export HTTP_PROXY="${PROXY_LIST[$proxy_index]}"
    export HTTPS_PROXY="${PROXY_LIST[$proxy_index]}"

    agent-browser open "${URLS[$i]}"
    agent-browser get text body > "output-$i.txt"
    agent-browser close

    sleep 1  # 礼貌延迟
done
```

### 企业网络访问

```bash
#!/bin/bash
# 通过企业代理访问内外网

export HTTP_PROXY="http://corpproxy.company.com:8080"
export HTTPS_PROXY="http://corpproxy.company.com:8080"
export NO_PROXY="localhost,127.0.0.1,.company.com"

# 外网走代理
agent-browser open https://external-vendor.com

# 内网绕过代理
agent-browser open https://intranet.company.com
```

## 验证代理连接

```bash
# 检查出口 IP
agent-browser open https://httpbin.org/ip
agent-browser get text body
# 应显示代理出口 IP，而非本机真实 IP
```

## 故障排查

### 代理连接失败

```bash
# 先验证代理连通性
curl -x http://proxy.example.com:8080 https://httpbin.org/ip

# 若代理需要鉴权，补充账号密码
export HTTP_PROXY="http://user:pass@proxy.example.com:8080"
```

### 通过代理出现 SSL/TLS 错误

部分代理会执行 SSL 检查。若遇到证书错误：

```bash
# 仅用于测试，不建议生产使用
agent-browser open https://example.com --ignore-https-errors
```

### 性能缓慢

```bash
# 仅在必要场景走代理
export NO_PROXY="*.cdn.com,*.static.com"  # CDN 直连
```

## 最佳实践

1. **优先使用环境变量**：不要硬编码代理凭据  
2. **合理设置 `NO_PROXY`**：避免本地流量误走代理  
3. **自动化前先验连通性**：用简单请求先探测  
4. **处理代理不稳定**：为失败场景加入重试逻辑  
5. **大规模抓取需轮换代理**：分摊流量、降低封禁风险
