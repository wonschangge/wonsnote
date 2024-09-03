export TARGET_INSTALL_PREFIX=`mktemp -d /tmp/busybox.XXXXXX`
echo $TARGET_INSTALL_PREFIX
cd $TARGET_INSTALL_PREFIX
git clone https://github.com/mirror/busybox.git -b 1_36_0 --depth 1

# 对于OpenHarmony,使用通用的cross-ng构建的arm-unknown-linux-musl即可
export SDK=$HOME/x-tools/arm-unknown-linux-musleabi
export PATH=$SDK/bin:$PATH
export CFLAGS=-I$SDK/include
export LDFLAGS=-L$SDK/lib
export SYSROOT=$SDK/arm-unknown-linux-musleabi/sysroot

cd busybox
# make clean
git checkout .

# 1.修改基础配置
sed -i 's/arm-linux-androideabi-/arm-unknown-linux-musleabi-/g' configs/android2_defconfig
sed -i 's/# CONFIG_USE_BB_CRYPT is not set/CONFIG_USE_BB_CRYPT=y/g' configs/android2_defconfig
sed -i 's/# CONFIG_USE_BB_CRYPT_SHA is not set/CONFIG_USE_BB_CRYPT_SHA=y/g' configs/android2_defconfig
sed -i 's/# CONFIG_FEATURE_TAR_LONG_OPTIONS is not set/CONFIG_FEATURE_TAR_LONG_OPTIONS=y/g' configs/android2_defconfig
sed -i 's/# CONFIG_FEATURE_TAR_TO_COMMAND is not set/CONFIG_FEATURE_TAR_TO_COMMAND=y/g' configs/android2_defconfig
TARGET_INSTALL_PATH=$(echo "$TARGET_INSTALL_PREFIX" | sed 's/\//\\\//g')
sed -i "s/.\/_install/$TARGET_INSTALL_PATH/g" configs/android2_defconfig
echo "CONFIG_SYSROOT=\"$SYSROOT\"" >> configs/android2_defconfig

# 2.注释一个导致编译错误的结构体，没有任何地方使用，放心注释
sed -i '334s/^/\/\/ /' include/libbb.h
sed -i '335s/^/\/\/ /' include/libbb.h
sed -i '336s/^/\/\/ /' include/libbb.h

# 3.添加头文件
sed -i '78i #include <sys\/swap.h>' util-linux/swaponoff.c

make android2_defconfig
make -j${nproc}
make install

# 在OH内使用 ftpget 获取
# 1.本机开vftpd服务,将busybox文件烤入ftp目录
# 2.在OH端, ftpget -u <USER> -P <PASSWORD> <HOST_IP> busybox
# 注意: 比较坑爹的是上面的 password 使用的是大写的P, 非常见的小写的p