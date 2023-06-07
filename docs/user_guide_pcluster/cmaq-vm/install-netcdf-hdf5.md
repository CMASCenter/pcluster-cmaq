# Install I/O API libraries that support HDF5

This is required in order to:

1. Run CMAQ using the compressed netCDF-4 input files provided on the S3 bucket
or
2. Convert the *.nc4 files to *.nc files (to uncompressed classic netCDF-3 input files)

First build HDF5 libraries, then build netCDF-C, netCDF-Fortran

```
cd /shared/pcluster-cmaq
./gcc11_install_hdf5.csh
```




