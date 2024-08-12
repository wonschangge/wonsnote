capacitor源码总结
==========================

通信桥交互
--------------------

js往java发消息:

native-bridge.js:::postToNative、androidBridge.postMessage

androidBridge.postMessage 是 MessageHandler 往 webView 里添加的接口(addJavascriptInterface)

MessageHandler.java:::MessageHandler postMessage、callPluginMethod

callPluginMethod会使用到PluginCall，并通过responseMessage反馈最终结果。

responseMessage通过 webView.post、webView.evaluateJavascript(runScript, null); 的方式 eval 调用 webview 中的全局对象下的方法，

来传递处理后的数据。

所以JsBridge的速率：

* js->java: 就在于测试 addJavascriptInterface 定义的方法接口的速度。
* java->js: 就在于测试 evaluateJavascript 执行的速度。

测试该接口的速度，也可以称为压力测试。


## Bridge LifeCycle

- onStart
- onPause
- onResume
- onStop
- onDetachedWindow
- onDestroy
- onRestart

---

## MainFlow

1. BridgeActivity 继承自 AppCompatActivity，

AppCompatActivity 的生命周期方法：

CREATED --- STARTED --- RESUMED

对应到 BridgeActivity 内的生命周期

1.1 onCreate

a. 设置 Bridge.Builder 实例的状态
b. 设置 Theme、ContentView 等安卓内容
c. 实例化 PluginManager
d. 往 Bridge.Builder 中添加 PluginManager 加载的插件类
e. 往 Bridge.Builder 中添加 initialPlugins 并创建 Bridge 的实例
f. 写 keepRunning 的状态
g. 嵌套调用使 Bridge 响应 Intent

1.2 onStart

a. activityDepth 计数自增长
b. 手动触发 Bridge 的 onStart

#### Bridge

Bridge.Builder 用于构建 Bridge

#### PluginManager 插件管理器模块

`+ loadPluginClasses(): List<Class<Plugin>>` 工作步骤：

1. 解析 capacitor.plugins.json 为 pluginsJSON 数组
2. 逐 pluginsJSON 获取 classpath 字面量，提取 Class
3. 填充 List<Class<Plugin>> 结构并返还

#### CapConfig Cap配置

CapConfig 用于表示 Capacitor 的配置选项。

其中有一个子类：CapConfig.Builder，用于构建 Capacitor 配置

## Cordova生态兼容

Cordova插件和Capacitor插件的形态有差别，体现在以下几个方面：

- Cordova插件使用JS、CommonJS方式书写
- Capacitor插件使用TS、ESModule方式书写

包: com.getcapcitor.cordova

CapacitorCordovaCookieManager