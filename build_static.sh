#!/bin/bash
# Gentoo related static build hints:
# CFLAGS += "-static"
# net-libs/nghttp2 net-libs/nghttp3 net-libs/ngtcp2
# export USE="static-libs"
# dev-libs/libunistring dev-libs/openssl net-dns/c-ares net-dns/libidn2 net-libs/libpsl net-misc/curl sys-libs/zlib


make -j"$(nproc)" SPEEDTEST_LINK_SHARED=no LDFLAGS="-static" ;
make -j"$(nproc)" speedtest
make -j"$(nproc)" minitest
make -j"$(nproc)" bartest
make -j"$(nproc)" sparktest


STATIC_LIBS="
  ./libspeedtestcpp.a \
  /usr/lib64/libcurl.a \
  /usr/lib64/libnghttp2.a \
  /usr/lib64/libnghttp3.a \
  /usr/lib64/libngtcp2.a \
  /usr/lib64/libngtcp2_crypto_ossl.a \
  /usr/lib64/libcares.a \
  /usr/lib64/libpsl.a \
  /usr/lib64/libssl.a \
  /usr/lib64/libz.a \
  /usr/lib64/libcrypto.a \
  /usr/lib64/libidn2.a \
  /usr/lib64/libunistring.a \
  -lpthread -ldl -lstdc++ -static"


rm -f speedtest
g++ -march=x86-64 --std=c++23 -Wall -fPIC \
  objs/main.o \
  objs/sp_md5.o objs/sp_xml.o objs/sp_client.o \
  objs/sp_parser.o objs/sp_profile.o \
  objs/sp_speedtest.o objs/sp_json_servers_parser.o \
  $STATIC_LIBS \
  -o speedtest ;
ldd speedtest


rm -f minitest
g++ objs/minitest.o $STATIC_LIBS -o minitest
ldd minitest


rm -f bartest
g++ objs/bartest.o $STATIC_LIBS -o bartest
ldd bartest


rm -f sparktest
g++ objs/sparktest.o $STATIC_LIBS -o sparktest
ldd sparktest

