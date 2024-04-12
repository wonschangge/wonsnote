fdisk和gdisk和parted工具测试
=====================================

使用多种工具测试GPT分区(带hybrid MBR)

fdisk
-------------------------------------

$ sudo fdisk /dev/mmcblk0
欢迎使用 fdisk (util-linux 2.37.2)。
更改将停留在内存中，直到您决定将更改写入磁盘。
使用写入命令前请三思。

备份 GPT 表损坏，但主表似乎正常，将使用它。
The backup GPT table is not on the end of the device. This problem will be corrected by write.
This disk is currently in use - repartitioning is probably a bad idea.
It's recommended to umount all file systems, and swapoff all swap
partitions on this disk.

检测到混合 GPT。您需要手动同步混合 MBR (用专家命令“M”)

命令(输入 m 获取帮助)： p

Disk /dev/mmcblk0：29.72 GiB，31914983424 字节，62333952 个扇区
单元：扇区 / 1 * 512 = 512 字节
扇区大小(逻辑/物理)：512 字节 / 512 字节
I/O 大小(最小/最佳)：512 字节 / 512 字节
磁盘标签类型：gpt
磁盘标识符：5452574F-2211-4433-5566-778899AABB00

设备             起点    末尾   扇区  大小 类型
/dev/mmcblk0p1     34  131105 131072   64M Microsoft 基本数据
/dev/mmcblk0p2 131106  262177 131072   64M Microsoft 基本数据
/dev/mmcblk0p3 262178  393249 131072   64M Microsoft 基本数据
/dev/mmcblk0p4 393250  606241 212992  104M Linux 文件系统
/dev/mmcblk0p5 606242  819233 212992  104M Linux 文件系统
/dev/mmcblk0p6 819234 1032225 212992  104M Linux 文件系统

命令(输入 m 获取帮助)： M
进入 保护/混合 MBR 磁盘标签。

命令(输入 m 获取帮助)： p
Disk /dev/mmcblk0：29.72 GiB，31914983424 字节，62333952 个扇区
单元：扇区 / 1 * 512 = 512 字节
扇区大小(逻辑/物理)：512 字节 / 512 字节
I/O 大小(最小/最佳)：512 字节 / 512 字节
磁盘标签类型：dos
磁盘标识符：0x5452574f

设备           启动   起点   末尾   扇区  大小 Id 类型
/dev/mmcblk0p1          34 131105 131072   64M  c W95 FAT32 (LBA)
/dev/mmcblk0p2      131106 262177 131072   64M  c W95 FAT32 (LBA)
/dev/mmcblk0p3      262178 393249 131072   64M  c W95 FAT32 (LBA)
/dev/mmcblk0p4           1     33     33 16.5K ee GPT

分区表记录没有按磁盘顺序。

命令(输入 m 获取帮助)： q

parted
-------------------------------------

$ sudo parted /dev/mmcblk0
GNU Parted 3.4
使用 /dev/mmcblk0
欢迎使用 GNU Parted！输入 'help' 来查看命令列表。
(parted) p                                                                
错误: 备份 GPT 表损坏，但主表似乎是正确的，所以使用备份。
确认/OK/放弃/Cancel? ok
警告: 并非所有可用于 /dev/mmcblk0 的空间都被用到了，您可以修正 GPT 以使用所有的空间 (额外的 61301693 个区块)，还是说要继续使用目前的设置？ 
修正/Fix/忽略/Ignore? Ignore                                              
型号：SD SD32G (sd/mmc)
磁盘 /dev/mmcblk0: 31.9GB
扇区大小 (逻辑/物理)：512B/512B
分区表：gpt
磁盘标志：

编号  起始点  结束点  大小    文件系统  名称   标志
 1    17.4kB  67.1MB  67.1MB  fat16     boota  旧版启动, msftdata
 2    67.1MB  134MB   67.1MB  fat16     bootb  旧版启动, msftdata
 3    134MB   201MB   67.1MB  fat16     bootc  旧版启动, msftdata
 4    201MB   310MB   109MB   ext2      roota
 5    310MB   419MB   109MB   ext2      rootb
 6    419MB   528MB   109MB   ext2      rootc

(parted) q                                                                

gdisk
-------------------------------------

$ sudo gdisk /dev/mmcblk0
GPT fdisk (gdisk) version 1.0.8

Caution: invalid backup GPT header, but valid main header; regenerating
backup header from main header.

Warning! Main and backup partition tables differ! Use the 'c' and 'e' options
on the recovery & transformation menu to examine the two tables.

Warning! One or more CRCs don't match. You should repair the disk!
Main header: OK
Backup header: ERROR
Main partition table: OK
Backup partition table: ERROR

Partition table scan:
  MBR: hybrid
  BSD: not present
  APM: not present
  GPT: damaged

Found valid MBR and corrupt GPT. Which do you want to use? (Using the
GPT MAY permit recovery of GPT data.)
 1 - MBR
 2 - GPT
 3 - Create blank GPT

Your answer: 1

Command (? for help): p
Disk /dev/mmcblk0: 62333952 sectors, 29.7 GiB
Sector size (logical/physical): 512/512 bytes
Disk identifier (GUID): EBAFE14B-633B-49C0-A0C2-B5792A6C5A70
Partition table holds up to 128 entries
Main partition table begins at sector 2 and ends at sector 33
First usable sector is 34, last usable sector is 62333918
Partitions will be aligned on 2-sector boundaries
Total free space is 61940669 sectors (29.5 GiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1              34          131105   64.0 MiB    0700  Microsoft basic data
   2          131106          262177   64.0 MiB    0700  Microsoft basic data
   3          262178          393249   64.0 MiB    0700  Microsoft basic data

Command (? for help): q 
wons@t14:~/WORK_DIR/0important/embedded/raspberry/rpi-imager$ sudo gdisk /dev/mmcblk0
GPT fdisk (gdisk) version 1.0.8

Caution: invalid backup GPT header, but valid main header; regenerating
backup header from main header.

Warning! Main and backup partition tables differ! Use the 'c' and 'e' options
on the recovery & transformation menu to examine the two tables.

Warning! One or more CRCs don't match. You should repair the disk!
Main header: OK
Backup header: ERROR
Main partition table: OK
Backup partition table: ERROR

Partition table scan:
  MBR: hybrid
  BSD: not present
  APM: not present
  GPT: damaged

Found valid MBR and corrupt GPT. Which do you want to use? (Using the
GPT MAY permit recovery of GPT data.)
 1 - MBR
 2 - GPT
 3 - Create blank GPT

Your answer: 2

Command (? for help): p
Disk /dev/mmcblk0: 62333952 sectors, 29.7 GiB
Sector size (logical/physical): 512/512 bytes
Disk identifier (GUID): 5452574F-2211-4433-5566-778899AABB00
Partition table holds up to 128 entries
Main partition table begins at sector 2 and ends at sector 33
First usable sector is 34, last usable sector is 1032225
Partitions will be aligned on 2-sector boundaries
Total free space is 0 sectors (0 bytes)

Number  Start (sector)    End (sector)  Size       Code  Name
   1              34          131105   64.0 MiB    0700  boota
   2          131106          262177   64.0 MiB    0700  bootb
   3          262178          393249   64.0 MiB    0700  bootc
   4          393250          606241   104.0 MiB   8300  roota
   5          606242          819233   104.0 MiB   8300  rootb
   6          819234         1032225   104.0 MiB   8300  rootc

Command (? for help): q
