AB系统方案设计
=======================

步骤设计：

1. 配置分区和env

分区表设计为：bootA,bootB,rootA,rootB

在env中指定：boot_partition=bootA root_partition=rootA

配置boot_normal命令，从$boot_partition变量指定的分区加载系统

对应在树莓派上的分区设计：

- p1: persistent

  - (弃用)autoboot.txt 启动分区指向p2
  - config.txt 指定启动kernel为u-boot.bin

- p2: boota
  
  - config.txt 指定启动kernel为u-boot.bin

  - u-boot.bin 启动，根据环境变量加载kernel和rootfs

1. 配置编译系统

勾选已适配好的 SWUpdate。

3. 准备 sw-description

参考示例：target/allwinner/generic/swupdate/sw-description-ab

::

    /* 固定格式，最外层为software = { } */
    software =
    {
        /* 版本号和描述 */
        version = "0.1.0";
        description = "Firmware update for Tina Project";

        /*
        * 外层tag，stable，
        * 没有特殊含义，就理解为一个字符串标志即可。
        * 可以修改，调用的时候传入匹配的字符串即可。
        */
        stable = {
            /*
             * 内层tag，now_A_next_B,
             * 当调用swupdate xxx -e stable,now_A_next_B时，就会匹配到这部分，执行｛｝内的动作，
             * 可以修改，调用的时候传入匹配的字符串即可。
             */
            /* now in systemA, we need to upgrade systemB(bootB, rootfsB) */
            now_A_next_B = {
                /* 这部分是描述，当前处于A系统，需要更新B系统，该执行的动作。执行完后下次启动为B系统 */
                images: ( /* 处理各个image */
                    {
                        /* 源文件是OTA包中的kernel文件 */
                        filename = "kernel";
                        /* 要写到/dev/by-name/bootB节点中, 这个节点在tina上就对应bootB分区 */
                        device = "/dev/by-name/bootB"; 
                        /* 流式升级，即从网络升级时边下载边写入, 而不是先完整下载到本地再写入，避免占用额外的RAM或ROM */
                        installed-directly = true; 
                    },
                    {
                        /* 同上，但处理rootfs，不赘述 */
                        filename = "rootfs";
                        device = "/dev/by-name/rootfsB";
                        installed-directly = true;
                    },
                    {
                        /* 源文件是OTA包中的uboot文件 */
                        filename = "uboot";
                        /* type为awuboot，则swupdate会调用对应的handler做处理 */
                        type = "awuboot";
                    },
                    {
                        /* 源文件是OTA包中的boot0文件 */
                        filename = "boot0";
                        /* type为awuboot，则swupdate会调用对应的handler做处理 */
                        type = "awboot0";
                    }
                );

                /* image处理完之后，需要设置一些标志，切换状态 */
                bootenv: ( /* 处理bootenv，会修改uboot的env分区 */
                    {
                        /* 设置env:swu_mode=upgrade_kernel, 这是为了记录OTA进度, 对于AB系统来说，此时已经升级完成，置空 */
                        name = "swu_mode";
                        value = "";
                    },
                    {
                        /* 设置env:boot_partition=bootB, 这是为了切换系统，下次uboot就会启动B系统(kernel位于bootB分区) */
                        name = "boot_partition";
                        value = "bootB";
                    },
                    {
                        /* 设置env:root_partition=rootfsB, 这是为了切换系统，下次uboot就会通过cmdline指示挂载B系统的rootfs */
                        name = "root_partition";
                        value = "rootfsB";
                    },
                    {
                        /* 兼容另外的切换方式，可以先不管 */
                        name = "systemAB_next";
                        value = "B";
                    },
                    {
                        /* 设置env:swu_next=reboot, 这是为了跟外部脚本配合，指示外部脚本做reboot动作 */
                        name = "swu_next";
                        value = "reboot";
                    }
                );
            };

            /*
             * 内层tag，now_B_next_A,
             * 当调用swupdate xxx -e stable,now_B_next_A时，就会匹配到这部分，执行｛｝内的动作，
             * 可以修改，调用的时候传入匹配的字符串即可
             */
            /* now in systemB, we need to upgrade systemA(bootA, rootfsA) */
            now_B_next_A = {
                /* 这里面就不赘述了, 跟上面基本一致，只是AB互换了 */
                images: (
                    {
                        filename = "kernel";
                        device = "/dev/by-name/bootA";
                        installed-directly = true;
                    },
                    {
                        filename = "rootfs";
                        device = "/dev/by-name/rootfsA";
                        installed-directly = true;
                    },
                    {
                        filename = "uboot";
                        type = "awuboot";
                    },
                    {
                        filename = "boot0";
                        type = "awboot0";
                    }
                );
                bootenv: (
                    {
                        name = "swu_mode";
                        value = "";
                    },
                    {
                        name = "boot_partition";
                        value = "bootA";
                    },
                    {
                        name = "root_partition";
                        value = "rootfsA";
                    },
                    {
                        name = "systemAB_next";
                        value = "A";
                    },
                    {
                        name = "swu_next";
                        value = "reboot";
                    }
                );
            };
        };

        /* 当没有匹配上面的tag，进入对应的处理流程时，则运行到此处。我们默认清除掉一些状态 */
        /* when not call with -e xxx,xxx just clean */
        bootenv: (
            {
                name = "swu_param";
                value = "";
            },
            {
                name = "swu_software";
                value = "";
            },
            {
                name = "swu_mode";
                value = "";
            },
            {
                name = "swu_version";
                value = "";
            }
        );
    }

升级过程会进行一次重启，升级kernel和rootfs到另一个系统所在分区，升级uboot、boot0，设置boot_partition为切换系统

重启进入新系统

4. 准备 sw-subimgs.cfg

参考示例：target/allwinner/generic/swupdate/sw-subimgs-ab.cfg

::

    swota_file_list=(
        # 取得sw-description-ab, 重命名成sw-description, 放到OTA包中。
        # 注意第一行必须为sw-description
        target/allwinner/generic/swupdate/sw-description-ab:sw-description
    
        # 取得uboot.img，重命名为uboot，放到OTA包中。以下雷同
        # uboot.img和boot0.img是执行swupdate_pack_swu时自动拷贝得到的，
        # 需配置sys_config.fex中的storage_type
        out/${TARGET_BOARD}/uboot.img:uboot
    
        # 注：boot0没有修改的话，以下这行可去除，其他雷同，可按需升级
        out/${TARGET_BOARD}/boot0.img:boot0
        out/${TARGET_BOARD}/boot.img:kernel
        out/${TARGET_BOARD}/rootfs.img:rootfs
    )

指明打包swupdate升级包所需的各个文件位置，这些文件将被拷贝到out目录下再生成swupdate OTA包


5. 编译OTA包所需镜像

编译kerenl: make

编译uboot: muboot

生成OTA包: pack / pack -s

swupdate_pack_swu -ab

6. 执行OTA

    a. 准备OTA包

    adb push直接推入: adb push out/<board>/swupdate/<board>.swu /mnt/UDISK

    实际应用时，可先从网络下载到本地再调swupdate，或直接传url给swupdate

    b. 判断AB系统

    判断当前处于A系统还是B系统

    使用fw_printenv读取boot_partition和root_partition的值

    c. 调用swupdate_cfg

    位于A系统: swupdate -i /mnt/UDISK/<board>.swu -e stable,now_A_next_B

    位于B系统: swupdate -i /mnt/UDISK/<board>.swu -e stable,now_B_next_A





boot0/uboot安全更新的底层实现
-----------------------------------------------------------

前提条件：在flash中保存多份boot0/uboot。

在此基础上，启动流程需支持校验，并选择完整的boot0/uboot进行启动。

更新流程需保证任意时刻掉电，在flash上总存有一份可用的boot0/uboot。

NAND Flash NFTL方案 实现
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

NAND NFTL方案中，boot0和uboot由nand驱动管理，保存在物理地址中，逻辑分区不可见。

NAND驱动会保存多份boot0和uboot，启动时从第一份开始依次尝试，直到找到一份完整的boot0/uboot进行使用。

更新boot0/uboot时，上层调用nand驱动提供的接口，驱动中会从第一份开始依次更新，多份全部更新完毕后返回。

可保证在OTA过程中任意时刻掉电，flash中均有至少一份完整的boot0/uboot可用。

再次启动后，只需重新调用更新接口进行更新，直到调用成功返回即可。

目前nand中的多份boot0/uboot由nand驱动管理，只能整体更新，暂不支持单独更新其中的一份。


NAND Flash UBI方案 实现
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

NAND UBI方案中，boot0一般


MMC Flash实现
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

mmc方案中，boot0和uboot各有两份，存在mmc上的指定偏移处，逻辑分区不可见。

需要读写可直接操作 /dev/mmcblk0 节点的指定偏移。

具体位置：

::

    1 sector = 512 bytes = 0.5k。
    boot0/toc0 保存了两份，offset1: 16 sector, offset2: 256 sector。
    uboot/toc1 保存了两份，offset1: 32800 sector, offset2: 24576 sector。

启动时，优先读取 offset1，如果完整性校验失败，则读取offset2。

更新时，默认只更新offset1，而offset2保持在出厂状态。只要offset1正常更新，则启动时会优先使用。
如果更新offset1时因掉电而导致数据损坏，则自动使用offset2进行启动。

如果要定制策略，例如改成每次offset1和offset2均更新，可自行修改ota-burnboot代码。


树莓派uboot env配置

::
    U-Boot> printenv 
    baudrate=115200
    board_name=4 Model B
    board_rev=0x11
    board_rev_scheme=1
    board_revision=0xD03115
    boot_partition=2
    root_partition=/dev/mmcblk0p5
    bootdelay=5
    ethaddr=d8:3a:dd:91:e8:4d
    fdt_addr=2eff2e00
    fdtcontroladdr=3af1fb60
    fdtfile=broadcom/bcm2711-rpi-4-b.dtb
    kernel_addr_r=0x00080000
    serial#=100000002c030146
    usbethaddr=d8:3a:dd:91:e8:4d
    bootcmd=\
    setenv bootargs console=serial0,115200 console=tty1 root=$root_partition rootfstype=squashfs,ext4 rootwait;\
    fatload mmc 0:$boot_partition ${kernel_addr_r} kernel8.img;\
    booti ${kernel_addr_r} - ${fdt_addr}

    Environment size: 701/131068 bytes