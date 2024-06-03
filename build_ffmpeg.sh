#!/bin/bash

# 设置NDK路径
export NDK=/Users/qfinn/Library/Android/sdk/ndk/25.1.8937393/
export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/darwin-x86_64
export API=28

# 设置目标架构
ARCH=arm64
CPU=armv8-a
TARGET=aarch64-linux-android
CROSS_PREFIX=$TOOLCHAIN/bin/aarch64-linux-android-

# 设置编译工具链
export CC=$TOOLCHAIN/bin/aarch64-linux-android$API-clang
export CXX=$TOOLCHAIN/bin/aarch64-linux-android$API-clang++
export AR=$TOOLCHAIN/bin/llvm-ar
export AS=$TOOLCHAIN/bin/llvm-as
export NM=$TOOLCHAIN/bin/llvm-nm
export STRIP=$TOOLCHAIN/bin/llvm-strip
export RANLIB=$TOOLCHAIN/bin/llvm-ranlib
export LD=$TOOLCHAIN/bin/ld

# 额外的编译选项
CFLAGS="-march=$CPU"
LDFLAGS=""

# 配置并编译FFmpeg


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
    --disable-symver \
    --disable-shared \ # 禁用共享链接
    --disable-asm \
    --disable-x86asm \
    --disable-avdevice \ # 禁用libavdevice构建
    --disable-postproc \ # 禁用libpostproc构建
    --disable-cuvid \ # 禁用Nvidia Cuvid
    --disable-nvenc \ # 禁用Nvidia视频编码
    --disable-vaapi \ # 禁用视频加速API代码（Unix/Intel）
    --disable-vdpau \ # 禁用禁用Nvidia解码和API代码（Unix）
    --disable-videotoolbox \ # 禁用ios和macos的多媒体处理框架videotoolbox
    --disable-audiotoolbox \ # 禁用ios和macos的音频处理框架audiotoolbox
    --disable-appkit \ # 禁用苹果 appkit framework
    --disable-avfoundation \ 禁用苹果 avfoundation framework
    --enable-static \ # 启用静态链接
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
