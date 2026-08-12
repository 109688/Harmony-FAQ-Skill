---
name: harmony-listing-faq
description: >-
  Applies HarmonyOS app/atomic-service listing detection standards from the
  official 上架检测FAQ专题 (UX, stability, power, performance, compatibility,
  security), plus zufangtong ArkTS UI/UX implementation patterns for pages,
  views, common components, and utils under entry/src/main/ets. Use when
  reviewing or fixing AppGallery上架/审核驳回 issues, running 上架预检/自检,
  checking module.json5/app.json5/package rules, icons, permissions, ads/privacy,
  foldable/window UX, DevEco Testing listing precheck, AppAnalyzer reports, or
  when writing HarmonyOS UI in the gtsdk + Navigation(MyNavPathStack) + Tabs +
  MyNavbar style distilled from zufangtong. Complements harmony-next for API/IDE;
  this skill owns listing quality checklists, FAQ-derived standards, and UI style.
---

# HarmonyOS 上架检测标准 + 租房通 UI 写法

离线蒸馏自官方专题：[上架检测FAQ专题](https://developer.huawei.com/consumer/cn/forum/subject/2114199480637425001)。

路径相对本 skill 目录（`harmony-listing-faq.skill/`）。与 `harmony-next` 分工：本 skill 管**上架质量标准与检查** + **zufangtong 界面写法风格**；API、DevEco、hdc、模拟器细节交给 `harmony-next`。

## Routing

1. **Classify** the request:
   - Listing audit / 上架自检 → FAQ categories below
   - **写 UI / 新页面 / 改界面 / ArkTS 视图** → [references/zufangtong-ui-style.md](references/zufangtong-ui-style.md) + 命中 [ux.md](references/ux.md) 行
   - Both → open UI style + relevant FAQ category
2. **FAQ only**：open matching file(s) under `references/` plus hit rows in [INDEX.md](references/INDEX.md). Full audit → all six category files.
3. **Unknown category** → search `references/INDEX.md` by keyword (布局|权限|崩溃|功耗|启动|广告|卡片|折叠屏|…).

| Intent keywords | File |
| --- | --- |
| 布局、字体、对比度、状态栏、图标、横竖屏、深色、挖孔、导航、窗口、元服务胶囊 | [references/ux.md](references/ux.md) |
| 崩溃、卡死、内存泄漏、fd、线程过载 | [references/stability.md](references/stability.md) |
| 动效、传感器、音频类型、后台、导航/音乐类型 | [references/power.md](references/power.md) |
| 启动快、点击、滑动、转场、起播、Seek、流媒体 | [references/performance.md](references/performance.md) |
| 包结构、权限清单、安装/升级、卡片、折叠屏、免安装、so、卸载、bundleName | [references/compatibility.md](references/compatibility.md) |
| 广告、隐私、儿童、调试属性、名称图标一致性、频繁申请权限 | [references/security.md](references/security.md) |
| 页面结构、Tab、NavPathStack、MyNavbar、ListView、表单、详情、对话框、zufangtong 风格 | [references/zufangtong-ui-style.md](references/zufangtong-ui-style.md) |

Full title → URL map: [references/INDEX.md](references/INDEX.md).

## Workflows

### A. Develop (follow standards while coding)

When changing UI, lifecycle, window, media, permissions, or package config:

1. **UI 页面/视图** → 先读 [zufangtong-ui-style.md](references/zufangtong-ui-style.md)，选对应模板（Tab 主视图 / List Manager / Form / Detail）。
2. Match the change to FAQ rows in INDEX / category file（尤其 [ux.md](references/ux.md)）。
3. Reply with: **应满足** / **常见失败** / **修改要点**（配置、ArkTS/ArkUI、工程检查点）.
4. Prefer concrete file targets (`app.json5`, `module.json5`, `route_map.json`, `pages/` vs `views/`, `common/MyNavbar`).

### B. Review / 上架自检

1. Scope: full audit → all six FAQ files + UI style spot-check; partial → only relevant categories.
2. Emit a graded checklist:
   - **阻断**：不改无法过检/易被驳回
   - **高风险**：常见驳回或体验红线
   - **建议**：体验增强，非硬阻断时注明
3. Each finding: FAQ title + 标准摘要 + 证据路径 + 修改建议 + 源链接（INDEX 中有则给出）.
4. UI 实现类问题可引用 zufangtong 风格 §（如安全区 padding、Navbar、双轨导航）.

### C. Tools (do not reinvent)

- Local: **DevEco Testing** 应用上架预检（黑盒）
- Cloud: 云测试上架预检
- Diagnose: 预检报告导入 **AppAnalyzer**
- For IDE/device commands, use `harmony-next` scripts/playbooks.

### D. New UI page (zufangtong style)

1. **定层级**：Tab 内容 → `views/mainViews/`；栈内子页 → `views/domainViews/` + `XxxViewBuilder` + `route_map.json`；H5 → `pages/WebPage` + `router`.
2. **定导航**：栈内 `MyNavPathStack.pushPath/pop`；跨 Ability `router`；勿混用。
3. **套壳**：`NavDestination` + `hideTitleBar(true)` + `MyNavbar`；Tab 页无 `NavDestination`。
4. **套视觉**：`main_background` / `main_color`；边距 15vp；卡片 radius 10/15；`clickEffect(HEAVY, 0.5)`。
5. **套交互**：校验 toast；危险 `showDialog`；Loading `MyLoadingDialog`；数据变更 `emitter.emit('changeHouse')`。
6. **套安全区**：`AppSpace.TOP_SPACE` / `BOTTOM_SPACE`；列表底 `BOTTOM_SPACE * 2 + 15`。
7. **过 UX FAQ**：对照 [ux.md](references/ux.md) 底部条、状态栏、字体、热区、侧滑返回。

详细 API 与骨架代码见 [references/zufangtong-ui-style.md](references/zufangtong-ui-style.md)。

## Output template

```markdown
### [阻断|高风险|建议] 【上架检测FAQ】标题
- 分类: ux|stability|power|performance|compatibility|security
- 标准: …
- 证据: path / 现象
- 修改: …
- 源: https://developer.huawei.com/consumer/cn/forum/topic/...
```

UI 实现建议可附加：

```markdown
### 【zufangtong UI】模板/规则
- 适用: Tab|List|Form|Detail|Web
- 参照: references/zufangtong-ui-style.md §N
- 修改: file path + 要点
```

## High-priority blockers (always check on listing)

- `requestPermissions` 完整（user_grant 含 `reason` + `usedScene`）
- 包结构 / Entry HAP / bundleName·versionCode 一致 / 设备类型 / SDK 版本
- 应用与元服务免安装属性正确；元服务禁 so；应用支持 64 位 so
- 分层图标（前景+背景 1024）与必须有图标
- 发布包 `debug` 关闭
- 启动/运行无 CppCrash、JsCrash、冻屏、侧滑无法返回
- 卸载无残留；广告可关闭且关闭热区足够；不频繁弹广告/诱导隐私
- UI：`route_map` 与 `pushPath({ name })` 一致；底部安全区不挡操作；`hideTitleBar` + 自绘 Navbar

## Boundaries

- Do not paste entire forum posts into chat; cite distilled rules + source URL.
- Standards evolve; if online FAQ conflicts with local text, prefer the live topic page and note the delta.
- This skill does not replace AppGallery 《审核指南》内容合规全文；安全类聚焦检测 FAQ 覆盖项。
- zufangtong UI 风格蒸馏范围：**排除** `MineView.ets`、`LoginView.ets`、`LogoutView.ets`；其余 `entry/src/main/ets` 界面写法为准。登录/个人中心页不以此风格为强制模板。
