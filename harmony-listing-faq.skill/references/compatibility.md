# 兼容性上架检测标准（34项）

### 【上架检测FAQ】应用短音、瞬态音播放场景体验规范
- 标准：短音/瞬态音（提示音、按键音等）播放符合场景规范，不异常打断其它音频或不按预期发声。
- 常见失败：短音抢占音乐焦点不当；静音模式仍外放不合规。
- 修改要点：短音使用正确 usage；尊重系统静音/勿扰；播完释放焦点。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0202202129293111269

### 【上架检测FAQ】应用静音播放场景体验规范
- 标准：系统静音或用户静音场景下，应用音频行为符合规范（不违规外放等）。
- 常见失败：系统静音仍大声播放；未监听静音状态。
- 修改要点：读取系统铃量/静音策略；媒体与瞬态音分别处理；提供应用内静音开关时与系统一致。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0203202129526412542

### 【上架检测FAQ】应用/元服务/游戏运行无兼容性问题
- 标准：运行时无无响应、冻屏无法退出、侧滑无法返回（除弹框）、CppCrash/JsCrash。
- 常见失败：点击无响应；侧滑返回失效；运行中崩溃。
- 修改要点：查 AppFreeze/手势冲突/崩溃栈；预检 + AppAnalyzer；保证返回栈可用。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0202203873984368060

### 【上架检测FAQ】应用或元服务升级后原有卡片无兼容性问题
- 标准：升级后已添加服务卡片可继续使用，名称等关键信息不随意破坏兼容。
- 常见失败：升级后卡片失效；卡片名随意变更导致异常。
- 修改要点：卡片 form 配置向后兼容；慎重改卡片名；升级路径实测桌面卡片。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0202203874408620062

### 【上架检测FAQ】卡片isdefault字段不可缺省
- 标准：卡片配置中 `isDefault` 字段必须存在且合法。
- 常见失败：form_config 缺 `isDefault`。
- 修改要点：检查所有卡片配置 JSON，补齐 `isDefault`。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0204204475708379066

### 【上架检测FAQ】卡片支持尺寸规格应符合规范
- 标准：卡片声明的支持尺寸属于官方允许规格集合。
- 常见失败：声明不支持的尺寸；尺寸拼写错误。
- 修改要点：按 Form Kit 文档配置 supportDimensions；与设计稿尺寸一致。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0201204475804196196

### 【上架检测FAQ】应用/元服务/游戏必须有图标
- 标准：包内必须配置有效应用/元服务图标。
- 常见失败：icon 缺失或资源路径无效。
- 修改要点：`app.json5`（及需要时 `module.json5`）配置 icon；资源存在且可加载。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0204204475950812067

### 【上架检测FAQ】应用/元服务/游戏启动无兼容性问题
- 标准：在声明支持的 OS/设备上可正常启动，无冻屏、闪退、无响应。
- 常见失败：启动即崩溃；启动卡死；循环导航。
- 修改要点：启动路径精简；查 Js/CppCrash 与 AppFreeze；避免启动死锁。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0203204476173106180

### 【上架检测FAQ】应用或元服务在不同窗口布局变化下功能可以正常响应
- 标准：窗口大小/布局变化后核心功能仍可点击、可完成。
- 常见失败：缩放后按钮不可点；分屏后主流程阻断。
- 修改要点：响应式布局；最小窗口尺寸下自测；避免绝对定位遮挡。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0203204476359882181

### 【上架检测FAQ】应用或元服务在折叠屏状态切换时无兼容性问题
- 标准：折叠/展开状态切换无崩溃、白屏、功能失效。
- 常见失败：展开后布局错乱；切换崩溃。
- 修改要点：监听 foldStatus；双布局/断点适配；折叠机实测。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0204204476489931068

### 【上架检测FAQ】应用或元服务在折叠屏横竖屏切换时无兼容性问题
- 标准：折叠屏上横竖屏切换无兼容性故障。
- 常见失败：内外屏+方向组合下溢出或卡死。
- 修改要点：方向与折叠态组合回归；状态保持见 UX「窗口内容状态保持」。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0202205083221139052

### 【上架检测FAQ】卡片默认尺寸规格应符合规范
- 标准：卡片默认尺寸属于允许规格且与 `isDefault` 等配置一致。
- 常见失败：defaultDimension 非法或不在 support 列表。
- 修改要点：defaultDimension ∈ supportDimensions；对照官方规格表。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0201205750485276699

### 【上架检测FAQ】卡片配置应符合规范
- 标准：卡片相关配置项完整、合法，符合 Form 配置规范。
- 常见失败：缺必填字段；类型/取值错误。
- 修改要点：按 Form Kit 配置清单逐项检查 form_config / module 卡片段。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0201205750809230700

### 【上架检测FAQ】卡片刷新方式应符合规范
- 标准：卡片刷新方式（定时/定点等）配置合法且行为符合规范。
- 常见失败：非法刷新类型；刷新过频不合规。
- 修改要点：按文档设置 updateEnabled/updateDuration 等；避免违规高频刷新。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0203205750948083561

### 【上架检测FAQ】应用/元服务/游戏明确支持设备类型
- 标准：`deviceTypes` 明确声明支持的设备类型，且与分发选择一致。
- 常见失败：缺 deviceTypes；包内与 AGC 勾选不一致。
- 修改要点：各 module `deviceTypes` 完整；多 HAP 范围一致；与 AGC 对齐。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0203205751235535562

### 【上架检测FAQ】应用/元服务/游戏权限清单必须指定
- 标准：各 hap/hsp/har 的 `requestPermissions` 必须声明（可为空数组）；非空时 `name` 必填；user_grant 须含 `reason` 与 `usedScene`（abilities+when）。
- 常见失败：字段缺失；user_grant 的 reason/usedScene 为空。
- 修改要点：全局搜 `requestPermissions`；reason 用 `$string:`；usedScene 写全；预检验证。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0202205751339196278

### 【上架检测FAQ】应用或元服务在折叠屏支架态切换时无兼容性问题
- 标准：支架态（hover）切换无崩溃、布局不可用或功能失效。
- 常见失败：支架态上下分区内容不可用；切换白屏。
- 修改要点：适配 hover 态布局；监听折叠相关状态；支架机型实测。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0202205751491230279

### 【上架检测FAQ】元服务仅支持免安装
- 标准：元服务包属性为免安装，不得按普通应用安装属性配置。
- 常见失败：元服务配置成非免安装。
- 修改要点：检查 bundleType/安装相关配置为 atomic service/免安装要求。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0201206355698281985

### 【上架检测FAQ】应用仅支持非免安装
- 标准：普通应用为非免安装，不得按元服务免安装属性配置。
- 常见失败：应用误配免安装。
- 修改要点：确认 `bundleType` 为 app；安装属性与产品类型一致。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0204206355566596082

### 【上架检测FAQ】元服务预加载对应模块类型不能为entry
- 标准：元服务预加载模块类型不得为 entry。
- 常见失败：preload 指向 entry 模块。
- 修改要点：调整预加载模块 type；entry 仅作入口规范用途。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0204206442828388113

### 【上架检测FAQ】应用/元服务/游戏bundleName不可缺省
- 标准：`bundleName` 必须配置且合法。
- 常见失败：app.json5 缺 bundleName。
- 修改要点：补齐并保持全包一致；与签名/AGC 一致。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0202206355247094597

### 【上架检测FAQ】应用或元服务中鼠标操作对应功能能正常响应
- 标准：在支持键鼠的设备上，鼠标点击/滚轮等对应功能可用。
- 常见失败：仅触控可点，鼠标无响应；滚轮无法滚动。
- 修改要点：PC/平板键鼠路径回归；热区与 hover/点击事件打通。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0201206355466860984

### 【上架检测FAQ】应用/元服务/游戏安装无兼容性问题
- 标准：在目标设备上可正常安装，无安装失败或兼容性阻断。
- 常见失败：so 架构不匹配；包结构错误导致安装失败。
- 修改要点：安装日志定位；64 位 so；包结构与 SDK 版本配置正确。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0208208172478202080

### 【上架检测FAQ】应用或元服务所有Hap配置文件中bundleName、versionCode一致
- 标准：同一 App Pack 内所有 HAP 的 bundleName、versionCode 一致。
- 常见失败：多 module 版本号不一致。
- 修改要点：统一由 app.json5/工程配置驱动；打包前核对 pack.info。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0208208172745859081

### 【上架检测FAQ】应用/元服务/游戏需配置其支持运行的系统版本信息
- 标准：配置支持运行的最小/目标 SDK（OS）版本信息。
- 常见失败：缺 compatibleSdkVersion/targetSdkVersion 等。
- 修改要点：在工程/module 配置中声明并与实测设备匹配。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0208208172853820082

### 【上架检测FAQ】应用要支持64位so文件
- 标准：若含 native 库，须提供 64 位 so（按设备要求）。
- 常见失败：仅 32 位 so；缺 arm64-v8a。
- 修改要点：CMake/ABI 产出 64 位；检查 libs 目录架构。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0208208173558470083

### 【上架检测FAQ】应用/元服务/游戏包结构应符合规范
- 标准：App Pack 结构符合规范（如含且仅合理 Entry 等，module.type 正确）。
- 常见失败：无 entry 或多 entry 不合规；module 类型错误。
- 修改要点：核对 Stage 包结构；entry/feature/shared 类型正确。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0203208709888398225

### 【上架检测FAQ】应用/元服务/游戏升级无兼容性问题
- 标准：覆盖升级成功，功能与数据可继承，无升级后无法启动等。
- 常见失败：升级失败；升级后崩溃；数据不兼容。
- 修改要点：升级路径实测；数据迁移兼容；versionCode 递增。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0208208711194212284

### 【上架检测FAQ】应用或元服务中的走焦事件能够响应tab键或方向键切换
- 标准：键鼠/键盘场景下焦点可在可聚焦控件间用 Tab/方向键移动并响应。
- 常见失败：焦点陷阱；控件不可焦；方向键无反应。
- 修改要点：合理 `focusable`；焦点链测试；自定义组件转发按键。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0207208712552864266

### 【上架检测FAQ】元服务禁止使用so文件
- 标准：元服务不得集成 Native so。
- 常见失败：元服务包内含 .so 或依赖含 so 的库。
- 修改要点：移除 native 依赖；改用纯 ArkTS/允许的共享能力。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0208208712669004285

### 【上架检测FAQ】应用/元服务/游戏升级后类型不可变更
- 标准：升级不得变更应用/元服务等包类型。
- 常见失败：应用改元服务或反之导致升级失败。
- 修改要点：保持 bundleType 稳定；类型变更走新产品而非覆盖升级。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0203209384691240437

### 【上架检测FAQ】登入账号，应用升级无兼容性问题
- 标准：登录态下覆盖升级后账号与关键数据兼容，可继续使用。
- 常见失败：升级后被迫异常登出且数据丢失；登录态崩溃。
- 修改要点：令牌/本地会话迁移；升级后回归登录主路径。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0208209384884484499

### 【上架检测FAQ】应用或元服务卸载无残留
- 标准：卸载后无文件/数据/进程残留（系统文件管理器视角无残留数据）。
- 常见失败：卸载失败；私有目录外乱写导致残留；进程未退出。
- 修改要点：数据写在应用沙箱；退订后台任务；卸载路径实测。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0201211195141984813

### 【上架检测FAQ】应用或元服务中键盘快捷键操作应满足标准定义且不与系统定义冲突
- 标准：自定义快捷键符合标准且不与系统快捷键冲突。
- 常见失败：占用系统保留快捷键；未声明却拦截系统组合键。
- 修改要点：避开系统快捷键表；仅在获焦场景响应；提供可发现的快捷键说明。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0208211195312592035
