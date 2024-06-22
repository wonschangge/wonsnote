udev_hal_Dbus_DeviceKit之间的关系
===========================================================

systemd作者Lennart Poettering的 `邮件解释 <https://lists.freedesktop.org/archives/dbus/2010-April/012545.html>`_


对内核驱动如何工作、udev在kernel和user-space中间干什么有基本了解，
但看到HAL、Dbus、DeviceKit、Network Manager时又对彼此的功能感到迷惑，求解释。


回答：

1. 忽略devicekit，它仅仅是一个概念，从未真正存在过
2. 忽略HAL，只有在老代码中存在（sysvinit？）
3. udev提供访问linux设备树的低层级访问，允许程序遍历设备和属性，并在设备接入拔出时获取通知
4. dbus是一个提供程序间通信的框架，安全、可靠、高度面向对象的API
5. udisks（旧称DeviceKit-disks）是一个守护进程，位于libudev和其他内核接口之上，提供到存储设备的高级接口，可通过dbus访问应用
6. upower（旧称DeviceKit-power）类似udisks
7. NetworkManager类似udisks

.. note:: HAL将一切融合在一个大的守护进程上，最终被淘汰（设计糟糕）

.. note:: 依此类推，NM——unetwork,dbus——ubus,X11——udisplay