## Install CMAQ sofware and libraries on ParallelCluster

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


The following instructions assume that you will be installing the software to a /shared/build directory

`mkdir /shared/build`

Install the pcluster-cmaq git repo to the /shared directory

`cd /shared`

`git clone -b main https://github.com/CMASCenter/pcluster-cmaq.git pcluster-cmaq`


### Check to make sure elastic network adapter (ENA) is enabled

`modinfo ena`

`lspci`

### Check what modules are available on the cluster

`module avail`

### Load the openmpi module

`module load openmpi/4.1.4`

### Load the Libfabric module

`module load libfabric-aws/1.16.1amzn1.0`

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

The install process currently uses .csh scripts to install the libraries and CMAQ.
An alternative is to keep a copy of the source code for netcdf-C and netcdf-Fortran and all of the other underlying code on an S3 bucket and to use custom bootstrap actions to build the sofware as the ParallelCluster is provisioned.  

The following link provides instructions on how to create a custom bootstrap action to pre-load software from an S3 bucket to the ParallelCluster at the time that the cluster is created.

<a href="https://docs.aws.amazon.com/parallelcluster/latest/ug/custom-bootstrap-actions-v3.html">Custom Bootstrap Actions</a>

### Build netcdf C and netcdf F libraries - these scripts work for the gcc 8+ compiler
Note, if this script fails, it is typically because NCAR has released a new version of netCDF C or Fortran, so the old version is no longer available, or if they have changed the name or location of the download file. 


`./gcc_netcdf_cluster.csh`

### A .cshrc script with LD_LIBRARY_PATH was copied to your home directory, enter the shell again and check environment variables that were set using

`cat ~/.cshrc`

### If the .cshrc was not created use the following command to create it

`cp dot.cshrc.pcluster ~/.cshrc`


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

### Confirm library was created

`ls -rlt /shared/build/ioapi-3.2/Linux2_x86_64gfort/*.a`

Output:

```
-rw-rw-r-- 1 ubuntu ubuntu 23776724 Jun 30 14:46 /shared/build/ioapi-3.2/Linux2_x86_64gfort/libioapi.a
```

### Confirm m3tools were built

`ls -rlt  /shared/build/ioapi-3.2/Linux2_x86_64gfort/m3xtract`

Output:

```
-rwxrwxr-x 1 ubuntu ubuntu 16812336 Jun 30 14:46 /shared/build/ioapi-3.2/Linux2_x86_64gfort/m3xtract
```

### Build CMAQ

`./gcc_cmaq54+_pcluster.csh`

Check to confirm that the cmaq executable has been built

`ls /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/BLD_CCTM_v54+_gcc/*.exe`

## Install netCDF libraries that use HDF5 and support nc4 compressed files

Need to have this version of the library installed to uncompress the *.nc4 data using the indexer.csh script.

`cd /shared/pcluster-cmaq`

`./gcc_install_hdf5.csh`



The following instructions are not typically needed.

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


