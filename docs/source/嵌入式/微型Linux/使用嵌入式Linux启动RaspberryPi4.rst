`使用嵌入式Linux启动RaspberryPi4`_
======================================

.. _使用嵌入式Linux启动RaspberryPi4: https://hechao.li/2021/12/20/Boot-Raspberry-Pi-4-Using-uboot-and-Initramfs/
.. _crosstool-NG: https://crosstool-ng.github.io/
.. _精彩解释一文: https://crosstool-ng.github.io/docs/toolchain-construction/
.. _文件系统层次结构标准: https://refspecs.linuxfoundation.org/FHS_3.0/fhs-3.0.pdf

0. 概述
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
这篇文章的目的是了解嵌入式Linux的四个组成部分 —— 工具链、引导加载程序、内核、根文件系统 —— 通过使用最少的代码从头开始启动 Raspberry Pi 4 的命令。

1. 硬件要求
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* 用于编译源代码的 Linux 桌面计算机。我正在使用 Ubuntu 20.04。
* 带有电源适配器的 Raspberry 4 型号 b。
* SD 卡和读卡器。我使用的是 2GB SD 卡。

2. 准备工作
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SD 卡将用于存储引导加载程序和根文件。所以，我们首先在其上创建两个分区 - boot（FAT32格式）和 root（ext4格式）。

2.1 查找TF卡设备名
------------------------------------

将 SD 读卡器插入 Linux PC 后，从dmesg或mount找到其设备名称。

::


   $ dmesg | tail
   [19304.704047] usbcore: registered new interface driver uas
   [19305.719653] scsi 33:0:0:0: Direct-Access     Mass     Storage Device   1.00 PQ: 0 ANSI: 0 CCS
   [19305.720283] sd 33:0:0:0: Attached scsi generic sg2 type 0
   [19305.725987] sd 33:0:0:0: [sdb] 3842048 512-byte logical blocks: (1.97 GB/1.83 GiB)
   [19305.728140] sd 33:0:0:0: [sdb] Write Protect is off
   [19305.728142] sd 33:0:0:0: [sdb] Mode Sense: 03 00 00 00
   [19305.730188] sd 33:0:0:0: [sdb] No Caching mode page found
   [19305.730750] sd 33:0:0:0: [sdb] Assuming drive cache: write through
   [19305.757769]  sdb: sdb1 sdb2
   [19305.788187] sd 33:0:0:0: [sdb] Attached SCSI removable disk

在本例中，设备名称为 sdb，并且它已经有两个分区sdb1和 sdb2。我将删除它们并重新分区 SD 卡。

2.2 删除现有分区
------------------------------------

::
   
   $ sudo fdisk /dev/sdb
   Welcome to fdisk (util-linux 2.34).
   Changes will remain in memory only, until you decide to write them.
   Be careful before using the write command.


   Command (m for help): d
   Partition number (1,2, default 2):

   Partition 2 has been deleted.

   Command (m for help): d
   Selected partition 1
   Partition 1 has been deleted.

   Command (m for help): p
   Disk /dev/sdb: 1.85 GiB, 1967128576 bytes, 3842048 sectors
   Disk model: Storage Device
   Units: sectors of 1 * 512 = 512 bytes
   Sector size (logical/physical): 512 bytes / 512 bytes
   I/O size (minimum/optimal): 512 bytes / 512 bytes
   Disklabel type: dos
   Disk identifier: 0x00000000

   Command (m for help): w
   The partition table has been altered.
   Calling ioctl() to re-read partition table.
   Syncing disks.


2.3 添加两个分区
------------------------------------

添加一个 100MB 的boot分区和一个剩余大小的root分区。


::


   $ sudo fdisk /dev/sdb

   Welcome to fdisk (util-linux 2.34).
   Changes will remain in memory only, until you decide to write them.
   Be careful before using the write command.


   Command (m for help): n
   Partition type
      p   primary (0 primary, 0 extended, 4 free)
      e   extended (container for logical partitions)
   Select (default p):

   Using default response p.
   Partition number (1-4, default 1):
   First sector (2048-3842047, default 2048):
   Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-3842047, default 3842047): +100M

   Created a new partition 1 of type 'Linux' and of size 100 MiB.
   Partition #1 contains a vfat signature.

   Do you want to remove the signature? [Y]es/[N]o: Y

   The signature will be removed by a write command.

   Command (m for help): n
   Partition type
      p   primary (1 primary, 0 extended, 3 free)
      e   extended (container for logical partitions)
   Select (default p):

   Using default response p.
   Partition number (2-4, default 2):
   First sector (206848-3842047, default 206848):
   Last sector, +/-sectors or +/-size{K,M,G,T,P} (206848-3842047, default 3842047):

   Created a new partition 2 of type 'Linux' and of size 1.8 GiB.
   Partition #2 contains a ext4 signature.

   Do you want to remove the signature? [Y]es/[N]o: Y

   The signature will be removed by a write command.

   Command (m for help): t
   Partition number (1,2, default 2): 1
   Hex code (type L to list all codes): b

   Changed type of partition 'Linux' to 'W95 FAT32'.

   Command (m for help): p
   Disk /dev/sdb: 1.85 GiB, 1967128576 bytes, 3842048 sectors
   Disk model: Storage Device
   Units: sectors of 1 * 512 = 512 bytes
   Sector size (logical/physical): 512 bytes / 512 bytes
   I/O size (minimum/optimal): 512 bytes / 512 bytes
   Disklabel type: dos
   Disk identifier: 0x00000000

   Device     Boot  Start     End Sectors  Size Id Type
   /dev/sdb1         2048  206847  204800  100M  b W95 FAT32
   /dev/sdb2       206848 3842047 3635200  1.8G 83 Linux

   Command (m for help): w
   The partition table has been altered.
   Calling ioctl() to re-read partition table.
   Syncing disks.


2.4 格式化分区
------------------------------------

::
   
   # FAT32 for boot partition
   $ sudo mkfs.vfat -F 32 -n boot /dev/sdb1

   # ext4 for root partition
   $ sudo mkfs.ext4 -L root /dev/sdb2


2.5 挂载分区
------------------------------------

挂载两个分区，以便我们可以写入它们。

::
   

   $ sudo mount /dev/sdb1 /mnt/boot
   $ sudo mount /dev/sdb2 /mnt/root


3. 工具链
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

首先，我们需要一个工具链来将源代码编译为运行在 树莓派 4。我们构建的工具链包括：

* 交叉编译器
* 二进制实用程序，如汇编程序和链接器，以及
* 一些运行时库

需要交叉编译器，因为我们将编译在 Linux 台式计算机 （X86） 上的 Raspberry Pi 4 （ARM）。

我们可以按照 Linux 中的步骤从头开始构建一个完整的工具链从零开始[2]。但我会走捷径，
使用 `crosstool-NG`_。有关 构建工具链的过程，请参阅此处的 `精彩解释一文`_。

3.1 下载crosstool-NG源码
------------------------------------

::
   
   $ git clone https://github.com/crosstool-ng/crosstool-ng
   $ cd crosstool-ng/
   # Switch to the latest release
   $ git checkout crosstool-ng-1.24.0 -b 1.24.0


3.2 构建和安装crosstool-NG
------------------------------------

安装 crosstool-NG 的完整文档可以[在这里找到](https://crosstool-ng.github.io/docs/install/)。

::
   

   $ ./bootstrap
   $ ./configure --prefix=${PWD}
   $ make
   $ make install
   $ export PATH="${PWD}/bin:${PATH}"

>configures是可能会报 not found: libtool，需要额外安装 libtool-bin 解决。

3.3 配置crosstool-NG
------------------------------------

在用crosstool-NG于构建工具链之前，我们需要首先对其进行配置。配置器的工作方式与配置 Linux 内核相同。

::
   
   $ ct-ng menuconfig


还有一些示例配置，我们可以通过ct-ng list-samples命令获取。我们可以使用其中之一，然后使用ct-ng menuconfig。这里 我将不加修改地使用 aarch64-rpi4-linux-gnu。

::
   

   # Basic information about this config
   $ ct-ng show-aarch64-rpi4-linux-gnu
   [G...]   aarch64-rpi4-linux-gnu
      Languages       : C,C++
      OS              : linux-4.20.8
      Binutils        : binutils-2.32
      Compiler        : gcc-8.3.0
      C library       : glibc-2.29
      Debug tools     : gdb-8.2.1
      Companion libs  : expat-2.2.6 gettext-0.19.8.1 gmp-6.1.2 isl-0.20 libiconv-1.15 mpc-1.1.0 mpfr-4.0.2 ncurses-6.1 zlib-1.2.11
      Companion tools :

   # Use this config
   $ ct-ng aarch64-rpi4-linux-gnu


>注意：操作系统是 linux-4.20.8，意思是由工具链编译的二进制文件 应该能够在任何内核版本 >= 4.20.8 上运行。

3.4 构建工具链
------------------------------------

要构建工具链，只需运行：

::


   $ ct-ng build


>注意：在撰写本文时，上述命令在尝试时失败 下载 ISL LIB，因为位置似乎已关闭。一个 可以在[此处](https://github.com/crosstool-ng/crosstool-ng/issues/1625)找到解决方法。isl.gforge.inria.fr

默认情况下，构建的工具链安装在 ~/x-tools/aarch64-rpi4-linux-gnu。

1. 引导加载程序
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

引导加载程序的工作是将系统设置到基本级别（例如，配置内存控制器以访问DRAM）并加载内核。 通常，启动顺序为：

1. 存储在芯片上的 ROM 代码运行。它加载辅助程序加载程序 （SPL） 到静态随机存取存储器 （SRAM） 中，不需要存储器 控制器。SPL 可以是完整引导加载程序的精简版本，例如 U-启动。由于SRAM尺寸有限，因此需要它。
2. SPL 设置内存控制器，以便可以访问 DRAM 并执行 其他一些硬件配置。然后，它将完整的引导加载程序加载到 DRAM。
3. 然后，完整的引导加载程序加载内核，即扁平化设备树 （FDT） 以及可选的初始 RAM 磁盘 （initramfs） 到 DRAM 中。一旦内核是 加载后，引导加载程序会将控制权移交给它。

4.1 下载u-boot源码
------------------------------------

::


   $ git clone git://git.denx.de/u-boot.git
   $ cd u-boot
   $ git checkout v2021.10 -b v2021.10


4.2 配置u-boot
------------------------------------

因为引导加载程序是特定于设备的，所以我们需要在构建它之前对其进行配置。与 crosstool-NG类似，有几个位于configs/下的 sample/default 配置。我们可以在configs/rpi_4_defconfig下 找到一个用于Raspberry Pi 4的。那么我们只需要运行 make rpi_4_defconfig。在此之前，我们还需要设置 CROSS_COMPILE 环境变量。

::


   $ export PATH=${HOME}/x-tools/aarch64-rpi4-linux-gnu/bin/:$PATH
   $ export CROSS_COMPILE=aarch64-rpi4-linux-gnu-
   $ make rpi_4_defconfig


4.3 构建u-boot
------------------------------------

::


   $ make


4.4 安装u-boot
------------------------------------

我们只需要将最后一步编译的二进制文件 u-boot.bin 复制到 SD 卡上的 boot 分区中即可。

::

   
   $ sudo cp u-boot.bin /mnt/boot


注意：Raspberry Pi 有自己专有的引导加载程序，由 ROM代码，并且能够加载内核。但是，既然我想 使用开源，我需要配置树莓派启动 loader 加载，然后让内核加载。u-bootu-bootu-boot

从4B的官方镜像中拷贝出 bootcode.bin, start4.elf 和 fixup4.dat 到 /mnt/boot 中。

再手动写一份 config.txt:

::

   # Let Raspberry Pi 4 bootloader load u-boot
   $ cat << EOF > config.txt
   enable_uart=1
   arm_64bit=1
   kernel=u-boot.bin
   EOF
   $ sudo mv config.txt /mnt/boot/


介绍下rpi4的启动过程，其启动分区采用的 fat32 fs，并采用三级启动方式：
1. 板载VideoCore GPU启动固化在rpi4中的ROM，该阶段非常简单，主要支持读取TF卡中的fat32 fs的第2级启动程序;
2. 板载VideoCore GPU加载并执行启动分区(/boot)中的bootcode.bin，该文件的主要功能是解析elf格式文件，再加载并解析同目录下的start4.elf;
3. 运行start4.elf，读取并解析config.txt的配置文件，再加载并执行真正的u-boot程序。


\5. 内核
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

接下来，我们编译 Linux 内核。

5.1 下载内核源码
------------------------------------

虽然原来的 Linux 内核应该可以工作，但使用 Raspberry Pi 的分支 更稳定。另请注意，内核版本必须高于 为工具链配置的内核版本。

::

   $ git clone --depth=1 -b rpi-5.10.y https://github.com/raspberrypi/linux.git
   $ cd linux


5.2 配置和构建内核
------------------------------------

我们只使用 Raspberry Pi 4 的默认配置。有关 Raspberry Pi 4 型号 b 规格，请参阅[此处](https://www.raspberrypi.com/products/raspberry-pi-4-model-b/specifications/)。

::

   $ make ARCH=arm64 CROSS_COMPILE=aarch64-rpi4-linux-gnu- bcm2711_defconfig
   $ make -j$(nproc) ARCH=arm64 CROSS_COMPILE=aarch64-rpi4-linux-gnu-


5.3 安装内核和设备树
------------------------------------

现在我们将内核映像和设备树二进制文(`*.dtb`)复制到SD卡上的boot分区中。

::

   $ sudo cp arch/arm64/boot/Image /mnt/boot
   $ sudo cp arch/arm64/boot/dts/broadcom/bcm2711-rpi-4-b.dtb /mnt/boot/


6. 根文件系统
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

请参阅 `文件系统层次结构标准`_ 配置，更多 有关 Linux 系统基本目录布局的详细信息。

6.1 创建目录
------------------------------------

::

   $ mkdir rootfs
   $ cd rootfs
   $ mkdir {bin,dev,etc,home,lib64,proc,sbin,sys,tmp,usr,var}
   $ mkdir usr/{bin,lib,sbin}
   $ mkdir var/log

   # Create a symbolink lib pointing to lib64
   $ ln -s lib64 lib

   $ tree -d
   .
   ├── bin
   ├── dev
   ├── etc
   ├── home
   ├── lib -> lib64
   ├── lib64
   ├── proc
   ├── sbin
   ├── sys
   ├── tmp
   ├── usr
   │   ├── bin
   │   ├── lib
   │   └── sbin
   └── var
      └── log

   16 directories

   # Change the owner of the directories to be root
   # Because current user doesn't exist on target device
   $ sudo chown -R root:root *


6.2 构建和安装Busybox
------------------------------------

我们将 Busybox 用于基本的 Linux 实用程序，例如 shell。所以，我们需要 将其安装到刚刚创建的rootfs目录中。

::

   # Download the source code
   $ wget https://busybox.net/downloads/busybox-1.33.2.tar.bz2
   $ tar xf busybox-1.33.2.tar.bz2
   $ cd busybox-1.33.2/

   # Config
   $ CROSS_COMPILE=${HOME}/x-tools/aarch64-rpi4-linux-gnu/bin/aarch64-rpi4-linux-gnu-
   $ make CROSS_COMPILE="$CROSS_COMPILE" defconfig
   # Change the install directory to be the one just created
   $ sed -i 's%^CONFIG_PREFIX=.*$%CONFIG_PREFIX="/home/hechaol/rootfs"%' .config

   # Build
   $ make CROSS_COMPILE="$CROSS_COMPILE"

   # Install
   # Use sudo because the directory is now owned by root
   $ sudo make CROSS_COMPILE="$CROSS_COMPILE" install


6.3 安装所需的库
------------------------------------

接下来，我们安装一些 Busybox 需要的共享库。我们可以找到那些库：

::

   $ readelf -a ~/rootfs/bin/busybox | grep -E "(program interpreter)|(Shared library)"
         [Requesting program interpreter: /lib/ld-linux-aarch64.so.1]
   0x0000000000000001 (NEEDED)             Shared library: [libm.so.6]
   0x0000000000000001 (NEEDED)             Shared library: [libresolv.so.2]
   0x0000000000000001 (NEEDED)             Shared library: [libc.so.6]


我们需要将这些文件从工具链的sysroot目录复制到rootfs/lib目录。

::

   $ export SYSROOT=$(aarch64-rpi4-linux-gnu-gcc -print-sysroot)
   $ sudo cp -L ${SYSROOT}/lib64/{ld-linux-aarch64.so.1,libm.so.6,libresolv.so.2,libc.so.6} ~/rootfs/lib64/


6.4 创建设备节点
------------------------------------

Busybox 需要两个设备节点。

::

   $ cd ~/rootfs
   $ sudo mknod -m 666 dev/null c 1 3
   $ sudo mknod -m 600 dev/console c 5 1


7. 启动开发板
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

最后，准备好所有组件后，我们就可以启动电路板了。有两个根文件系统的选项。我们可以将其用作 initramfs 它可以在以后挂载一个真正的根文件系统或将其用作永久根文件系统。

7.1 选项 1：使用 initramfs 引导
------------------------------------

什么时候是 initramfs 需要？根据 Linux From Scratch [2]，只有四个主要 在 LFS 环境中使用 initramfs 的原因：

* 从网络加载 rootfs。
* 从 LVM 逻辑卷加载它。
* 有一个加密的rootfs，其中需要密码。
* 为了方便将 rootfs 指定为 LABEL 或 UUID。

除了使用 initramfs，我们还可以将根文件系统直接放入 SD 卡上的分区中。在这种情况下，我们需要配置 内核命令行从引导加载程序传递到内核。root

7.1.1 构建 initramfs
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

initramfs 是一个压缩的存档，它是一个旧的 Unix 存档 格式类似于 和 。cpiotarzip

::

   $ cd ~/rootfs
   $ find . | cpio -H newc -ov --owner root:root -F ../initramfs.cpio
   $ cd ..
   $ gzip initramfs.cpio
   $ ~/u-boot/tools/mkimage -A arm64 -O linux -T ramdisk -d initramfs.cpio.gz uRamdisk

   # Copy the initramffs to boot partition
   $ sudo cp uRamdisk /mnt/boot/


7.1.2 配置u-boot
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

我们需要配置 u-boot，以便它可以通过正确的内核 命令行和设备树二进制到内核。为简单起见，我将使用 Busybox shell 作为init程序。在现实生活中，如果使用 initramfs，那么 init 程序应负责挂载永久根目录文件系统。

::

   $ cat << EOF > boot_cmd.txt
   fatload mmc 0:1 \${kernel_addr_r} Image
   fatload mmc 0:1 \${ramdisk_addr_r} uRamdisk
   setenv bootargs "console=serial0,115200 console=tty1 rdinit=/bin/sh"
   booti \${kernel_addr_r} \${ramdisk_addr_r} \${fdt_addr}
   EOF
   $ ~/u-boot/tools/mkimage -A arm64 -O linux -T script -C none -d boot_cmd.txt boot.scr

   # Copy the compiled boot script to boot partition
   $ sudo cp boot.scr /mnt/boot/


引导命令的含义：

* 将内核映像从分区1（ boot partition） 加载到内存中。
* 将 initramfs 从分区1（ boot partition） 加载到内存中。
* 设置内核命令行。
* 使用给定的内核、设备树二进制文件和 initramfs 启动。

>注意：在最后一行中，最后一个参数 fdt_addr 与其他两个参数不同。起初，我使用 fdt_addr 无法启动开发板。发现这个后我意识到了错误 [在树莓上发帖](https://forums.raspberrypi.com/viewtopic.php?f=98&t=314845) Raspberry Pi论坛。此外，根据其中一个回复，当前的 U-boot 已经从固件继承 DTB，将其地址放入 {fdt_addr}。所以我们不需要在 U-Boot 中加载 dtb 文件。

7.1.3 启动它！
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

最后，所有四个组件都准备就绪。我们现在可以尝试启动它。靴子 分区现在包含以下文件：

::

   $ tree /mnt/boot/
   /mnt/boot/
   ├── bcm2711-rpi-4-b.dtb
   ├── bootcode.bin
   ├── boot.scr
   ├── config.txt
   ├── Image
   ├── start4.elf
   ├── uRamdisk
   └── u-boot.bin

   0 directories, 7 files


现在我们卸载分区并将 SD 卡插入 Raspberry Pi 4。

::

   $ sudo umount /dev/sdb1
   $ sudo umount /dev/sdb2


启动 Raspberry Pi 4 后，如果成功，我们应该会得到一个Busybox shell。

7.2 选项 2：直接使用永久 rootfs 引导
------------------------------------

或者，我们可以在 root 分区作为根文件系统的情况下直接启动。为此，请按照以下步骤操作。

7.2.1 将rootfs复制到SD卡上的root分区
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

将 SD 卡插入读卡器，然后将读卡器插入 Linux 桌面。

::

   $ sudo mount /dev/sdb1 /mnt/boot
   $ sudo mount /dev/sdb2 /mnt/root
   $ cp -r ~/rootfs/* /mnt/root/

  
7.2.2 更改引导命令
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

我们不再需要 initramfs。

::

   $ cat << EOF > boot_cmd.txt
   fatload mmc 0:1 \${kernel_addr_r} Image
   setenv bootargs "console=serial0,115200 console=tty1 root=/dev/mmcblk0p2 rw rootwait init=/bin/sh"
   booti \${kernel_addr_r} - \${fdt_addr}
   EOF
   $ ~/u-boot/tools/mkimage -A arm64 -O linux -T script -C none -d boot_cmd.txt boot.scr
   $ sudo cp boot.scr /mnt/boot/

   # Remove the initramfs as it's not needed
   $ sudo rm -f /mnt/boot/uRamdisk


7.2.3 启动它！
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

现在我们卸载分区并将 SD 卡插入 Raspberry Pi 4。

::

   $ sudo umount /dev/sdb1
   $ sudo umount /dev/sdb2


启动 Raspberry Pi 4 后，如果出现以下情况，我们应该会得到一个 shell 成功的。与上面的 -only 情况不同，在这种情况下，无论什么 我们对根文件系统所做的更改将被保留。Busyboxinitramfs。

如下是我的 rootfs 方式下的 U-Boot 串口启动日志：

::

   欢迎使用 minicom 2.8

   选项: I18n 
   通信端口 /dev/ttyUSB0, 14:09:08

   按 CTRL-A Z 说明特殊键 



   U-Boot 2024.04-rc4 (Mar 14 2024 - 11:38:29 +0800)

   DRAM:  948 MiB (effective 7.9 GiB)
   RPI 4 Model B (0xd03115)
   Core:  211 devices, 16 uclasses, devicetree: board
   MMC:   mmcnr@7e300000: 1, mmc@7e340000: 0
   Loading Environment from FAT... Unable to read "uboot.env" from mmc0:1... 
   In:    serial,usbkbd
   Out:   serial,vidconsole
   Err:   serial,vidconsole
   Net:   eth0: ethernet@7d580000
   PCIe BRCM: link up, 5.0 Gbps x1 (SSC)
   starting USB...
   Bus xhci_pci: Register 5000420 NbrPorts 5                                       
   Starting the controller                                                         
   USB XHCI 1.00                                                                   
   scanning bus xhci_pci for devices... 3 USB Device(s) found                      
         scanning usb for storage devices... 0 Storage Device(s) found            
   Hit any key to stop autoboot:  0                                                
   Card did not respond to voltage select! : -110                                  
   ** Booting bootflow 'mmc@7e340000.bootdev.part_1' with script                   
   25463296 bytes read in 1227 ms (19.8 MiB/s)                                     
   Moving Image from 0x80000 to 0x200000, end=1b60000                              
   ## Flattened Device Tree blob at 2eff2500                                       
      Booting using the fdt blob at 0x2eff2500                                     
   Working FDT set to 2eff2500                                                     
      Using Device Tree in place at 000000002eff2500, end 000000002f002fa2         
   Working FDT set to 2eff2500                                                     
                                                                                 
   Starting kernel ... 


资源

1. [掌握嵌入式 Linux 编程 - 第三版](https://www.amazon.com/Mastering-Embedded-Linux-Programming-potential/dp/1789530385)
2. [Linux 从零开始](https://www.linuxfromscratch.org/)
3. [如何构建工具链](https://crosstool-ng.github.io/docs/toolchain-construction/)