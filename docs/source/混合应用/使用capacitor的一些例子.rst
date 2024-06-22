使用capacitor的一些例子
===========================================

创建 capacitor 示例应用（最小化、无JS框架）：

::

    npx @capacitor/create-app


进入该应用，通过以下步骤将其编为安卓应用：


::

    npm install @capacitor/android
    npx cap add android
    npm run build
    npx cap sync
    npx cap open android



