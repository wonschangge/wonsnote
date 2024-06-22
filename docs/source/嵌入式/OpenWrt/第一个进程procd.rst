第一个进程procd
===========================================================

什么是 procd?

procd是OpenWrt中用C编写的”进程管理守护进程“。
它跟踪从 init 脚本启动的进程（通过 ubus 调用），并且可以在配置/环境未更改时抑制冗余服务启动/重新启动请求。

procd已取代...，例如

* hotplug2，用于嵌入式系统的动态设备管理子系统。Hotplug2 是一个小包中的一些 UDev 功能的简单替代品，旨在用于 Linux 早期用户空间：Init RAM FS 和 InitRD。
* busybox-klogd和busybox-syslogd
* busybox-watchdog

procd旨在与现有格式保持兼容/etc/config/；例外……

ubus 和 dbus 有什么区别？
-----------------------------------------------------------

dbus臃肿，其C API使用起来非常烦人，需要编写大量的样板代码。

事实上，纯 C API非常烦人，以至于它自己的API文档指出：“如果你直接使用这个低级API，你就会承受一些痛苦。”

ubus它很小，优点是易于从常规 C 代码中使用，并且自动使所有导出的API功能也可用于 shell 脚本，而无需额外的工作。



ubus组成：守护进程、库、helper