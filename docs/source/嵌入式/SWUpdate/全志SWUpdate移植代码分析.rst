全志如何移植SWUpdate
===========================================================

全志在TinaOS(基于OpenWrt改)上移植SWUpdate上代码结构:


::

    全志/tina-V83x/package/allwinner/swupdate$ tree
    .
    ├── config
    │   ├── bootloader
    │   │   └── Config.in-----------------------------------------------------SWUpdate配置bootloader的子config
    │   ├── Config.in---------------------------------------------------------SWUpdate的主config
    │   ├── handlers
    │   │   └── Config.in-----------------------------------------------------SWUpdate配置handler的子config
    │   ├── mongoose
    │   │   └── Config.in-----------------------------------------------------SWUpdate配置web服务器mongoose的子config
    │   ├── parser
    │   │   └── Config.in-----------------------------------------------------SWUpdate配置JSON解析器的子config
    │   ├── reduce
    │   │   └── Config.in-----------------------------------------------------SWUpdate配置裁剪的子config
    │   └── suricatta
    │       └── Config.in-----------------------------------------------------SWUpdate配置suricatta守护模式的子config
    ├── Config-defaults.in----------------------------------------------------
    ├── Config.in-------------------------------------------------------------Menuconfig中SWUpdate部分的config入口，根据是否自定义展开
    ├── convert_defaults.pl---------------------------------------------------合并默认值的perl，从busybox处拷贝
    ├── convert_menuconfig.pl-------------------------------------------------合并编译菜单的perl，从busybox处拷贝
    ├── Makefile--------------------------------------------------------------按swupdate构建格式编写的makefile
    ├── patches
    │   ├── 0001-awboot_handler.patch-----------------------------------------全志补丁1
    │   └── 0002-swupdate-add-paratermen-for-open-in-writing-raw-data.patch---全志补丁2
    ├── swupdate_autorun.init-------------------------------------------------放在init.d下自动运行的脚本，打印进度，启动swupdate_cmd.sh
    └── swupdate_cmd.sh-------------------------------------------------------搭配swupdate一起工作的脚本

其选用的 swupdate2019.04tag 的版本，存在一套默认配置。

包构建依赖如下内容:

1. zlib
2. libconfig
3. curl
4. uboot-envtools
5. mtd-utils
6. ota-burnboot(针对自家芯片的烧录)
7. libopenssl
8. librsync

在包定义里头还有一个 libjson-c 的依赖项。

子项的配置位于 Config.in 中（OpenWrt的构建系统所定义的类型文件）

目标安装位置：

- installdir /usr/bin
- installdir /etc/init.d
- installdir /sbin
- installbin /usr/bin/swupdate /sbin
- installbin /usr/bin/progress /sbin
- installbin /usr/bin/client /sbin
- installbin /usr/bin/hawkbitcfg /sbin
- installbin /usr/bin/sendtohawkbit /sbin
- installbin ./swupdate_autorun.init /etc/init.d/S99swupdate_autorun
- installbin ./swupdate_cmd.sh /sbin


suricatta守护模式
-----------------------------------------------------------

它轮询远程服务器来获取更新、下载、安装。重启后向远程服务器报告更新状态，基于bootaloader环境中设置的更新状态变量来确保在重启后进行持久存储。


Config.in 区别对照（全志移植vs.SWUpdate内部）
-----------------------------------------------------------

全志Config.in的编写也主要来自于SWUpdate内部（也源于大家使用同样的menuconfig构建），主要区别有以下几点：

1. 在 config 标签之前添加了 SWUPDATE_CONFIG_，如 SWUPDATE_CONFIG_UBOOT，以确保不发生冲突
2. 将部分默认值（主要是路径字符串、数值、布尔值）使用变量替代，放在外层的 Config-defaults.in集中管理
3. 在 handlers 中增加了全志的 SWUPDATE_CONFIG_AWBOOT_HANDLER，用于处理全志平台通过libota-burnboot命令升级boot0/uboot
4. 全志增加了裁剪配置模块，可不在rootfs中安装client、progress、autorun cmd。
5. 主Config.in对应Kconfig

---

总结，全志移植SWUpdate所做的主要工作：

1. 参照 busybox 编写移植文件（命名空间、默认值）
2. 添加适配自己平台的两个 patch（支持更新boot0，uboot）
3. 添加自启动脚本init.d，定义运行内容，默认在后台启动progress输出到串口，默认启动脚本swupdate_cmd.sh，负责完善参数最终调用swupdate。

---

默认值设定

| 配置项                             | 值类型    | 默认值                  | 作用备注 |
| ------------------------------- | ------ | -------------------- | ---- |
| HAVE_DOT_CONFIG                 | bool   | y                    |      |
| CURL                            | bool   | n                    |      |
| CURL_SSL                        | bool   | n                    |      |
| SYSTEMD                         | bool   | n                    |      |
| SCRIPTS                         | bool   | y                    |      |
| HW_COMPATIBILITY                | bool   | n                    |      |
| SW_VERSIONS_FILE                | string | "/etc/sw-versions"   |      |
| SOCKET_CTRL_PATH                | string | "/tmp/sockinstctrl"  |      |
| SOCKET_PROGRESS_PATH            | string | "/tmp/swupdateprog"  |      |
| SOCKET_REMOTE_HANDLER_DIRECTORY | string | "/tmp/"              |      |
| MTD                             | bool   | n                    |      |
| LUA                             | bool   | n                    |      |
| FEATURE_SYSLOG                  | bool   | n                    |      |
| CROSS_COMPILE                   | string | ""                   |      |
| SYSROOT                         | string | ""                   |      |
| EXTRA_CFLAGS                    | string | ""                   |      |
| EXTRA_LDFLAGS                   | string | ""                   |      |
| EXTRA_LDLIBS                    | string | ""                   |      |
| DEBUG                           | bool   | n                    |      |
| WERROR                          | bool   | n                    |      |
| NOCLEANUP                       | bool   | n                    |      |
| BOOTLOADER_EBG                  | bool   | n                    |      |
| UBOOT                           | bool   | y                    |      |
| BOOTLOADER_NONE                 | bool   | n                    |      |
| BOOTLOADER_GRUB                 | bool   | n                    |      |
| UBOOT_FWENV                     | string | "/etc/fw_env.config" |      |
| UBOOT_NEWAPI                    | bool   | n                    |      |
| DOWNLOAD                        | bool   | n                    |      |
| DOWNLOAD_SSL                    | bool   | n                    |      |
| CHANNEL_CURL                    | bool   | n                    |      |
| HASH_VERIFY                     | bool   | n                    |      |
| SIGNED_IMAGES                   | bool   | n                    |      |
| ENCRYPTED_IMAGES                | bool   | n                    |      |
| SURICATTA                       | bool   | n                    |      |
| WEBSERVER                       | bool   | n                    |      |
| GUNZIP                          | bool   | y                    |      |
| LIBCONFIG                       | bool   | y                    |      |
| PARSERROOT                      | string | ""                   |      |
| JSON                            | bool   | n                    |      |
| SETSWDESCRIPTION                | bool   | n                    |      |
| UBIVOL                          | bool   | n                    |      |
| UBIVIDOFFSET                    | int    | 2048                 |      |
| CFI                             | bool   | n                    |      |
| CFIHAMMING1                     | bool   | n                    |      |
| RAW                             | bool   | y                    |      |
| RDIFFHANDLER                    | bool   | n                    |      |
| SHELLSCRIPTHANDLER              | bool   | y                    |      |
| ARCHIVE                         | bool   | n                    |      |
| REMOTE_HANDLER                  | bool   | n                    |      |
| SWUFORWARDER_HANDLER            | bool   | n                    |      |
| BOOTLOADERHANDLER               | bool   | y                    |      |
| AWBOOT_HANDLER                  | bool   | y                    |      |
| UCFWHANDLER                     | bool   | n                    |      |

其他修改
-----------------------------------------------------------

从全志/tina-V83x/package/libs/zlib拷贝了  zlib
从全志/tina-V83x/package/libs/zlib拷贝了  librsync

## 全志对Uboot-env的修改

SWUpdate 依赖到了 libubootenv，并且全志对这块的 make 进行了改动。

从安全的角度思考，先去自行编译下树莓派4b的uboot，再来对照这一块的改动。

编译树莓派4b的Uboot参考[在树莓派4（Raspberry Pi 4 B）上运行u-boot](https://zhuanlan.zhihu.com/p/92689086)

rpi4的启动分区采用的 fat32 fs，并采用三级启动方式：

1. 板载VideoCore GPU启动固化在rpi4中的ROM，该阶段非常简单，主要支持读取TF卡中的fat32 fs的第2级启动程序;
2. 板载VideoCore GPU加载并执行启动分区(/boot)中的bootcode.bin，该文件的主要功能是解析elf格式文件，再加载并解析同目录下的start4.elf;
3. 运行start4.elf，读取并解析config.txt的配置文件，再加载并执行真正的u-boot程序。

依赖的文件:

1. bcm2711-rpi-4-b.dtb
2. bootcode.bin
3. fixup4.data
4. start4.elf
5. u-boot.bin
6. config.txt