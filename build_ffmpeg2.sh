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
--disable-encoders \ # 禁用所有编码器
--disable-decoders \ # 禁用所有解码器
--disable-doc \ # 禁用文档
--disable-htmlpages \
--disable-manpages \
--disable-podpages \
--disable-txtpages \
--disable-ffmpeg \ # 禁用 ffmpeg 可执行程序构建
--disable-ffplay \ # 禁用 ffplay 可执行程序构建
--disable-ffprobe \ # 禁用 ffprobe 可执行程序构建
--disable-symver \ #禁用符号版本控制
--disable-shared \ # 禁用共享链接
--disable-asm \
--disable-x86asm \
--disable-avdevice \ # 禁用libavdevice构建 通常用于设备输入输出，对移动端非必须
--disable-postproc \ # 禁用libpostproc构建
--disable-cuvid \ # 禁用Nvidia Cuvid
--disable-nvenc \ # 禁用Nvidia视频编码
--disable-vaapi \ # 禁用视频加速API代码（Unix/Intel）
--disable-vdpau \ # 禁用禁用Nvidia解码和API代码（Unix）
--disable-videotoolbox \ # 禁用ios和macos的多媒体处理框架videotoolbox
--disable-audiotoolbox \ # 禁用ios和macos的音频处理框架audiotoolbox
--disable-appkit \ # 禁用苹果 appkit framework
--disable-avfoundation \ 禁用苹果 avfoundation framework
# --enable-static \ # 启用静态链接
--disable-static \ # 禁用静态链接
--enable-shared \ # 启用共享链接
--enable-nonfree \ # 启用非免费的组件
--enable-gpl \ # 启用公共授权组件
--enable-version3 \ 
--enable-pic \
--enable-pthreads \ # 启用多线程
--enable-encoder=bmp \ 
--enable-encoder=flv \
--enable-encoder=gif \
--enable-encoder=mpeg4 \
--enable-encoder=rawvideo \
--enable-encoder=png \
--enable-encoder=mjpeg \
--enable-encoder=yuv4 \
--enable-encoder=aac \
--enable-encoder=pcm_s16le \
--enable-encoder=subrip \
--enable-encoder=text \
--enable-encoder=srt \
# --enable-libx264 \ # 启用支持h264
#--enable-encoder=libx264 \
#--enable-libfdk-aac \ # 启用支持fdk-aac
# --enable-encoder=libfdk_aac \
# --enable-decoder=libfdk_aac \
#--enable-libmp3lame \ # 启用支持mp3lame
# --enable-encoder=libmp3lame \
#--enable-libopencore-amrnb \ # 启用支持opencore-amrnb
# --enable-encoder=libopencore_amrnb \
# --enable-decoder=libopencore_amrnb \
#--enable-libopencore-amrwb \ # 启用支持opencore-amrwb
# --enable-decoder=libopencore_amrwb \
--enable-mediacodec \ # 启用支持mediacodec
--enable-encoder=h264_mediacodec \
--enable-encoder=hevc_mediacodec \
--enable-decoder=h264_mediacodec \
--enable-decoder=hevc_mediacodec \
--enable-decoder=mpeg4_mediacodec \
--enable-decoder=vp8_mediacodec \
--enable-decoder=vp9_mediacodec \
--enable-decoder=bmp \
--enable-decoder=flv \
--enable-decoder=gif \
--enable-decoder=mpeg4 \
--enable-decoder=rawvideo \
--enable-decoder=h264 \
--enable-decoder=png \
--enable-decoder=mjpeg \
--enable-decoder=yuv4 \
--enable-decoder=aac \
--enable-decoder=aac_latm \
--enable-decoder=pcm_s16le \
--enable-decoder=mp3 \
--enable-decoder=flac \
--enable-decoder=srt \
--enable-decoder=xsub \
--enable-small \
--enable-neon \
--enable-hwaccels \
--enable-jni \
--enable-cross-compile \
--cross-prefix=$CROSS_PREFIX \
--target-os=android \
--arch=$COMPILE_ARCH \
--cpu=$ANDROID_CUP \
--cc=$CC \
--cxx=$CXX \
--nm=$NM \
--ar=$AR \
--as=$AS \
--strip=$STRIP \
--ranlib=$RANLIB \
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
