#!/bin/csh -f
set echo

#  -----------------------
#  Download and build HDF5
#  -----------------------
   cd /shared/build-hdf5
   wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.5/src/hdf5-1.10.5.tar.gz
   tar xvf hdf5-1.10.5.tar.gz
   rm -f hdf5-1.10.5.tar.gz
   cd hdf5-1.10.5
   export CFLAGS="-O3"
   export FFLAGS="-O3"
   export CXXFLAGS="-O3"
   export FCFLAGS="-O3"
   ./configure --prefix=/shared/build-hdf5/install --enable-fortran --enable-cxx --enable-shared --with-pic
   make |& tee make.gcc9.log 
#  make check > make.gcc9.check
   make install
#  ---------------------------
#  Download and build netCDF-C
#  ---------------------------
   cd /shared/build-hdf5
   wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-c-4.7.1.tar.gz
   tar xvf netcdf-c-4.7.1.tar.gz
   rm -f netcdf-c-4.7.1.tar.gz
   cd netcdf-c-4.7.1
   ./configure --with-pic --enable-netcdf-4 --enable-shared --prefix=/shared/build-hdf5/install
   make |& tee  make.gcc9.log
   make install
#  ---------------------------------
#  Download and build netCDF-Fortran
#  ---------------------------------
   cd /shared/build-hdf5
   wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-fortran-4.5.2.tar.gz
   tar xvf netcdf-fortran-4.5.2.tar.gz
   rm -f netcdf-fortran-4.5.2.tar.gz
   cd netcdf-fortran-4.5.2
   export LIBS="-lnetcdf"
   ./configure --with-pic --enable-shared --prefix=/shared/build-hdf5/install
   make |& tee make.gcc9.log 
   make install
#  -----------------------------
#  Download and build netCDF-CXX
#  -----------------------------
   cd /shared/build-hdf5
   wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-cxx4-4.3.1.tar.gz
   tar xvf netcdf-cxx4-4.3.1.tar.gz
   rm -f netcdf-cxx4-4.3.1.tar.gz
   cd netcdf-cxx4-4.3.1
   ./configure --with-pic --enable-shared --prefix=/shared/build-hdf5/install
   make |& tee  make.gcc9.log
   make install
#  --------------------------
#  Download and build OpenMPI
#  --------------------------
#   cd /usr/local/s
#   wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.4.tar.gz
#   tar xvf openmpi-3.1.4.tar.gz
#   rm -f openmpi-3.1.4.tar.gz
#   cd openmpi-3.1.4
#   export CFLAGS="-O3"
#   export FFLAGS="-O3"
#   export CXXFLAGS="-O3"
#   export FCFLAGS="-O3"
#   ./configure --prefix=/shared/build-hdf5/install --enable-mpi-cxx
#   make |& tee make.gcc9.log
##  make check > make.gcc9.check
#   make install
#  ----------------------------------
#  Download and build Parallel netCDF
#  ----------------------------------
   cd /shared/build-hdf5
   wget https://parallel-netcdf.github.io/Release/pnetcdf-1.12.1.tar.gz
   tar xvf pnetcdf-1.12.1.tar.gz
   rm -f pnetcdf-1.12.1.tar.gz
   cd pnetcdf-1.12.1
   export CFLAGS="-O3 -fPIC"
   export FFLAGS="-O3 -fPIC"
   export CXXFLAGS="-O3 -fPIC"
   export FCFLAGS="-O3 -fPIC"
   ./configure --prefix=/shared/build-hdf5/install MPIF77=mpif90 MPIF90=mpif90 MPICC=mpicc MPICXX=mpicxx --with-mpi=/opt/amazon/openmpi
   make |& tee make.gcc9.log
   make install
#  ----------------------------------------
#  Use tcsh 6.20 instead of the broken 6.21
#  ----------------------------------------
#   cd /shared/build-hdf5
#   wget http://ftp.funet.fi/pub/mirrors/ftp.astron.com/pub/tcsh/old/tcsh-6.20.00.tar.gz
#   tar xvf tcsh-6.20.00.tar.gz
#   rm -f tcsh-6.20.00.tar.gz
#   cd tcsh-6.20.00
#   ./configure --disable-nls
#   make > make.gcc9.log 2>&1
#   make install
#   ln -s /usr/local/bin/tcsh /bin/csh
#  ----------------------
#  Download and build vim
#  ----------------------
#   cd /usr/local/src
#   git clone https://github.com/vim/vim.git vim
#   cd vim
#   ./configure
#   make > make.gcc9.log 2>&1
#   make install
#   cd /usr/local/bin
#   ln -s vim vi

# install test
   cd /shared/build-hdf5/install/bin
   whereis h5diff
   nc-config --version
   nf-config --version
   ncxx4-config --version
