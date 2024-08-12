# WebView的speedometer2和JetStream2.0跑分过低原因排查

在UNISOC/uis7885_s880机器上进行了测试，记录了WebView在运行speedometer2 Benchmark的情况下，CPU的频率及和核心占用情况。

通过手动push kengine的配置文件来启用/禁用kengine完成测试。

## 开启kengine功耗管理情况下

1.目标WebView进程及线程的CPU占用

Threads: 32 total,   1 running,  31 sleeping,   0 stopped,   0 zombie
  Mem:  7550872K total,  7150800K used,   400072K free,     6176K buffers
 Swap:  4681536K total,   170496K used,  4511040K free,  4633124K cached
800%cpu 177%user   2%nice 119%sys 487%idle   0%iow  11%irq   5%sirq   0%host
  TID USER         PR  NI VIRT  RES  SHR S[%CPU] %MEM     TIME+ THREAD          PROCESS                                                                                                                                                                                                   
 4109 u0_i9000     20   0 1.6G 189M  96M R 96.3   2.5  24:15.84 CrRendererMain  com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 5643 u0_i9000     20   0 1.6G 189M  96M S 10.6   2.5   0:21.54 ThreadPoolForeg com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 5768 u0_i9000     20   0 1.6G 189M  96M S 10.3   2.5   0:21.98 ThreadPoolForeg com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 5813 u0_i9000     20   0 1.6G 189M  96M S  9.0   2.5   0:23.45 ThreadPoolForeg com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 5174 u0_i9000     20   0 1.6G 189M  96M S  5.0   2.5   0:25.12 ThreadPoolForeg com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 5815 u0_i9000     20   0 1.6G 189M  96M S  4.6   2.5   0:24.29 ThreadPoolForeg com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 5812 u0_i9000     20   0 1.6G 189M  96M S  4.3   2.5   0:25.49 ThreadPoolForeg com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 5814 u0_i9000     20   0 1.6G 189M  96M S  4.0   2.5   0:22.00 ThreadPoolForeg com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4164 u0_i9000     16  -4 1.6G 189M  96M S  2.6   2.5   0:50.86 Compositor      com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4157 u0_i9000     16  -4 1.6G 189M  96M S  2.6   2.5   0:51.60 Chrome_ChildIOT com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4154 u0_i9000     20   0 1.6G 189M  96M S  0.3   2.5   0:00.97 ThreadPoolServi com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 8886 u0_i9000     20   0 1.6G 189M  96M S  0.0   2.5   0:00.12 MemoryInfra     com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4167 u0_i9000     30  10 1.6G 189M  96M S  0.0   2.5   0:00.00 CompositorTileW com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4166 u0_i9000     20   0 1.6G 189M  96M S  0.0   2.5   0:04.42 CompositorTileW com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4165 u0_i9000     20   0 1.6G 189M  96M S  0.0   2.5   0:00.00 ThreadPoolSingl com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4160 u0_i9000     20   0 1.6G 189M  96M S  0.0   2.5   0:00.00 GpuMemoryThread com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4106 u0_i9000     20   0 1.6G 189M  96M S  0.0   2.5   0:00.00 binder:4089_3   com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4102 u0_i9000     20   0 1.6G 189M  96M S  0.0   2.5   0:00.00 binder:4089_1   com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4105 u0_i9000     20   0 1.6G 189M  96M S  0.0   2.5   0:00.00 Verification th com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4103 u0_i9000     20   0 1.6G 189M  96M S  0.0   2.5   0:00.00 binder:4089_2   com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4096 u0_i9000      0 -20 1.6G 189M  96M S  0.0   2.5   0:00.00 perfetto_hprof_ com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4097 u0_i9000      0 -20 1.6G 189M  96M S  0.0   2.5   0:00.00 ADB-JDWP Connec com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4098 u0_i9000     24   4 1.6G 189M  96M S  0.0   2.5   0:00.02 HeapTaskDaemon  com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4099 u0_i9000     24   4 1.6G 189M  96M S  0.0   2.5   0:00.00 ReferenceQueueD com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxewdProcessService0:0
 4100 u0_i9000     24   4 1.6G 189M  96M S  0.0   2.5   0:00.00 FinalizerDaemon com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4101 u0_i9000     24   4 1.6G 189M  96M S  0.0   2.5   0:00.00 FinalizerWatchd com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4095 u0_i9000      0 -20 1.6G 189M  96M S  0.0   2.5   0:00.00 Signal Catcher  com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4094 u0_i9000      0 -20 1.6G 189M  96M S  0.0   2.5   0:00.00 Runtime worker  com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4093 u0_i9000      0 -20 1.6G 189M  96M S  0.0   2.5   0:00.00 Runtime worker  com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4092 u0_i9000      0 -20 1.6G 189M  96M S  0.0   2.5   0:00.00 Runtime worker  com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4091 u0_i9000      0 -20 1.6G 189M  96M S  0.0   2.5   0:00.00 Runtime worker  com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4089 u0_i9000     10 -10 1.6G 189M  96M S  0.0   2.5   0:00.02 ocessService0:0 com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0

2.CPU频率
	max	min	cur
cpu0	2184000	614400	1703000
cpu1	2184000	614400	1703000
cpu2	2184000	614400	1703000
cpu3	2184000	614400	1703000
cpu4	2301000	614400	614400
cpu5	2301000	614400	614400
cpu6	2301000	614400	614400
cpu7	2704000	614400	26000

3.目标WebView进程及线程的CPU核心占用

取的某一常见时刻下的瞬时占用

4089 	 (ocessService0:0) 	 1
4091 	 (Runtime 	 0
4092 	 (Runtime 	 0
4093 	 (Runtime 	 0
4094 	 (Runtime 	 0
4095 	 (Signal 	 -1
4096 	 (perfetto_hprof_) 	 4
4097 	 (ADB-JDWP 	 -1
4098 	 (HeapTaskDaemon) 	 3
4099 	 (ReferenceQueueD) 	 5
4100 	 (FinalizerDaemon) 	 7
4101 	 (FinalizerWatchd) 	 6
4102 	 (binder:4089_1) 	 1
4103 	 (binder:4089_2) 	 4
4105 	 (Verification 	 -1
4106 	 (binder:4089_3) 	 2
4109 	 (CrRendererMain) 	 0
4154 	 (ThreadPoolServi) 	 5
4157 	 (Chrome_ChildIOT) 	 1
4160 	 (GpuMemoryThread) 	 4
4164 	 (Compositor) 	 2
4165 	 (ThreadPoolSingl) 	 3
4166 	 (CompositorTileW) 	 4
4167 	 (CompositorTileW) 	 4
8886 	 (MemoryInfra) 	 3
5174 	 (ThreadPoolForeg) 	 4
4089 	 (ocessService0:0) 	 1

该种情况下 speedometer2 的跑分在 15 左右

4. 保持一定时间静止后（屏幕打开或关闭并不影响）的cpu频率：

	max	min	cur
cpu0	2184000	614400	1105000
cpu1	2184000	614400	1105000
cpu2	2184000	614400	1105000
cpu3	2184000	614400	1105000
cpu4	2301000	614400	614400
cpu5	2301000	614400	614400
cpu6	2301000	614400	614400
cpu7	2704000	614400	26000

可见，一段时间静止后7885的超大核休眠、4颗小核中频运行，3颗大核低频运行。

## 关闭kengine功耗管理情况下

1.目标WebView进程及线程的CPU占用

Threads: 30 total,   1 running,  29 sleeping,   0 stopped,   0 zombie
  Mem:  7550872K total,  5186236K used,  2364636K free,     6060K buffers
 Swap:  4681536K total,    28672K used,  4652864K free,  2166588K cached
800%cpu 191%user   1%nice 144%sys 451%idle   0%iow   9%irq   4%sirq   0%host
  TID USER         PR  NI VIRT  RES  SHR S[%CPU] %MEM     TIME+ THREAD          PROCESS                                                                                                                                                                                                   
 4435 u0_i9000     20   0 1.6G 243M  96M R 87.6   3.2   0:34.01 CrRendererMain  com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4509 u0_i9000     20   0 1.6G 243M  96M S  9.0   3.2   0:02.68 ThreadPoolForeg com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 6830 u0_i9000     20   0 1.6G 243M  96M S  8.3   3.2   0:01.91 ThreadPoolForeg com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 6831 u0_i9000     20   0 1.6G 243M  96M S  6.0   3.2   0:01.52 ThreadPoolForeg com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4511 u0_i9000     20   0 1.6G 243M  96M S  6.0   3.2   0:02.15 ThreadPoolForeg com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4510 u0_i9000     16  -4 1.6G 243M  96M S  6.0   3.2   0:01.80 Chrome_ChildIOT com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 6828 u0_i9000     20   0 1.6G 243M  96M S  5.6   3.2   0:02.20 ThreadPoolForeg com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4513 u0_i9000     16  -4 1.6G 243M  96M S  4.3   3.2   0:01.73 Compositor      com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4508 u0_i9000     20   0 1.6G 243M  96M S  4.3   3.2   0:02.26 ThreadPoolForeg com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 6829 u0_i9000     20   0 1.6G 243M  96M S  3.0   3.2   0:02.10 ThreadPoolForeg com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4515 u0_i9000     20   0 1.6G 243M  96M S  0.3   3.2   0:00.27 CompositorTileW com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4516 u0_i9000     30  10 1.6G 243M  96M S  0.0   3.2   0:00.00 CompositorTileW com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4514 u0_i9000     20   0 1.6G 243M  96M S  0.0   3.2   0:00.00 ThreadPoolSingl com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4512 u0_i9000     20   0 1.6G 243M  96M S  0.0   3.2   0:00.00 GpuMemoryThread com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4507 u0_i9000     20   0 1.6G 243M  96M S  0.0   3.2   0:00.03 ThreadPoolServi com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4431 u0_i9000     20   0 1.6G 243M  96M S  0.0   3.2   0:00.00 binder:4418_2   com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4432 u0_i9000     20   0 1.6G 243M  96M S  0.0   3.2   0:00.00 Verification th com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4430 u0_i9000     20   0 1.6G 243M  96M S  0.0   3.2   0:00.00 binder:4418_1   com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4422 u0_i9000      0 -20 1.6G 243M  96M S  0.0   3.2   0:00.00 Runtime worker  com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4423 u0_i9000      0 -20 1.6G 243M  96M S  0.0   3.2   0:00.00 Signal Catcher  com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4424 u0_i9000      0 -20 1.6G 243M  96M S  0.0   3.2   0:00.00 perfetto_hprof_ com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4425 u0_i9000      0 -20 1.6G 243M  96M S  0.0   3.2   0:00.00 ADB-JDWP Connec com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4426 u0_i9000     24   4 1.6G 243M  96M S  0.0   3.2   0:00.02 HeapTaskDaemon  com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4427 u0_i9000     24   4 1.6G 243M  96M S  0.0   3.2   0:00.00 ReferenceQueueD com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4428 u0_i9000     24   4 1.6G 243M  96M S  0.0   3.2   0:00.00 FinalizerDaemon com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4429 u0_i9000     24   4 1.6G 243M  96M S  0.0   3.2   0:00.00 FinalizerWatchd com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4421 u0_i9000      0 -20 1.6G 243M  96M S  0.0   3.2   0:00.00 Runtime worker  com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4420 u0_i9000      0 -20 1.6G 243M  96M S  0.0   3.2   0:00.00 Runtime worker  com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4419 u0_i9000      0 -20 1.6G 243M  96M S  0.0   3.2   0:00.00 Runtime worker  com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0
 4418 u0_i9000     10 -10 1.6G 243M  96M S  0.0   3.2   0:00.02 ocessService0:0 com.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0

2.CPU频率

	max	min	cur
cpu0	2184000	614400	614400
cpu1	2184000	614400	1560000
cpu2	2184000	614400	1846000
cpu3	2184000	614400	1560000
cpu4	2301000	614400	2210000
cpu5	2301000	614400	2210000
cpu6	2301000	614400	2210000
cpu7	2704000	614400	768000

3.目标WebView进程及线程的CPU核心占用

取的某一常见时刻下的瞬时占用

4418 	 (ocessService0:0) 	 1
4419 	 (Runtime 	 0
4420 	 (Runtime 	 0
4421 	 (Runtime 	 0
4422 	 (Runtime 	 0
4423 	 (Signal 	 -1
4424 	 (perfetto_hprof_) 	 5
4425 	 (ADB-JDWP 	 -1
4426 	 (HeapTaskDaemon) 	 5
4427 	 (ReferenceQueueD) 	 1
4428 	 (FinalizerDaemon) 	 6
4429 	 (FinalizerWatchd) 	 2
4430 	 (binder:4418_1) 	 5
4431 	 (binder:4418_2) 	 6
4432 	 (Verification 	 -1
4435 	 (CrRendererMain) 	 4
4507 	 (ThreadPoolServi) 	 0
4508 	 (ThreadPoolForeg) 	 7
4509 	 (ThreadPoolForeg) 	 6
4510 	 (Chrome_ChildIOT) 	 1
4511 	 (ThreadPoolForeg) 	 5
4512 	 (GpuMemoryThread) 	 5
4513 	 (Compositor) 	 0
4514 	 (ThreadPoolSingl) 	 4
4515 	 (CompositorTileW) 	 2
4516 	 (CompositorTileW) 	 5
6828 	 (ThreadPoolForeg) 	 2
6829 	 (ThreadPoolForeg) 	 6
6830 	 (ThreadPoolForeg) 	 7
6831 	 (ThreadPoolForeg) 	 3
4418 	 (ocessService0:0) 	 1

该种情况下 speedometer2 的跑分在 38~48 之间

4. 保持一定时间静止后（屏幕打开或关闭并不影响）的cpu频率：

	max	min	cur
cpu0	2184000	614400	614400
cpu1	2184000	614400	614400
cpu2	2184000	614400	614400
cpu3	2184000	614400	614400
cpu4	2301000	614400	2210000
cpu5	2301000	614400	2210000
cpu6	2301000	614400	2210000
cpu7	2704000	614400	26000

可见，一段时间静止后7885的超大核休眠、4颗小核低频运行，3颗大核高频运行。

## 手动绑定核心

1.目标WebView进程及线程的CPU核心占用

5364 	 (ocessService0:0) 	 7
5365 	 (Runtime 	 0
5366 	 (Runtime 	 0
5367 	 (Runtime 	 0
5368 	 (Runtime 	 0
5369 	 (Signal 	 -1
5370 	 (perfetto_hprof_) 	 6
5371 	 (ADB-JDWP 	 -1
5372 	 (HeapTaskDaemon) 	 2
5373 	 (ReferenceQueueD) 	 1
5374 	 (FinalizerDaemon) 	 0
5375 	 (FinalizerWatchd) 	 4
5376 	 (binder:5364_1) 	 4
5377 	 (binder:5364_2) 	 4
5378 	 (Verification 	 -1
5379 	 (binder:5364_3) 	 0
5380 	 (CrRendererMain) 	 7
5427 	 (ThreadPoolServi) 	 0
5431 	 (Chrome_ChildIOT) 	 1
5435 	 (GpuMemoryThread) 	 5
5439 	 (Compositor) 	 4
5440 	 (ThreadPoolSingl) 	 5
5441 	 (CompositorTileW) 	 1
5442 	 (CompositorTileW) 	 5
7323 	 (ThreadPoolForeg) 	 0
8679 	 (MemoryInfra) 	 6
27358 	 (ThreadPoolForeg) 	 3
27601 	 (ThreadPoolForeg) 	 4
27607 	 (ThreadPoolForeg) 	 6
27613 	 (ThreadPoolForeg) 	 2
27614 	 (ThreadPoolForeg) 	 1
27615 	 (ThreadPoolForeg) 	 5
5364 	 (ocessService0:0) 	 7

2.CPU频率
	max	min	cur
cpu0	2184000	614400	1703000
cpu1	2184000	614400	1703000
cpu2	2184000	614400	1703000
cpu3	2184000	614400	1703000
cpu4	2301000	614400	614400
cpu5	2301000	614400	614400
cpu6	2301000	614400	614400
cpu7	2704000	614400	614400

开启kengine功耗管理情况下并将JS主线程绑定到超大核或大核，线程池绑定到大核的情况下 speedometer2 的跑分略低于15分，且大核和超大核无法突破614400的频率。

关闭kengine功耗管理情况下并将JS主线程绑定到小核，speedometer2 的跑分20分左右，且大核和小核的频率接近跑满。

## 总结

speedometer2 Benchmark可认为仅与JS主线程(亦可认为是渲染线程，即上面线程名为CrRendererMain的线程)相关。

对比开关kengine的两种情况下，主要差异点有：

1. JS主线程开kengine时运行在小核，关kengine时运行在大核或超大核
2. 静止状态下，关kengine算力DMIPS是开kengine的1.5倍
3. 活跃状态下，关kengine算力DMIPS是开kengine的1.5~2倍
4. speedometer2 Benchmark的跑分差距相差2.5~3.2倍
