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
    --prefix=$PREFIX \ # 编译之后的保存位置
    --disable-everything \ # 禁用所有功能，启用特定功能
    --enable-gpl \ # 启用GPL授权组件
    --enable-version3 \ # 启用GPLv3组件
    --enable-pic \ # 启用位置无关代码
    --enable-small \ # 启用小型构建，优化为较小的二进制文件
    --enable-shared \ # 启用共享链接
    --enable-pthreads \ # 启用多线程
    --enable-cross-compile \ # 启用交叉编译
    --cross-prefix=$CROSS_PREFIX \ # 交叉编译前缀
    --target-os=android \ # 目标操作系统为Android
    --arch=$ARCH \ # 架构
    --cpu=$CPU \ # CPU类型
    --cc=$CC \ # C编译器
    --cxx=$CXX \ # C++编译器
    --nm=$NM \ # NM工具
    --ar=$AR \ # AR工具
    --as=$CC \ # AS工具，使用C编译器
    --strip=$STRIP \ # Strip工具
    --ranlib=$RANLIB \ # Ranlib工具
    --sysroot=$SYSROOT \ # Sysroot路径
    --extra-cflags="-Os -fpic $OPTIMIZE_CFLAGS" \ # 额外的编译标志，优化大小和位置无关代码
    --extra-ldflags="$ADDI_LDFLAGS" \ # 额外的链接标志

    # 启用所需的编码器
    --enable-encoder=libx264 \ # 启用H.264编码器
    --enable-encoder=aac \ # 启用AAC编码器
    --enable-encoder=png \ # 启用PNG编码器，用于图片水印
    --enable-encoder=mjpeg \ # 启用MJPEG编码器，用于图片水印
    --enable-encoder=srt \ # 启用SRT编码器，用于字幕

    # 启用所需的解码器
    --enable-decoder=h264 \ # 启用H.264解码器
    --enable-decoder=aac \ # 启用AAC解码器
    --enable-decoder=mp3 \ # 启用MP3解码器
    --enable-decoder=png \ # 启用PNG解码器，用于图片水印
    --enable-decoder=mjpeg \ # 启用MJPEG解码器，用于图片水印

    # 启用所需的滤镜
    --enable-filter=drawtext \ # 启用drawtext滤镜，用于添加文本水印
    --enable-filter=overlay \ # 启用overlay滤镜，用于添加图片水印
    --enable-filter=crop \ # 启用crop滤镜，用于视频裁剪
    --enable-filter=trim \ # 启用trim滤镜，用于视频剪切
    --enable-filter=atrim \ # 启用atrim滤镜，用于音频剪切

    # 启用所需的协议
    --enable-protocol=file \ # 启用file协议
 
make clean
make -j8
make install
 

echo "<<<<<< 编译完成，产物存储在:$PREFIX <<<<<<"
 
}

# 函数调用
build_android