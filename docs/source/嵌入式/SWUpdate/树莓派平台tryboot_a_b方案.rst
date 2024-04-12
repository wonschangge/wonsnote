树莓派平台tryboot_a_b方案
===========================================================

本方案基于 buildroot_pi_swupdate.git 提供的示例

简介
-----------------------------------------------------------

buildroot_pi_swupdate.git 仓库提供了一个示例模板，其中实现了一种AB系统更新设备的机制，
允许设备在更新失败时返回到之前的工作状态，有如下特征：

- 设备提供网页来接收新镜像(架设在http://[target_ip]:8080)

- 设备使用两组冗余分区(bootA+rootfsA 和 bootB+rootfsB)

- 镜像使用 `SWUpdate 2022.05` 的 `buildroot 2022.08.1` 生成

- 支持设备: `Raspberry Pi 2B` 和 `Raspberry Pi Compute Module 4`。

当设备从某一组分区运行并请求更新时，设备将执行如下⚠️原子化过程⚠️：

1. 将分区集合写入已收到的还未使用的镜像。

2. 完成后，设备将重启以测试更新的分区集合。

3. 如果能够启动，它将更新一个文件（autoboot.txt），告诉它在下次启动时使用该组分区。

.. note:: 如果过程在最后一步之前的任何时刻中断，设备将继续使用未更新的分区集合。

还有哪些可以改进的地方？

- 如何预防和处理可能的文件系统损坏

- 为什么无法使用较新的SWUpdate版本。
  当前位于 `/board/raspberrypi/generic/overlay_swupdate/var/www/swupdate/` 的 WebApp 
  是 `SWUpdate 2021.04` 附带的 WebApp 的副本。作为参考，文件夹 `swupdate_from_2022_10_18` 
  中提供了 SWUpdate 仓库（从 22-10-18 开始）的副本。


基础原理
-----------------------------------------------------------

.. _SWUpdate: https://sbabic.github.io/swupdate/swupdate.html
.. _PINN 项目: https://github.com/procount/pinn/tree/master/buildroot/package/rebootp
.. _autoboot: https://www.raspberrypi.com/documentation/computers/config_txt.html#autoboot-txt
.. _tryboot_a_b: https://www.raspberrypi.com/documentation/computers/config_txt.html#tryboot_a_b

1. `SWUpdate`_ 部署一个网页来接收用户提供的新镜像并将其写入设备。

2. rebootp 机制基于 `PINN 项目`_ 实现的自定义 `reboot` 命令，
   因为原始 reboot 命令不会注入切换分区所需的分区号和 tryboot 参数。

3. S80swupdate 初始化脚本负责测试在执行更新后设备是否从预期的启动分区启动，从而将其持久化。

4. `autoboot`_ 机制及其 `tryboot_a_b`_ 选项的实现是为了让设备识别当前工作的引导分区以及
   在 `rebootp` 使用 `tryboot` 参数请求时要测试的引导分区。

构建镜像
-----------------------------------------------------------

这一块需自行移植 buildroot_pi_swupdate 项目中的少量代码完成镜像构建

使用镜像
-----------------------------------------------------------

默认情况下，一旦启动 Pi 将提供：


1. SSH 服务器（由dropbear提供）

2. 网页应用 http://[target_ip]:8080

3. 使用 check.sh 脚本获知可用的安装点

有关 tryboot 定义的详细信息
-----------------------------------------------------------

在设备的 eMMC 上创建以下分区：

1. mmcblk0p1 - boot_a: A组为启动工作组

2. mmcblk0p2 - boot_b: B组为启动工作组

3. mmcblk0p3 - persistent: 使用非易失性的VFAT分区来保存镜像更新后的信息

4. mmcblk0p5 - rootfs_a: A组配套的rootfs

5. mmcblk0p6 - rootfs_b: B组配套的rootfs

测试 tryboot 特性的步骤：

1. 通电启动，默认从A组启动

2. `rebootp 2` 命令将重启到 `boot 2`，
   其默认 config.txt 要求加载 `rootfs 6`， ./check.sh 检查rootfs挂载点应为 6。

3. `rebootp 1` 命令将重启到 `boot 1`，
   其默认 config.txt 要求加载 `rootfs 5`，./check.sh 检查rootfs挂载点应为 5。

4. `rebootp '2 tryboot'` 命令将重启到 `boot 2`，
   其 tryboot.txt 有一个 `cmdline_from_a` 询问 `rootfs 5` ，
   ./check.sh 检查rootfs挂载点应为 5。

5. `rebootp '1 tryboot'` 命令将重启到 `boot 1`，
   其 tryboot.txt 有一个 `cmdline_from_b` 询问 `rootfs 6` ，
   ./check.sh 检查rootfs挂载点应为 6。


有关 autoboot 定义的详细信息
-----------------------------------------------------------

`autoboot.txt` 是 Raspberry Pi 从特定分区启动的`未记录机制(undocumented mechanism)`。

在设备的 eMMC 上创建以下分区：

1. mmcblk0p1 - persistent: 包含 autoboot.txt 文件，该文件将告诉 Pi 从指定分区启动

2. mmcblk0p2 - boot_a: A组为启动工作组

3. mmcblk0p3 - boot_b: B组为启动工作组

4. mmcblk0p5 - rootfs_a: A组配套的rootfs

5. mmcblk0p6 - rootfs_b: B组配套的rootfs

测试 autoboot 特性的步骤：

1. 通电启动，将从 boot 2 启动并使用 rootfs 5。

2. 执行 set_boot_partition_b.sh 并 reboot。将从 boot 3 启动并使用 rootfs 6。

3. 执行 set_boot_partition_a.sh 并 reboot。将从 boot 2 启动并使用 rootfs 5。

4. 执行 `rebootp 3` 将重启到 boot 3，
   其默认的config.txt要求加载 rootfs 6，./check.sh 检查rootfs挂载点应为 6。

5. 执行 `rebootp 2` Pi将重启到 boot 2，
   其默认的config.txt要求加载 rootfs 5，./check.sh 检查rootfs挂载点应为 5。

此外，还可以测试 tryboot 特性：

1. 测试 `rebootp '3 tryboot'` Pi 将重启到 boot 3，
   其tryboot.txt有一个 cmdline_from_a 询问rootfs 5，./check.sh 检查rootfs挂载点应为 5。

2. 测试 `rebootp '2 tryboot'` Pi 将重启到 boot 2，
   其tryboot.txt有一个 cmdline_from_b 询问rootfs 6，./check.sh 检查rootfs挂载点应为 6。


树莓派各种启动方式的优先级
-----------------------------------------------------------

树莓派4b中，reboot 'n tryboot' 由 syscall 调用 reboot，并将重启参数带入到 VPU（推测应是 VideoCore GPU），期间VPU的工作相当于将开机动作重新执行一遍，只是代入了reboot时带来的参数。

代码位置：raspberry/linux/drivers/firmware/raspberrypi.c

::

    /**
     * rpi_firmware_property_list - Submit firmware property list
     * @fw:        Pointer to firmware structure from rpi_firmware_get().
     * @data:    Buffer holding tags.
     * @tag_size:    Size of tags buffer.
     *
     * Submits a set of concatenated tags to the VPU firmware through the
     * mailbox property interface.
     * ...
     */
    int rpi_firmware_property_list(struct rpi_firmware *fw,
                    void *data, size_t tag_size)
    {
        ...
        buf = dma_alloc_coherent(fw->cl.dev, PAGE_ALIGN(size), &bus_addr,
                    GFP_ATOMIC);
        ...
        buf[0] = size;
        buf[1] = RPI_FIRMWARE_STATUS_REQUEST;
        memcpy(&buf[2], data, tag_size);
        buf[size / 4 - 1] = RPI_FIRMWARE_PROPERTY_END;
        ...
    }   

参照官方文档及实际运行，可推知其几种不同启动的优先级：

1. reboot "n tryboot"
   
   - n代表sdcard上的具体分区号
   
   - 会自动加载 tryboot.txt，如果有
   
   - 官方文档提到的 tryboot 的开关在更高一层（uboot之前，应该是 VideoCore GPU初始化部分）完成
   
   - 其优先级高于 autoboot

2. autoboot 自动启动

   - 当有 autoboot.txt 并且 tryboot_a_b 标志位为 1 时，则执行自动启动流程

   - 会自动加载 config.txt，而不是 tryboot.txt

   - 继续读取 boot_partition 键，根据键值指定的分区号去对应分区查找 kernel 启动文件，kernel 再根据 cmdline.txt 启动 rootfs

   - 其优先级高于普通启动

3. config.txt 普通启动

   - 在本文件的分区内查找 kernel 启动文件，kernel 再根据 cmdline.txt 启动 rootfs