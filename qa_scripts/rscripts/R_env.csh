#!/bin/csh -f

#> This script is for setting up R plotting and mapping environment on Dogwood

# R
module load r/4.1.0

# GCC compiler
module load gcc/9.1.0   

#OpenMPI
module load openmpi_4.0.1/gcc_9.1.0

# netCDF
module load netCDF-4compression/gcc-9.1-netcdf

# I/O API
module load  ioapi-3.2/gcc-9.1-netcdf

