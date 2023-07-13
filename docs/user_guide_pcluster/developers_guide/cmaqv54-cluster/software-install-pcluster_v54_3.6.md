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

The install process currently uses .csh scripts to install the libraries.

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

## Install netCDF libraries that use HDF5 and support nc4 compressed files

Need to have this version of the library installed to uncompress the *.nc4 data using the indexer.csh script.

`cd /shared/pcluster-cmaq/install`

`./gcc_install_hdf5.csh`

### Create Custom Environment Module for Libraries

There are two steps required to create your own custome module:

1. write a module file

2. add a line to your ~/.cshrc to update the MODULEPATH

Create a new custom module that will be loaded with:

```
module load ioapi-3.2/gcc-9.5-netcdf
```

Step 1: Create the module file for ioapi-3.2.

First, create a path to store the module file. The path must contain /Modules/modulefiles/ and should have the general form
/<path to>/Modules/modulefiles/<module-name>/<version> where <version> is typically numerical and is the actual module file.

```
mkdir -p /shared/build/Modules/modulefiles/ioapi-3.2
```

Next, create the module file and save it in the directory above.

```
cd /shared/build/Modules/modulefiles/ioapi-3.2
vim gcc-9.5-netcdf
```

Contents of gcc-9.5-netcdf:

```
#%Module

proc ModulesHelp { } {
   puts stderr "This module adds ioapi-3.2/gcc-9.5 to your path"
}

module-whatis "This module adds ioapi-3.2/gcc-9.5 to your path\n"

set basedir "/shared/build/ioapi-3.2/"
prepend-path PATH "${basedir}/Linux2_x86_64gfort"
prepend-path LD_LIBRARY_PATH "${basedir}/ioapi/fixed_src"
```

The example module file above sets two evironment variables.

The modules update the PATH and LD_LIBRARY_PATH.

Step 2. Create the module file for netcdf-4.8.1

```
mkdir -p /shared/build/Modules/modulefiles/netcdf-4.8.1
```

Next, create the module file and save it in the directory above.

```
cd /shared/build/Modules/modulefiles/netcdf-4.8.1

vim gcc-9.5
```

Contents of gcc-9.5

```
#%Module

proc ModulesHelp { } {
   puts stderr "This module adds netcdf-4.8.1/gcc-9.5 to your path"
}

module-whatis "This module adds netcdf-4.8.1/gcc-9.5 to your path\n"

set basedir "/shared/build/netcdf"
prepend-path PATH "${basedir}/bin"
prepend-path LD_LIBRARY_PATH "${basedir}/lib"
module load openmpi
```

Step 3: Add the module path to MODULEPATH.

Now that the module file has been created, add the following line to your ~/.cshrc file so that it can be found:

```
module use --append /shared/build/Modules/modulefiles
```

Step 4. Source your shell

```
csh
```

Step 5: View the modules available after creation of the new module

The module avail command shows the paths to the module files on a given cluster.

```
module avail
```

Output

```
---------------------------------------------- /usr/share/modules/modulefiles ------------------------------------------------------------------
armpl/21.0.0  dot  libfabric-aws/1.17.1  module-git  module-info  modules  null  openmpi/4.1.5  use.own  

---------------------------------------------- /shared/build/Modules/modulefiles ----------------------------------------------------------------
ioapi-3.2/gcc-9.5-netcdf  netcdf-4.8.1/gcc-9.5  

```

Step 6: Load the modules

```
 module load ioapi-3.2/gcc-9.5-netcdf  netcdf-4.8.1/gcc-9.5 
```

Step 7: List the loaded modules

`module list`

Output:

```
Currently Loaded Modulefiles:
 1) openmpi/4.1.5   2) libfabric-aws/1.17.1   3) ioapi-3.2/gcc-9.5-netcdf   4) netcdf-4.8.1/gcc-9.5  
```


The following step is not typically needed.

## Install gh following these instructions

```
type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y
```

## Use gh authentication
