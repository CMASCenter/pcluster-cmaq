# Install CMAQ and pre-requisite libraries on linux

## Install CMAQ sofware on parallel cluster

### Login to updated cluster
(note, replace the centos.pem with your Key Pair)

`pcluster ssh -v -Y -i ~/centos.pem --cluster-name cmaq`


### Change shell to use .tcsh

`sudo usermod -s /bin/tcsh ubuntu`

Log out and log back in to have the tcsh shell be active

`exit`

`pcluster ssh -v -Y -i ~/centos.pem --cluster-name cmaq`

### Check to see the tcsh shell is default

`echo $SHELL`


The following instructions assume that you will be installing the software to a /shared/build directory

```
mkdir /shared/build
```

Install the pcluster-cmaq git repo to the /shared directory

```
cd /shared
```

### Use a configuration file from the github repo that was cloned to your local machine

```
git clone -b main https://github.com/lizadams/pcluster-cmaq.git pcluster-cmaq
```


```
cd pcluster-cmaq
```

### Check to make sure elastic network adapter (ENA) is enabled

`modinfo ena`

`lspci`

### Check what modules are available on the cluster

`module avail`

### Load the openmpi module

`module load openmpi/4.1.1`

### Load the Libfabric module

`module load libfabric-aws/1.13.2amzn1.0`

### Verify the gcc compiler version is greater than 8.0
(note, gcc version on centos7 has been gcc (GCC) 4.8.5 20150623 (Red Hat 4.8.5-44a, and this seems to work ok.)

`gcc --version`

output:

```
gcc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0 Copyright (C) 2019 Free Software Foundation, Inc. This is free software; see the source for copying conditions. There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

### Change directories to install and build the libraries and CMAQ

`cd /shared/pcluster-cmaq`


### Build netcdf C and netcdf F libraries - these scripts work for the gcc 8+ compiler
Note, if this script fails, it is typically because NCAR has released a new version of netCDF C or Fortran, so the old version is no longer available, or if they have changed the name or location of the download file. 


`./gcc_netcdf_cluster.csh`

### A .cshrc script with LD_LIBRARY_PATH was copied to your home directory, enter the shell again and check environment variables that were set using

`cat ~/.cshrc`

### If the .cshrc wasn't created use the following command to create it

`cp dot.cshrc.pcluster ~/.cshrc`


### Execute the shell to activate it

`csh`

`env`

### Verify that you see the following setting

```
LD_LIBRARY_PATH=/opt/amazon/openmpi/lib64:/shared/build/netcdf/lib:/shared/build/netcdf/lib
```

### Build I/O API library

`./gcc_ioapi_cluster.csh`

### Build CMAQ

`./gcc_cmaq_pcluster.csh`

Check to see that the cmaq executable has been built

`ls /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/BLD_CCTM_v533_gcc/*.exe`
