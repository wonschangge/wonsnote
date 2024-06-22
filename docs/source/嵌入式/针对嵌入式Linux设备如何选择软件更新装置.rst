针对嵌入式Linux设备如何选择软件更新装置
===========================================================

https://elinux.org/images/0/07/Leon-anavi-software-updates.pdf


常见的嵌入式Linux更新策略

开源解决方案

Yocto/OpenEmbedded的实际示例





关键点：更新体积

* 硬盘空间是否受限？
* 数据传输的网络带宽是否受限？
* 存储空间每1GB的价格？

关键点：数据传输

有哪些不同的数据传输方式？

* OTA（WiFi/蜂窝网络）
* 以太网
* USB
* ...

关键点：设备管理

* 单设备更新还是多设备更新？
* 所有设备是否使用相同的软件栈？
* 所有设备是否在线？是否需要监控设备更新？
* 是否需要在不同时间更新不同设备？
* 如何更新设备群？

关键点：镜像构建

* 用的什么发行版和构建系统？
* 是否有你使用的硬件的BSP？
* 软件更新技术是否与构建系统和BSP相兼容？

.. note:: 常见的：Yocto/OpenEmbedded, Buildroot, OpenWrt, debian, PTXdist, Ubuntu Core


Debian？

* Debian是一个稳定的完整发行版，有成千上万的软件包以二进制文件的形式安装，不需要从源代码进行交叉编译
* 嵌入式设备有许多Debian衍生产品

Debian和Yocto Project怎么选？参考视频：`Chris Simmonds, Embedded Linux Conference Europe 2019 <https://www.youtube.com/watch?v=iDllXa8SzUgr>`_

.. youtube:: iDllXa8SzUg

Yocto Project？

* Linux基金会的开源协作项目，使用OpenEmbedded版本为嵌入式设备创建定制的基于Linux的系统
* OpenEmbedded构建系统包括BitBake和OpenEmbedded内核
* Poky是Yocto项目的参考发行版，作为元数据提供，没有二进制文件，用于引导您自己的嵌入式设备发行版
* 两年一次的发布周期
* 涵盖两年期的长期支持(LTS)版本

共通的嵌入式Linux更新策略

* A/B更新（双冗余方案）
* 增量更新
* 基于容器的更新
* 组合策略

A/B更新

* 双A/B副本的rootfs分区
* 数据分区，用于存储在更新过程中保持不变的任何持久数据
* 通常，客户端应用程序在嵌入式设备上运行，并定期连接到服务器以检查更新
* 如果有新的软件更新可用，客户端会下载并将其安装在另一个分区上
* 更新失败时回退

增量更新

* 只有差值之间的二进制增量被发送到嵌入式设备
* 在类似Git的文件系统树模型中工作
* 节省存储空间和连接带宽
* 系统回滚到以前的状态

流行的更新开源解决方案：

* Mender
* libostree(OSTree)
* SWUpdate
* Snap
* RAUC
* Aktualizr
* Aktualizr-lite
* Swupd
* QtOTA
* UpdateHub
* Torizon
* Balena
* FullMetalUpdate
* Rpm-ostree(used in Project Atomic)

Mender

* 作为免费开源或付费商业/企业计划提供
* A/B更新方案开源，所有方案包括增量更新都面向的专业和商业用户
* 后端服务（托管Mender）
* 用Go、Python、JavaScript编写
* 通过meta-mender和额外的BSP层集成在Yocto/OE: https://github.com/mendersoftware/meta-mender
* Apache 2.0下GitHub源代码

Mender支持的设备

* Raspberry Pi
* BeagleBone
* Intel x86-64
* Rockchip
* Allwinner
* NXP
* And more in: https://github.com/mendersoftware/meta-mender-community



有用的链接：

* https://www.yoctoproject.org/
* https://mender.io/
* https://rauc.io/
* https://ostreedev.github.io/ostree/
* https://www.konsulko.com/building-platforms-with-secure-over-the-air-updating/
* https://www.konsulko.com/how-mender-works/
* https://www.konsulko.com/getting-started-with-rauc-on-raspberry-pi-2/