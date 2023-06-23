#!/bin/csh -f
set echo

#  -----------------------
#  Download and build HDF5
#  -----------------------
   mkdir /shared/build-hdf5
   cd /shared/build-hdf5
   wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.5/src/hdf5-1.10.5.tar.gz
   tar xvf hdf5-1.10.5.tar.gz
   rm -f hdf5-1.10.5.tar.gz
   cd hdf5-1.10.5
   setenv CFLAGS "-O3"
   setenv FFLAGS "-O3"
   setenv CXXFLAGS "-O3"
   setenv FCFLAGS "-O3"
   ./configure --prefix=/shared/build-hdf5/install --enable-fortran --enable-cxx --enable-shared --with-pic
   make |& tee make.gcc11.log
  make check > make.gcc11.check
   make install
#  ---------------------------
#  Download and build netCDF-C
#  ---------------------------
   setenv CPPFLAGS -I/shared/build-hdf5/install/include
   setenv LDFLAGS -L/shared/build-hdf5/install/lib
   cd /shared/build-hdf5
   #wget https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.7.4.tar.gz
   #tar xvf v4.7.4.tar.gz
   #rm -f v4.7.4.tar.gz
   #cd netcdf-c-4.7.4
   #wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-c-4.7.1.tar.gz
   wget https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.8.1.tar.gz
   tar xzvf v4.8.1.tar.gz
   #rm -f netcdf-c-4.8.1.tar.gz
   cd netcdf-c-4.8.1
   ./configure --with-pic --enable-netcdf-4 --enable-shared --prefix=/shared/build-hdf5/install
   make |& tee  make.gcc11.log
   make install
#  ---------------------------------
#  Download and build netCDF-Fortran
#  ---------------------------------
   cd /shared/build-hdf5
   #wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-fortran-4.5.2.tar.gz
   wget https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.5.3.tar.gz
   tar xvf v4.5.3.tar.gz
   rm -f v4.5.3.tar.gz
   cd netcdf-fortran-4.5.3
  # export LIBS="-lnetcdf"
   ./configure --with-pic --enable-shared --prefix=/shared/build-hdf5/install
   make |& tee make.gcc11.log
   make install

