# OpenCode Go Usage Float

一个原生 Windows 轻量浮窗，用于查看 OpenCode Go 的 5 小时 / 每周 / 每月额度。

## 功能

- 输入 `sk-opencode-...` 后直接查询 OpenCode Go 用量
- 5h / Week / Month 三个额度进度条
- 自动显示重置倒计时
- 每 30 秒自动刷新；失败时保留上一次成功数据并提示“数据未更新”
- Windows 托盘：显示/隐藏、立即刷新、修改 API Key、始终置顶、退出
- 无 Electron / Node / WebView 依赖
- API Key 使用当前 Windows 用户的 DPAPI 加密，仅保存到本机 `%APPDATA%\OpenCodeGoUsage\key.dat`

## 查询接口

本程序依据 `yascitom/dsh-opencode-go-box` 的独立额度查询逻辑：

```http
GET https://opencode.ai/zen/go/v1/usage
Authorization: Bearer <API_KEY>
Accept: application/json
```

期望响应：

```json
{
  "usage": {
    "rolling": { "status": "ok", "percent": 9,  "resetsAt": "..." },
    "weekly":  { "status": "ok", "percent": 12, "resetsAt": "..." },
    "monthly": { "status": "ok", "percent": 6,  "resetsAt": "..." }
  }
}
```

> 该接口目前不是公开文档接口，未来可能变化。本程序已对网络错误、401 和响应结构变化做基本保护。

## 构建

需要 Go 1.23+。在 Windows / Linux / macOS 均可交叉编译 Windows x64 单文件：

```bash
GOOS=windows GOARCH=amd64 CGO_ENABLED=0 go build -trimpath -ldflags="-H windowsgui -s -w" -o OpenCodeGoUsage.exe .
```

PowerShell：

```powershell
$env:GOOS="windows"
$env:GOARCH="amd64"
$env:CGO_ENABLED="0"
go build -trimpath -ldflags="-H windowsgui -s -w" -o OpenCodeGoUsage.exe .
```

## 致谢 / 来源

额度接口与“失败时保留最后成功数据”的行为参考：

- `https://github.com/yascitom/dsh-opencode-go-box`

原项目采用 MIT License。见 `THIRD_PARTY_LICENSE.txt`。

## v1.1.0 图标更新

- 内置专属 OpenCode Go Usage 图标。
- 图标包含 16/20/24/32/40/48/64/128/256 px 多尺寸。
- 图标通过 Go `embed` 打包进 EXE，运行时无需外部 PNG/ICO。
- Windows 托盘图标与窗口图标统一使用内置图标。
