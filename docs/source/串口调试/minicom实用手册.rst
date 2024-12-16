minicom实用手册
============================

版本: Minicom 2.8

进入命令索引界面: Ctrl-A Z

传输文件(S)
----------------------------

共支持 zmodem, ymodem, xmodem, kermit, ascii 五种方式，传输速率依次降低。

传输速率与串口波特率（Baudrate）线性相关，与芯片厂商的限制（不一定有）有关。

串口波特率分调试板的时钟速率/8和串口芯片的速率。

USB转串口工具芯片方面:

1. 以FTDI FT232为例，其通信速率峰值为3Mbps。

2. 以沁恒CH340为例，其通信速率峰值为2Mbps。

芯片厂商速率限制方面：

1. RaspberryPi对应的broadcom芯片无限制

2. Rockchip只支持两种速率: 115200bps 或 1500000 bps。

Using rz and sz under linux shell?
---------------------------------------------

https://superuser.com/questions/604055/using-rz-and-sz-under-linux-shell