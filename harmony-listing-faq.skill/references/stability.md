# 稳定性上架检测标准（5项）

### 【上架检测FAQ】应用崩溃
- 标准：在支持的 OS/设备上正常使用过程中不出现 CppCrash、JsCrash、OOM 等导致进程退出。
- 常见失败：空指针/越界；NAPI 异常；启动或关键路径闪退。
- 修改要点：按 JsCrash/CppCrash 日志定位；主路径空值与异常捕获；发布前稳定性压测 + 上架预检；报告导入 AppAnalyzer。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0214198799180841232

### 【上架检测FAQ】应用卡死
- 标准：不出现主线程长时间无响应（AppFreeze）、冻屏、必须强杀才能退出的情况。
- 常见失败：UI 线程同步重 I/O/计算；死循环；页面无法退出。
- 修改要点：重任务下沉 Worker/任务池；分析 AppFreeze 日志；避免启动期阻塞主线程。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0214201777966964602

### 【上架检测FAQ】内存泄漏
- 标准：长时间运行内存可控，无持续上涨不释放，无不必要的对象/监听器滞留。
- 常见失败：监听器未 off；定时器未 clear；大图/缓存无限增长。
- 修改要点：Ability/页面销毁释放监听与定时器；用 Profiler/HiDebug 查泄漏；列表复用与图片缓存上限。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0203218141163476450

### 【上架检测FAQ】资源过载（fd过载）
- 标准：文件句柄/FD 使用在合理范围，无未关闭文件、socket、管道导致 FD 耗尽。
- 常见失败：打开文件/网络连接未关闭；异常路径跳过 close。
- 修改要点：`try/finally` 或 RAII 式关闭；限制并发连接；稳定性长稳跑监控 FD。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0202218141320678293

### 【上架检测FAQ】资源过载（线程过载）
- 标准：线程数量在合理范围，无失控创建线程导致资源过载。
- 常见失败：每次请求新建线程；线程池无上限；重复启动未回收任务。
- 修改要点：复用任务池/线程池；设上限与队列；退出时停止任务；长稳监控线程数。
- 源：https://developer.huawei.com/consumer/cn/forum/topic/0202218141379550294
