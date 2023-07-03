#!/bin/csh
# use with the following command line for copying from compressed nc4 files to classic nc files
# find . -name '*.nc4' -exec ./indexer.csh {} \;
# this script requires that the netCDF with nc4 compression are installed. see: gcc_install_hdf5.csh 

echo "You entered '$1'"
setenv file `echo $1`
setenv file2 `echo $1 | sed 's/\.[^.]*$//'`
echo $file
echo $file2
/shared/build-hdf5/install/bin/nccopy -k classic $file $file2.nc

