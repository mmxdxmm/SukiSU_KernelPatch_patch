#!/bin/bash
set -e

HOME=/root/other
TOOLS=/root/other/tools
PATCH=/root/other/patch
# 构建 Android 版本
cd $TOOLS
rm -rf build/android
mkdir -p build/android
cd build/android
# 请替换以下变量为实际 NDK 路径或通过环境变量传递
cmake \
  -DCMAKE_TOOLCHAIN_FILE="$NDK_HOME/build/cmake/android.toolchain.cmake" \
  -DCMAKE_BUILD_TYPE=Release \
  -DANDROID_PLATFORM=android-33 \
  -DANDROID_ABI=arm64-v8a ../..
cmake --build .
mv kptools kptools-android

# 构建 Linux 版本
cd $TOOLS
cd build
cmake ..
make
mv kptools kptools-linux

cd $HOME

export ANDROID_NDK=/root/other/ndk/android-ndk-r28

cp -r $TOOLS/build/android/kptools-android $PATCH/res
cp -r $TOOLS/build/kptools-linux $PATCH/res

cd $PATCH

xxd -i res/kpimg.enc > include/kpimg_enc.h
xxd -i res/kptools-linux > include/kptools_linux.h
xxd -i res/kptools-android > include/kptools_android.h

# 创建构建目录
rm -rf build-android
mkdir -p build-android
cd build-android

# 生成编译配置
cmake .. \
    -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK}/build/cmake/android.toolchain.cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DANDROID_ABI=arm64-v8a \
    -DANDROID_PLATFORM=android-33 \
    -DANDROID_STL=c++_static

cmake --build .
cp -r patch_android $HOME

cd $PATCH
rm -rf build-linux
mkdir -p build-linux
cd build-linux
cmake .. && make
mv patch patch_linux
cp -r patch_linux $HOME