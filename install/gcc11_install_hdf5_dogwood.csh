#!/bin/csh -f
set echo


#  ---------------------
#  Download and build zlib
#  ----------------------

   cd /proj/ie/proj/CMAS/CMAQ/AAQMS/build
   setenv BLD_DIR /proj/ie/proj/CMAS/CMAQ/AAQMS/build
#   wget https://zlib.net/zlib-1.3.tar.gz
#   tar -xzvf zlib-1.3.tar.gz
#   cd zlib-1.3
#   ./configure --prefix=../install/
#   make
#   make install

#  -----------------------
#  Download and build HDF5
#  -----------------------
   cd $BLD_DIR
   if [ ! /proj/ie/proj/CMAS/CMAQ/AAQMS/build/install/libhdf5.a ] then
	   wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.5/src/hdf5-1.10.5.tar.gz
  tar xvf hdf5-1.10.5.tar.gz
   rm -f hdf5-1.10.5.tar.gz
   cd hdf5-1.10.5
   export CFLAGS="-O3"
   export FFLAGS="-O3"
   export CXXFLAGS="-O3"
   export FCFLAGS="-O3"
   setenv  LDFLAGS -L/proj/ie/proj/CMAS/CMAQ/AAQMS/build/install/lib
   ./configure --prefix=/proj/ie/proj/CMAS/CMAQ/AAQMS/build/install --enable-fortran --enable-cxx --enable-shared --with-pic
   make |& tee make.gcc11.log
  make check > make.gcc11.check
   make install
   endif
#  ---------------------------
#  Download and build netCDF-C
#  ---------------------------
   setenv CPPFLAGS -I/proj/ie/proj/CMAS/CMAQ/AAQMS/build/install/include
   setenv LDFLAGS -L/proj/ie/proj/CMAS/CMAQ/AAQMS/build/install/lib
   cd /proj/ie/proj/CMAS/CMAQ/AAQMS/build
   #wget https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.7.4.tar.gz
   #tar xvf v4.7.4.tar.gz
   #rm -f v4.7.4.tar.gz
   #cd netcdf-c-4.7.4
   #wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-c-4.7.1.tar.gz
   wget https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.8.1.tar.gz
   tar xzvf v4.8.1.tar.gz
   #rm -f netcdf-c-4.8.1.tar.gz
   cd netcdf-c-4.8.1
   ./configure --with-pic --enable-netcdf-4 --with-hdf4=/proj/ie/proj/CMAS/CMAQ/AAQMS/build/install/lib --enable-shared --prefix=/proj/ie/proj/CMAS/CMAQ/AAQMS/build/install
   make |& tee  make.gcc11.log
   make install
#  ---------------------------------
#  Download and build netCDF-Fortran
#  ---------------------------------
   cd /proj/ie/proj/CMAS/CMAQ/AAQMS/build
   #wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-fortran-4.5.2.tar.gz
   wget https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.5.3.tar.gz
   tar xvf v4.5.3.tar.gz
   rm -f v4.5.3.tar.gz
   cd netcdf-fortran-4.5.3
   #export LIBS="-lnetcdf"
   setenv LIBS "-lnetcdf"
   ./configure --with-pic --enable-shared --prefix=/proj/ie/proj/CMAS/CMAQ/AAQMS/build/install
   make |& tee make.gcc11.log
   make install
