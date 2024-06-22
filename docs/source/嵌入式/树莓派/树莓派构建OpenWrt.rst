树莓派构建OpenWrt
===========================================================

直接构建 target/linux/<platform>/image/<package>
-----------------------------------------------------------

在 menuconfig 指定平台后，可通过 make target/linux/{clean,compile} V=s 进行编译

树莓派
-----------------------------------------------------------

Overlays A/B rootfs

目标: 使用 u-Boot 设置一个具有 A/B OTA 的系统，在 FAT 分区中只保留一些不变的文件，而大多数文件在分区 A 或 B 上的 /boot 中，以便更新可以包括内核和 overlays，如：

在 mmcblk0p1 (Fat, /) 中:

bootcode.bin config.txt (minimal config) cmdline.txt fixup.dat start.elf kernel7.img (is really u-boot.bin)

在 mmcblk0p2 (ext4, /boot) 中

bcm2710-rpi-3-b.dtb config.txt (full config) boot.scr uImage overlays/

不清楚 DT 文件/config.txt 的工作方式及他们的使用时间（系统启动、内核启动等），是否可以用另一个文件覆盖初始 config.txt？

树莓派有多种启动方法，但都归结为：

1) 找到并加载bootcode.bin
   
2) 加载start*.elf

3) 加载config.txt，从头开始 wrt config.txt
   
4) 加载内核（可以是U-boot)和cmdline.txt
   
5) 加载DTB和任何overlays
   
6) 启动内核固件

仅识别FAT16/32/VFAT，因此加载来自其他文件系统（包括ext4）的数据必须由内核/U-boot完成。

U-boot可以使用pi固件传递给他的dtb，也可以加载自己的dtb。







