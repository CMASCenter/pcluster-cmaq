#!/bin/bash -f

#  ---------------------------
#  Build and install gcc 9.3.0
#  ---------------------------
cd /shared/build
GCC_VERSION=3.3.6
wget https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.gz
tar xzvf gcc-${GCC_VERSION}.tar.gz
mkdir obj.gcc-${GCC_VERSION}
cd gcc-${GCC_VERSION}
./contrib/download_prerequisites
cd ../obj.gcc-${GCC_VERSION}
../gcc-${GCC_VERSION}/configure --disable-multilib --prefix /shared/build/gcc-9.3-install
make -j $(nproc)
sudo make install
