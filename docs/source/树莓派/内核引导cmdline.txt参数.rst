# 树莓派内核引导命令行参数（cmdline.txt）

- 4B官方64位镜像: console=tty1 console=serial0,115200 root=PARTUUID=b307905e-02 rootfstype=ext4 fsck.repair=yes rootwait quiet splash plymouth.ignore-serial-consoles cfg80211.ieee80211_regdom=CN
- 4B OpenWrt: console=serial0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=squashfs,ext4 rootwait

编辑注意:

1. 所有参数放在cmdline.txt同一行
2. 禁用回车符

内核命令行参数选项:

标准条目:

* console: 定义串行控制台，通常有两个条目:
  * console=serial0,115200
  * console=tty1
* root: 定义rootfs位置，如root=/dev/mmcblk0p2表示SDCard0第2分区, 其他示例:
  * root=LABEL=xbian-root-btrfs
  * root=UUID=12345-0123-10234
  * root=PARTUUID=abcdefab-02
* rootfstype: 定义rootfs使用的fs类型，如rootfstype=ext4
* quiet: 将内核默认日志级别设为KERN_WARNING，这会在启动期间将过滤只剩下非常严重的日志消息

KMS显示模式条目:

* 如果未指定video的内容，kernel将读取HDMI连接显示器的EDID并自动选择显示器支持的最佳分辨率
* video: 可更改文本控制台的分辨率，如:
  * video=HDMI-A-1:1920x1080M@60
  * video=HDMI-A-1:1920x1080M@60,rotate=90,reflect_x 添加旋转和反射参数
  * 对等HDMI-A-1(对应HDMI0丝印)的有HDMI-A-2(对应HDMI1丝印)、DSI-1(DSI或DPI)、复合1

其他条目:

* splash: 告诉启动通过Plymouth模块使用启动屏幕
* plymouth.ignore-serial-consoles: 通常如果启用了Plymouth模块,它将阻止启动消息出现在任何可能存在的串行控制台上。该标志告诉Plymouth忽略所有串行控制台，使启动消息再次可见，就像Plymouth未运行时一样
* dwc_otg.lpm_enable=0: 关闭 dwc_otg 驱动程序中的链路电源管理 (LPM)，该驱动程序驱动 Raspberry Pi 计算机上使用的处理器中内置的 USB 控制器。
  * 注意: 在 Raspberry Pi 4 上，该控制器默认禁用，并且仅连接到 USB Type C 电源输入连接器；Raspberry Pi 4 上的 USB A 型端口由单独的 USB 控制器驱动，不受此设置的影响。
* dwc_otg.speed：设置 Raspberry Pi 计算机上处​​理器内置的 USB 控制器的速度。dwc_otg.speed=1会将其设置为全速 (USB 1.0)，该速度比高速 (USB 2.0) 慢。除非在排除 USB 设备问题期间，否则不应设置此选项。
* smsc95xx.turbo_mode：启用/禁用有线网络驱动程序 Turbo 模式。smsc95xx.turbo_mode=N关闭涡轮模式。
* usbhid.mousepoll：指定鼠标轮询间隔。如果您遇到无线鼠标缓慢或不稳定的问题，将其设置为 0usbhid.mousepoll=0可能会有所帮助。
* drm.edid_firmware=HDMI-A-1:edid/your_edid.bin：使用 的内容覆盖显示器的内置 EDID /usr/lib/firmware/edid/your_edid.bin。