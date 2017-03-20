#!/bin/bash
# OpenSSL 1.0.1u  26 Sep 2016
if ls /usr/local/ssl > /dev/null ;then
	if openssl version -a |grep "OpenSSL 1.0.1u"  > /dev/null;then
		exit 0
	fi
fi

CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
rm -rf openssl-1.0.1u

if [ ! -f openssl-1.0.1u.tar.gz ];then
  # wget http://t-down.oss-cn-hangzhou.aliyuncs.com/openssl-1.0.1h.tar.gz
	wget -O openssl-1.0.1u.tar.gz -c https://github.com/openssl/openssl/archive/OpenSSL_1_0_1u.tar.gz
  # https://www.openssl.org/source/openssl-1.0.1u.tar.gz
	# https://github.com/openssl/openssl/archive/OpenSSL_1_0_1u.tar.gz
	# https://github.com/openssl/openssl/releases
fi

# ---
tar zxvf openssl-1.0.1u.tar.gz
mv openssl-OpenSSL_1_0_1u openssl-1.0.1u
cd openssl-1.0.1u
\mv /usr/local/ssl /usr/local/ssl.OFF
./config shared zlib enable-tlsext
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install clean

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
