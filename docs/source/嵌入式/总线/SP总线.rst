SPI总线
===========

SPI（Serial Peripheral Interface Bus），串行外设接口。

SPI总线规定的4个保留逻辑信号接口：

- SCLK（Serial Clock），串列时脉，主机发出
- MOSI（Master Output Slave Input），主机输出、从机输入
- MISO（Master Input Slave Output），主机输入、从机输出
- SS（Slave Select），从选信号，主机发出（低电平有效）

.. tip:: SCL 和 SCLK（SCK）的区别，SCL是I2C的时钟线、是由主机拉低的开漏输出，SCLK是SPI的时钟线，是由主机驱动的推挽输出。

SPI总线单主单从示意图：

.. image::
    res/SPI_single_slave.svg


SPI总线单主多从示意图：

.. image::
    res/SPI_three_slave.svg

