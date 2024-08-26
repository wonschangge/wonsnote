export TARGET_INSTALL_PREFIX=`mktemp -d /tmp/ubus-dev.XXXXXX`
cd $TARGET_INSTALL_PREFIX
git clone --depth=1 https://github.com/json-c/json-c.git
git clone --depth=1 https://github.com/openwrt/libubox.git
git clone --depth=1 https://github.com/openwrt/ubus.git

# rm -rf build
# rm -rf dist
mkdir -p build/{json-c,libubox,ubus}
DIST_PATH=$PWD/dist
mkdir -p $DIST_PATH

cd build/json-c
cmake ../../json-c \
    -DCMAKE_SYSTEM_NAME=Android \
    -DCMAKE_SYSTEM_VERSION=34 \
    -DCMAKE_ANDROID_ARCH_ABI=x86_64 \
    -DCMAKE_ANDROID_NDK=${HOME}/Android/Sdk/ndk/26.3.11579264/ \
    -DCMAKE_INSTALL_PREFIX=$DIST_PATH
make -j${nproc}
make install
cd ../..

cd libubox
echo 'diff --git a/udebug.c b/udebug.c
index e39a32c..46b92d4 100644
--- a/udebug.c
+++ b/udebug.c
@@ -72,14 +72,17 @@ shm_open_anon(char *name)
 
 	for (int i = 0; i < 100; i++) {
 		__randname(template);
-		fd = shm_open(name, O_RDWR | O_CREAT | O_EXCL, 0600);
-		if (fd >= 0) {
-			if (shm_unlink(name) < 0) {
-				close(fd);
-				continue;
-			}
-			return fd;
-		}
+		// fd = shm_open(name, O_RDWR | O_CREAT | O_EXCL, 0600);
+		// if (fd >= 0) {
+		// 	if (shm_unlink(name) < 0) {
+		// 		close(fd);
+		// 		continue;
+		// 	}
+		// 	return fd;
+		// }
+		/* Android do not support shm_open/shm_unlink */
+		/* See also ~/Android/Sdk/ndk/26.3.11579264/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/android/sharedmem.h */
+		fd = 0;
 
 		if (fd < 0 && errno != EEXIST)
 			return -1;' | git apply
cd ..

cd build/libubox
cmake ../../libubox \
    -DCMAKE_SYSTEM_NAME=Android \
    -DCMAKE_SYSTEM_VERSION=34 \
    -DCMAKE_ANDROID_ARCH_ABI=x86_64 \
    -DCMAKE_ANDROID_NDK=${HOME}/Android/Sdk/ndk/26.3.11579264/ \
    -DCMAKE_INSTALL_PREFIX=$DIST_PATH \
    -DCMAKE_FIND_ROOT_PATH=$DIST_PATH \
    -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
    -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
    -Djson=$DIST_PATH/lib/libjson-c.so \
    -DBUILD_LUA=OFF \
    -DBUILD_EXAMPLES=ON
make -j${nproc}
make install
cd ../..

cd ubus
echo 'diff --git a/CMakeLists.txt b/CMakeLists.txt
index 8ae853b..ad9f4a6 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -13,7 +13,9 @@ OPTION(BUILD_LUA "build Lua plugin" ON)
 OPTION(BUILD_EXAMPLES "build examples" ON)
 
 SET(CMAKE_SHARED_LIBRARY_LINK_C_FLAGS "")
-SET(UBUS_UNIX_SOCKET "/var/run/ubus/ubus.sock")
+# SET(UBUS_UNIX_SOCKET "/var/run/ubus/ubus.sock")
+# SET(UBUS_UNIX_SOCKET "/var/run/ubus.sock") #linux
+SET(UBUS_UNIX_SOCKET "/data/local/tmp/ubus-dev/ubus.sock") #android
 SET(UBUS_MAX_MSGLEN 1048576)
 
 ADD_DEFINITIONS( -DUBUS_UNIX_SOCKET="${UBUS_UNIX_SOCKET}")
diff --git a/examples/CMakeLists.txt b/examples/CMakeLists.txt
index 81f9997..ddda050 100644
--- a/examples/CMakeLists.txt
+++ b/examples/CMakeLists.txt
@@ -9,4 +9,12 @@ IF (BUILD_EXAMPLES)
 
 	ADD_EXECUTABLE(client client.c count.c)
 	TARGET_LINK_LIBRARIES(client ubus ${ubox_library})
+
+	INSTALL(TARGETS server
+		RUNTIME DESTINATION sbin
+	)
+
+	INSTALL(TARGETS client
+		RUNTIME DESTINATION sbin
+	)
 ENDIF()' | git apply
cd ..

cd build/ubus
cmake ../../ubus \
    --log-level=VERBOSE \
    -DCMAKE_C_FLAGS=-I$DIST_PATH/include \
    -DCMAKE_SYSTEM_NAME=Android \
    -DCMAKE_SYSTEM_VERSION=34 \
    -DCMAKE_ANDROID_ARCH_ABI=x86_64 \
    -DCMAKE_ANDROID_NDK=${HOME}/Android/Sdk/ndk/26.3.11579264/ \
    -DCMAKE_INSTALL_PREFIX=$DIST_PATH \
    -DCMAKE_FIND_ROOT_PATH=$DIST_PATH \
    -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
    -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
    -Djson=$DIST_PATH/lib/libjson-c.so \
    -Dblob_library=$DIST_PATH/lib/libblobmsg_json.so \
    -Dubox_library=$DIST_PATH/lib/libubox.so \
    -Dubox_include_dir=$DIST_PATH/include/libubox \
    -DBUILD_LUA=OFF \
    -DBUILD_EXAMPLES=ON
make -j${nproc}
make install

# TARGET_DIR=/data/local/tmp/ubus-dev
# adb push dist/bin/ubus dist/sbin/{client,server,ubusd} dist/lib/{libjson-c.so,libubus.so,libblobmsg_json.so,libubox.so} $TARGET_DIR
# adb shell LD_LIBRARY_PATH=$TARGET_DIR $TARGET_DIR/ubusd &
# adb shell LD_LIBRARY_PATH=$TARGET_DIR $TARGET_DIR/server &
# adb shell LD_LIBRARY_PATH=$TARGET_DIR $TARGET_DIR/client
# adb shell LD_LIBRARY_PATH=$TARGET_DIR $TARGET_DIR/ubus monitor
