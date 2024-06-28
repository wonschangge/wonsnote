U-Boot的核心问题
=================

1. 计算机系统的主要部件

以CPU核心来运行，PC机、嵌入式设备（手机、平板、游戏机）、MCU（家用电器）

核心部件：CPU+内存）DDR SDRAM/SDRAM/SRAM）+外存（Flash/Disk）

2. PC机的启动过程

1) 部署. PC机BIOS程序部署在PC机主板，OS部署在硬盘，内存在掉电时无作用，CPU在掉电时不工作。
2) 启动. PC上电执行BIOS（NorFlash），BIOS初始化DDR内存和硬盘，并从硬盘上读取OS到DDR中，再跳转到DDR中执行OS直到启动。

3. 嵌入式Linux的启动过程

1) 部署. uboot部署在Flash上，OS部署在Flash上，内存掉电时无作用、CPU在掉电时不工作。
2) 启动. 上电先指向uboot，uboot初始化DDR、Flash，将OS从Flash中读取到DDR中，启动OS。

4. Android的启动过程

1) 前面一样，但内核启动后加载根文件系统后不同。





Uboot来历

1. 