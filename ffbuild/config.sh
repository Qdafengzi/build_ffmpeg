# Automatically generated by configure - do not modify!
shared=yes
build_suffix=
prefix=/Users/qfinn/Downloads/ffmpeg/ffmpeg-6.1.1/android/armv7-a
libdir=${prefix}/lib
incdir=${prefix}/include
rpath=
source_path=.
LIBPREF=lib
LIBSUF=.a
extralibs_avutil="-pthread -lm -latomic -landroid"
extralibs_avcodec="-pthread -lm -latomic -landroid -lz"
extralibs_avformat="-lm -latomic -lz"
extralibs_avdevice="-lm -latomic"
extralibs_avfilter="-pthread -lm -latomic"
extralibs_postproc="-lm -latomic"
extralibs_swscale="-lm -latomic"
extralibs_swresample="-lm -latomic"
avdevice_deps="avformat avcodec swresample avutil"
avfilter_deps="swscale avformat avcodec swresample avutil"
swscale_deps="avutil"
postproc_deps="avutil"
avformat_deps="avcodec swresample avutil"
avcodec_deps="swresample avutil"
swresample_deps="avutil"
avutil_deps=""
