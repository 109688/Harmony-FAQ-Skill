# 功耗上架检测标准（5项）

### 【上架检测FAQ】应用处于前台不可见动效时，需立即停止相关动效的资源占用
- 标准：页面/组件不可见（被遮挡、切 Tab、进后台过渡等）时，立即停止相关动效与不必要渲染，避免空转耗电。
- 常见失败：离屏动画/视频仍跑；不可见 Lottie/属性动画未 pause。
- 修改要点：`onPageHide`/`onInactive`/`visibility` 变化时 pause/stop；可见再 resume；减少过度绘制。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0202201777916584972

### 【上架检测FAQ】应用退后台禁止使用传感器
- 标准：进入后台后不得继续占用传感器（如加速度、陀螺、持续定位相关不合理占用），无业务必要则断链。
- 常见失败：退后台仍高频读传感器；定位/传感器未在 `onBackground` 释放。
- 修改要点：生命周期中 stop 传感器订阅；后台仅保留合规长时任务并声明类型；上架预检功耗项。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0203203100333705947

### 【上架检测FAQ】音乐类应用设置正确的音乐类型
- 标准：音乐类应用正确设置音频/应用类型，便于系统正确调度音频焦点与功耗策略。
- 常见失败：播放音乐却用错误 stream/usage；类型与业务不符。
- 修改要点：按媒体文档设置正确 `AudioRenderer`/`AVPlayer` 的 usage/contentType；`module.json5` 与应用品类一致。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0203205082698244392

### 【上架检测FAQ】导航类要设置正确的应用类型
- 标准：导航类应用正确声明应用/音频类型，后台导航播报等行为符合系统策略。
- 常见失败：导航播报类型错误导致被静音或异常保活；品类与实际不符。
- 修改要点：导航场景使用正确音频 usage；后台能力与长时任务类型匹配；避免伪装其它类型。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0203205082788152393

### 【上架检测FAQ】后台合理使用音频播放
- 标准：后台音频仅在用户可预期场景继续播放，停止播放后释放资源，无静默后台播音。
- 常见失败：用户暂停后仍占音频焦点；无播放却保活；异常打断后未释放。
- 修改要点：处理后台音频焦点与打断；停止时 release；申请后台音频相关能力需与功能一致。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0201211194974238812
