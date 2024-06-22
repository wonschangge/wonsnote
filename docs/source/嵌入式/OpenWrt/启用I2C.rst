启用I2C
===========================================================

我所使用的树莓派UPS电源使用I2C总线来和树莓派通信，

`UPS Hat的资料页 <https://www.waveshare.net/wiki/UPS_HAT>`_

状态监测脚本使用了python及SMBus总线模块，这些需要在OpenWrt的MenuConfig中手动勾选进去。

* libpython3
* python3-smbus

对应的 kmod 也需勾选进去：

* kmod-i2c-bcm2835
* kmod-i2c-smbus
* kmod-i2c-core

还用了i2c-tools的i2cdetect来检测i2c的设备地址情况:

* i2c-tools

最后，还需配置树莓派硬件设备树的启动参数：

* dtparam=i2c1=on

OpenWrt树莓派页的配置：

https://openwrt.org/toh/raspberry_pi_foundation/raspberry_pi#using_i2c_and_spi

