#!/bin/csh -f

#  ---------------------------
#  Build and install gcc 9.3.0
#  ---------------------------
#cd /home/centos/build
#GCC_VERSION=9.3.0
#wget https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.gz
#tar xzvf gcc-${GCC_VERSION}.tar.gz
#mkdir obj.gcc-${GCC_VERSION}
#cd gcc-${GCC_VERSION}
#./contrib/download_prerequisites
#cd ../obj.gcc-${GCC_VERSION}
#../gcc-${GCC_VERSION}/configure --disable-multilib
#make -j $(nproc)
#sudo make install

#  -----------------------
#  Download and build HDF5
#  -----------------------
#   cd /home/centos/build
#   wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.5/src/hdf5-1.10.5.tar.gz
#   tar xvf hdf5-1.10.5.tar.gz
#   rm -f hdf5-1.10.5.tar.gz
#   cd hdf5-1.10.5
#   export CFLAGS="-O3"
#   export FFLAGS="-O3"
#   export CXXFLAGS="-O3"
#   export FCFLAGS="-O3"
#   ./configure --prefix=/usr/local --enable-fortran --enable-cxx --enable-shared --with-pic
#   make > make.gcc9.log 2>&1
#  make check > make.gcc9.check
#   make install
#  ---------------------------
#  Download and build netCDF-C
#  ---------------------------
   setenv DIR /shared/build
   mkdir $DIR
   cd $DIR
   #wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-c-4.7.1.tar.gz
  wget https://downloads.unidata.ucar.edu/netcdf-c/4.8.1/src/netcdf-c-4.8.1.tar.gz
  tar xvf netcdf-c-4.8.1.tar.gz
   rm -f netcdf-c-4.8.1.tar.gz
   cd netcdf-c-4.8.1
   #./configure --with-pic --with-hdf5=/home/centos/build/hdf5-1.10.5/hdf5/ --enable-netcdf-4 --enable-shared --prefix=$DIR/netcdf
#configure: error: curl required for remote access. Install curl or build with --disable-dap.
   #./configure --with-pic --enable-netcdf-4 --enable-shared --disable-dap --prefix=/usr/local
#configure: error: Can't find or link to the hdf5 library. Use --disable-netcdf-4, or see config.log for errors.
#   ended up using:
 ./configure --disable-netcdf-4 --disable-shared --disable-dap --prefix=$DIR/netcdf
   make >& make.netcdf4c.log
   make install
#  ---------------------------------
#  Download and build netCDF-Fortran
#  ---------------------------------
   cd $DIR
   #wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-fortran-4.5.2.tar.gz
   wget https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.5.3.tar.gz
   #tar xvf netcdf-fortran-4.5.2.tar.gz
    tar xzvf v4.5.3.tar.gz
   #rm -f netcdf-fortran-4.5.2.tar.gz
   cd netcdf-fortran-4.5.3
   setenv NCDIR $DIR/netcdf
   setenv CPPFLAGS -I${NCDIR}/include
   setenv LDFLAGS -L${NCDIR}/lib
   setenv LIBS "-lnetcdf"
   ./configure --disable-shared --prefix=$DIR/netcdf

#got error: checking size of off_t... configure: error:
#edited .cshrc to add path to /usr/local/lib where netcdf-c was installed`

   make >& make.netcdf.log
   make install

# Test install
cd $DIR/netcdf/bin
   ./nc-config --version
   ./nf-config --version

# What I really need to do is edit the .cshrc
#if ( ! $?LD_LIBRARY_PATH ) then
#    setenv LD_LIBRARY_PATH /shared/build/netcdf/lib
#else
#    setenv LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:/shared/build/netcdf/lib
#endif

cp /shared/pcluster-cmaq/dot.cshrc ~/.cshrc
