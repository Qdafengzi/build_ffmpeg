#!/bin/bash
make clean
#配置NDK和TOOLCHAIN路径
export NDK=/Users/qfinn/Library/Android/sdk/ndk/25.1.8937393
TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/darwin-x86_64
AR=$TOOLCHAIN/bin/llvm-ar
NM=$TOOLCHAIN/bin/llvm-nm
RANLIB=$TOOLCHAIN/bin/llvm-ranlib
STRIP=$TOOLCHAIN/bin/llvm-strip


# 检查NDK路径是否存在
if [ ! -d "$NDK" ]; then
    echo "NDK路径不存在: $NDK"
    exit 1
fi


# 检查工具链路径是否存在
if [ ! -d "$TOOLCHAIN" ]; then
    echo "工具链路径不存在: $TOOLCHAIN"
    exit 1
fi

#arm64-v8a 参数配置
# ARCH=arm64
# CPU=armv8-a
# API=28
# CC=$TOOLCHAIN/bin/aarch64-linux-android$API-clang
# CXX=$TOOLCHAIN/bin/aarch64-linux-android$API-clang++
# SYSROOT=$NDK/toolchains/llvm/prebuilt/darwin-x86_64/sysroot
# CROSS_PREFIX=$TOOLCHAIN/bin/aarch64-linux-android-
# PREFIX=$(pwd)/android/$CPU
# OPTIMIZE_CFLAGS="-march=$CPU"


#armeabi-v7a
ARCH=arm
CPU=armv7-a
API=28
CC="$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang"
CXX=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang++
SYSROOT=$NDK/toolchains/llvm/prebuilt/darwin-x86_64/sysroot
CROSS_PREFIX=$TOOLCHAIN/bin/armv7a-linux-androideabi-
PREFIX=$(pwd)/android/$CPU
OPTIMIZE_CFLAGS="-march=$CPU"


# 检查编译工具是否存在
if [ ! -x "$CC" ]; then
    echo "C编译器不存在或不可执行: $CC"
    exit 1
fi

if [ ! -x "$CXX" ]; then
    echo "C++编译器不存在或不可执行: $CXX"
    exit 1
fi

 
function build_android
{
echo ">>>>>> FFMPEG 开始编译 >>>>>>"    
./configure \
--prefix=$PREFIX \
--enable-postproc \
--enable-debug \
--disable-asm \
--enable-doc \
--enable-ffmpeg \
--enable-ffplay \
--enable-ffprobe \
--enable-symver \
--disable-avdevice \
--enable-static \
--enable-shared \
--enable-neon \
--enable-hwaccels \
--enable-jni \
--enable-mediacodec \
--enable-decoder=h264_mediacodec \
--enable-decoder=hevc_mediacodec \
--enable-decoder=mpeg4_mediacodec \
--cross-prefix=$CROSS_PREFIX \
--target-os=android \
--arch=$ARCH \
--cpu=$CPU \
--cc=$CC \
--cxx=$CXX \
--ar=$TOOLCHAIN/bin/llvm-ar \
--nm=$TOOLCHAIN/bin/llvm-nm \
--ranlib=$RANLIB \
--strip=$STRIP \
--enable-cross-compile \
--sysroot=$SYSROOT \
--extra-cflags="-Os -fpic $OPTIMIZE_CFLAGS" \
--extra-ldflags="$ADDI_LDFLAGS"
 
make clean
make -j8
make install
 
echo "<<<<<< 编译完成，产物存储在:$PREFIX <<<<<<"
 
}

# 函数调用
build_android
