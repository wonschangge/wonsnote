U-Boot介绍
=================================

启动流程
--------------------

电脑启动流程：

* 多级引导

    1. 一阶引导

        - 重设复位向量（Resides on reset vector）
        - 一般是片上BootROM
        - 初始化HW，加载下一阶
    
    2. 二阶引导

        - 第一段用户控制代码

* Linux kernel

* Userspace

使用 U-Boot bootloader 的启动流程：

* 多级引导

    1. 一阶引导（同上）
   
    2. 二阶引导（U-Boot SPL）
        - 第一段用户控制代码
        - 响应额外的HW初始化
        - 加载U-Boot或直接加载Linux
  
    3. 三阶引导（U-Boot）
        - 可交互shell
        - 启动显示器
        - debug工具

* Linux kernel

* Userspace


U-Boot示例：

::

    U-Boot SPL 2018.01-00002-g9aa111a004 (Jan 20 2018 - 12:45:29)
    Trying to boot from MMC1
    
    
    U-Boot 2018.01-00002-g9aa111a004 (Jan 20 2018 - 12:45:29 -0600)
    
    CPU : AM335X-GP rev 2.1
    I2C: ready
    DRAM: 512 MiB
    Reset Source: Global warm SW reset has occurred.
    Reset Source: Power-on reset has occurred.
    MMC: OMAP SD/MMC: 0, OMAP SD/MMC: 1

    Model: BeagleBoard.org PocketBeagle
    Net: usb_ether
    Press SPACE to abort autoboot in 2 seconds
    =>

U-Boot SPL 对比 U-Boot TPL

* SPL - Secondary Program Loader

    - 从U-Boot同源构建

    - 显著减少体积和功能集

    - 用于出初始化系统、启动U-Boot或Linux

* TPL - Tertiary Program Loader

    - 从U-Boot同源构建
    
    - 甚至比 SPL 更小

    - 几乎没人用

    - 用于少数受限系统（如：OneNAND）

U-Boot基础命令
----------------------

提供两种shell：

1. 没有名字的老版shell
2. （默认）功能丰富的HUSH shell（类似bourne shell，支持持久化环境变量、支持脚本）

``help`` 命令：

- 支持“help 子命令”

``echo`` 命令：

- 不能中断控制序列，``\\c`` 可用于阻止换行，如：

::

    echo foo\\c ; echo bar
    foobar


``bdinfo`` 命令：

- 探查系统信息

U-Boot访存命令
-----------------------

访存命令： ``mw``、 ``md``

- 读/写内存和寄存器
- 支持使用后缀（.b,.w,.l,.q）访问 byte/word/long/quad 寄存器
- 默认访问宽度是long（32bit, 即默认md=md.l）
- 支持同时读多个单元（默认0x40）
- 如果指定单元数，则更新读取的默认值
- 如果未指定地址，可读取后续地址

示例：

::

    => mw 0x81000000 0x1234abcd
    => md.l 0x81000000 0x8
    81000000: 1234abcd 00000000 00000000 00000000 ..4.............
    81000010: 00000000 00000000 00000000 00000000 ................
    => md.w 0x81000000 0x8
    81000000: abcd 1234 0000 0000 0000 0000 0000 0000 ..4...........7 => md.b 0x81000000 0x8
    81000000: cd ab 34 12 00 00 00 00 ..4.....
    =>
     81000008: 00 00 00 00 00 00 00 00 ........

- 尝试硬切换GPIO接口

- 注意使用的位区域， ``|xxxx|xxx0|000x|xxxx|xxxx|xxxx|xxxx|xxxx|``

- 期望看到可开关2个蓝色LED

示例：

::

    => echo "Try toggling GPIOs the hard way"
    => md 0x4804c130 4
    4804c130: 00000002 ffffffff f0000300 00000000 ................
    => mw 0x4804c134 0xfe1fffff
    => mw 0x4804c13c 0x00a00000
    => mw 0x4804c13c 0x01400000
    => md 0x4804c130 4
    4804c130: 00000002 fe1fffff f1400300 01400000 ..........@...@.

内存修改命令： ``mm``、 ``nm``

- 用于交互修改寄存器
- 用法类似 md/mw
- mm自动增长地址，nm不会
- 'q'丢弃
- '-'返回上一地址
- 'Enter'跳过当前地址

示例：

::

    => mm 0x4804c134
    4804c134: ffffffff ? fe1fffff
    4804c138: f0002300 ?
    4804c13c: 00000000 ? 00400000
    4804c140: 00000000 ? q
    =>

访存命令： ``cp``、 ``cmp``

- cp 拷贝内存
- cmp 比较内存
- 用法和md/mw类似

示例：

::

    => mw 0x81000000 0x1234abcd 0x10
    => cp 0x81000000 0x82000000 0x8
    => cmp 0x81000000 0x82000000 0x8
    Total of 8 word(s) were the same
    => cmp 0x81000000 0x82000000 0x9
    word at 0x81000020 (0x1234abcd) != word at 0x82000020 \
    (0xea000003)
    Total of 8 word(s) were the same


U-Boot环境和脚本命令
------------------------------

* env使用k-v对存储
* 可包含值、脚本
* 默认env编入U-Boot二进制中
* 可选从存储中加载自定义env
* RAM中有实时副本
* 可作为值被访问
* 可被修改
* 可持久化

``printenv`` 命令

- 打印环境变量
- 等于env print

示例：

::

    => env print
    arch=arm
    ...
    Environment size: 26907/131068 bytes
    =>
    => env print arch
    arch=arm
    => printenv arch
    arch=arm
    => echo "$arch"
    arm

``setenv`` / ``askenv`` / ``editenv`` 命令

- 修改env
- 等于env set/env ask/env edit

示例：

::

    => env set foo bar
    => env print foo
    foo=bar

    => env ask quux "Set quux to ?"
    Set quux to ? 1234
    => env print quux
    quux=1234

    => env edit quux
    edit: 24
    => env print quux
    quux=24

移除变量，设置变量为空来中env中移除：

::

    => env print foo
    ## Error: "foo" not defined
    => env set foo bar
    => env print foo
    foo=bar
    => env set foo
    => env print foo
    ## Error: "foo" not defined

``saveenv`` 命令

- 持久化保存
- 使env非临时，重启后还在
- 任何对env的修改都会同步到实时副本中去

示例：

::

    => env set foo bar
    => env print foo
    foo=bar
    => reset
    => env print foo
    ## Error: "foo" not defined 
    => env set foo bar
    => saveenv
    => reset
    => env print foo
    bar

``run`` 命令

- 运行env中的脚本
- 使用';'可做到链式使用
- 注意';'忽略返回值

示例：

::

    => env set foo 'echo hello'
    => run foo
    hello

    => env set foo 'echo hello ; echo world'
    => run foo
    hello
    world

env中的变量

注意2点：

1. 在U-Boot shell中 ``合适地结束``很重要
2. ``小心变量展开``

示例：

:: 

    => env set foo bar
    => env set quux echo $foo
    => env set foo baz
    => run quux
    bar
    => env print quux
    quux=echo bar

    => env set quux echo \$foo
    => env print quux
    => env set quux 'echo $foo'
    => env print quux

特殊变量

以下变量有特殊含义/函数：

- ver - 代表U-Boot版本
- stdin, stdout, stderr - STDIO的重定向，coninfo命令相关
- loadaddr - 默认加载地址
- filesize - 加载文件的大小
- bootargs - 传递到Linux命令行的启动参数
- bootcmd - 默认启动命令（参见boot命令和autoboot）
- preboot - autoboot之前执行的脚本
- ipaddr,netmask,serverip,gatewayip - 网络设置
- ethaddr,eth1addr - 以太网MAC地址

``setexpr`` 命令

- 手动操纵env的工具集
- 支持将内存内容加载到变量中
- 支持对变量和内存的算术操作（与、或、异或、+、-、*、/、%）
- 支持对字符串和变量的基础正则操作

示例：

:: 

    => md 0x9ff4e000 1
    9ff4e000: ea0000b8
    => setexpr foo *0x9ff4e000
    => env print foo
    foo=ea0000b8

    => env set foo 1 ; env set bar 2
    => setexpr baz $foo + $bar
    => env print baz
    baz=3

    => setexpr foo gsub ab+ x "aabbcc"
    foo=axcc


U-Boot shell条件表达式和循环
------------------------------

true和false命令

- 返回0（true）、非0（false）
- 支持处理命令的返回值
- 支持自动变量

示例：

::

    => true
    => echo $?
    0
    => false
    => echo $?
    1

条件表达式

- 支持if条件
- 支持||和&&
- 警告，不支持 "if ! foo; then ... fi"，使用 "if foo; then false; else ... fi" 代替

示例：

::

    => if true ; then echo "hello" ; else echo "bye" ; fi
    hello
    => false || echo "false!"
    false!

    => env set foo 'true && echo "true!"'
    => run foo
    true!

test命令

- HUSH的最小化测试命令

示例：

::

    => env set i 4
    => test $i -lt 5
    => echo $?
    0
    => env set i 6
    => test $i -lt 5
    => echo $?
    1

    => env set i 6
    => if test $i -lt 5 ; then echo "Less then 5" ; \
    else echo "More than 5" ; fi
    More than 5

for循环

- 元素列表上的for循环

示例：

::

    => for i in a b c d ; do echo "$i" ; done
    a
    b
    c
    d

while循环

- 带条件
- Ctrl-c可用于终止循环

示例：

::
    => while true ; do echo hello ; done
    hello
    hello
    hello
    Ctrl-c

U-Boot加载数据命令
---------------------------------

从存储中加载

* U-Boot支持从多种存储类型中加载

    - SD/MMC - mmc命令
    - USB - usb命令
    - SATA - sata命令
    - NAND - nand命令

* 支持 RAW 存储和文件系统

    - 通用的FS访问 - ls,load命令
    - ExtFS - 传统的extls/extload命令
    - VFAT - 传统的fatls/fatload命令
    - UBI/UBIFS - ubi命令


从sd卡加载

示例：

::

    => mmc rescan
    => mmc part

    Partition Map for MMC device 0 -- Partition Type: DOS

    Part Start Sector Num Sectors UUID          Type
      1  8192         6955008     1147c091-01   83 Boot

    => ls mmc 0:1
    <DIR> 4096 .
    <DIR> 4096 ..
            40 ID.txt
    ...
    => load mmc 0:1 $loadaddr ID.txt
    => md.b $loadaddr $filesize
    82000000: 42 65 61 67 6c 65 42 6f 61 72 ... BeagleBoard.org
    82000010: 44 65 62 69 61 6e 20 49 6d 61 ... Debian Image 201
    82000020: 38 2d 30 31 2d 32 38 0a           8-01-28.

从网络加载

- U-Boot网络栈只支持UDP
- 支持TFTP、NFS（UDP之上）、DHCP/BOOTP...
- ping - ICMP打印
- tftp - TFTP下载（tftpput用于上传）
- dhcp - 从DHCP获取设置和 en. 加载文件

示例：

:: 

    => env set ethaddr 00:aa:bb:cc:dd:ee # optional!
    => env set ipaddr 192.168.1.300
    => env set netmask 255.255.255.0
    => env set serverip 192.168.1.1
    => ping $serverip
    => tftp $loadaddr $serverip:somefile
    => dhcp $loadaddr $serverip:somefile


从串口加载

- UART是最后的可靠选择
- U-BOot支持X/Y modem、Srecord和kermit协议

示例：

::

    U-Boot> loady
    <send file over ymodem protocol, e.g. sb -T>

- 使用GNU screen的示例

::

    $ screen /dev/ttyUSB0 115200
        => loady
    ctrl-a:exec !! sb -T yourbinary.bin

    or from another shell on the same host computer:

    $ screen -x -r -X exec \!\! sb -T yourbinary.bin



启动内核
---------------

有多种镜像格式：

* (z)Image

    - Linux二进制（和解压器）
    - 没有对bitrot保护
    - 仅仅设置寄存器并跳过去
    - 可选分离设备树

* uImage

    - 永久遗产
    - 包裹任意二进制
    - CRC32校验和、少量元数据
    - 只包裹单文件
    - 可选分离设备树

* fitImage - 多组件镜像

    - 基于设备树
    - 支持多文件
    - 可对每个入口配置计算校验和算法
    - 支持数字签名
    
启动内核镜像：

- bootz - (z)Image
- booti - ARM64 Image
- bootm - fitImage, uImage
- $bootcmd - 默认启动命令

bootz用法说明：

::

    => help bootz
    bootz - boot Linux zImage image from memory

    Usage:
    bootz [addr [initrd[:size]] [fdt]]
        - boot Linux zImage stored in memory
            The argument 'initrd' is optional... The optional arg
            ':size' allows specifying the size of RAW initrd.

            When booting a Linux kernel which requires a flat
            device-tree a third argument is required which is
            the address of the device-tree blob.

::

    => env set bootargs console=tty0,115200
    => load mmc 0:1 0x82000000 boot/zImage-4.9.82-ti-r102
    9970640 bytes read in 673 ms (14.1 MiB/s)
    => load mmc 0:1 0x88000000 boot/dtbs/4.9.82-ti-r102/\
            am335x-pocketbeagle.dtb
    132769 bytes read in 180 ms (719.7 KiB/s)
    => bootz 0x82000000 - 0x88000000
    ## Flattened Device Tree blob at 88000000
        Booting using the fdt blob at 0x88000000
        Loading Device Tree to 8ffdc000, end 8ffff6a0 ... OK
    
    Starting kernel ...
    
    [ 0.000000] Booting Linux on physical CPU 0x0
    [ 0.000000] Linux version 4.9.82-ti-r102 \
    (root@b2-am57xx-beagle-x15-2gb) (gcc version 6.3.0 20170
    (Debian 6.3.0-18) ) #1 SMP PREEMPT Thu Feb 22 01:16:12 UTC 2
    [ 0.000000] CPU: ARMv7 Processor [413fc082] revision 2 (ARMv7

设备树

- 描述HW的数据结构

- 通常传递给OS，来提供无法检测或探测的HW拓扑信息

- 一个非循环图，有包含属性的具名节点组成

    - 节点可包含属性和子节点

    - 属性是一组name-value对
    
    - 见 https://en.wikipedia.org/wiki/Device_tree

- 设备树属性可通过使用 phandles（引用其他节点）来引用其他节点

    - phandles提供简单引用给设备节点标记（如 "\<&L2>" 是对 L2 cache节点的引用）

    - phandles可用于在设备树的任意地方引用节点

设备树示例：

::

    /dts-v1/;
    #include "arm-realview-eb-mp.dtsi"
    / {
            model = "ARM RealView EB Cortex A9 MPCore";
    [...]
            cpus {
                    #address-cells = <1>;
                    #size-cells = <0>;
                    enable-method = "arm,realview-smp";
                    A9_0: cpu@0 {
                            device_type = "cpu";
                            compatible = "arm,cortex-a9";
                            reg = <0>;
                            next-level-cache = <&L2>;
                    };
    [...]
            pmu: pmu@0 {
                    interrupt-affinity = <&A9_0>, <&A9_1>, <&A9_2>, <&A9_3>;19
            };
    };


fitImage示例：

::

    /dts-v1/; 
    / {
        description = "Linux kernel and FDT blob for sockit";   
    
        images {
            kernel@1 {
                description = "Linux kernel";
                data = /incbin/("./arch/arm/boot/zImage");
                type = "kernel";
                arch = "arm";
                os = "linux";
                compression = "none";
                load = <0x00008000>;
                entry = <0x00008000>;
                hash@1 {
                    algo = "crc32";
                };
            };

            fdt@1 {
                description = "Flattened Device Tree blob";
                data = /incbin/("./arch/arm/boot/dts/socfpga....dtb");
                type = "flat_dt";
                arch = "arm";
                compression = "none";
                hash@1 {
                    algo = "crc32";
                };
            };
        };

        configurations {
            default = "conf@1";
            conf@1 {
                description = "Boot Linux kernel with FDT blob";
                kernel = "kernel@1";
                fdt = "fdt@1";
                hash@1 {
                    algo = "crc32";
                };
            };
        };
    };


编译：mkimage -f fit-image.its fitImage



fdt命令

- 手动操作fdt
- fdt addr - 告诉U-Boot FDT在哪
- fdt resize - 给FDT添加额外空间
- fdt print - 打印DT地址
- fdt set - 添加或修改DT入口

示例：

::

    => load mmc 0:1 0x88000000 boot/dtbs/4.9.82-ti-r102/am335x-pocketbeagle.dtb
    132769 bytes read in 180 ms (719.7 KiB/s)
    => fdt addr 0x88000000
    => fdt resize
    => fdt print /chosen
    chosen {
        stdout-path = "/ocp/serial@44e09000";
    };
    => fdt set /chosen/ foo bar
    => fdt print /chosen
    chosen {
        foo = "bar";
        stdout-path = "/ocp/serial@44e09000";
    };
    => bootz 0x82000000 - 0x88000000


U-Boot其他命令

gpio命令

- 用于GPIO切换/采样
- GPIO输入设置返回值
- gpio input - 读一个gpio
- gpio set - 设一个gpio
- gpio clear - 清除一个gpio
- gpio toggle - 切换一个gpio

示例:

::

    => gpio input 45
    gpio: pin 45 (gpio 45) value is 1
    => echo $?
    1
    => gpio set 53
    gpio: pin 53 (gpio 53) value is 1


i2c命令

- 用于访问I2C总线
- i2c bus - 列出可用的所有I2C总线
- i2c dev - 选择一个I2C总线
- i2c md - 从I2C设备读寄存器
- i2c mw - 将寄存器写入I2C设备
- i2c probe - 探测I2C上的设备
- i2c speed - 设置I2C总线速度

示例：

::

    => i2c dev 2
    Setting bus to 2
    => i2c probe
    Valid chip addresses: 1C
    => i2c md 0x1c 0x0 0x8
    0000: 00 41 ac 01 fc 7f 10 00 .A......


从源码编译U-Boot
--------------------------

- 主git： http://git.denx.de/?p=u-boot.git;a=summary

- Github: https://github.com/u-boot/u-boot

- Custodian subtrees: http://git.denx.de/?p=u-boot.git;a=forks


构建源码

::

    $ git clone git://git.denx.de/u-boot.git
    $ cd u-boot
    $ export CROSS_COMPILE=arm-linux-gnueabihf- # optional, set cross compiler
    $ make am335x_evm_defconfig
    $ make

- U-Boot沙箱目标 (sandbox_defconfig)

    U-Boot作为用户空间应用运行

- U-Boot QEMU目标, (qemu_defconfig)

    U-Boot作为BIOS运行在QEMU
    ``qemu-system-arm -M virt -bios u-boot.bin``


实践练习
---------------------

- 示例来自 PocketBeagle 和 Techlab
- https://beagleboard.org/pocket
- https://beagleboard.org/techlab

练习0
^^^^^^^^^^^^^^^^^^^^^

输入U-Boot提示符

- 提示：按下空格来停止自动启动

示范：

::

    Model: BeagleBoard.org PocketBeagle
    <ethaddr> not set. Validating first E-fuse MAC
    Net: No ethernet found.
    Press SPACE to abort autoboot in 2 seconds
    =>


练习1
^^^^^^^^^^^^^^^^^^^^^

从SD卡进入内核：

- 检查SD卡是否包含zImage和DTB
- 全都加载进内存
- 设置 $bootargs
- 用DT启动内核
- 提示：mmc rescan、ls、load、bootz命令

示范：

::

    => env set bootargs root=/dev/mmcblk0p1 rootfstype=ext4 rootwait \
    console=ttyO0,115200
    => mmc rescan
    => load mmc 0:1 0x82000000 boot/vmlinuz-4.14.91-ti-r90
    => load mmc 0:1 0x88000000 boot/dtbs/4.14.91-ti-r90/\
    am335x-pocketbeagle-techlab.dtb
    => bootz 0x82000000 - 0x88000000
    9970640 bytes read in 6594 ms (1.4 MiB/s)
    132769 bytes read in 123 ms (1 MiB/s)
    ## Flattened Device Tree blob at 88000000
        Booting using the fdt blob at 0x88000000
        Loading Device Tree to 8ffdc000, end 8ffff6a0 ... OK
    
    Starting kernel ...
    
    [ 0.000000] Booting Linux on physical CPU 0x0

练习2
^^^^^^^^^^^^^^^^^^^^^

从SD卡使用调整后的DT启动内核：

- 修改在DT中的 / model 变量，并用其启动内核
- 提示：mmc rescan、load、fdt addr、fdt set、bootz命令
- 提示：在Linux中查看 cat /proc/device-tree/model

示范：

::

    => env set bootargs root=/dev/mmcblk0p1 rootfstype=ext4 rootwait \
    console=ttyO0,115200
    => mmc rescan
    => load mmc 0:1 0x82000000 boot/vmlinuz-4.14.91-ti-r90
    => load mmc 0:1 0x88000000 boot/dtbs/4.14.91-ti-r90/\
    am335x-pocketbeagle-techlab.dtb
    => fdt addr 0x88000000
    => fdt set / model "Something"
    => fdt list
    / {
        ...
        compatible = "ti,am335x-pocketbeagle", "ti,am335x-bone", "ti,am33xx";
        model = "Something";
        chosen {
        ...
    };
    => bootz 0x82000000 - 0x88000000
    ...
    [ 0.000000] OF: fdt: Machine model: Something
    ...
    beaglebone login:debian
    debian@beaglebone:~$ dmesg | grep model
    [ 0.000000] OF: fdt: Machine model: Something

练习3
^^^^^^^^^^^^^^^^^^^^^

按键输入：

- 提示：gpio input 命令
- 提示：0x4804c138是GPIO input寄存器的偏移量
- 提示：gpio 45是USR按键的GPIO

示范：

::

    => if gpio input 45 ; then
        echo "Button pressed" ;
    else
        echo "Button not pressed" ;
    fi

练习4
^^^^^^^^^^^^^^^^^^^^^

驱动HW IO来闪烁USR LED：

- 提示：使用for或while命令
- 提示：0x4804c134是GPIO direction寄存器的偏移量。

    使用下面的方式来设置4个pin脚作为输出：

    mw 0x4804c134 0xfe1fffff

- 提示：0x4804c13c是GPIO value寄存器的偏移量。

    使用下面的方式来设置LED 0：

    mw 0x4804c13c 0x00200000

- 提示：sleep 1 将等待1秒
- 提示：查看base命令

示范：

::

    => mw 0x4804c134 0xfe1fffff
    => while true ; do
        mw 0x4804c13c 0x00200000 ;
        sleep 1 ;
        mw 0x4804c13c 0x00000000 ;
        sleep 1 ;
    done

练习5
^^^^^^^^^^^^^^^^^^^^^

使用GPIO命令和USR LED来实现动态亮度：

- 提示：使用for或while命令
- 提示：LED灯组是 GPIO 53、54、55、56
- 提示：sleep 1 将等待1秒
- 提示：查看base命令

示例：

::
    
    => while true ; do
        for i in 53 54 55 56 ; do
            gpio set $i ;
            sleep 1 ;
            gpio clear $i ;
        done ;
    done

练习6
^^^^^^^^^^^^^^^^^^^^^

使用Ymodem便捷加载当前环境：

- 提示：loady、env import 命令

示范：

::

    linux$ cat << EOF > /tmp/env.txt
    > hello=world
    > foo=bar
    > EOF

    => loady
    ## Ready for binary (ymodem) download to 0x82000000 at 115200 bps...
    ctrl-a:exec !! sb -T /tmp/env.txt
    C## Total Size = 0x00000014 = 20 Bytes
    => md.b $loadaddr $filesize
    82000000: 68 65 6c 6c 6f 3d 77 6f 72 6c 64 0a 66 6f 6f 3d hello=world.foo=bar.
    82000010: 62 61 72 0a
    => env import $loadaddr $filesize
    ## Warning: defaulting to text format
    => env print hello
    hello=world

练习7
^^^^^^^^^^^^^^^^^^^^^

编译U-Boot以在沙盒模式下运行：

- 克隆U-Boot源码，配置它们用于沙盒，编译U-Boot
- 提示：在主机上进行

示范：

:: 

    $ git clone git://git.denx.de/u-boot.git
    $ cd u-boot
    $ make sandbox_defconfig
    $ make -j $(nproc)
    $ ./u-boot

::

    $ make sandbox_defconfig
      HOSTCC scripts/basic/fixdep
    ...
    #
    # configuration written to .config
    #

    $ make -j $(nproc)
    scripts/kconfig/conf --syncconfig Kconfig
        CHK include/config.h
        UPD include/config.h
    ...
        CFGCHK u-boot.cfg
    $ ./u-boot
    
    U-Boot 2018.11-rc1-00033-ga16accc9fb (Oct 07 2018 - 17:13:29 +0200)
    
    Model: sandbox
    DRAM: 128 MiB
    ...
    =>

练习8
^^^^^^^^^^^^^^^^^^^^^

条形码阅读器（Barcode reader）示例：

- 假设一个以太网MAC地址从一个格式不正确的条形码读取器输入到U-Boot中
- 过滤掉MAC地址并忽略分隔符
- 输入应该读为“env ask”并类似于“00xaaxbbxccxddxee”
- 使用setexpr将输入更改为正确的MAC地址（即“00:aa:bb:cc:dd:ee”）
- 假设分隔符列表已知并固定为“xyz”

示范：

::

    => env ask mac 'MAC address ?'
    MAC address ? 00xaaxbbxccxddxee
    => setexpr myethaddr gsub '\\(..\\)[xyz]' '\\\\1:' $mac
    myethaddr=00:aa:bb:cc:dd:ee

练习9
^^^^^^^^^^^^^^^^^^^^^

玩一下Techlab的加速度器（Accelerometer）：

- 读出 MMA8452Q 加速度器数据
- 提示：i2c命令
- 提示：加速度器在总线2上，选择bus 2

::

    => i2c dev 2

- 提示：加速度器有I2C地址0x1c，尝试：

::

    => i2c md 0x1c 0 0x10

- 提示：加速度器处于待机状态，唤醒使用：

::

    => i2c mw 0x1c 0x2a 0x1

    然后尝试再次读取在偏移0x1到0x6上的采样

示范：

::

    => i2c dev 2
    => i2c md 0x1c 0 0x10
    => i2c mw 0x1c 0x2a 0x1
    => while true ; do i2c md 0x1c 0x2a 0x3; done

.. note:: 参考：https://cm.e-ale.org/2020/ELC2020/intro-to-u-boot/intro-to-u-boot-2020.pdf