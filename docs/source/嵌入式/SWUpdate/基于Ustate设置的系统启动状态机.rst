基于Ustate设置的系统启动状态机
===========================================================

.. image:: https://sbabic.github.io/swupdate/_images/statemachine.png

* 1. EEPROM 加载 U-Boot SPL
* 2. U-Boot SPL 加载 U-Boot 或其他 Bootloader
* 3. 开启了启动计数机制的 U-Boot 中启动计数器 +1
* 4. 开启了启动计数机制的 U-Boot 检查有无超过启动次数限制
* 4.1 超过启动次数限制，检查 ustate 是否为 1
* 4.2 ustate 为 1，将ustate 设为 3,并切换设备正常启动
* 4.3 ustate 不为 1，进入救援系统（ramdisk）
* 5. 没超过启动次数限制，正常启动
* 6. 启动成功，系统正常运行，将 ustate 和 bootcounter 置0
* 7. 启动失败，系统重置/重启