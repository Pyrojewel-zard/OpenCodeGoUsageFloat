# OpenCode Go Usage Float

一个原生 Windows 轻量浮窗，用于查看 OpenCode Go 的 5 小时 / 每周 / 每月额度。

## v1.2.0

- 深色 / 白色模式切换
- 透明度可调：100% / 85% / 70% / 55%
- Pin 锁定模式：锁定后主浮窗启用 Windows 级鼠标穿透，鼠标事件会落到后面的应用
- 锁定时仅右上角独立“解锁”小按钮可点击，其余区域不能拖动、不能误触
- 保留托盘图标、置顶、自动刷新、DPAPI 加密保存 Key 等功能

## 基础功能

- 输入 `sk-opencode-...` 后直接查询 OpenCode Go 用量
- 5h / Week / Month 三个额度进度条
- 自动显示重置倒计时
- 每 30 秒自动刷新；失败时保留上一次成功数据并提示“数据未更新”
- Windows 托盘：显示/隐藏、立即刷新、修改 API Key、主题、透明度、Pin、始终置顶、退出
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

由于 ChatGPT GitHub 连接器对超长文件有限制，仓库中的 `main.go` 被无损拆成：

```text
src/main.go.part00
src/main.go.part01
src/main.go.part02
src/main.go.part03
src/main.go.part04
```

Windows 下直接运行：

```powershell
.\build.ps1
```

脚本会自动合并为 `main.go`、执行 `go vet`，并编译：

```text
OpenCodeGoUsage.exe
```

GitHub Actions 也会在每次 push 后自动构建 Windows x64 EXE，可在对应 Actions run 的 Artifacts 中下载。

## Pin 实现

Pin 并不是简单“禁用窗口”。锁定时主浮窗会加入 `WS_EX_TRANSPARENT`，因此鼠标操作直接穿透到后面的 Cadence、浏览器、终端等窗口；同时单独创建一个置顶的小型解锁窗口，因此仍然保留唯一可点击的解锁入口。

## 致谢 / 来源

额度接口与“失败时保留最后成功数据”的行为参考：

- `https://github.com/yascitom/dsh-opencode-go-box`

原项目采用 MIT License。
