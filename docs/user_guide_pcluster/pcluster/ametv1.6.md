# Create EC2 instance for AMETv1.6 installation

## Launch EC2 instance from the AWS Console 

Name the instance AMETv1.6<br>
Select Ubuntu AMI from the quickstart option.<br>
Select the t3.medium instance type <br>
Create a pem key <br>
Configure storage, select 100 GB for root, and select new volume with 500 GB of EBS storage<br>
Launch Instance<br>

## Login to EC2 instance using the pem key

## Update Linux

```
sudo apt-get update && sudo apt-get upgrade -y
```

## Reboot and then relogin

Use the console to reboot the instance

## Install GCC 

```
sudo apt-get install gcc
```

## Check version of gcc

```
gcc --version
gcc (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0
Copyright (C) 2023 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

## Install gfortran 

```
sudo apt-get install gfortran
```

## Install OpenMPI

```
sudo apt install build-essential
sudo apt-get install openmpi-bin openmpi-doc libopenmpi-dev
```

## Check version of OpenMPI

```
mpirun --version
mpirun (Open MPI) 4.1.6
```

## Install tcsh

```
sudo apt-get install tcsh
```

## Install environment modules

```
sudo apt-get install environment-modules
```

## Add to bash initialization file
either your personal (~/.bashrc) or system-wide (/etc/bash.bashrc) bash initialization file:

```
# enable module command in non-interactive shells
if ! shopt -q login_shell; then
    . /usr/share/modules/init/bash
fi
```

## For tcsh

```
 sudo ln -s /usr/share/modules/init/csh /etc/csh/cshrc.d/modules
```
or

Or update personal (~/.cshrc) initialization file:

```
# enable module command in non-login shells
if (! $?loginsh) then
    source /usr/share/modules/init/csh
endif
```

## Install netcdf

```
wget https://raw.githubusercontent.com/USEPA/CMAQ/refs/heads/main/DOCS/Users_Guide/Tutorials/scripts/cmaq_libraries/gcc_11.4_install_netcdf_for_nc4_compression.csh
chmod 755 gcc_11.4_install_netcdf_for_nc4_compression.csh
```

## edit the script to remove the module load commands

## run script

```
./gcc_11.4_install_netcdf_for_nc4_compression.csh
```

Successful output should show what versions have been installed 

```
./nc-config --version
netCDF 4.8.1
./nf-config --version
netCDF-Fortran 4.5.3
```


## Install I/O API

```
wget https://raw.githubusercontent.com/USEPA/CMAQ/refs/heads/main/DOCS/Users_Guide/Tutorials/scripts/cmaq_libraries/gcc_11.4_install_ioapi_for_nc4_compression.csh 
chmod 755 gcc_11.4_install_ioapi_for_nc4_compression.csh
```

## Edit the script to use https for the git clone instead of ssh

```
git clone https://github.com/cjcoats/ioapi-3.2.git
```

Run the installation script

```
./gcc_11.4_install_ioapi_for_nc4_compression.csh
```

## Add environment modules for netCDF and I/O API

```
mkdir -p /home/ubuntu/Modules/modulefiles/netcdf
```

Add the following to define where the netcdf libraries and executables are located

```
vi gcc-13.3
```

Add the following contents to the gcc-13.3 file

```
#%Module
  
proc ModulesHelp { } {
   puts stderr "This module adds netcdf-4.5.3/gcc-13.3 to your path"
}

module-whatis "This module adds netcdf-4.5.3/gcc-13.3 to your path\n"

set basedir "/home/ubuntu/LIBRARIES/LIBRARIES_gcc/"
prepend-path PATH "${basedir}/bin`"
prepend-path LD_LIBRARY_PATH "${basedir}/lib"
```

### Add environment module for I/O API

```
mkdir -p /home/ubuntu/Modules/modulefiles/ioapi-3.2 
```

### add the following contents to the gcc-13.3 file in the ioapi-3.2 module directory

```
#%Module
  
proc ModulesHelp { } {
   puts stderr "This module adds ioapi-3.2/gcc-13.3 to your path"
}

module-whatis "This module adds ioapi-3.2/gcc-13.3 to your path\n"

set basedir "/home/ubuntu/LIBRARIES_gcc/ioapi-3.2"
prepend-path PATH "${basedir}/Linux2_x86_64gfort10"
prepend-path LD_LIBRARY_PATH "${basedir}/ioapi/fixed_src"
```

## Add the following commands to your .cshrc

```
# start .cshrc


umask 002


if (! $?prompt) exit                    #exit if not interactive

#alias rm 'rm -i'
alias sh bash

limit stacksize unlimited

setenv LD_LIBRARY_PATH ""

module use --append  /home/ubuntu/Modules/modulefiles
```

## Verify that the LD_LIBRARY_PATH is set correctly after loading the modules

```
module avail
module load ioapi-3.2/gcc-13.3  netcdf/gcc-13.3
echo $LD_LIBRARY_PATH
```

output

```
/home/ubuntu/LIBRARIES/LIBRARIES_gcc//lib:/home/ubuntu/LIBRARIES_gcc/ioapi-3.2/ioapi/fixed_src
```


## Install MariaDB

```
sudo apt install mariadb-server mariadb-client
```
## Download AMETv1.6

```
git clone -b 1.6 https://github.com/USEPA/AMET.git AMET_v16
```


