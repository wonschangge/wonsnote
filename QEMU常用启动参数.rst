QEMU常用启动参数
=========================

::

    qemu-system-aarch64 -M virt-4.0 -m 1G -cpu cortex-a57 -nographic -kernel zImage -initrd initrd

一些常用的qemu启动参数：

* -M virt: 指定需要使用的machine类型，virt是qemu提供的一个通用machine，可以同时支持arm32和arm64（部分cortex不支持）， -M help 可以列出所有支持的machine列表

* -m 1G: 可选，可以通过修改此参数来增大OS的可用内存

* -cpu cortex-a57: 指定模拟的cpu类型，指定 -M 的情况下可以使用 -cpu help 查看当前machine支持的cpu类型

* -smp 2: 可选，可以修改OS的cpu数量，默认为1

* -append: 可选，指定内核的启动参数(cmdline)

* -kernel: 指定OS的内核

* -initrd: 指定OS的文件系统

* -dtb: 可选，用于指定dtb(device tree)文件

* -d in_asm -D qemu.log: 可选，输出qemu在tcg模式下的”指令流”。 -d 选择指令流类型，可以用 -d help 查看支持的选项列表； -D 指定输出的文件名

* -s -S: 可选，调试参数。 -S 可以让qemu加载OS的zImage、initrd到指定位置后停止运行，等待gdb连接； -s 等价于 --gdb tcp::1234 ，启动gdb server并默认监听1234端口

* -serial: 可选，用于串口重定向。不指定时默认为 -serial stdio ，即打印到标准输入输出。也可以重定向到tcp: -serial tcp::1111,server,nowait ，通过 telnet localhost 1111 连接

