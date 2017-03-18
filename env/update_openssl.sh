#!/bin/bash
# OpenSSL 1.0.2j  26 Sep 2016
if ls /usr/local/ssl > /dev/null ;then
	if openssl version -a |grep "OpenSSL 1.0.2j"  > /dev/null;then
		exit 0
	fi
fi
CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
rm -rf openssl-1.0.2j
if [ ! -f openssl-1.0.2j.tar.gz ];then
  # wget http://t-down.oss-cn-hangzhou.aliyuncs.com/openssl-1.0.1h.tar.gz
	wget -O openssl-1.0.2j.tar.gz -c https://github.com/openssl/openssl/archive/OpenSSL_1_0_2j.tar.gz
  # https://www.openssl.org/source/openssl-1.0.2j.tar.gz
	# https://github.com/openssl/openssl/archive/OpenSSL_1_0_2k.tar.gz
	# https://github.com/openssl/openssl/releases
fi

# ---
tar zxvf openssl-1.0.2j.tar.gz
mv openssl-OpenSSL_1_0_2j openssl-1.0.2j
cd openssl-1.0.2j
\mv /usr/local/ssl /usr/local/ssl.OFF
./config shared zlib
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install
# ---
\mv /usr/bin/openssl /usr/bin/openssl.OFF
\mv /usr/include/openssl /usr/include/openssl.OFF
ln -s /usr/local/ssl/bin/openssl /usr/bin/openssl
ln -s /usr/local/ssl/include/openssl /usr/include/openssl
if ! cat /etc/ld.so.conf| grep "/usr/local/ssl/lib" >> /dev/null;then
	echo "/usr/local/ssl/lib" >> /etc/ld.so.conf
fi
ldconfig -v
openssl version -a
