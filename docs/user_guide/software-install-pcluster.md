# Install CMAQ and pre-requisite libraries on linux

### Change shell to use .tcsh

'sudo usermod -s /bin/tcsh lizadams'


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

## Install CMAQ sofware on parallel cluster

### Login to updated cluster
(note, replace the centos.pem with your Key Pair)

`pcluster ssh -v -Y -i ~/centos.pem --cluster-name cmaq`

### Check to make sure elastic network adapter (ENA) is enabled

`modinfo ena`

`lspci`

### Check what modules are available on the cluster

`module avail`

### Load the openmpi module

`module load openmpi/4.1.1`

### Load the Libfabric module

`module load libfabric-aws/1.13.0amzn1.0`

### Verify the gcc compiler version is greater than 8.0

`gcc --version`

output:

```
gcc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0 Copyright (C) 2019 Free Software Foundation, Inc. This is free software; see the source for copying conditions. There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

### Change directories to install and build the libraries and CMAQ

`cd /shared`

`git clone https://github.com/lizadams/pcluster-cmaq.git`

### Build netcdf C and netcdf F libraries - these scripts work for the gcc 8+ compiler

`cd pcluster-cmaq`

`gcc_netcdf_pcluster.csh`

### A .cshrc script with LD_LIBRARY_PATH was copied to your home directory, enter the shell again and check environment variables that were set using

`cat ~/.cshrc`

### If the .cshrc wasn't created use the following command to create it

`cp dot.cshrc ~/.cshrc`

### Execute the shell to activate it

### If the .cshrc wasn't created use the following command to create it

`cp dot.cshrc ~/.cshrc`

### Execute the shell to activate it

`csh`

`env`

### Verify that you see the following setting

```
LD_LIBRARY_PATH=/opt/amazon/openmpi/lib64:/shared/build/netcdf/lib:/shared/build/netcdf/lib
```

### Build I/O API library

`./gcc_ioapi_pcluster.csh`

### Build CMAQ

`./gcc_cmaq_pcluster.csh`

## Obtain the Input data from a public S3 Bucket
Two methods are available either importing the data on the lustre file system using the yaml file to specify the s3 bucket location or copying the data using s3 copy commands.

### First Method: Import the data by specifying it in the yaml file - example available in c5n-18xlarge.ebs_shared.yaml

```
  - MountDir: /fsx
    Name: name2
    StorageType: FsxLustre
    FsxLustreSettings:
      StorageCapacity: 1200
      ImportPath: s3://conus-benchmark-2day    <<<  specify name of S3 bucket
```
This requires that the S3 bucket specified is publically available


### Second Method: Copy the data using the s3 command line

### set the aws credentials
If you don't have credentials, please contact the manager of your aws account.

