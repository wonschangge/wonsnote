Suricatta支持通用HTTP服务器方案
===========================================================

Suricatta可支持Hawkbit后端、wfx后端，还可支持非常简单的后端——通用的HTTP服务器。

使用标准HTTP响应代码来表示是否有更新可用。

示例：一个简单的（模拟）服务器实现在 [SWUpdate源码]/examples/suricatta/server_general.py。

该API由带查询参数的GET组成，用于通知服务器已安装的版本，其查询字符串的格式如下：

::

    http(s)://<base URL>?param1=val1&param=value2...

作为参数的示例，设备可以发送其序列号、MAC地址和软件的运行版本。

后端负责解释这些内容，SWUpdate只需从配置文件的“identify”部分获取它们并对URL进行编码即可。

服务器使用以下返回代码进行应答：

.. csv-table:: 通用HTTP服务器应答表
   :file: res/通用HTTP服务器应答表.csv
   :widths: 25 25 25
   :header-rows: 1

服务器的应答可以包含以下标头：

.. csv-table:: 通用HTTP服务器应答标头表.csv
   :file: res/通用HTTP服务器应答表.csv
   :widths: 25 25 25
   :header-rows: 1

设备可以将日志数据发送到服务器，任何信息都可以通过HTTP PUT请求传输，数据作为消息正文中的纯字符串。Header的Content-Type需设置为text/plain。

日志记录的URL可在配置文件中设置为单独的URL，也可通过 -logurl 命令行参数设置：

设备以CSV格式（逗号分隔值）发送数据。

格式可在配置文件中指定，可为每个事件设置一个格式，支持的时间有：

.. list-table:: 支持的事件
    :widths: 15 15
    :header-rows: 1

    * - 事件
      - 描述
    * - 查看
      - 虚拟的，可在每次轮询服务器时发送一个事件
    * - 开始
      - 发现新软件，SWUpdate开始安装
    * - 成功
      - 新软件已成功安装
    * - 失败
      - 安装新软件失败

通用服务器在配置文件中有自己的部分，如：

::

    gservice =
    {
        url = ....;
        logurl = ....;
        logevent: (
            {event="check";format="#2,date,fw,hw,sp"},
            {event="started";format="#12,date,fw,hw,sp"},
            {event="success";format="#13,date,fw,hw,sp"},
            {event="fail";format="#14,date,fw,hw,sp"}
        )
    }

date是一个特殊字段，它在RFC 2822中被解释为本地时间。在配置文件的标帜部分中查找每个逗号分隔的字段，如果找到匹配项，则进行替换。如果没有匹配项，则按原样发送该字段。

例如，如果标识部分具有以下值：

::

    identify : (
        { name = "sp"; value = "333"; },
        { name = "hw"; value = "ipse";1 },
        { name = "fw"; value = "1.0"; }
    );

按照上述设置事件后，”成功”情况写的格式化文本将为“

::

    Formatted log: #13,Mon, 17 Sep 2018 10:55:18 CEST,1.0,ipse,333