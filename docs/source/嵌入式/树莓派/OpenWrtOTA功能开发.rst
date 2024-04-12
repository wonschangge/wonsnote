树莓派4bOpenWrtOTA功能开发
===========================================================

TODO:

1. tryboot_a_b flag验证是否有效
   
   1. 如果有效，OTA AB系统验证从u-boot做起，u-boot，kernel，rootfs
   
   2. 如果无效，OTA AB系统验证从kernel做起，kernel，rootfs

2. traboot_a_b flag验证通过，可用
   
   1. 可做到通过该标识位及autoboot.txt文件配置，来做到引导不同的系统启动，比如通过四个分区（boot1,root1,boot2,root2）可以交替启动树莓派OS和OpenWrt启动

OTA功能实际开发（uboot A/B，boot A/B，rootfs A/B）

1. 从u-boot做起，需自编u-boot，在里头做如下功能扩展：

2. 添加misc或env分区用于读取、设置启动标志位

3. 设置ab分区的启动方案，不同系统启动根据指定的dtb

## 树莓派官方文档的A/B更新流程示例：

下面的伪代码展示了假设的操作系统`更新服务`如何使用 `tryboot_a_b`标识位 + `autoboot.txt` 来执行A/B系统升级。

初始 `autoboot.txt`

```
[all]
tryboot_a_b=1
boot_partition=2
[tryboot]
boot_partition=3
```

### 安装更新[​](https://pidoc.cn/docs/computers/config-txt#%E5%AE%89%E8%A3%85%E6%9B%B4%E6%96%B0 "安装更新的直接链接")

- 系统开机，将默认启动到MBR分区 2
- `更新服务` 运行，并将下个版本的OS下载到分区 3
- 通过重启至 `tryboot` 模式 `reboot "3 tryboot"` 来测试更新，其中 `0` 表示默认分区

### 提交或取消更新[​](https://pidoc.cn/docs/computers/config-txt#%E6%8F%90%E4%BA%A4%E6%88%96%E5%8F%96%E6%B6%88%E6%9B%B4%E6%96%B0 "提交或取消更新的直接链接")

- 系统将从MBR分区 3 启动，因为在 `tryboot模式` 下，`[tryboot]` 过滤器的值为 true
- 如果 tryboot 处于活动状态（`/proc/device-tree/chosen/bootloader/tryboot == 1`）
  - 如果当前启动分区（`/proc/device-tree/chosen/bootloader/partition`）与 autoboot.txt 中 `[tryboot]` 部分的 `boot_partition` 相匹配
    - `更新服务`会验证系统是否更新成功
    - 如果更新成功
      - 替换 `autoboot.txt` 交换 `boot_partition` 配置
      - 正常重启 - 分区 3 现在是默认启动分区
    - 否则
      - `更新服务`将更新标记为失败，例如删除更新文件。
      - 正常重启 - 分区 2 仍是默认引导分区，因为 `tryboot` 标记已自动清除
    - 结束如果
  - 结束如果
- 结束如果

更新的 `autoboot.txt`

```
[all]
tryboot_a_b=1
boot_partition=3
[tryboot]
boot_partition=2
```

注意

- 更新 `autoboot.txt` 后不一定要重新启动。不过，`更新服务`必须注意避免覆盖当前分区，因为 `autoboot.txt` 已被修改以提交上次更新。

- 另请参阅： [设备树参数](https://pidoc.cn/docs/computers/configuration#%E8%AE%BE%E5%A4%87%E6%A0%91%E5%8F%82%E6%95%B0)。

## 树莓派各种启动方式的优先级

树莓派4b中，reboot 'n tryboot' 由 syscall 调用 reboot，并将重启参数通过MailBox带入到 VPU（VideoCore GPU），期间VPU的工作相当于将开机动作重新执行一遍，只是代入了reboot时带来的参数。

代码位置：raspberry/linux/drivers/firmware/raspberrypi.c

```c
/**
 * rpi_firmware_property_list - Submit firmware property list
 * @fw:        Pointer to firmware structure from rpi_firmware_get().
 * @data:    Buffer holding tags.
 * @tag_size:    Size of tags buffer.
 *
 * Submits a set of concatenated tags to the VPU firmware through the
 * mailbox property interface.
 * ...
 */
int rpi_firmware_property_list(struct rpi_firmware *fw,
                   void *data, size_t tag_size)
{
    ...
    buf = dma_alloc_coherent(fw->cl.dev, PAGE_ALIGN(size), &bus_addr,
                 GFP_ATOMIC);
    ...
    buf[0] = size;
    buf[1] = RPI_FIRMWARE_STATUS_REQUEST;
    memcpy(&buf[2], data, tag_size);
    buf[size / 4 - 1] = RPI_FIRMWARE_PROPERTY_END;
    ...
}   
```

参照官方文档及实际运行，可推知其几种不同启动的优先级：

1. autoboot 自动启动
   
   - 当有 autoboot.txt 并且 tryboot_a_b 标志位为 1 时，则执行自动启动流程   
   
   - 会自动加载 config.txt，而不是 tryboot.txt
   
   - 继续读取 boot_partition 键，根据键值指定的分区号去对应分区查找 kernel 启动文件，kernel 再根据 cmdline.txt 启动 rootfs
   
   - 其优先级高于tryboot启动

2. reboot "n tryboot"
   
   - n代表sdcard上的具体分区号
   
   - 会自动加载 tryboot.txt，如果有
   
   - 官方文档提到的 tryboot 的开关在更高一层（uboot之前，应该是 VideoCore GPU初始化部分）完成
   
   - 其优先级高于普通启动

3. config.txt 普通启动
   
   - 在本文件的分区内查找 kernel 启动文件，kernel 再根据 cmdline.txt 启动 rootfs

## 功能开发

- uboot
  
  - 启动计数机制
    
    - bootcount=N 
    
    - bootlimit=5 #启动失败阈值
    
    - 配置CONFIG_BOOTCOUNT_LIMIT，选择bootcount存放位置
    
    - 放在env分区（掉电不丢失）
    
    - 在用户空间配置 tryboot_a_b 的值以对A/B系统功能进行动态开关。例如可在OTA之前打开，确认OTA成功后关闭，也可一直打开。在用户空间需清空bootcount，否则多次重启就会导致bootcount超过bootlimit。

- 应用程序分区
  
  - 应用单独放到一个分区（/mnt/app），并在启动时挂载该分区。
  
  - 为保证更新过程掉电重启，仍有可用应用，可设置两个应用分区，并配合环境变量等进行挂载。
  
  - 将 /mnt/app 目录从 rootfs 中分离出，打包时被制成一个单独的文件映像。

## 借鉴 buildroot_pi_swupdate 项目

弄清楚几点问题

一、在何处、何时进行分区的划分，比如添加进持久化分区

该项目里的分区及分区文件系统的确定、生成、划分根据 buildroot 项目中定义的文件和格式来的，文件格式：genimage_swupdate.cfg

```shell
image persistent.vfat {
    vfat {
        extraargs="-F 32"
        label = "Pesistent"
        files = {
            "autoboot.txt"
        }
        file id.device {
            image = "persistent/id.device"
        }
    }

    size = 64M
}
...
```

首先，openwrt 最开始确实是一个基于 buildroot 构建的 os，但后来 openwrt 为自身整套可自编译的源码做了大量修改，所以使用方式以及与 buildroot 相差较大。在对应的划定分区及系统也有较大差异，这是在 openwrt 上的示例，文件格式：gen_rpi_sdcard_img.sh

```shell
...
set $(\
    ptgen -o $OUTPUT -h $head -s $sect -l 4096 \
        -t c -p ${BOOTFSSIZE}M \
        -t 83 -p ${ROOTFSSIZE}M
)
...
dd bs=512 if="$BOOTFS" of="$OUTPUT" seek="$BOOTOFFSET" conv=notrunc
dd bs=512 if="$ROOTFS" of="$OUTPUT" seek="$ROOTFSOFFSET" conv=notrunc
```

$ ./ptgen -o /tmp/test.img -h 4 -s 63 -l 1024 -t c -p 5M -t 83 -p 32M

由于MBR分区只支持4个主分区，无法满足persistent, boota, bootb, roota, rootb五个分区的要求，在查看 ptgen.c 源码后，可采用 GPT分区来完成支持。

MBR分区与GPT分区的差异：

- MBR - 1983年诞生，小型磁盘的完美选择，最多只能有4个主分区，想拥有4个以上的分区，需要创建3个主分区和一个可以进一步细分为逻辑分区的扩展分区。最大硬盘容量限制为2TB。

- GPT - 2006年诞生，没有上述限制，可支持128个主分区和无限数量的逻辑分区。最大硬盘容量限制为18EB

**实际验证**

通过对 OpenWrt 中的 target/linux/bcm27xx/image/gen_rpi_sdcard_img.sh 脚本及 Makefile 进行修改，可做到如下：

1. 在 MBR 分区模式下自由创建分区的能力，但数量上限仅支持4个分区，这一点是因为OpenWrt中的 ptgen.c 不支持 MBR 扩展分区（逻辑分区）的功能，所以无法满足我们进行 A/B分区OTA  的基础验证。

2. 在 GPT 分区模式``下自由创建任意数量分区的能力，可支持树莓派正常启动，但无法通过指定分区进行启动，在通过磁盘工具（fdisk/gdisk/sfdisk/Ubuntu硬盘工具等）检查后，其GPT分区的结构表也存在非法故障需修复。

思考：

1. 全志TinaOS分区采用的自家的工具，一是方便快捷，二是最终生成的镜像是TinaOS镜像不是OpenWrt的镜像，所以不受到`镜像校验`等功能的干扰。

2. 参考物，树莓派 Android by emteria 的镜像是采用的 GPT 分区模式，但类似第1点中最终生成的镜像是修改后的AndroidOS镜像而不是OpenWrt的镜像，所以不受到`镜像校验`等功能的干扰。

如何应对：

1. 优先学习 GPT 分区，修复 ptgen.c 中可能的故障。

2. 增加支持 MBR 扩展分区的功能。

### 其他：soc核间通信—MailBox

mailbox是多核soc上，核与核之间互相发中断的机制。由于核与核之间可能存在不同的业务，传统硬件上设计分配的有限数量的中断无法满足业务需求，导致软件拓展困难，所以可将mailbox视为可通过软件自定义的中断模块。

举例：OMAP1510 SoC 上的 ARM(MPU) 和 DSP 间的通信

soc为每个核分配两个mailbox中断，arm2dsp1/arm2dsp2、dsp2arm1/dsp2arm2，每个中断可以有16bit自定义，故单核有32个自定义。

arm2dsp1和arm2dsp2中断在dsp中分别注册成INT5和INT19，dsp2arm1和dsp2arm2中断分别映射到MPU level1中断的IRQ10和IRQ11。

被中断的处理器必须通过读取中断寄存器来确认中断，读取后中断被复位，中断