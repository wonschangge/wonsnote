OpenHarmony
============================

- 标准（128MB RAM）
- 小型（1MB RAM）
- 轻量（128KB RAM）

Docker编译
----------------------------

参考：https://gitee.com/openharmony/docs/blob/master/zh-cn/device-dev/get-code/gettools-acquire.md#%E6%90%AD%E5%BB%BAdocker%E7%8E%AF%E5%A2%83%E6%A0%87%E5%87%86%E7%B3%BB%E7%BB%9F

1. 从 https://repo.huaweicloud.com/harmonyos/os/ 下载系统整包源码
2. 拉取构建标准版容器， docker pull swr.cn-south-1.myhuaweicloud.com/openharmony-docker/docker_oh_standard:3.2
3. 挂载源码目录，docker run -it -v $(pwd):/home/openharmony swr.cn-south-1.myhuaweicloud.com/openharmony-docker/docker_oh_standard:3.2
4. 进入容器，docker run
5. 启动编译，./build.sh --product-name {product_name} --ccache


