## Install CMAQ sofware and libraries on ParallelCluster version 3.6
note, when you update the version of ParallelCluster, you often get different versions of the openmpi, libfabric, and gcc compilers and environment modules.

### Login to updated cluster
```{note}
Replace the your-key.pem with your Key Pair.
```

`pcluster ssh -v -Y -i ~/your-key.pem --cluster-name cmaq`


### Change shell to use .tcsh

```{note}
This command depends on what OS you have installed on the ParallelCluster
```

`sudo usermod -s /bin/tcsh ubuntu`

or

`sudo usermod -s /bin/tcsh centos`

Log out and log back in to have the tcsh shell be active

`exit`

`pcluster ssh -v -Y -i ~/your-key.pem --cluster-name cmaq`

### Check to see the tcsh shell is default

`echo $SHELL`

### Reload the environment modules

`module load openmpi/4.1.5  libfabric-aws/1.17.1 `


The following instructions assume that you will be installing the software to a /shared/build directory

`mkdir /shared/build`

Install the pcluster-cmaq git repo to the /shared directory

`cd /shared`

`git clone -b main https://github.com/CMASCenter/pcluster-cmaq.git pcluster-cmaq`

### Check to make sure elastic network adapter (ENA) is enabled

`modinfo ena`

`lspci`


### Verify the gcc compiler version is greater than 8.0

`gcc --version`

Output:

```
gcc (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0
Copyright (C) 2019 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

```

### Change directories to install and build the libraries and CMAQ

`cd /shared/pcluster-cmaq/install`

Note: the sofware build process for CMAQ integration and continuous deployment needs improvement.
Currently the Unidata Ucar netcdf-c download page is broken, and the location where the source code can be obtained may need to be updated from their  website to the netcdf git repository.
For this reason, this tutorial provides a snapshot image that was compiled on a c5n.xlarge head node, and runs on the c5n.18xlarge compute node.
A different snapshot image would need to be created to compile and run CMAQ on a c6gn.16xlarge Arm-based AWS Graviton2 processor.

An alternative is to keep a copy of the source code for netcdf-C and netcdf-Fortran and all of the other underlying code on an S3 bucket and to use custom bootstrap actions to build the sofware as the ParallelCluster is provisioned.  

The following link provides instructions on how to create a custom bootstrap action to pre-load software from an S3 bucket to the ParallelCluster at the time that the cluster is created.

<a href="https://docs.aws.amazon.com/parallelcluster/latest/ug/custom-bootstrap-actions-v3.html">Custom Bootstrap Actions</a>

### Build netcdf C and netcdf F libraries - these scripts work for the gcc 8+ compiler
Note, if this script fails, it is typically because NCAR has released a new version of netCDF C or Fortran, so the old version is no longer available, or if they have changed the name or location of the download file. 


`./gcc_netcdf_cluster.csh`

### A .cshrc script with LD_LIBRARY_PATH was copied to your home directory, enter the shell again and check environment variables that were set using

`cat ~/.cshrc`

### If the .cshrc was not created use the following command to create it

`cp dot.cshrc.pcluster.v36 ~/.cshrc`


### Execute the shell to activate it

`csh`

`env`

### Verify that you see the following setting

Output:

```
LD_LIBRARY_PATH=/opt/amazon/openmpi/lib64:/shared/build/netcdf/lib:/shared/build/netcdf/lib
```

### Build I/O API library

`./gcc_ioapi_cluster.v36.csh`

### Build CMAQ

`./gcc_cmaq54+_pcluster.csh`

Check to confirm that the cmaq executable has been built

`ls /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/BLD_CCTM_v54+_gcc/*.exe`

## Install Homebrew to install github command line gh to allow you to create authentication to commit changes to git repo

```
cd /shared/build
git clone https://github.com/Homebrew/brew homebrew
```

Change shell to bash
`bash`

Run following commands to install
```
eval "$(homebrew/bin/brew shellenv)"
brew update --force --quiet
chmod -R go-w "$(brew --prefix)/share/zsh"
```

## Install github gh

`brew install gh`

## Use gh authentication

## Install netCDF libraries that use HDF5 and support nc4 compressed files

Need to have this version of the library installed to uncompress the *.nc4 data using the indexer.csh script.

`cd /shared/pcluster-cmaq`

`./gcc_install_hdf5.csh`





