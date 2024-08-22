export TARGET_INSTALL_PREFIX=`mktemp -d /tmp/busybox.XXXXXX`
echo $TARGET_INSTALL_PREFIX
cd $TARGET_INSTALL_PREFIX
git clone https://github.com/mirror/busybox.git -b 1_36_0 --depth 1

# NDK编译
# 参考: https://developer.android.com/ndk/guides/other_build_systems?hl=zh-cn
# 最低组合
# export NDK=$HOME/Android/Sdk/ndk/22.1.7171670
# export API=21
# 最高组合
export NDK=$HOME/Android/Sdk/ndk/26.3.11579264
export API=34

export PATH="$NDK/toolchain/bin:$PATH"
export SYSROOT=$NDK/toolchain/sysroot

cd busybox
make distclean
make clean
git checkout .

# 1.修改基础配置
sed -i 's/arm-linux-androideabi-/x86_64-linux-android-/g' configs/android2_defconfig
sed -i 's/# CONFIG_USE_BB_CRYPT is not set/CONFIG_USE_BB_CRYPT=y/g' configs/android2_defconfig
sed -i 's/# CONFIG_USE_BB_CRYPT_SHA is not set/CONFIG_USE_BB_CRYPT_SHA=y/g' configs/android2_defconfig
sed -i 's/# CONFIG_FEATURE_TAR_LONG_OPTIONS is not set/CONFIG_FEATURE_TAR_LONG_OPTIONS=y/g' configs/android2_defconfig
sed -i 's/# CONFIG_FEATURE_TAR_TO_COMMAND is not set/CONFIG_FEATURE_TAR_TO_COMMAND=y/g' configs/android2_defconfig
TARGET_INSTALL_PATH=$(echo "$TARGET_INSTALL_PREFIX" | sed 's/\//\\\//g')
sed -i "s/.\/_install/$TARGET_INSTALL_PATH/g" configs/android2_defconfig
echo "CONFIG_SYSROOT=\"$SYSROOT\"" >> configs/android2_defconfig

git diff configs/android2_defconfig

2.替换ar和nm工具
sed -i 's/$(CROSS_COMPILE)ar/llvm-ar/g' Makefile
sed -i 's/$(CROSS_COMPILE)strip/llvm-strip/g' Makefile

# 3.添加头文件
sed -i '78i #include <sys\/swap.h>' util-linux/swaponoff.c

make android2_defconfig
make -j${nproc}
make install
