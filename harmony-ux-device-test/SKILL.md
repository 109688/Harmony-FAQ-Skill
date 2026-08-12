---
name: harmony-ux-device-test
description: >-
  Tests HarmonyOS apps on a real connected phone from a real-user perspective
  against AppGallery review and listing standards (审核指南 50104, 审核FAQ 50106,
  doc 50180, 上架检测FAQ专题): maps every feature, walks each flow with
  hdc/uitest, and reports bugs immediately with screenshot/layout/hilog
  evidence. Use when the user asks to 真机测试, 用户体验测试, 全功能测试,
  体验应用, 点测, 对照审核指南, UX walkthrough, or to verify every function
  on a linked HarmonyOS device.
---

# 鸿蒙真机 · 真实用户全功能体验测试

用已连接的真机，以**普通用户**身份走完应用每一个可触达功能；判定时对照华为官方审核与上架检测要求；发现问题**立刻输出**，不要攒到最后才说。

与现有技能分工：

| Skill | 职责 |
| --- | --- |
| **本 skill** | 真机用户旅程、功能覆盖、对照官方标准的即时缺陷报告 |
| `harmony-next` | hdc / uitest / dumpLayout / 证据采集命令细节 |
| `harmony-listing-faq` | 上架检测 FAQ 全文蒸馏（UX/稳定/性能/功耗/兼容/安全） |

技能根目录：`C:/Users/Administrator/.cursor/skills/harmony-ux-device-test/`

## 官方依据（必须对照）

开测前读 [references/official-standards.md](references/official-standards.md)。源链接：

| 文档 | URL |
| --- | --- |
| 应用市场审核指南 | https://developer.huawei.com/consumer/cn/doc/app/50104 |
| 应用审核 FAQ | https://developer.huawei.com/consumer/cn/doc/app/50106 |
| 文档中心条目 | https://developer.huawei.com/consumer/cn/doc/50180 |
| 上架检测 FAQ 专题 | https://developer.huawei.com/consumer/cn/forum/subject/2114199480637425001 |

执行规则：

1. **功能完备**（50104 §3）：每个入口必须可用，禁止「开发中」空壳、点击无响应、主路径闪退。
2. **隐私与权限**（50104 §7）：首次同意、隐私政策可打开、权限允许/拒绝双路径、拒绝不死循环。
3. **广告与弹窗**（50104 §5 / §3.7）：可关、标识清晰、不频繁打断、不挡系统返回。
4. **体验红线**（上架检测 FAQ）：布局/安全区/热区/侧滑返回/崩溃卡死/点击反馈与滑动流畅——细则查 `harmony-listing-faq`。
5. **50106 / 50180**：报障或不确定时打开现行页面标题与 FAQ 条目核对；与本地摘要冲突以线上为准。
6. 缺陷尽量带 `对照: 50104 §x` 或 `【上架检测FAQ】标题` + 源 URL。

## 何时启用

用户提到：真机测试、连上手机、体验应用、全功能测试、点一下每个功能、用户视角测、对照审核指南/上架检测、发现问题及时说 → **立即按本 skill 执行**。

## 前置条件（每次开测先跑）

```powershell
hdc list targets
hdc shell param get const.product.model
hdc shell "aa dump -l"
```

- 无 `Connected` target → 停，请用户开 USB 调试 / 授权。
- 多设备 → 用 `hdc -t <serial>`，全程固定同一台。
- 未指定包名 → 从前台 `aa dump -l` 取 `FOREGROUND` 的 `bundle name`；仍不清则列出近期 mission 让用户确认。
- 启动应用（用户未要求勿卸载/清数据）：

```powershell
hdc shell aa start -a EntryAbility -b <bundleName>
```

Ability 名以工程 `module.json5` 为准；不确定时用 `hdc shell bm dump -n <bundleName>`。

## 核心原则（必须遵守）

1. **真实用户**：按「打开 → 浏览 → 点按钮 → 填表 → 提交 → 返回 → 换 Tab」顺序，不跳过引导/空态/错误态。
2. **全功能覆盖**：每个 Tab、入口、列表项、表单、设置项、权限弹窗、分享/登录/搜索都要走到；不可达要记「阻塞」，不可静默跳过。
3. **即时报障**：任一功能异常，**立刻**向用户输出一条缺陷（见下方模板），再继续测其它路径。
4. **证据优先**：报障必须附截图 + 关键 layout 节点；崩溃/卡死再附短段 hilog。
5. **坐标空间**：点击坐标必须来自当前 `dumpLayout` 的 `bounds` 中心；禁止用缩放预览图估点。
6. **不破坏数据**：默认不 `bm uninstall`、不 `rm` 用户数据；需要清缓存须用户明确同意。
7. **读图**：拉回的 PNG 用 Read 工具查看，结合 layout 判断文案截断、空白页、错位、遮挡。

## 标准操作循环（每个功能点）

对每个待测项执行：

```text
观察 → 操作 → 再观察 → 判定 → (失败则即时报告) → 下一功能
```

### 1. 观察

```powershell
# 设备上落盘后 file recv 到本机 artifacts
hdc shell uitest dumpLayout -p /data/local/tmp/ux_layout.json -a
hdc file recv /data/local/tmp/ux_layout.json <artifactDir>/layout_<step>.json
hdc shell uitest screenCap -p /data/local/tmp/ux_cap.png
hdc file recv /data/local/tmp/ux_cap.png <artifactDir>/cap_<step>.png
```

也可用 `harmony-next` 的 `device_evidence_bundle.py` / `device_ui_action.py`（有 DevEco 路径时）。

Windows 建议产物目录：`d:/_Document/_Usually/WorkFile/.ux-test/<bundle>-<yyyyMMdd-HHmm>/`

### 2. 操作

```powershell
hdc shell uitest uiInput click <x> <y>
hdc shell uitest uiInput swipe <x1> <y1> <x2> <y2> [velocity]
hdc shell uitest uiInput inputText <x> <y> "<text>"
hdc shell uitest uiInput text "<text>"
hdc shell uitest uiInput keyEvent Back
hdc shell uitest uiInput dircFling <0|1|2|3>   # left right up down
```

优先按可见 `text` / `id` / `description` 解析 bounds；同文案多节点用索引或更大可点区域。

### 3. 判定（用户视角）

通过：界面有明确反馈；结果符合入口承诺；可返回；无崩溃/白屏/连点无响应。

失败（立刻报告）：闪退、ANR/卡死、白屏/错页、按钮无响应、文案错误/截断遮挡、流程走不通、错误无提示、权限死循环、数据丢失、严重卡顿。

### 4. 即时缺陷输出模板

发现问题后**马上**发（不要等总结）：

```markdown
### 缺陷 [<severity>] <短标题>
- 对照：50104 §3.x / 【上架检测FAQ】…（能映射则写）
- 源：https://developer.huawei.com/consumer/cn/doc/app/50104
- 包名/页面：`<bundle>` / `<当前页可见标题或路由推断>`
- 步骤：1. … 2. … 3. …
- 期望：…
- 实际：…
- 证据：`cap_xxx.png`、`layout_xxx.json`（关键节点 text/bounds）
- 复现：稳定 / 偶发（约 n 次中 m 次）
- 日志：（仅崩溃卡死时，hilog 末 30～80 行）
```

严重级别：

| 级别 | 含义 |
| --- | --- |
| P0 | 启动失败、主流程崩溃、数据损坏、无法退出 |
| P1 | 核心功能不可用、错误结果、严重遮挡导致不可用 |
| P2 | 次要功能失败、明显体验问题、文案/布局明显错误 |
| P3 | 轻微 UI、文案笔误、低优先级体验建议 |

## 全功能覆盖工作流

复制进度清单并边测边勾：

```text
覆盖进度
- [ ] 0. 设备与包名确认；记下对照文档版本意图（50104/50106/专题）
- [ ] 1. 冷启动 / 首屏 / 引导 / 隐私同意与政策入口（50104 §7）
- [ ] 2. 主导航（Tab / 侧栏 / 底部栏）逐项进入（§3 功能完备）
- [ ] 3. 每个 Tab 内：列表滚动、空态、下拉刷新（若有）+ 滑动流畅抽查
- [ ] 4. 每个列表至少点开 1～2 条详情并返回（含侧滑/返回键）
- [ ] 5. 搜索 / 筛选 / 排序（若有）
- [ ] 6. 表单：合法提交 + 至少 1 组非法/空提交
- [ ] 7. 设置 / 关于 / 反馈 / 隐私政策 / 注销（有则测）
- [ ] 8. 登录注册找回（有则测；无账号先问用户 / 演示帐号）
- [ ] 9. 权限弹窗：允许与拒绝各走一遍（拒绝后是否可再进，§7.19）
- [ ] 10. 广告/推送弹窗（有则测关闭与频率，§5 / §3.7）
- [ ] 11. 系统键：返回、Home 再回前台、分屏/旋转（若产品支持）
- [ ] 12. 上架 UX 红线抽查（安全区、热区、状态栏、挖孔）
- [ ] 13. 异常网：可关网抽测加载失败提示（可选）
- [ ] 14. 汇总报告（含官方条款对照索引）
```

### A. 建功能地图（先图后点）

1. dump 首屏 layout，列出可点击文本/按钮/Tab。
2. 若工作区有工程：扫 `main_pages.json`、`route_map.json`、`pages/`、`views/` 补全入口，避免漏页。
3. 输出「功能地图」给用户一眼确认，再开始深测。

### B. 深度体验规则

- **每个 Tab 至少**：进入 → 主操作 1 次 → 二级页 → 返回，确认状态仍正确。
- **列表**：滑到底；注意重复加载、空白、错乱高度。
- **表单**：必填校验、键盘遮挡、提交 loading、成功/失败提示。
- **媒体**：播放/暂停/进度（有则测）。
- **Web/半屏**：加载与返回是否困在 H5。
- **钱/提交类**：只走到确认页或用测试账号；不真实付款 unless 用户明确要求。

### C. 稳定性旁路（不替代功能测）

怀疑卡死/崩溃时：

```powershell
hdc shell "hilog -x | tail -n 80"
hdc shell aa dump -l
```

记录后 `force-stop` 再冷启，继续其它功能；P0 启动失败则暂停深测并优先报告。

## 结束时的汇总报告

全部可测路径走完（或用户叫停）后输出：

```markdown
## 真机体验报告
- 设备：<model> / <serial>
- 应用：<bundle> <version if known>
- 时长 / 覆盖：Tab x/y；入口 m/n
- P0/P1/P2/P3 计数
- 已即时同步的缺陷列表（标题 + 级别）
- 未测项与原因（无账号、需真支付、入口灰掉…）
- 总体结论：可继续开发 / 需修主路径后再测
```

详细字段见 [references/report-template.md](references/report-template.md)。检查项细则见 [references/checklist.md](references/checklist.md)。官方条款蒸馏见 [references/official-standards.md](references/official-standards.md)。

## 辅助脚本

```powershell
powershell -ExecutionPolicy Bypass -File "C:/Users/Administrator/.cursor/skills/harmony-ux-device-test/scripts/capture_step.ps1" `
  -ArtifactDir "d:/_Document/_Usually/WorkFile/.ux-test/run1" -Step "01_home"
```

将当前界面 `dumpLayout` + `screenCap` 拉到本机并打印可点击文本摘要。

## 禁止事项

- 不要用桌面鼠标坐标点手机画面。
- 不要一次盲点多个控件还不 dump。
- 不要把「只跑了 DevEco 上架预检」当成「已完成真实用户全功能体验」。
- 不要在未报障的情况下声称「全功能正常」或「符合审核指南」。
- 不要把 hypium 工程测试与本次真机手测混为一谈（除非用户要跑自动化用例）。
- 不要编造未打开过的官方条款号；不确定就写现象并给源文档链接。
