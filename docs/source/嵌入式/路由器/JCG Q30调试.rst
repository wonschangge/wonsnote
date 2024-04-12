JCG Q30调试
==================================

串口连接设备后，内核日志打印太多，无法在控制台进行正常交互，暂时关闭内核日志打印：

```shell
echo 0 > /proc/sys/kernel/printk
```

U-Boot内部基本信息
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

version
-----------------------------------------------------------

.. code::shell

  MT7981> version 
  U-Boot 2022.07-rc5 (Jul 18 2022 - 10:55:13 +0800)

  aarch64-linux-gnu-gcc (Ubuntu/Linaro 7.5.0-3ubuntu1~18.04) 7.5.0
  GNU ld (GNU Binutils for Ubuntu) 2.30

mtd list
-----------------------------------------------------------

.. code::shell
  
  MT7981> mtd list
  List of MTD devices:
  * spi-nand0
    - device: spi_nand@0
    - parent: spi@1100a000
    - driver: spi_nand
    - path: /spi@1100a000/spi_nand@0
    - type: NAND flash
    - block size: 0x20000 bytes
    - min I/O: 0x800 bytes
    - OOB size: 64 bytes
    - OOB available: 24 bytes
    - 0x000000000000-0x000008000000 : "spi-nand0"
  * nmbm0
    - type: Unknown
    - block size: 0x20000 bytes
    - min I/O: 0x800 bytes
    - OOB size: 64 bytes
    - OOB available: 24 bytes
    - 0x000000000000-0x000007800000 : "nmbm0"
            - 0x000000000000-0x000000100000 : "bl2"
            - 0x000000100000-0x000000180000 : "u-boot-env"
            - 0x000000180000-0x000000380000 : "factory"
            - 0x000000380000-0x000000580000 : "fip"
            - 0x000000580000-0x000004580000 : "ubi"

printenv
-----------------------------------------------------------

.. code::shell
  
  MT7981> printenv 
  baudrate=115200
  bootdelay=2
  bootfile=0312czg.bin
  bootmenu_0=Startup system (Default)=mtkboardboot
  bootmenu_1=Upgrade firmware=mtkupgrade fw
  bootmenu_2=Upgrade ATF BL2=mtkupgrade bl2
  bootmenu_3=Upgrade ATF FIP=mtkupgrade fip
  bootmenu_4=Upgrade single image=mtkupgrade simg
  bootmenu_5=Load image=mtkload
  dual_boot.current_slot=0
  dual_boot.slot_0_invalid=0
  dual_boot.slot_1_invalid=0
  ethact=ethernet@15100000
  ethaddr=26:af:c3:37:5f:11
  fdtcontroladdr=4f7fe370
  fileaddr=46000000
  filesize=1678b37
  ipaddr=192.168.10.1
  loadaddr=0x46000000
  mtdids=nmbm0=nmbm0
  mtdparts=nmbm0:1024k(bl2),512k(u-boot-env),2048k(factory),2048k(fip),65536k(ubi)
  netmask=255.255.255.0
  serverip=192.168.10.2
  stderr=serial@11002000
  stdin=serial@11002000
  stdout=serial@11002000

  Environment size: 744/524284 bytes

Linux内部基本信息
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

df
-----------------------------------------------------------

.. code::shell

  root@AOS:/etc/config# df -h
  Filesystem                Size      Used Available Use% Mounted on
  /dev/root                18.8M     18.8M         0 100% /rom
  tmpfs                   111.2M      1.1M    110.1M   1% /tmp
  /dev/ubi0_4               5.7M    600.0K      4.8M  11% /overlay
  overlayfs:/overlay        5.7M    600.0K      4.8M  11% /
  tmpfs                   512.0K         0    512.0K   0% /dev
  /dev/ubi0_6             344.0K     24.0K    268.0K   8% /mnt/ubi0_6


mount
-----------------------------------------------------------

.. code::shell

  root@AOS:/etc/config# mount
  /dev/root on /rom type squashfs (ro,relatime)
  proc on /proc type proc (rw,nosuid,nodev,noexec,noatime)
  sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,noatime)
  cgroup2 on /sys/fs/cgroup type cgroup2 (rw,nosuid,nodev,noexec,relatime,nsdelegate)
  tmpfs on /tmp type tmpfs (rw,nosuid,nodev,noatime)
  /dev/ubi0_4 on /overlay type ubifs (rw,noatime,assert=read-only,ubi=0,vol=4)
  overlayfs:/overlay on / type overlay (rw,noatime,lowerdir=/,upperdir=/overlay/upper,workdir=/overlay/work)
  tmpfs on /dev type tmpfs (rw,nosuid,noexec,noatime,size=512k,mode=755)
  devpts on /dev/pts type devpts (rw,nosuid,noexec,noatime,mode=600,ptmxmode=000)
  debugfs on /sys/kernel/debug type debugfs (rw,noatime)
  none on /sys/fs/bpf type bpf (rw,nosuid,nodev,noexec,noatime,mode=700)
  /dev/ubi0_6 on /mnt/ubi0_6 type ubifs (rw,relatime,assert=read-only,ubi=0,vol=6)
  mountd(pid3319) on /tmp/run/blockd type autofs (rw,relatime,fd=7,pgrp=1,timeout=21474836510,minproto=5,maxproto=5,indirect)
  tracefs on /sys/kernel/debug/tracing type tracefs (rw,noatime)


cat /proc/cpuinfo 
-----------------------------------------------------------

.. code::shell

  root@AOS:/etc/config# cat /proc/cpuinfo 
  processor       : 0
  model name      : ARMv8 Processor rev 4 (v8l)
  BogoMIPS        : 26.00
  Features        : fp asimd evtstrm aes pmull sha1 sha2 crc32 cpuid
  CPU implementer : 0x41
  CPU architecture: 8
  CPU variant     : 0x0
  CPU part        : 0xd03
  CPU revision    : 4

  processor       : 1
  model name      : ARMv8 Processor rev 4 (v8l)
  BogoMIPS        : 26.00
  Features        : fp asimd evtstrm aes pmull sha1 sha2 crc32 cpuid
  CPU implementer : 0x41
  CPU architecture: 8
  CPU variant     : 0x0
  CPU part        : 0xd03
  CPU revision    : 4



uname -a
-----------------------------------------------------------

.. code::shell

  root@AOS:/etc/config# uname -a
  Linux AOS 5.10.168 #0 SMP Mon Mar 11 02:29:14 2024 aarch64 GNU/Linux
  root@AOS:/etc/config# cat /proc/version 
  Linux version 5.10.168 (czgbyer@czgbyer-PC) (aarch64-openwrt-linux-musl-gcc (OpenWrt GCC 11.2.0 r0-0b2715c30) 11.2.0, GNU ld (GNU Binutils) 2.37) #0 SM4


uboot相关
-----------------------------------------------------------

.. code::shell

  root@AOS:/sys/firmware/devicetree/base/chosen# cat name 
  chosen
  root@AOS:/sys/firmware/devicetree/base/chosen# cat u-boot,bootconf
  config-1root
  root@AOS:/sys/firmware/devicetree/base/chosen# cat u-boot,version
  2022.07-rc5
  root@AOS:/sys/firmware/devicetree/base/chosen# cat bootargs
  boot_rootfs_part=rootfs boot_param.upgrade_kernel_part=kernel2 boot_param.upgrade_rootfs_part=rootfs2 boot_param.env_part=volu-env boot_param.rootfs_data_part=rootfs_data boot_param.boot_image_slot=0 boot_param.upgrade_image_slot=1 boot_param.dual_boot^@


kernel启动参数

boot_rootfs_part=rootfs boot_param.upgrade_kernel_part=kernel2 boot_param.upgrade_rootfs_part=rootfs2 boot_param.env_part=volu-env boot_param.rootfs_data_part=rootfs_data boot_param.boot_image_slot=0 boot_param.upgrade_image_slot=1 boot_param.dual_boot^@


分析
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


mount
-----------------------------------------------------------

挂载了非常多类型的fs，常规的有：

- proc on /proc type proc (rw,nosuid,nodev,noexec,noatime)

- sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,noatime)

- cgroup2 on /sys/fs/cgroup type cgroup2 (rw,nosuid,nodev,noexec,relatime,nsdelegate)

- tmpfs on /tmp type tmpfs (rw,nosuid,nodev,noatime)

- tracefs on /sys/kernel/debug/tracing type tracefs (rw,noatime)

- overlayfs:/overlay on / type overlay(rw,noatime,lowerdir=/,upperdir=/overlay/upper,workdir=/overlay/work)

- tmpfs on /dev type tmpfs (rw,nosuid,noexec,noatime,size=512k,mode=755)

- debugfs on /sys/kernel/debug type debugfs (rw,noatime)

- none on /sys/fs/bpf type bpf (rw,nosuid,nodev,noexec,noatime,mode=700)

特别的：

- /dev/root on /rom type squashfs (ro,relatime)
  
  - /rom的作用？

- devpts on /dev/pts type devpts (rw,nosuid,noexec,noatime,mode=600,ptmxmode=000)
  
  - /dev/pts的作用？

- /dev/ubi0_4 on /overlay type ubifs (rw,noatime,assert=read-only,ubi=0,vol=4)
  
  - /overlay上为何又使用 ubifs 而不是 overlayfs

- /dev/ubi0_6 on /mnt/ubi0_6 type ubifs (rw,relatime,assert=read-only,ubi=0,vol=6)
  
  - ubi0_6 划分的意义，及为何使用 ubifs

- 这个/tmp/run/blockd不知何用：

- mountd(pid3293) on /tmp/run/blockd type autofs (rw,relatime,fd=7,pgrp=1,timeout=21474836510,minproto=5,maxproto=5,indirect)

嵌入式上的各种文件系统和MTD技术紧密相关，MTD是Media Techonolody Device（内存技术设备）的缩写，MTD是一个处理大多数原始闪存硬件（如NOR、Nand、dataflash、SPI flash）的统称，可认为是一块单独的Linux子系统，用于提供对这些存储硬件及专用fs的字符和块访问。

属于MTD范畴的硬件：

- Nand flash

- Nor flash

- OneNand flash

- Atmel dataflash

- SPI flash

非MTD范畴的硬件：

- USB插入的设备 （归USB和SCSI管理）

- Compact Flash - 归PC Card/IDE子系统管

- EEPROMS （归SPI EEPROM驱动或I2C EEPROM驱动管理）

- MMC/SD卡 (归MMC驱动管)

MTD提供的能力：

- 将存储芯片作为块或字符设备访问

- 将单个芯片划分为多个更小分区的能力

- 功能以处理闪存为中心，包括磨损均衡、坏块检测和处理、带外（OOB）数据

- 有许多fs专用于MTD

UBI 本身指“未排序的块映像（Unsorted Block Images）”，它是MTD中