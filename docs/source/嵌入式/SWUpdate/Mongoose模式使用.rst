Mongoose模式使用
===========================================================

比较坑爹的是，Mongoose的文档十分不健全，许多功能的使用只能东拼西找。

成功从 Web 应用中刷入镜像，要注意以下内容：

1. 必须得设置 "机器名 机器硬件版本" 到 /etc/hwrevision 中
2. sw-description 中使用 机器名: { images:({}); files:({})... } 格式
3. 在 swupdate.cfg global 下设置的 pre、post 脚本也会被使用（TODO）