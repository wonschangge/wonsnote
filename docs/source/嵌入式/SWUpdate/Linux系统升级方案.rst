Linux系统升级方案
===========================================================

常见的两种模式：

- Recovery模式，需要一个单独的Recovery分区来配合升级操作。

- Linux A/B模式，需要在flash上占用两套固件，互相交替升级。

Recovery模式
-----------------------------------------------------------

Recovery模式多出的Recovery分区，内容由kernel+resource+ramdisk组成。U-Boot根据misc分区存放的字段来判断将要引导的系统是 Normal/Recovery。

优点：

差分升级（增量升级）
-----------------------------------------------------------

通过对新、旧OTA固件（update.img）解包、差分、打包，制作补丁包。![](/home/wons/Documents/RFC/差分升级.svg)![差分升级.svg](/home/wons/Documents/RFC/差分升级.svg)![](https://docs.google.com/drawings/d/e/2PACX-1vSh-_tWflBpJs3fwCMaJZD52nRfcNd8wZZNNumWXcCBmpULRE9nzQg1At_c1XCjM_UFB09srWSkm44x/pub?w=960&h=720)

制作差分升级包的注意事项：

- 产生的差分固件为新的update.img，仅为OTA使用到的部分，仅包含需要升级的分区

- 旧的固件建议使用包含所有分区的update.img，至少应包含需要进行差分的分区

- 旧的固件务必要与目标机器上的固件相同

- 对于link文件，需考虑在新的版本中是否指向其他文件了，需特别处理

- 实际的差分升级过程还会有升级前的check sum验证等
