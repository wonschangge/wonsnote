I-Cache和D-Cache
=====================

I-Cache 代表 Instructions-Cache。

D-Cache 代表 Data-Cache。

I-Cache是CPU Core取指的首选位置，它相比主存获取（当缓存未命中时会发生）要快100倍。
常用指令不会出现在主存中，而是位于I-Cache中，目的是让CPU Core更快访指。
如果指令在I-Cache中丢失，则发生缓存未命中，之后会从主存检索指令并放入I-Cache供后续使用。

D-Cache是主存中高频请求的数据的缓存，CPU Core使用它读写数据，通过更快地访问常用数据来减少访存延迟。

I-Cahce和D-Cache的主要区别就是各自的用途和存储的数据类型。

以下是典型的3级流水线设计:

.. image:: res/boh_fig1.17.png
