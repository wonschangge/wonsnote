U-Boot对AB系统升级的支持
===========================================================

使用A/B方案:

1. 系统正运行在处于活跃状态的系统副本A上
2. 通过本地（SD卡、USB棒）或网络下载到更新映像，触发更新
3. 更新映像被烧入/写入当前处于非活跃状态的的系统副本B上
4. 如果刷入成功，更新引导加载程序配置，将副本B标记为活跃副本
5. 系统重启，并在副本B安装的新系统上启动
6. 看门狗用于检测无法正常工作的系统，并在必要情况下回退到旧版本


升级失败如何恢复

假设使用A/B分区方案：

.. note::
    1. 更新失败的情况很容易应对，易于发现并仍使用当前的根文件系统即可
    2. 如果成功，还需要确认新的根文件系统也能正常工作，否则就退回到旧的根分区
  
假设使用单个根文件系统和救援文件系统：

.. warning:: 
    1. 如果更新失败，系统可能无法启动
    2. 因此需要引导加载程序提供机制来退回到救援文件系统，并等待新的更新

U-Boot的bootcount和bootlimit机制

U-Boot提供一种检测失败并进行引导尝试的机制：

* 通过 `CONFIG_BOOTCOUNT_LIMIT <https://elixir.bootlin.com/u-boot/latest/K/ident/CONFIG_BOOTCOUNT_LIMIT>`_ 启用该功能

* 更新完毕后，将U-Boot环境变量upgrade_available设置为1，将bootcount设置为0

* 当U-Boot启动时，如果upgrade_available不为0，bootcount将递增并保存

* 如果定义了bootlimit并且 bootcount > bootlimit，U-Boot将运行altbootcmd而不是bootcmd中的命令

* 当Linux成功引导后，用户空间应用程序负责将upgrade_available和bootcount设置回0

* 否则，系统将手动（按下复位键）或自动（如果使用了看门狗）重启，bootcount将增加，直到达到bootlimit

.. note::
    U-Boot的配置提供了除在环境中存储引导计数之外的其他可能性:  
      * 在I2C设备（如RTC）中
      * 在EEPROM中
      * 在SPI闪存中
      * 在EXT文件系统的文件中
      * 在RAM中（重置后持久存储的区域）
      * ...

    详细请参考U-Boot的 `bootcount文档 <https://elixir.bootlin.com/u-boot/latest/source/doc/README.bootcount>`_

从Linux访问U-Boot环境

从Linux设置upgrade_available和bootcount等U-Boot中的环境变量，启动引导计数机制，
或者在最新更新引导完成时禁用该机制，可以使用fw_printenv和fw_setenv命令。

* 此类工具可以从U-Boot的源代码树构建: `make CROSS _ COMPILE = arm-Linux-env tools`

* Yocto Project: libubootenv配方

* Buildroot: BR2_PACKAGE_UBOOT_TOOLS_FWPRINTENV 配置

* 参考1： https://elixir.bootlin.com/u-boot/latest/source/tools/env/README
* 参考2： https://elinux.org/U-boot_environment_variables_in_linux

使用看门狗处理更新失败的典型用法：

* 在硬件平台上配置U-Boot来启用看门狗
* 当Linux启动时，应运行一个定期的用户空间进程，通过写入/dev/watchdog来保持“喂养”看门狗，否则硬件看门狗将重启机器，bootcount将增加
* 详情请参考内核文档中的 `watchdog/watchdog-api <https://www.kernel.org/doc/html/latest/watchdog/watchdog-api.html>`_

如何更新引导程序？

.. important:: 需要SoC支持才能更新SPL

1. 需要配置SPL从文件系统中加载U-Boot
   
2. 在空间有限的SPL中实现分区选择和引导计数可能很困难

3. 如果是从eMMC启动，可以在特殊的boot0和boot1硬件分区上刷新SPL和U-Boot
   请参阅U-Boot文档中 `mmc partconf命令 <https://u-boot.readthedocs.io/en/latest/usage/cmd/mmc.html>`_