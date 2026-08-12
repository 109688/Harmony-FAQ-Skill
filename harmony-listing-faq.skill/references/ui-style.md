# 租房通 ArkTS UI / UX / 组件 / 工具写法

蒸馏自 `zufangtong/entry/src/main/ets`。**风格源范围**：除 `MineView.ets`、`LoginView.ets`、`LogoutView.ets` 外的全部界面与相关 common/utils。写新 UI 时套用本文件；骨架见 [ui-skeletons.md](ui-skeletons.md)。

与上架 FAQ 交叉：沉浸式顶栏、`AppSpace` 安全区、侧滑返回（`Navigation`+`MyNavbar`）、点击反馈、浅色强制——实现时同时满足 [ux.md](ux.md) 对应项。

## 目录职责

| 目录 | 放什么 |
| --- | --- |
| `pages/` | 仅 router 级：`Index`、`MainHomePage`、`WebPage`（`@Entry` + `main_pages.json`） |
| `views/mainViews/` | Tab 内嵌主视图，**不**包 `NavDestination` |
| `views/domainViews/` | 栈内业务子页：`NavDestination` + `@Builder XxxViewBuilder` + `route_map.json` |
| `common/` | `MyNavbar`、`MyLoadingDialog`、`CustomDialogComp`、`BarChartComp`、`MyNavPathStack` |
| `utils/` | 单例：`XxxUtil.getInstance()` / `statusBar` / `permissionManager` |
| `constans/` | `AppSpace`、文档 URL（目录名保持仓库拼写 `constans`） |
| `modules/` | router 参数类型（如 `WebPageParams`） |

**规则**：新 Tab 内容 → `mainViews`；新详情/表单 → `domainViews` + Builder + route_map；协议/H5 → `WebPage` + `router`。

## 导航双轨（必须）

| 场景 | API | 参数 |
| --- | --- | --- |
| 启动↔主页、协议 Web | `router.replaceUrl` / `pushUrl` / `back` | `params as WebPageParams` |
| Tab 内业务子页、会员等 | `MyNavPathStack.pushPath({ name, param? })` / `pop()` | `getParamByName('Name').pop() as T` |

- `route_map.name` === `pushPath({ name })` === `getParamByName(...)` === `XxxViewBuilder`。
- 子页根：`NavDestination() { ... }.hideTitleBar(true)`，顶栏用 `MyNavbar`，禁止系统标题栏。
- Tab 内视图禁止再包 `NavDestination`。
- H5 **不**进 NavPathStack。

```ets
MyNavPathStack.pushPath({ name: 'AddHouseView', param: item })
// aboutToAppear:
const param = MyNavPathStack.getParamByName('AddHouseView').pop() as MyHouseInfo
```

## 主壳与安全区

**MainHomePage**

- 根：`Navigation(MyNavPathStack) { ... }.mode(NavigationMode.Stack).hideToolBar(true)`
- 内：`Tabs({ index: $$this.selectBarIndex })`，`barPosition: End`，`scrollable(false)`，`animationDuration(0)`
- 底：`.padding({ bottom: AppSpace.BOTTOM_SPACE })`
- 跨 Tab 数据：`@Provider('key')`；子视图 `@Consumer('key')`
- 会员等「假 Tab」：空 `TabContent`，`onChange` 里复位 index 并 `pushPath`
- `aboutToAppear`：`statusBar.setDark()` + 拉数 + `emitter.on('changeHouse', ...)`

**安全区 / 状态栏**

- `EntryAbility` 写 `AppStorage`：`safeTop` / `safeBottom`（px2vp）
- `AppSpace.TOP_SPACE` / `BOTTOM_SPACE` 读 AppStorage
- Navbar 默认 `padding.top = TOP_SPACE`，高度 `56 + TOP_SPACE`
- 列表管理页底：`BOTTOM_SPACE * 2 + 15`
- 强制浅色：`COLOR_MODE_LIGHT`；普通页 Dark 状态栏；深色营销页 Light，进出成对恢复

## 组件装饰器惯例

| 装饰器 | 用法 |
| --- | --- |
| `@ComponentV2` | 业务视图默认 |
| `@Entry` | 仅 `pages/` |
| `@Local` | V2 本地状态 |
| `@Param` / `@Event` | 子组件入参/回调 |
| `@Prop` | 仅 `@CustomDialog` |
| `@Provider` / `@Consumer` | 主壳共享 |
| `@Monitor` | Provider 字段联动过滤 |
| `@Link` | **不使用** |

生命周期：`aboutToAppear` 取参/拉数/订 emitter；`NavDestination.onShown`/`onHidden` 切状态栏。

## 视觉与交互

**颜色（`$r('app.color.*')`）**

| 角色 | token / 值 |
| --- | --- |
| 页底 | `main_background` `#eff3f4` |
| 主色/顶栏/主按钮 | `main_color` `#328dff` |
| 已收/出租中 | `already_get_color` |
| 待收/强调 | `await_get_color` / `#F63F3F` |
| 次要文案 | `#6A6666` / `#8C8E8E` |
| 卡片 | `Color.White` |
| 输入底 | `#e6eaea` |
| 次按钮 | `#d9d9d9` / `#D5F2FA` |

**尺寸**

- 页边距 `15`/`13`/`20`；`Column({ space: 12|13|15 })`
- 列表卡 `borderRadius: 10`；表单卡 `15`
- Navbar 标题默认 `18`、`fontWeight: 600`
- 主按钮：`ButtonType.Normal`，高约 `35`，`main_color`，`borderRadius(10)`
- 点击：`.clickEffect({ level: ClickEffectLevel.HEAVY, scale: 0.5 })`

**列表 / 空态 / Loading**

- 首页：`Scroll` + `scrollBar(BarState.Off)` + `layoutWeight(1)`
- 管理列表：`ListView`（`@abner/refresh`），`isLazyData: true`，`itemLayout` → `@Builder itemBuilder`；**不接**下拉刷新
- 空态：居中 `Text('暂无…')`，高 `'30%'`/`'60%'`，无插画
- 卡角标：`Stack` + 右上角状态条 `borderRadius({ topRight: 10, bottomLeft: 10 })`
- Loading：`CustomDialogController` + `MyLoadingDialog`，`customStyle: true`，`autoCancel: false`

## Common 组件用法

### MyNavbar

```ets
MyNavbar({
  title: string,
  showBorder?: boolean,
  leftIcon / rightIcon?: ResourceStr,
  showRightIcon / showRightTitle?: boolean,
  rightTitle / leftTitle?: string,
  divHeight?: number,              // 自定义高度时 top padding=0
  titleColor / divLeftColor / divRightColor / mainColor?: ResourceColor,
  titleSize?: number,              // default 18
  showLeftIcon?: boolean,          // Tab 页常 false + leftIcon:''
  isRouter?: boolean,              // true→router.back；false→MyNavPathStack.pop
  onclickBack?: () => void,
  onClickRight?: () => void
})
```

Tab 管理页：白字 + `.backgroundColor(main_color)`，藏返回。扩顶栏只加 `@Param`，勿另起标题栏。

### 对话框

- 页内确认：`CustomDialogController` + 页内 `@Builder`（宽约 `70%`，双按钮）
- 危险确认：`promptAction.showDialog`，取消 `#999999`，危险色红，`result.index === 1`
- 通用：`CustomDialogComp`（`content` / `isDivContent`+`@BuilderParam` / `divAll`）
- Toast：`getUIContext().getPromptAction().showToast` 或 `promptAction.showToast` / `AppUtil.showToast`

### MyNavPathStack

全局单例 `NavPathStack`，与主壳 `Navigation(MyNavPathStack)` 绑定。

## Utils 从视图调用

| 工具 | 模式 |
| --- | --- |
| `statusBar.setDark/setLight()` | 进出页成对 |
| `HouseManagerUtil.getInstance()` | CRUD、格式化；写后 `emitter.emit('changeHouse')` |
| `UserFreeUtil.getInstance().checkFreeCount()` | 写操作前闸门，失败 toast |
| `permissionManager` | 设置页跳转 |
| `emitter` | `'changeHouse'` 刷主数据；`'1'` 刷登录态 |

数据流：域内 util mutate → emit → 主壳 `getData()` → 更新 Provider → Consumer 刷新。

## 命名

| 类型 | 约定 |
| --- | --- |
| 页面 | `XxxPage` / `Index` |
| 视图 | `XxxView` |
| Builder | `XxxViewBuilder`（与 route name 一致） |
| 组件 | `MyXxx` / `XxxComp` |
| 工具 | `XxxUtil` / `xxxTool` |
| Import | 相对路径 `../../common/...`；Kit：`@kit.ArkUI` |

## 反模式

1. Tab 内嵌视图包 `NavDestination`
2. 使用系统 Navigation 标题栏（未 `hideTitleBar(true)`）
3. 使用 `@Link`；跨组件不用 Provider/Consumer 或 util+emitter
4. H5/协议进 NavPathStack
5. 插画空态 / 默认接 ListView 下拉刷新
6. 暗色主题
7. `pushPath` 却漏 `route_map` + Builder
8. 列表页忽略底部安全区
9. 主按钮依赖系统默认样式（应用 `ButtonType.Normal` + `main_color`）
10. 新 V2 页混用 `@State`（历史例外勿跟）

## 任务 → 套用

| 任务 | 打开 |
| --- | --- |
| 新 Tab 内容 | 本文件主壳 + [ui-skeletons.md](ui-skeletons.md) Tab 模板 |
| 新业务列表 | List Manager 骨架 + ListView itemBuilder |
| 新表单/编辑 | Form 骨架 + pushPath 参数 + route_map |
| 新详情 | Detail 骨架；危险操作用 showDialog |
| 新 H5 | WebPage + WebPageParams |
| 上架 UX 预检 | 回到 [ux.md](ux.md) / INDEX |
