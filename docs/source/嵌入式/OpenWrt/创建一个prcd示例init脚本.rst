创建一个prcd示例init脚本
===============================

procd init脚本可带来类似restart策略、读写UCI配置的能力。

1. 起步
----------

创建一个简单脚本 myscript.sh：

::

    #!/bin/sh
 
    #these if statements will check input and place default values if no input is given
    #they will also check if input is a number so you can call 
    #this script with just a time and it will still work correctly
    
    if [ "$1" = '' ]; then
        name="You"
    else
        if echo "$1" | egrep -q '^[0-9]+$'; then
            name="You"
        else
            name="$1"
        fi
    fi
    
    if [ "$2" = '' ]; then
        every="5"
    else
        every="$2"
    fi
    
    if echo "$1" | egrep -q '^[0-9]+$'; then
        every="$1"
    fi
    
    #endless loop, will print the message every X seconds as indicated in the $every variable
    
    while [ 1 ]; do 
        echo "Hey, $name, it's time to get up"
        sleep $every
    done
    
    exit 0

将其放在 /var/myscript.sh 并运行。

::

    $ /bin/sh /var/myscript.sh "Name Surname"

2. 创建一个基础procd脚本
-------------------------

第1步有了一个可工作的脚本，现在可以创建一个服务来使用它。

在 /etc/init.d/myservice 中创建一个最小化服务脚本：

::

    #!/bin/sh /etc/rc.common
    USE_PROCD=1
    START=95
    STOP=01
    start_service() {
        procd_open_instance
        procd_set_param command /bin/sh "/var/myscript.sh"
        procd_close_instance
    }

首先， 要包含写服务所通用的 "run commands" 文件 /etc/rc.common。

它里面定义了少数几个函数用于管理服务的生命周期。

默认支持老版的procd脚本格式，USE_PROCD用于指示使用新版脚本格式。

START和STOP告诉系统服务该何时起和关，它的值的设定与依赖和被依赖有关。

3. 启用服务
-------------------------

启用： /etc/init.d/myservice enable

它将自动装一个符号连接在 /etc/rc.d 中，名字叫 S95myservice，和START=95相关联。

OpenWrt将启动/etc/rc.d/下以S*打头的脚本。

可以通过 logread -f 来观察日志。

启动： /etc/init.d/myservice start

当前，仍无日志，缺少了重定向标准输出的步骤，往 procd 脚本中增加：

::

    #!/bin/sh /etc/rc.common
    USE_PROCD=1
    START=95
    STOP=01
    start_service() {
        procd_open_instance
        procd_set_param command /bin/sh "/var/myscript.sh"
        procd_set_param stdout 1
        procd_set_param stderr 1
        procd_close_instance
    }

可见 log:

::

    $ logread -f
    ... ommitted ... Hey, You, it's time to get up
    ... ommitted ... Hey, You, it's time to get up
    ... ommitted ... Hey, You, it's time to get up
    ... ommitted ... Hey, You, it's time to get up
    ... ommitted ... Hey, You, it's time to get up
    ... ommitted ... Hey, You, it's time to get up
    ...

4. 服务配置
-------------------------
   
对上UCI配置接口，创建一个 /etc/config/myservice 的配置文件：

::

    config myservice 'hello'
        option name 'Joost'
        option every '5'

UCI将自动配置成如下内容：

::

    $ uci show myservice
    myservice.hello=myservice
    myservice.hello.name=Joost
    myservice.hello.every='5'

亦可通过 uci 获取单个选项:

::
    
    uci get myservice.hello.name

亦可通过 uci 设置单个选项:

::
    
    uci set myservice.hello.name=Knight
    uci commit

5. 在procd脚本中加载服务配置

::

    #!/bin/sh /etc/rc.common
    USE_PROCD=1
    START=95
    STOP=01

    CONFIGURATION=myservice

    start_service() {
        #读配置
        config_load "${CONFIGURATION}"
        local name
        local every

        config_get name hello name
        config_get every hello every

        procd_open_instance
        #将配置传递给启动脚本
        procd_set_param command /bin/sh "/var/myscript.sh" "$name" "$every"
        procd_set_param file /etc/config/myservice
        procd_set_param stdout 1
        procd_set_param stderr 1
        procd_close_instance
    }

重其服务以应用配置：

::

    /etc/init.d/myservice reload

6. 其他的高级选项

respawn功能，发生意外断开时以重启

::

    procd_set_param respawn \
        ${respawn_threshold:-3600} \
        ${respawn_timeout:-5} ${respawn_retry:-5}

pidfile，储存pid

::

    procd_set_param pidfile $PIDFILE

env vars，传递环境变量到进程中

::

    procd_set_param env A_VAR=avalue


ulimit，进程资源限制

::

    procd_set_param limits core="unlimited"

https://openwrt.org/docs/guide-developer/procd-init-script-example
https://openwrt.org/docs/guide-developer/procd-init-scripts