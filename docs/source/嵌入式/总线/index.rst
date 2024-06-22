总线
====================

.. toctree::
    I2C总线
    SMBus总线
    SPI总线

Inter-Process Communication/Remote Procedure Call 总线：

- GNOME/KDE - D-Bus - 中间人模式
- OpenWrt - ubus（基于dbus的架构）
- Android - Binder


`Binder vs. kdbus <http://kroah.com/log/blog/2014/01/15/kdbus-details/>`_

.. important:: Binder is bound to the CPU, D-Bus (and hence kdbus), is bound to RAM.


轻量级消息库：

* nanomsg
* ZeroMQ
* MQTT
* RabbitMQ