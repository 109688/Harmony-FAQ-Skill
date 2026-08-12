# UX 上架检测标准（18项）

蒸馏自华为开发者联盟【上架检测FAQ】专题。预检：DevEco Testing / 云测试「应用上架预检」。

### 【上架检测FAQ】布局基础要求
- 标准：折叠/展开或横竖屏切换时，窗口内组件、图片、视频等不得错位、截断、变形、模糊或被遮挡。
- 常见失败：图标/文字重叠；文本图片被裁切；弹窗遮挡主界面且无法关闭。
- 修改要点：用 `GridRow`/`GridCol`、断点与 `layoutWeight` 做响应式，避免固定 px；图片 `objectFit`；文本 `maxLines`+省略；监听 `windowSizeChange`/`foldStatusChange`；弹窗提供关闭路径。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0204198786161369031

### 【上架检测FAQ】字体大小
- 标准：文字清晰可读，随系统字体/缩放调整后不截断、重叠或布局崩溃。
- 常见失败：正文字号过小；调大系统字体后文字挤出屏幕。
- 修改要点：正文建议 ≥14fp、辅助 ≥12fp；容器勿写死高度；多档「字体大小和界面缩放」实测。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0203198799217774051

### 【上架检测FAQ】色彩对比度
- 标准：文字/图标与背景对比度满足可读性，浅色与深色模式下关键信息可辨。
- 常见失败：浅灰字配浅灰底；半透明字叠复杂背景；状态色对比不足。
- 修改要点：优先 `$r('sys.color.*')`；正文对比建议 ≥4.5:1；图上叠字加蒙层；联测深色模式。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0204198799066197038

### 【上架检测FAQ】底部导航条适配
- 标准：内容不被系统底部导航条/手势条遮挡，底部可交互区域完整可用。
- 常见失败：列表末项、底部 Tab、提交按钮被盖住；全屏页未预留安全区。
- 修改要点：`expandSafeArea` 或消费底部 inset；`Scroll`/`List` 底部加 padding；自绘底栏叠加系统安全区。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0214200865840885234

### 【上架检测FAQ】挖空区适配
- 标准：挖孔/刘海不遮挡关键内容与控件，沉浸式布局正确避让。
- 常见失败：标题/返回键被挖孔覆盖；横屏或折叠后避让失效。
- 修改要点：读取 cutout/avoidArea 动态 padding；沉浸式顶部预留状态栏+挖孔；勿在挖孔区放关键按钮。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0201200866813152952

### 【上架检测FAQ】避免与系统手势冲突
- 标准：应用内手势不与系统侧滑返回、底部上滑冲突，用户可正常返回与多任务。
- 常见失败：全屏 Swiper/地图占满边缘导致无法侧滑返回。
- 修改要点：优先 `Navigation` 返回；全屏手势避开边缘热区；真机验证边缘侧滑与底部上滑。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0214202123089875905

### 【上架检测FAQ】点击热区
- 标准：主要可点控件热区手机/平板/折叠 ≥40vp×40vp（推荐 48）；PC 键鼠/触屏满足尺寸下限。
- 常见失败：小图标可视与可点区域过小；只扩 `responseRegion` 未扩布局。
- 修改要点：图标按钮容器 48×48 居中；小图标外包一层扩大触控；PC 单独验鼠标热区。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0203202123897851534

### 【上架检测FAQ】状态栏
- 标准：状态栏区域显示正常，内容与背景对比清晰，沉浸式不误挡系统状态信息。
- 常见失败：浅底浅字不可见；页面内容顶到状态栏重叠。
- 修改要点：`setWindowSystemBarProperties` 匹配内容色；非沉浸式用安全区；深浅色同步状态栏样式。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0214200867142227235

### 【上架检测FAQ】界面图标
- 标准：应用内图标风格、尺寸、语义一致，不模糊、不混用多种风格。
- 常见失败：线性/面性混用；同一操作图标不一致；位图缩放发糊。
- 修改要点：优先 Symbol/统一 SVG；导航图标尺寸统一；提供多态资源。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0202203873818409059

### 【上架检测FAQ】窗口内容状态保持
- 标准：窗口尺寸变化、形态转换、获焦/失焦时，已输入文本、选中态、列表选中等保持连续。
- 常见失败：旋转/折叠后表单清空、列表回到顶部；分屏重建丢上下文。
- 修改要点：滚动位置与表单用 `AppStorage`/`PersistentStorage`；窗口变化只调布局，勿无故 `replaceUrl`。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0203205082204712391

### 【上架检测FAQ】图标清晰度
- 标准：界面图标在显示尺寸下清晰，无锯齿、马赛克或过度缩放模糊。
- 常见失败：低分辨率 PNG 放大；缺多倍图被拉伸。
- 修改要点：多密度资源或矢量；显示尺寸与像素比匹配；勿强行放大超原图。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0201205082551018495

### 【上架检测FAQ】应用图标
- 标准：分层图标（前景+背景）符合规范，清晰且与桌面展示一致。
- 常见失败：未分层；1024 资源模糊；内容贴边被裁切。
- 修改要点：`app.json5` 配置分层图标；前景+背景 1024×1024；前景主体落安全区；DevEco ≥推荐版本再处理图标。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0203209383550841435

### 【上架检测FAQ】横竖屏适配
- 标准：若声明支持横竖屏，切换后布局可用且无严重错位截断。
- 常见失败：横屏仍按竖屏固定宽；配置与实际能力不一致。
- 修改要点：`orientation` 与产品一致；断点切换分栏；视频/相机页保证返回路径。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0208209383790063497

### 【上架检测FAQ】元服务胶囊满足规范
- 标准：元服务胶囊展示、尺寸、位置符合规范，不遮挡内容且可交互。
- 常见失败：自定义导航与系统胶囊重叠；对比度/热区不足。
- 修改要点：用推荐导航模板；顶部预留胶囊避让高度；勿隐藏或仿冒系统胶囊。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0208209384019363498

### 【上架检测FAQ】深色模式下显示正常
- 标准：系统深色模式下背景、文字、图标、分割线可读，无大面积「残白」。
- 常见失败：强制白底黑字不随系统；插图浅底刺眼。
- 修改要点：`resources/dark` 配色或系统色；同步状态栏/导航栏；验 `colorMode` 切换。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0201210072264559504

### 【上架检测FAQ】元服务底部导航栏满足规范
- 标准：元服务底部导航栏数量、样式、位置符合规范，不遮挡内容且切换正常。
- 常见失败：Tab 过多/过少；底栏与手势条重叠。
- 修改要点：标准 `Tabs`/`Navigation`；项数在规范范围；底栏叠加安全区。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0208210072917086724

### 【上架检测FAQ】元服务图标符合要求
- 标准：元服务展示图标尺寸、格式、清晰度合格，与名称语义一致。
- 常见失败：模糊变形；错误格式；与应用图标配置混淆。
- 修改要点：按元服务图标规范配置资源；`app.json5`/`module.json5` icon 路径正确。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0201210073181225506

### 【上架检测FAQ】支持窗口形态转换
- 标准：分屏、浮窗、折叠展开/折叠、窗口化等形态下布局与功能可用。
- 常见失败：分屏溢出或按钮不可点；折叠后空白需重启。
- 修改要点：按断点而非机型布局；监听窗口/折叠变化；正确声明 `deviceTypes` 与窗口能力。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0207210073290009768
