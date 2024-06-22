嵌入式
====================

分区表和文件系统的关系
-------------------------

分区表一般由磁盘分区工具（MBR-fdisk, GPT-gdisk, parted...）创建，它将物理磁盘划分为多个逻辑部分。

文件系统是在每个分区上创建的逻辑结构，用于组织和管理文件和目录。

分区表提供了逻辑隔离、独立管理的功能。

文件系统负责管理文件的存储和访问。

.. toctree::
    
    OpenWrt/index.rst
    硬盘分区/index.rst
    U-Boot/index.rst
    微型Linux/index.rst
    总线/index.rst
    树莓派/index.rst
    嵌入式Linux通识学习