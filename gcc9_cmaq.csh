#!/bin/csh -f

#  -----------------------
#  Download and build CMAQ
#  -----------------------
setenv IOAPI_DIR /shared/build/ioapi-3.2/Linux2_x86_64gfort
setenv NETCDF_DIR /shared/build/netcdf/lib
setenv NETCDFF_DIR /shared/build/netcdf/lib
cd /shared/build/
git clone -b 5.3.2_singularity https://github.com/lizadams/CMAQ.git CMAQ_REPO
echo "downloaded CMAQ"
cd CMAQ_REPO
./bldit_cctm.csh
