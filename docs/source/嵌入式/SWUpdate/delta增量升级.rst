Δdelta增量升级
===========================================================

Δ - delta - incremental

为什么使用增量升级：

* 升级包体积在不断增长
* 带宽受限（GSM...弱网...）
* 设备端/服务端的流量开销

SWUpdate中使用增量升级的方式：

* 分离OS和应用
* 应用更新极小
* 持久化？？
* 差分升级基于 librsync

分离OS和应用：

::

    appimage :(
        {
            filename = "myapp.tgz";
            type = "archive";
            device = "dev to be used";
            path = "/";
            filesystem = "ext4";
            sha256 =<computed hash>;
        }
    );

使用 librsync handler：

* 构建期间就准备好差分包
* 用于每个源版本的差分包：

::

    images: (
    {
        type = "rdiff_image";
        filename = "image.rdiff.delta";
        device = "/dev/mmcblk0p2";
        properties: {
            rdiffbase = ["/dev/mmcblk0p1"];
        };
    });

特征：

* 使用 rdiff handler 来处理增量升级
* 增量包预构建
* 不适合从任何发行版A到任何发行版B的升级
* Δ + SRC → DST(device) == DST(Build)

Δ增量对于服务器来说：

* 持有所有版本（老、新）
* 生成大量Δ文件
* 仅根据设备发送的信息进行检查
* 低CPU负载
* Δ更新流程迅速

Δ增量对于设备终端来说：

* 服务器持有一个版本
* Δ可从任何X到任何Y
* 加密检查
* 高CPU负载
* Δ更新流程慢

构建Δ增量包的开源方案：

* X-delta
  * 生成的镜像位于内存中
  * 不适用于嵌入式
  * Δ特定于每个版本（类似于librsync）
* Librsync（正在用）
* casync


对 rootfs.ext4 ---------zck tool-----------> rootfs.ext4.zck

rootfs.ext4.zck --------> extract header -------> header --------> build swu(new sw)

rootfs.ext4.zck -----uploaded---> server

::

    images: (
        {
            filename = "myimage.rootfs.ext4.zck.header";
            type = "delta";
            device = "/dev/mmcblk0p2";
            properties: { // The destination
                url = "https://examples.com/my.rootfs.ext4.zck";
                chain = "raw";
                source = "/dev/mmcblk0p1";
                zckloglevel = "error";
                debug-chunks = "true";
            };
        }
    )

原理分析：

mmcblk0p1 借助 zchunk lib 可以


rdiff跟delta的区别
---------------------------------------------------------------------------------

rdiff不支持原地更新，也就是说需要有一个足够的剩余空间用于存储rdiff差分还原后的完整镜像。

同时rdiff不会去校验原文件，如果差分包应用在一个错误文件之上，则会生成一个无效的输出文件。但没有报错。

所以，基于rdiff的差分升级的优势在节约传输的数据量，而节约不了ram和rom的占用。

实际测试过程中，还存在如下问题：


1. 对A Rootfs做基于B rootfs的差分更新，更新完成启动之后，丢失了大量inode，/boot 挂载也不可见

    ::

        EXT4-fs error(device mmcblk0p7): ext4_lookup:1857: inode #2: comm mkdir: deleted inode referenced: 2075
        EXT4-fs error(device mmcblk0p7): ext4_lookup:1857: inode #2: comm mount: deleted inode referenced: 2075
        EXT4-fs error(device mmcblk0p7): ext4_lookup:1857: inode #2: comm sh: deleted inode referenced: 2075
        EXT4-fs error(device mmcblk0p7): ext4_lookup:1857: inode #73: comm sh: deleted inode referenced: 2082
        EXT4-fs error(device mmcblk0p7): ext4_lookup:1857: inode #73: comm find: deleted inode referenced: 2080
        ...

2. rdiff差分基于本分区、目标分区、差分文件的三者计算比较而来，逐扇区进行，速度较慢

其他
---------------------------------------------------------------------------------
                                                                           

swupdate 在不久前已經實作了一個新的 delta handler 來處理delta update的功能，
他是透過使用zchunk 來實做做這個功能的。原有的rdiff handler 也還保留支援，透過zchunk 的支援，
他除了本來的hawkbit server 外，還要另外再開一個http server 並且要支援 byte range header, 
這個原因是swupdate 它本身的 swu 本身只包含 zchunk header，然後把對應的 zchunk file 放在 
https server 上面，透過 swu 內的設定讓zchunk 知道要去哪裡抓這個 zchunk 檔案，使用上需要注意
一些事情，因為swupdate 目前只支持sha256 所以，zchunk 本身使用的時候也要指定使用sha256。

ref.

https://sbabic.github.io/swupdate/delta-update.html
https://sbabic.github.io/swupdate/handlers.html#delta-update-handler
https://github.com/madisongh/tegra-test-distro/wiki/swupdate-integration-notes
https://github.com/zchunk/zchunk
https://github.com/zchunk/zchunk/blob/main/zchunk_format.txt
