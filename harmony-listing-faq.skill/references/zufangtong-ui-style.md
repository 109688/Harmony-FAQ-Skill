# 租房通 ArkTS UI 写法风格（zufangtong）

蒸馏自 `D:\_Document\Projects\Harmony\oldApp\ZF\zufangtong\entry\src\main\ets`。

**范围**：除 `MineView.ets`、`LoginView.ets`、`LogoutView.ets` 外的全部界面与共用组件/工具写法。

**用途**：在本仓库或同构「gtsdk + Navigation(MyNavPathStack) + Tabs + MyNavbar」项目中写 ArkTS UI 时，按此风格实现；并与 [ux.md](ux.md) 上架 UX 标准交叉校验。

---

## 1. 目录职责

| 目录 | 职责 | 何时新增 |
|------|------|----------|
| `pages/` | `@Entry` + `main_pages.json` 注册的 router 级页 | 启动、主壳、独立 Web |
| `views/mainViews/` | Tab 内嵌主视图（**无** `NavDestination`） | 底部 Tab 内容 |
| `views/domainViews/` | 栈内业务子页（`NavDestination` + `route_map`） | 列表详情、表单、统计 |
| `common/` | 可复用 UI + 全局 `NavPathStack` | 跨页顶栏、对话框、图表 |
| `utils/` | 单例工具（状态栏、权限、业务 CRUD） | 视图内 `XxxUtil.getInstance()` |
| `constans/` | 文档 URL、安全区常量（拼写保持 `constans`） | `$r` / `AppStorage` 读取 |
| `modules/` | 跨页参数类型 | `router` params 强类型 |

- `main_pages.json` 仅：`Index`、`WebPage`、`MainHomePage`
- 子页走 `route_map.json`：`name` === `XxxViewBuilder` === `pushPath({ name })` === `getParamByName('...')`

---

## 2. 页面壳

### Index（启动 / 隐私门控）

- `@Entry` + `@ComponentV2`；`build()` 可为空
- `aboutToAppear`：`CustomDialogController` 隐私弹窗 **或** `router.replaceUrl({ url: 'pages/MainHomePage' })`
- 协议链接：`router.pushUrl` → `WebPage` + `WebPageParams`

### MainHomePage（主壳）

```ets
Navigation(MyNavPathStack) {
  Column() {
  Tabs({ index: $$this.selectBarIndex }) {
    TabContent() { HomeView() }      // mainViews
    // ...
  }
  .padding({ bottom: AppSpace.BOTTOM_SPACE })
  .scrollable(false)
  .animationDuration(0)
  .barPosition(BarPosition.End)
  }
}
.mode(NavigationMode.Stack)
.hideToolBar(true)
```

- 大量 `@Provider('key')` 供 Tab / 域视图 `@Consumer`
- `aboutToAppear`：`statusBar.setDark()` + 拉数据 + `emitter.on('changeHouse', ...)`
- 会员 Tab：空 `TabContent` + `onChange` 里 `selectBarIndex=0` + `pushPath({ name: 'MemberView' })`

### WebPage（router 独立页）

- `router.getParams() as WebPageParams`
- `MyNavbar({ isRouter: true, onclickBack: () => router.back() })`
- `Web` + `MyLoadingDialog`（`onProgressChange == 100` 关闭）
- 底：`.padding({ bottom: AppStorage.get('safeBottom') as number })`

### 安全区 / 状态栏

- `EntryAbility`：`AppStorage.setOrCreate('safeTop'|'safeBottom', px2vp(...))`
- `AppSpace.TOP_SPACE` / `BOTTOM_SPACE` 读 `AppStorage`
- `MyNavbar` 默认 `padding.top = AppSpace.TOP_SPACE`，高度 `56 + TOP_SPACE`
- Tab 页：`BOTTOM_SPACE`；列表页常 `BOTTOM_SPACE * 2 + 15`（对齐 [ux.md](ux.md) 底部导航条适配）

---

## 3. 组件装饰器与生命周期

| 装饰器 | 用法 |
|--------|------|
| `@ComponentV2` | 默认（业务视图） |
| `@Component` + `@State` | 历史例外（如 `MemberView`） |
| `@Entry` | 仅 `pages/` |
| `@Local` | V2 本地状态 |
| `@Param` / `@Event` | 子组件（`MyNavbar`） |
| `@Prop` | `@CustomDialog`（`MyLoadingDialog`、`CustomDialogComp`） |
| `@Provider` / `@Consumer` | 主壳 → Tab/域视图共享 |
| `@Monitor('a','b')` | Provider 变化触发过滤 |
| `@Link` | **未使用** |

**生命周期**：`aboutToAppear` 取参、拉数据、`statusBar`、订阅 `emitter`；栈内页可用 `NavDestination.onShown` / `onHidden` 切状态栏。

**build 结构**：`Column` / `NavDestination` → `MyNavbar`（或首页自绘顶栏）→ `Scroll` / `ListView` → `.backgroundColor($r('app.color.main_background'))`

**子页注册**：

```ets
@Builder
function XxxViewBuilder() { XxxView() }

@ComponentV2
struct XxxView {
  build() {
    NavDestination() { /* ... */ }
      .hideTitleBar(true)
  }
}
```

---

## 4. 视觉与布局

### 颜色（`color.json` + 硬编码）

| 角色 | 值 |
|------|-----|
| 页底 | `$r('app.color.main_background')` `#eff3f4` |
| 主色 / 主按钮 / 顶栏 | `$r('app.color.main_color')` `#328dff` |
| 已收 / 出租中 | `already_get_color` `#3ada00` |
| 待收 / 逾期 | `await_get_color` `#ff5622` / `#F63F3F` |
| 次要文案 | `#6A6666` / `#8C8E8E` |
| 卡片底 | `Color.White` |
| 输入框底 | `#e6eaea` |
| 次按钮 | `#d9d9d9` / `#D5F2FA` / `#E1DEDE` |

正文 ≥14fp、区块标题 `FontWeight.Medium`、数字 20–22fp（对齐 [ux.md](ux.md) 字体大小）。

### 间距 / 圆角（vp）

- 页边距：`15` / `13` / `20`；`Column({ space: 12|13|15 })`
- 列表卡片 `borderRadius: 10`；表单白卡 `15`
- 点击反馈：`.clickEffect({ level: ClickEffectLevel.HEAVY, scale: 0.5 })`

### 列表 / 空态 / Loading

- 首页：`Scroll` + `scrollBar(BarState.Off)` + `layoutWeight(1)`
- 管理列表：`ListView`（`@abner/refresh`），`isLazyData: true`，`itemLayout` → `@Builder itemBuilder`
- **不接下拉刷新**（仅用 ListView 列表能力）
- 空态：居中 `Text('暂无…')`，高度 `30%`/`60%`，无插画
- 卡片角标：`Stack` + 右上角状态条 `borderRadius({ topRight: 10, bottomLeft: 10 })`

---

## 5. Common 组件 API

### MyNavbar

```ets
MyNavbar({
  title: string,
  showBorder?: boolean,
  leftIcon / rightIcon?: ResourceStr,
  showRightIcon / showRightTitle?: boolean,
  rightTitle / leftTitle?: string,
  divHeight?: number,
  titleColor / divLeftColor / divRightColor / mainColor?: ResourceColor,
  titleSize?: number,        // default 18, fontWeight 600
  showLeftIcon?: boolean,    // Tab 页常 false + leftIcon:''
  isRouter?: boolean,        // true→router.back；false→MyNavPathStack.pop
  onclickBack?: () => void,
  onClickRight?: () => void
})
```

Tab 管理页：白字 + `.backgroundColor(main_color)`，藏返回。

### MyLoadingDialog

- `@CustomDialog`；`@Prop message` / `isDark?`
- 黑半透明 120×120 + `LoadingProgress`

### CustomDialogComp

- 模式：`isDivIn` / `content` / `isDivContent`+`@BuilderParam` / `divAll`
- 双按钮「取消/确认」→ `controller.close()` + `confirmEvent`

### BarChartComp

- `@Param dataArray/labelArray/chartWidth/...`；`StatisticsView` 中引用可被注释

### MyNavPathStack

```ets
const pageStack: NavPathStack = new NavPathStack()
export { pageStack as MyNavPathStack }
```

---

## 6. Utils 调用模式

| 工具 | 场景 |
|------|------|
| `statusBar.setDark/setLight()` | 进主壳 Dark；营销页 onShown Light / onHidden Dark |
| `HouseManagerUtil.getInstance()` | CRUD、日期/价格格式化、列表文案 |
| `UserFreeUtil.getInstance().checkFreeCount()` | 写操作前闸门 |
| `permissionManager.openPermissionSettingsPage()` | 撤销隐私等 |
| `appConfig` + `GtApi.getSwitchVal1(SWT_*)` | 会员支付开关 |
| `emitter` | `'changeHouse'` 刷新主数据；`'1'` 刷新登录态 |

数据变更：`HouseManagerUtil` 内 `emitter.emit('changeHouse')` → 主壳 `getData()` 更新 Provider。

---

## 7. 双轨导航

| 场景 | API | 参数 |
|------|-----|------|
| 启动 ↔ 主页 / Web 协议 | `router.replaceUrl` / `pushUrl` / `back` | `params as WebPageParams` |
| Tab 内子页、会员 | `MyNavPathStack.pushPath({ name, param? })` / `pop()` | `getParamByName('Name').pop() as T` |

```ets
MyNavPathStack.pushPath({ name: 'AddHouseView', param: item })

const param = MyNavPathStack.getParamByName('AddHouseView').pop() as MyHouseInfo
```

Web **不走** NavPathStack。

---

## 8. 页面模板

### Tab 主视图（HomeView）

- 无 Navbar；顶栏 `main_color` + `AppSpace.TOP_SPACE + 20`
- `@Consumer` 读统计；入口改 `selectBarIndex` 或 `pushPath`
- 空态 + 白卡片待办

### List Manager（HouseManager / GetRent）

```
Column
  MyNavbar(主色顶、无返回、右标题「添加」)
  Column(padding 15, space 15)
    统计 Row(4 列数字卡，白底 radius 10)
  [筛选/月份条]
    空态 Text OR ListView(itemBuilder)
  .padding({ bottom: AppSpace.BOTTOM_SPACE * 2 + 15 })
  .backgroundColor(main_background)
```

- 危险操作：`promptAction.showDialog`（取消灰 / 删除红）

### Form / Add（AddHouseView）

```
NavDestination
  MyNavbar(动态 title, mainColor White).backgroundColor(main_color)
  Scroll(scrollBar Off, align Top, layoutWeight 1)
    白卡表单(radius 15, padding 13)
      Label Text(Medium) + TextInput(#e6eaea) / Toggle / TextArea
    主按钮(满宽 height 35, main_color) + 次按钮(#d9d9d9)
  .hideTitleBar(true)
```

- 两步：`isNext` 切换子组件
- 校验 / 成功：`getUIContext().getPromptAction().showToast`
- 保存：`HouseManagerUtil.addAndEditHouse` → `pop()`

### Detail（ContractDetailView）

- Navbar + 状态 pill + 标题 + `Progress` + 白卡详情 + 底栏双按钮
- 解约：`showDialog` → 清空租客/合同 → `addAndEditHouse` → `pop` + toast

### Statistics

- Navbar + 三列统计卡 + Ring `Progress` + 图例；可选 `BarChartComp`

---

## 9. 命名与 Import

| 类型 | 约定 |
|------|------|
| 页面 | `XxxPage` / `Index` |
| 视图 | `XxxView` |
| Builder | `XxxViewBuilder`（与 route `name` 一致） |
| 组件 | `MyXxx` / `XxxComp` |
| 工具 | `XxxUtil` / `xxxTool` / `permissionManager` |

Import：相对路径 `../../common/...`；Kit `@kit.ArkUI`。

---

## 10. 可复制骨架

### Tab 主视图

```ets
@ComponentV2
export struct FooTabView {
  @Consumer('selectBarIndex') selectBarIndex: number = 0
  @Consumer('houseInfo') houseInfoList: MyHouseInfo[] = []

  build() {
    Column({ space: 15 }) {
      Column() { Text('标题').fontColor(Color.White) }
        .padding({ left: 15, right: 15, top: AppSpace.TOP_SPACE + 20, bottom: 15 })
        .width('100%')
        .backgroundColor($r('app.color.main_color'))
      Scroll() {
        Column({ space: 15 }) {
          if (this.houseInfoList.length == 0) {
            Text('暂无数据').width('100%').height('30%').textAlign(TextAlign.Center)
          }
        }
      }
      .scrollBar(BarState.Off).align(Alignment.Top).layoutWeight(1)
      .padding({ left: 15, right: 15, bottom: 15 })
    }
    .backgroundColor($r('app.color.main_background')).width('100%')
  }
}
```

### List Manager

```ets
@ComponentV2
export struct FooManagerView {
  @Consumer('houseInfo') list: MyHouseInfo[] = []

  @Builder
  itemBuilder(item: MyHouseInfo, index: number) {
    Stack({ alignContent: Alignment.Top }) {
      Row() {
        Text('状态').fontColor('#fff')
          .backgroundColor($r('app.color.main_color'))
          .padding({ top: 5, bottom: 5, left: 13, right: 13 })
          .borderRadius({ topRight: 10, bottomLeft: 10 })
      }.zIndex(1).justifyContent(FlexAlign.End).width('100%')
      Column({ space: 13 }) { /* 内容 */ }
        .padding(15).backgroundColor(Color.White).borderRadius(10).width('100%')
    }
    .margin({ bottom: 10 })
    .onClick(() => MyNavPathStack.pushPath({ name: 'AddHouseView', param: item }))
  }

  build() {
    Column() {
      MyNavbar({
        title: '管理', showLeftIcon: false, leftIcon: '', mainColor: Color.White,
        showRightTitle: true, rightTitle: '添加',
        onClickRight: () => {
          if (!UserFreeUtil.getInstance().checkFreeCount()) { return }
          MyNavPathStack.pushPath({ name: 'AddHouseView' })
        }
      }).backgroundColor($r('app.color.main_color'))
      Column({ space: 15 }) {
        if (this.list.length == 0) {
          Text('您还未添加~').width('100%').height('60%').textAlign(TextAlign.Center)
        } else {
          ListView({
            items: this.list,
            itemLayout: (item, index) => this.itemBuilder(item as MyHouseInfo, index),
            isLazyData: true
          })
        }
      }.padding(15)
    }
    .padding({ bottom: AppSpace.BOTTOM_SPACE * 2 + 15 })
    .backgroundColor($r('app.color.main_background')).width('100%')
  }
}
```

### Form + NavDestination

```ets
@Builder
function AddFooViewBuilder() { AddFooView() }

@ComponentV2
struct AddFooView {
  @Local model: MyHouseInfo = new MyHouseInfo()

  aboutToAppear(): void {
    const p = MyNavPathStack.getParamByName('AddFooView').pop() as MyHouseInfo
    if (p) { this.model = p }
  }

  build() {
    NavDestination() {
      MyNavbar({ title: '添加', mainColor: Color.White })
        .backgroundColor($r('app.color.main_color'))
      Scroll() {
        Column() {
          Column({ space: 6 }) {
            Text('字段').fontWeight(FontWeight.Medium).width('100%')
            TextInput({ placeholder: '请输入' })
              .backgroundColor('#e6eaea').placeholderColor('#8C8E8E')
              .onChange((v) => { this.model.address = v })
          }.backgroundColor(Color.White).padding(13).borderRadius(15).width('100%')
          Button({ type: ButtonType.Normal, stateEffect: true }) { Text('保存').fontColor(Color.White) }
            .backgroundColor($r('app.color.main_color')).width('100%').height(35)
            .clickEffect({ level: ClickEffectLevel.HEAVY, scale: 0.5 })
            .onClick(() => {
              if (!this.model.address) {
                this.getUIContext().getPromptAction().showToast({ message: '请填写完整有效的信息' })
                return
              }
              HouseManagerUtil.getInstance().addAndEditHouse(this.model)
              this.getUIContext().getPromptAction().showToast({ message: '保存成功' })
              MyNavPathStack.pop()
            })
        }.padding(20)
      }.scrollBar(BarState.Off).align(Alignment.Top).layoutWeight(1)
      .backgroundColor($r('app.color.main_background'))
    }.hideTitleBar(true)
  }
}
```

---

## 11. UX 交互

| 交互 | 做法 |
|------|------|
| Toast | `promptAction.showToast` 或 `getUIContext().getPromptAction().showToast` 或 `AppUtil.showToast` |
| 系统确认 | `promptAction.showDialog` + `result.index === 1` |
| 自定义确认 | `CustomDialogController` + `@Builder`，宽约 `70%`，双按钮 |
| 通用对话框 | `CustomDialogComp` |
| Loading | `MyLoadingDialog` + `open/close` |
| 点击反馈 | `clickEffect(HEAVY, 0.5)` |
| 返回 | Navbar 默认 pop/back；表单「取消」显式 `pop()` |
| 写操作限额 | `checkFreeCount()` 先挡 |
| 数据刷新 | `emit('changeHouse')` → 主壳 `getData` |

按钮热区：主操作 `height(35)` 满宽或 `padding` 扩区（对齐 [ux.md](ux.md) 点击热区 ≥40vp）。

---

## 12. 反模式（勿用）

1. Tab 内嵌视图包 `NavDestination`（仅栈内子页包）
2. 系统 `Navigation` 标题栏（一律 `hideTitleBar(true)` + `MyNavbar`）
3. `@Link`（用 `@Provider/@Consumer` 或 util + emitter）
4. H5/协议塞进 NavPathStack（用 `router` + `WebPage`）
5. 插画空态 / 骨架屏（居中文案即可）
6. 默认接 Refresh 下拉
7. 暗色主题（`EntryAbility` 强制 `COLOR_MODE_LIGHT`）
8. 漏 `route_map` + `XxxViewBuilder` 就 `pushPath`
9. 列表页忽略底部安全区
10. 主按钮用系统默认蓝（用 `ButtonType.Normal` + `main_color` + `borderRadius(10)`）
11. 会员做成真实 TabContent（空 Tab + 立即 push）
12. V2 新页混用 `@State`（历史例外除外）

---

## 13. 与上架 UX 交叉检查

写 UI 时同步对照 [ux.md](ux.md)：

| 实现点 | FAQ 项 |
|--------|--------|
| `AppSpace.BOTTOM_SPACE` / `BOTTOM_SPACE * 2 + 15` | 底部导航条适配 |
| `AppSpace.TOP_SPACE` + Navbar 高度 | 状态栏、挖空区 |
| 正文 ≥14fp、数字 20+ | 字体大小 |
| `#6A6666` 次要字 + 白卡对比 | 色彩对比度 |
| `MyNavPathStack.pop` / `router.back` | 避免与系统手势冲突 |
| `clickEffect` + 按钮 height 35 | 点击热区 |
| `emitter` + Provider 刷新 | 窗口内容状态保持 |
