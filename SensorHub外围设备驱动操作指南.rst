SensorHub外围设备驱动操作指南
================================================


I2C速率: I2C协议v2.1规定了3种速率(100K/400K/3.4Mbps)

SPI速率: 事实标准，目前有的实现高达50Mbps

SPI速率影响因子: CLK频率、CPU、PCB信号Bandwidth


I2C操作指南
-------------------------

功能: I2C模块可完成CPU对I2C总线上连接的从设备的读写

使用示例：

1. 模块初始化

    1. 驱动初始化，i2c_dev_init();
    2. 根据设备硬件特性配置相关管脚复用
    3. 根据需要调用模块的读写函数对设备进行访问

2. 通过调用驱动函数访问I2C设备

    1. 定义一个I2C设备描述结构体，struct i2c_client client;
    2. 调用 client_attach 把 client 关系到对应的控制器上;
        ::

            函数原型:
            int client_attach(struct i2c_client *client, int adapter_index);
            adapter_index 是被关联的 i2c 总线号的值，例如需要操作i2c0，则该值为0
    3. 调用I2C提供的标准读写函数对外围器件进行读写
        ::

            读:
            ret = i2c_transfer(struct i2c_adapter *adapter, struct i2c_msg *msgs, int count);
            写:
            ret = i2c_master_send(struct i2c_client *client, const char *buf, int count);

        示例代码：
        ::

            // 读写I2C外围设备的示例程序
            struct i2c_client i2c_client_obj; // i2c控制结构体
            #define SLAVE_ADDR 0x34 // i2c设备地址
            #define SLAGE_REG_ADDR 0x300f // i2c设备寄存器地址
            /* client 初始化 */
            int i2c_client_init(void)
            {
                int ret = 0;
                struct i2c_client *i2c_client0 = &i2c_client_obj;
                i2c_client0->addr = SLAVE_ADDR >> 1;
                ret = client_attach(i2c_client0, 0);
                if (ret < 0) {
                    dprintf("Fail to attach client!\n");
                    return -1;
                }
                return 0;
            }
            UINT32 sample_i2c_write(void)
            {
                int ret;
                struct i2c_client *i2c_client0 = &i2c_client_obj;
                char buf[4] = {0};
                i2c_client_init();

                buf[0] = SLAGE_REG_ADDR & 0xff;
                buf[1] = (SLAGE_REG_ADDR >> 8) & 0xff;
                buf[2] = 0x03; // 往i2c设备写入的值
                // 调用I2C驱动标准写函数进行操作
                ret = i2c_master_send(i2c_client0, &buf, 3);
                return ret;
            }
            UINT32 sample_i2c_read(void)
            {
                int ret;
                struct i2c_client *i2c_client0 = &i2c_client_obj;
                struct i2c_rdrw_ioctl_data rdwr;
                struct i2c_msg msg[2];
                unsigned char recvbuf[4];

                memset(recvbuf, 0x0, 4);
                i2c_client_init();

                msg[0].addr = SLAVE_ADDR >> 1;
                msg[0].flags = 0;
                msg[0].len = 2;
                msg[0].buf = recvbuf;

                msg[1].addr = SLAVE_ADDR >> 1;
                msg[1].flags = 0;
                msg[1].flags |= I2C_M_RD;
                msg[1].len = 1;
                msg[1].buf = recvbuf;

                rdwr.msgs = &msg[0];
                rdwr.nmsgs = 2;

                recvbuf[0] = SLAVE_REG_ADDR & 0xff;
                recvbuf[1] = (SLAGE_REG_ADDR >> 8) & 0xff;

                i2c_transfer(i2c_client0->adapter, msg, rdwr.nmsgs);
                dprintf("val = 0x%x\n", recvbuf[0]); // buf[0] 保存着从IC设备读写的值
                return ret;
            }
3. 通过设备节点操作访问I2C设备 

    1. 打开I2C总线对应的设备文件，获取文件描述符：fd = open("/dev/i2c-0", O_RDWR);
    2. 通过 ioctl 设置外围设备地址、外围设备寄存器位宽和数据位宽
        ::

            ret = ioctl(fd, I2C_SLAVE_FORCE, device_addr);
            ioctl(fd, I2C_16BIT_REG, 0);
            ioctl(fd, I2C_8BIT_DATA, 0);
    3. 使用以下函数进行读写操作：
        ::

            ioctl(fd, I2C_RDWR, &rdwr); // &rdwr为0时表示8bit位宽，为1时表示16bit位宽
            write(fd, buf, count);

4. shll命令
   1. i2c_read命令，在控制台使用i2c_read对I2CC设备进行读操作
   2. i2c_read <i2c_num> <device_addr> <reg_addr> <end_reg_addr> [reg_width] [data_width] [addr_width]
   3. 例如挂载在I2C控制器0上的IMX178设备的0x3000到0x3010寄存器:
   4. i2c_read 0 0x34 0x3000 0x3010 2 1 7
   5. device_addr - 外围设备地址
   6. reg_addr - 读外围设备寄存器操作的开始地址
   7. end_reg_addr - 读外围设备寄存器操作的结束地址
   8. reg_width - 外围设备的寄存器位宽（支持8/16bit，2:16bit/1:8bit）
   9. data_width - 外围设备的数据位宽（支持8/16bit，2:16bit/1:8bit）
   10. addr_width - 外围设备的地址位宽（支持7/10/bit，7:7bit/10:10bit）
   11. i2c_write命令，在控制台使用i2c_write对I2CC设备进行写操作
   12. i2c_write <i2c_num> <device_addr> <reg_addr> <reg_value> [reg_width] [data_width] [addr_width]

5. API参考
   1. i2c_dev_init: 用于初始化
   2. i2c_master_recv: 用于读取I2C数据的函数接口
   3. i2c_master_send: 用于写入I2C数据的函数接口
   4. i2c_transfer: 用于I2C传输的函数接口
   5. client_attach: 用于关联client与adapter
   6. client_deinit: 用于解除关联client与adapter

6. 数据类型
   1. i2c_client: I2C从设备结构体
   ::

        struct i2c_client {
            unsigned short flags; // 标志信息
            unsigned short addr; // 地址
            char name[I2C_NAME_SIZE]; // 名称
            struct i2c_adapter *adapter; // 适配层结构体指针
            struct i2c_driver *driver; // 驱动层结构体指针
            struct device dev; // 设备结构体
            int irq; // 中断号
            struct list_head detected; // 链表头
        };




SPI操作指南
-------------------------

功能: I2C模块可完成CPU对I2C总线上连接的从设备的读写


