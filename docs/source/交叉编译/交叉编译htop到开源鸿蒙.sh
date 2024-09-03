export TEMP_DIR=`mktemp -d /tmp/htop.XXXXXX`
cd $TEMP_DIR
git clone https://github.com/mirror/ncurses.git -b v6.4 --depth 1
git clone https://github.com/htop-dev/htop.git -b 3.3.0 --depth 1
export TARGET_INSTALL_PREFIX=$TARGET_INSTALL_PREFIX/dist
mkdir -p $TARGET_INSTALL_PREFIX

export SDK=$HOME/x-tools/arm-unknown-linux-musleabi
export PATH=$SDK/bin:$PATH
export CFLAGS=-I$SDK/include
export LDFLAGS=-L$SDK/lib
export SYSROOT=$SDK/arm-unknown-linux-musleabi/sysroot
export TARGET=x86_64-linux-android
export CC=arm-unknown-linux-musleabi-gcc
export CXX=arm-unknown-linux-musleabi-g++
export AR=arm-unknown-linux-musleabi-ar
export AS=arm-unknown-linux-musleabi-as
export LD=arm-unknown-linux-musleabi-ld
export RANLIB=arm-unknown-linux-musleabi-ranlib
export STRIP=arm-unknown-linux-musleabi-strip


# --with-shlib-version=rel 对应 realink, 有大版本号和小版本号
# --with-shlib-version=abi 对应 abi, 只有大版本号
# --without-shlib-version 还暂未实现，无法不带有大版本号
cd ncurses
make mostlyclean
make clean
make distclean
git checkout .
./configure \
    --prefix=$TARGET_INSTALL_PREFIX \
    --without-cxx \
    --without-cxx-binding \
    --without-database \
    --without-ada \
    --without-manpages \
    --without-progs \
    --without-tests \
    --with-shlib-version=abi \
    --host $TARGET \
    --with-shared
    # --with-abi-version=34 \
    # --disable-database \
make -j${nproc}
make install
cd -

cd htop
make mostlyclean
make clean
make distclean
git checkout .
./autogen.sh
./configure \
    --prefix=$TARGET_INSTALL_PREFIX \
    LDFLAGS=-L$TARGET_INSTALL_PREFIX/lib \
    CFLAGS=-I$TARGET_INSTALL_PREFIX/include \
    LIBS=-lncurses \
    --host=$TARGET \
    --disable-unicode
    # --enable-static
make -j${nproc}
make install
cd -


TARGET_LIB=`readelf -d $TARGET_INSTALL_PREFIX/bin/htop  | rg ncurses | awk '{print $5}' | sed 's/\[//g;s/\]//g'`
TARGET_DIR=/data/local/tmp
echo TARGET_LIB:${TARGET_LIB}
# adb push $TARGET_INSTALL_PREFIX/lib/$TARGET_LIB $TARGET_DIR
# adb push $TARGET_INSTALL_PREFIX/bin/htop $TARGET_DIR

# adb shell mkdir -p $TARGET_DIR/terminfo/s
# adb push $TARGET_INSTALL_PREFIX/share/terminfo/s/screen-256color /sdcard/terminfo/s # 体积小的256色 1.8KB
# echo run as:
# echo LD_LIBRARY_PATH=$TARGET_DIR TERMINFO=/sdcard/terminfo TERM=screen-256color $TARGET_DIR/htop

# adb shell mkdir -p $TARGET_DIR/terminfo/v
# adb push $TARGET_INSTALL_PREFIX/share/terminfo/v/vt100 /sdcard/terminfo/v # 适配度高 1.3KB
# echo run as:
# echo LD_LIBRARY_PATH=$TARGET_DIR TERMINFO=/sdcard/terminfo TERM=vt100 $TARGET_DIR/htop

# adb shell mkdir -p $TARGET_DIR/terminfo/x
# adb push $TARGET_INSTALL_PREFIX/share/terminfo/x/xterm-direct256 /sdcard/terminfo/x # 全面的256色 4KB
# echo run as:
# echo LD_LIBRARY_PATH=$TARGET_DIR TERMINFO=/sdcard/terminfo TERM=xterm-direct256 $TARGET_DIR/htop
