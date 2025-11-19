## Instructions for installing AMETv1.6 on an EC2 instance

### Launch EC2 instance from the AWS Console 

Name the instance AMETv1.6<br>
Select Ubuntu AMI from the quickstart option.<br>
Select the t3.medium instance type <br>
Create a pem key <br>
Configure storage, select 300 GB for root, and select new volume with 1000 GB of EBS storage<br>
Launch Instance<br>

### Login to EC2 instance using the pem key

#### Update Linux

```
sudo apt-get update && sudo apt-get upgrade -y
```

### Reboot and then relogin

Use the console to reboot the instance

### Install Compilers and Libraries

#### Install GCC 

```
sudo apt-get install gcc
```

#### Check version of gcc

```
gcc --version
gcc (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0
Copyright (C) 2023 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

### Install gfortran 

```
sudo apt-get install gfortran
```

### Install OpenMPI

```
sudo apt install build-essential
sudo apt-get install openmpi-bin openmpi-doc libopenmpi-dev
```

#### Check version of OpenMPI

```
mpirun --version
mpirun (Open MPI) 4.1.6
```

#### Install imagemagick

```
sudo apt install imagemagick
```

### Install tcsh

```
sudo apt-get install tcsh
```

### Install environment modules

```
sudo apt-get install environment-modules
```

#### Add to bash initialization file
either your personal (~/.bashrc) or system-wide (/etc/bash.bashrc) bash initialization file:

```
# enable module command in non-interactive shells
if ! shopt -q login_shell; then
    . /usr/share/modules/init/bash
fi
```

### For tcsh

```
 sudo ln -s /usr/share/modules/init/csh /etc/csh/cshrc.d/modules
```
or

Or update personal (~/.cshrc) initialization file:

```
# Enable module command in non-login shells

if (! $?loginsh) then
    source /usr/share/modules/init/csh
endif
```

### Install netcdf

```
wget https://raw.githubusercontent.com/USEPA/CMAQ/refs/heads/main/DOCS/Users_Guide/Tutorials/scripts/cmaq_libraries/gcc_11.4_install_netcdf_for_nc4_compression.csh
chmod 755 gcc_11.4_install_netcdf_for_nc4_compression.csh
```

#### edit the script to remove the module load commands

#### run script

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


### Install I/O API

```
wget https://raw.githubusercontent.com/USEPA/CMAQ/refs/heads/main/DOCS/Users_Guide/Tutorials/scripts/cmaq_libraries/gcc_11.4_install_ioapi_for_nc4_compression.csh 
chmod 755 gcc_11.4_install_ioapi_for_nc4_compression.csh
```

#### Edit the script to use https for the git clone instead of ssh

```
git clone https://github.com/cjcoats/ioapi-3.2.git
```

#### Run the installation script

```
./gcc_11.4_install_ioapi_for_nc4_compression.csh
```

#### Add environment modules for netCDF and I/O API

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

#### Add environment module for I/O API

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

#### Add the following commands to your .cshrc

```
# start .cshrc


umask 002


if (! $?prompt) exit                    #exit if not interactive

#alias rm 'rm -i'
alias sh bash

limit stacksize unlimited

setenv LD_LIBRARY_PATH ""

module use --append  /home/ubuntu/Modules/modulefiles

set path = ($path /usr/bin )
```

#### Verify that the LD_LIBRARY_PATH is set correctly after loading the modules

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

### Secure MariaDB to only allow login from localhost

```
sudo mariadb-secure-installation
```

### Initialize a data directory for AMET for the user ubuntu
following these directions: https://mariadb.com/docs/server/clients-and-utilities/deployment-tools/mariadb-install-db
(couldn't seem to do it for the user ametsecure

```
sudo mariadb-install-db --user=ubuntu --basedir=/usr --datadir=/home/ubuntu/MariaDB/data
```

### Start the MariaDB server

```
sudo systemctl start mariadb
```

### Login as root and give permissions to ametsecure user

```
sudo mysql 
mysql> USE mysql;
mysql> CREATE USER 'YOUR_SYSTEM_USER'@'localhost' IDENTIFIED BY 'YOUR_PASSWD';
mysql> GRANT ALL PRIVILEGES ON *.* TO 'YOUR_SYSTEM_USER'@'localhost';
mysql> UPDATE user SET plugin='auth_socket' WHERE User='YOUR_SYSTEM_USER';
mysql> FLUSH PRIVILEGES;
mysql> exit;
```

### Verify system users

```
mysql> USE mysql;
mysql> SELECT User, Host, plugin FROM mysql.user;
```

Output

```
+-------------+-----------+-----------------------+
| User        | Host      | plugin                |
+-------------+-----------+-----------------------+
| mariadb.sys | localhost | mysql_native_password |
| root        | localhost | mysql_native_password |
| mysql       | localhost | mysql_native_password |
| ubuntu      | localhost | mysql_native_password |
| ametsecure  | localhost | mysql_native_password |
+-------------+-----------+-----------------------+
```

## Install R

```
sudo apt install r-base
```

### Install missing software required for R packages

```
sudo apt-get install libudunits2-dev
sudo apt-get install libssl-dev 
sudo apt-get install libgdal-dev
sudo apt-get install libmariadbclient-dev libmariadb-client-lgpl-dev libmariadb-dev
sudo apt-get install libharfbuzz-dev libfribidi-dev
sudo apt-get install libfontconfig1-dev
sudo apt-get install libgeos-dev libproj-dev
sudo apt-get install libabsl-dev
sudo apt install cmake
```

### Install additional R packages

```
sudo R
> install.packages(c("akima","data.table","date","dplyr","dygraphs","fields","ggplot2","grid","gridExtra","htmltools","htmlwidgets","lattice","latticeExtra","leaflet","leaflet.extras","leafpop","lubridate","maps","mapdata","plotly","plotrix","processx","reshape2","RColorBrewer","RMySQL","RMariaDB","stats","webshot","xts","pandoc","ncdf4"),repos="http://cran.r-project.org")
library()
```

output:

```
Packages in library ‘/usr/local/lib/R/site-library’:

akima                   Interpolation of Irregularly and Regularly
                        Spaced Data
askpass                 Password Entry Utilities for R, Git, and SSH
base64enc               Tools for base64 encoding
bit                     Classes and Methods for Fast Memory-Efficient
                        Boolean Selections
bit64                   A S3 Class for Vectors of 64bit Integers
blob                    A Simple S3 Class for Representing Vectors of
                        Binary Data ('BLOBS')
brew                    Templating Framework for Report Generation
bslib                   Custom 'Bootstrap' 'Sass' Themes for 'shiny'
                        and 'rmarkdown'
cachem                  Cache R Objects with Automatic Pruning
callr                   Call R from R
classInt                Choose Univariate Class Intervals
cli                     Helpers for Developing Command Line Interfaces
cpp11                   A C++11 Interface for R's C Interface
crosstalk               Inter-Widget Interactivity for HTML Widgets
curl                    A Modern and Flexible Web Client for R
data.table              Extension of `data.frame`
date                    Functions for Handling Dates
DBI                     R Database Interface
deldir                  Delaunay Triangulation and Dirichlet (Voronoi)
                        Tessellation
digest                  Create Compact Hash Digests of R Objects
dotCall64               Enhanced Foreign Function Interface Supporting
                        Long Vectors
dplyr                   A Grammar of Data Manipulation
dygraphs                Interface to 'Dygraphs' Interactive Time Series
                        Charting Library
e1071                   Misc Functions of the Department of Statistics,
                        Probability Theory Group (Formerly: E1071), TU
                        Wien
evaluate                Parsing and Evaluation Tools that Provide More
                        Details than the Default
farver                  High Performance Colour Space Manipulation
fastmap                 Fast Data Structures
fields                  Tools for Spatial Data
fontawesome             Easily Work with 'Font Awesome' Icons
fs                      Cross-Platform File System Operations Based on
                        'libuv'
generics                Common S3 Generics not Provided by Base R
                        Methods Related to Model Fitting
ggplot2                 Create Elegant Data Visualisations Using the
                        Grammar of Graphics
glue                    Interpreted String Literals
gridExtra               Miscellaneous Functions for "Grid" Graphics
gtable                  Arrange 'Grobs' in Tables
highr                   Syntax Highlighting for R Source Code
hms                     Pretty Time of Day
htmltools               Tools for HTML
htmlwidgets             HTML Widgets for R
httr                    Tools for Working with URLs and HTTP
interp                  Interpolation Methods
isoband                 Generate Isolines and Isobands from Regularly
                        Spaced Elevation Grids
jpeg                    Read and write JPEG images
jquerylib               Obtain 'jQuery' as an HTML Dependency Object
jsonlite                A Simple and Robust JSON Parser and Generator
                        for R
knitr                   A General-Purpose Package for Dynamic Report
                        Generation in R
labeling                Axis Labeling
later                   Utilities for Scheduling Functions to Execute
                        Later with Event Loops
lattice                 Trellis Graphics for R
latticeExtra            Extra Graphical Utilities Based on Lattice
lazyeval                Lazy (Non-Standard) Evaluation
leaflet                 Create Interactive Web Maps with the JavaScript
                        'Leaflet' Library
leaflet.extras          Extra Functionality for 'leaflet' Package
leaflet.providers       Leaflet Providers
leafpop                 Include Tables, Images and Graphs in Leaflet
                        Pop-Ups
lifecycle               Manage the Life Cycle of your Package Functions
lubridate               Make Dealing with Dates a Little Easier
magrittr                A Forward-Pipe Operator for R
mapdata                 Extra Map Databases
maps                    Draw Geographical Maps
memoise                 'Memoisation' of Functions
mime                    Map Filenames to MIME Types
openssl                 Toolkit for Encryption, Signatures and
                        Certificates Based on OpenSSL
pandoc                  Manage and Run Universal Converter 'Pandoc'
                        from 'R'
pillar                  Coloured Formatting for Columns
pkgconfig               Private Configuration for 'R' Packages
plogr                   The 'plog' C++ Logging Library
plotly                  Create Interactive Web Graphics via 'plotly.js'
plotrix                 Various Plotting Functions
plyr                    Tools for Splitting, Applying and Combining
                        Data
png                     Read and write PNG images
processx                Execute and Control System Processes
promises                Abstractions for Promise-Based Asynchronous
                        Programming
proxy                   Distance and Similarity Measures
ps                      List, Query, Manipulate System Processes
purrr                   Functional Programming Tools
R6                      Encapsulated Classes with Reference Semantics
rappdirs                Application Directories: Determine Where to
                        Save Data, Caches, and Logs
raster                  Geographic Data Analysis and Modeling
RColorBrewer            ColorBrewer Palettes
Rcpp                    Seamless R and C++ Integration
RcppEigen               'Rcpp' Integration for the 'Eigen' Templated
                        Linear Algebra Library
reshape2                Flexibly Reshape Data: A Reboot of the Reshape
                        Package
rlang                   Functions for Base Types and Core R and
                        'Tidyverse' Features
RMariaDB                Database Interface and MariaDB Driver
rmarkdown               Dynamic Documents for R
RMySQL                  Database Interface and 'MySQL' Driver for R
s2                      Spherical Geometry Operators Using the S2
                        Geometry Library
S7                      An Object Oriented System Meant to Become a
                        Successor to S3 and S4
sass                    Syntactically Awesome Style Sheets ('Sass')
scales                  Scale Functions for Visualization
sf                      Simple Features for R
sp                      Classes and Methods for Spatial Data
spam                    SPArse Matrix
stringi                 Fast and Portable Character String Processing
                        Facilities
stringr                 Simple, Consistent Wrappers for Common String
                        Operations
svglite                 An 'SVG' Graphics Device
sys                     Powerful and Reliable Tools for Running System
                        Commands in R
systemfonts             System Native Font Finding
terra                   Spatial Data Analysis
textshaping             Bindings to the 'HarfBuzz' and 'Fribidi'
                        Libraries for Text Shaping
tibble                  Simple Data Frames
tidyr                   Tidy Messy Data
tidyselect              Select from a Set of Strings
timechange              Efficient Manipulation of Date-Times
tinytex                 Helper Functions to Install and Maintain TeX
                        Live, and Compile LaTeX Documents
units                   Measurement Units for R Vectors
utf8                    Unicode Text Processing
uuid                    Tools for Generating and Handling of UUIDs
vctrs                   Vector Helpers
viridisLite             Colorblind-Friendly Color Maps (Lite Version)
webshot                 Take Screenshots of Web Pages
withr                   Run Code 'With' Temporarily Modified Global
                        State
wk                      Lightweight Well-Known Geometry Parsing
xfun                    Supporting Functions for Packages Maintained by
                        'Yihui Xie'
xts                     eXtensible Time Series
yaml                    Methods to Convert R Data to YAML and Back
zoo                     S3 Infrastructure for Regular and Irregular
                        Time Series (Z's Ordered Observations)
```

## Download AMETv1.6

```
git clone -b 1.6 https://github.com/USEPA/AMET.git AMET_v16
```

### Build tools_src

Edit makefile to specify location of the libraries, and also use  -fallow-argument-mismatch flag

### Install java

```
sudo apt install default-jre
```

### try to run AMETGUI

Error: Unable to access jarfile /home/ubuntu/AMET_v16/AMETGUI/dist/AMETJavaGUI.jar

### building AMETGUI jar file 

This will take some time, but there are instructions


### Mount the 1000G EBS filesystem

```
sudo mkdir /shared
lsblk
sudo mkfs -t xfs /dev/nvme1n1
sudo mount /dev/nvme1n1 /shared
sudo chown ubuntu /shared
cd /shared
mkdir -p AMET_v16/model_data
```

### Obtain example AQ data
```
wget https://cmas-amet.s3.amazonaws.com/AMET/v1.6_example/AQ/aqExample/COMBINE_ACONC_aqExample_201807.nc
wget https://cmas-amet.s3.amazonaws.com/AMET/v1.6_example/AQ/aqExample/COMBINE_DEP_aqExample_201807.nc
```

### Download aws cli

```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

### Obtain example MET data

```
cd ~/AMET_v16/model_data/MET/metExample_wrf
aws s3 --no-sign-request --region=us-east-1 cp --recursive s3://cmas-amet/AMET/v1.5_example/MET/metExample_wrf/ .
cd ~/AMET_v16/model_data/MET/metExample_mcip
aws s3 --no-sign-request --region=us-east-1 cp --recursive s3://cmas-amet/AMET/v1.5_example/MET/metExample_mcip/ .
cd ~/AMET_v16/model_data/MET/metExample_mpas
aws s3 --no-sign-request --region=us-east-1 cp --recursive s3://cmas-amet/AMET/v1.5_example/MET/metExample_mpas/ .
```

### Extract example metExample_mcip data

```
#!/bin/csh
foreach i (*.tar.gz)
    tar -xzvf $i
    rm $i     ! need to remove tar.gz file after extraction to avoid filling up disk
end
```

Note, ran out of disk space on /shared, so I had to resize the volume to 1000 G, this also requires a wait on the EBS volume being optimized.
This process takes a long time - 15 hours. It is best to get the size correct when you create the instance, rather than having to resize it.

Then I need to resize the xfs volume using the following command:

```
sudo lsblk
sudo xfs_growfs -d /shared  ! need to verify this is the volume and partition listed in the sudo lsblk command
```

### Verify that the size has been increased

```
df -h
Filesystem       Size  Used Avail Use% Mounted on
/dev/root         29G  7.9G   21G  29% /
tmpfs            1.9G     0  1.9G   0% /dev/shm
tmpfs            768M  908K  767M   1% /run
tmpfs            5.0M     0  5.0M   0% /run/lock
efivarfs         128K  4.1K  119K   4% /sys/firmware/efi/efivars
/dev/nvme0n1p16  881M  151M  669M  19% /boot
/dev/nvme0n1p15  105M  6.2M   99M   6% /boot/efi
/dev/nvme1n1    1000G  494G  506G  50% /shared
tmpfs            384M   16K  384M   1% /run/user/1000
```

### Obtain example AQS Obs data

```
cd ~/AMET_v16/obs/AQ
wget https://cmas-amet.s3.amazonaws.com/AMET/2000_2024_NAmerican_AQ_Obs_Data/AMET_obsdata_2018.tar.gz
tar -xzvf AMET_obsdata_2018.tar.gz
```

### Install wgrib on ubuntu

https://www.cpc.ncep.noaa.gov/products/wesley/wgrib.html
 
```
mkdir -p ~/LIBRARIES/LIBRARIES_gcc/wgrib
cd ~/LIBRARIES/LIBRARIES_gcc/wgrib
wget https://ftp.cpc.ncep.noaa.gov/wd51we/wgrib/wgrib.tar
tar -xvf wgrib.tar
cd wgrib
make |& tee make.log
```
Add the path to the wgrib executible to your .cshrc

```
set path = ($path /usr/bin /usr/lib/ /usr/local/bin/ ~/LIBRARIES/LIBRARIES_gcc/wgrib )
```

### Edit amet-config.R

Add the following:

```
## Misc Executables 
Bldoverlay_exe_config    <- paste(amet_base,"/bin/bldoverlay.exe",sep="")       ## Full path to build overlay executable
EXEC_sitex_daily_config  <- paste(amet_base,"/bin/sitecmp_dailyo3.exe",sep="") ## Full path to site compare daily executable
EXEC_sitex_config        <- paste(amet_base,"/bin/sitecmp.exe",sep="")          ## Full path to site compare executable
```

### Set the AMETBASE environment variable
setenv AMETBASE /home/ubuntu/AMET_v16

### These instructions assumes that the amet database has been created, but it hasn't been yet.

https://github.com/USEPA/AMET/blob/1.6/docs/AMET_User_Guide_v16.md#52-basic-mysql-commands

```
 mysql -u ametsecure -D amet -p
Enter password: 
ERROR 1049 (42000): Unknown database 'amet'
```

Now getting error

```
./create_amet_user.csh
Creating new AMET user
Enter the MYSQL root user, root: 
Enter the MYSQL root user password (no terminal echo): \nEnter the AMET username to create: ametsecure
Enter the AMET user password (no terminal echo): \nRe-enter the AMET user password (no terminal echo): 
Creating or modifying user ametsecure...
Failed to grant new user privileges with the error: Error : Access denied for user 'ubuntu'@'localhost' (using password: YES) [1045]
.Error: 
Execution halted
Warning message:
call dbDisconnect() when finished working with a connection 
```

I had already added the ametsecure user, so, I think it will be ok to proceed, and skip this step.


### Try running metExample_wrf

```
cd $AMETBASE/scripts_db/metExample_wrf
./matching_surface.csh |& tee log.populate.sfc
Enter the AMET user password: 
Date/Time START
Wed Sep 24 16:04:10 UTC 2025
Loading required package: RMariaDB
Loading required package: date
Loading required package: ncdf4
Error: Required Package ncdf4 was not loaded
Execution halted
Date/Time END
Wed Sep 24 16:04:11 UTC 2025
```

Added ncdf4 to the list of packages to be installed from cran.

### Reran after installing necdf4.

The data is currently loading into the amet table.

Getting message that there is no space on the device.
gzip: 20160706_2300: No space left on device


### Modify root volume to be 300 GB instead of 30 GB.


### missing linkem.csh script

This script is referenced in these instructions: https://github.com/USEPA/AMET/blob/1.6/docs/AMET_Install_Guide_v16.md#install-amet-source-code-and-tier-3-software

```
Note, the combine script directory contains a script called linkem that needs to be edited to point to your CMAQv5.5+ REPO directory to obtain the species definition files.

cd $AMETBASE/tools_src/combine/scripts/spec_def_files
vi linkem.csh

Modify the set src = line to point to the CMAQv5.5+ Repository.

set src = /path_to/CMAQ/CMAQv5.5+/build/CMAQ_REPO_v5.5+/CCTM/src/MECHS

modify to the path for your CMAQ installation directory

set src = /path_to/CMAQ_REPO/CCTM/src/MECHS

Then run the linkem.csh script to create links to the species definition files.

./linkem.csh
```

It looks like the aqProject_pre_and_post.csh script is referencing combine and the species definition files directly from CMAQv5.5:
Need to download the CMAQ code and also include that as a requirement.

```
# =====================================================================
#> 4. Combine Configuration Options
# =====================================================================

#> Set the full path of combine executable.
 setenv EXEC_combine ${CMAQ_HOME}/POST/combine/scripts/BLD_combine_${VRSN}_${compiler}${compilerVrsn}/combine_${VRSN}.exe

#> Set location of species definition files for concentration and deposition species needed to run combine.
 setenv SPEC_CONC  ${CMAQ_HOME}/POST/combine/scripts/spec_def_files/SpecDef_${MECH}.txt
 setenv SPEC_DEP   ${CMAQ_HOME}/POST/combine/scripts/spec_def_files/SpecDef_Dep_${MECH}.txt

```

### Grow the root partition

```
df -T
Filesystem      Type      1K-blocks      Used Available Use% Mounted on
/dev/root       ext4       29378688  29348668     13636 100% /
tmpfs           tmpfs       1964536         0   1964536   0% /dev/shm
tmpfs           tmpfs        785816       916    784900   1% /run
tmpfs           tmpfs          5120         0      5120   0% /run/lock
efivarfs        efivarfs        128         5       119   4% /sys/firmware/efi/efivars
/dev/nvme0n1p16 ext4         901520    153796    684596  19% /boot
/dev/nvme0n1p15 vfat         106832      6250    100582   6% /boot/efi
/dev/nvme1n1    xfs      1048320000 934988208 113331792  90% /shared
tmpfs           tmpfs        392904        16    392888   1% /run/user/1000

ip-172-31-16-32:~/AMET_v16/model_data/MET/metExample_mcip% sudo growpart /dev/nvme0n1 1

This step seems to be taking awhile.. Should have saved the root volume to a snapshot.
```

This seemed to resize, but didn't change the available space on /root

```
df -h
Filesystem       Size  Used Avail Use% Mounted on
/dev/root         29G   28G   14M 100% /
tmpfs            1.9G     0  1.9G   0% /dev/shm
tmpfs            768M  916K  767M   1% /run
tmpfs            5.0M     0  5.0M   0% /run/lock
efivarfs         128K  4.1K  119K   4% /sys/firmware/efi/efivars
/dev/nvme0n1p16  881M  151M  669M  19% /boot
/dev/nvme0n1p15  105M  6.2M   99M   6% /boot/efi
/dev/nvme1n1    1000G  904G   96G  91% /shared
tmpfs            384M   16K  384M   1% /run/user/1000
```
### Resize the partition

```
sudo resize2fs /dev/nvme0n1p1
```

This worked, now have 290G available.
```
df -hT
Filesystem      Type      Size  Used Avail Use% Mounted on
/dev/root       ext4      290G   28G  262G  10% /
tmpfs           tmpfs     1.9G     0  1.9G   0% /dev/shm
tmpfs           tmpfs     768M  916K  767M   1% /run
tmpfs           tmpfs     5.0M     0  5.0M   0% /run/lock
efivarfs        efivarfs  128K  4.1K  119K   4% /sys/firmware/efi/efivars
/dev/nvme0n1p16 ext4      881M  151M  669M  19% /boot
/dev/nvme0n1p15 vfat      105M  6.2M   99M   6% /boot/efi
/dev/nvme1n1    xfs      1000G  908G   92G  91% /shared
tmpfs           tmpfs     384M   16K  384M   1% /run/user/1000
```


### Install CMAQ

```
git clone -b 5.5+ https://github.com/USEPA/CMAQ.git CMAQ55plus_REPO
```

### Load Modules

```
module load ioapi-3.2/gcc-13.3  netcdf/gcc-13.3  openmpi/gcc  
```

### edit bldit_cctm.csh script

```
cd /home/ubuntu/CMAQ55plus_REPO
vi bldit_project.csh
modify CMAQ_HOME to use !!! set CMAQ_HOME = /home/ubuntu/CMAQv5.5+
./bldit_project.csh
cd /home/ubuntu/CMAQv5.5+
edit the config_cmaq.csh script to specify the paths of the netCDF and I/O API Libraries
```

### find the location of the openmpi include files to specify in the config_cmaq.csh

```
mpicc -showme 
```

Output

```
gcc -I/usr/lib/x86_64-linux-gnu/openmpi/include -I/usr/lib/x86_64-linux-gnu/openmpi/include/openmpi -L/usr/lib/x86_64-linux-gnu/openmpi/lib -lmpi
```

### Edit the  aqProject_pre_and_post.csh script

cp ./CMAQ55plus_REPO/POST/hr2day/inputs/tz.csv ${CMAQ_HOME}/POST/hr2day/inputs/tz.csv

### Run aqProject_pre_and_post.csh script

```
./aqProject_pre_and_post.csh |& tee ./aqProject_pre_and_post.log
```

Output
```
 Inserting metadata for station AM0098E for NAMN network
 Inserting metadata for station AM0099E for NAMN network
 Inserting metadata for station AM0100E for NAMN network
 Inserting metadata for station AM0101E for NAMN network
 Inserting metadata for station AM0102E for NAMN network
 Inserting metadata for station AM0103E for NAMN network
 Warning message:
call dbDisconnect() when finished working with a connection 
done. 
Warning messages:
1: call dbDisconnect() when finished working with a connection 
2: call dbDisconnect() when finished working with a connection 
**Checking to see if AQ project table exists, if not create it. Will update existing table if requested.**
Done with project table creation.
**Populating new AQ project.  This may take some time....
```

Getting an error when trying to use chromium to display html files.

eglInitialize OpenGL failed with error EGL_NOT_INITIALIZED, trying next display type
[12499:12499:0925/144643.310809:ERROR:ui/gl/angle_platform_impl.cc:42] Display.cpp:1089 (initialize): ANGLE Display::initialize error 12289: Cannot create an OpenGL ES platform on GLX without the GLX_ARB_create_context extension.

Also getting an error when try to use chromium to display html or pdf files.

Added the following to the .bashrc
export XAUTHORITY=$HOME/.Xauthority

### Load MET data

To load the mpas data into the database, a larger memory machine would be needed.

### Automount /shared

follow these instructions: https://docs.aws.amazon.com/ebs/latest/userguide/ebs-using-volumes.html

### Creating an AMI of this EC2 instance.

### Install php and 

```
sudo apt-get php
sudo apt-get install php-mysql
```

I can see the text from the php files now.

First I run the following command in one window:

```
cd /home/ubuntu/AMET_v16/AMET_Website
php -S 0.0.0.0:8000 querygen_aq.php
```

Then in a separate login, I use the following command:

```
cd /home/ubuntu/AMET_v16/AMET_Website
chromium http://0.0.0.0:8000/querygen_aq.php

```

I can see the website, and in the original php -S window, I get the following errors:

```
[Thu Sep 25 21:18:52 2025] PHP 8.3.6 Development Server (http://0.0.0.0:8000) started
[Thu Sep 25 21:19:05 2025] 127.0.0.1:36810 Accepted
[Thu Sep 25 21:19:05 2025] PHP Warning:  Undefined array key "project_id" in /home/ubuntu/AMET_v16/AMET_Website/querygen_aq.php on line 131
[Thu Sep 25 21:19:05 2025] PHP Warning:  Undefined array key "POCode" in /home/ubuntu/AMET_v16/AMET_Website/querygen_aq.php on line 165
[Thu Sep 25 21:19:05 2025] PHP Warning:  Undefined array key "DoW" in /home/ubuntu/AMET_v16/AMET_Website/querygen_aq.php on line 166
[Thu Sep 25 21:19:05 2025] PHP Warning:  Undefined array key "Filter" in /home/ubuntu/AMET_v16/AMET_Website/querygen_aq.php on line 167
[Thu Sep 25 21:19:05 2025] PHP Warning:  Undefined array key "Non_Filter" in /home/ubuntu/AMET_v16/AMET_Website/querygen_aq.php on line 168
[Thu Sep 25 21:19:05 2025] PHP Warning:  Undefined array key "Method_Code" in /home/ubuntu/AMET_v16/AMET_Website/querygen_aq.php on line 169
[Thu Sep 25 21:19:05 2025] PHP Warning:  Undefined array key "O3_NA_Sites" in /home/ubuntu/AMET_v16/AMET_Website/querygen_aq.php on line 170
[Thu Sep 25 21:19:05 2025] PHP Warning:  Undefined array key "custom_query" in /home/ubuntu/AMET_v16/AMET_Website/querygen_aq.php on line 171
[Thu Sep 25 21:19:05 2025] PHP Warning:  Undefined array key "submit" in /home/ubuntu/AMET_v16/AMET_Website/querygen_aq.php on line 177
[Thu Sep 25 21:19:05 2025] PHP Fatal error:  Uncaught mysqli_sql_exception: MySQL server has gone away in /home/ubuntu/AMET_v16/AMET_Website/querygen_aq.php:2405
Stack trace:
#0 /home/ubuntu/AMET_v16/AMET_Website/querygen_aq.php(2405): mysqli->real_connect()
#1 {main}
  thrown in /home/ubuntu/AMET_v16/AMET_Website/querygen_aq.php on line 2405
[Thu Sep 25 21:19:05 2025] 127.0.0.1:36810 [200]: GET /querygen_aq.php - Uncaught mysqli_sql_exception: MySQL server has gone away in /home/ubuntu/AMET_v16/AMET_Website/querygen_aq.php:2405
Stack trace:
#0 /home/ubuntu/AMET_v16/AMET_Website/querygen_aq.php(2405): mysqli->real_connect()
#1 {main}
  thrown in /home/ubuntu/AMET_v16/AMET_Website/querygen_aq.php on line 2405
[Thu Sep 25 21:19:05 2025] 127.0.0.1:36810 Closing
[Thu Sep 25 21:19:05 2025] 127.0.0.1:36816 Accepted
[Thu Sep 25 21:19:05 2025] 127.0.0.1:36818 Accepted
[Thu Sep 25 21:19:05 2025] 127.0.0.1:36816 [404]: GET /general.css - No such file or directory
[Thu Sep 25 21:19:05 2025] 127.0.0.1:36816 Closing
```

If it can't connect to the database, then restart it.

```
sudo systemctl start mariadb
```

I am using firefox to connect

```
firefox http://0.0.0.0:8000/querygen_aq.php
```

Other method is to use ssh port tunneling to reduce the time it takes to respond to the website.

Installed the code to /var/www/html

```
/var/www/html$ ls -rlt
total 720
-rw-rw-r-- 1 www-data www-data   4333 Sep 23 17:55 AMET_Species_Name_Mapping.txt
-rw-rw-r-- 1 www-data www-data    420 Sep 23 17:55 example_stat_file.txt
-rw-rw-r-- 1 www-data www-data   2283 Sep 23 17:55 disaq_4km_met_sites.txt
-rw-rw-r-- 1 www-data www-data    331 Sep 23 17:55 disaq_1km_met_sites.txt
-rw-rw-r-- 1 www-data www-data   2700 Sep 23 17:55 O3_NA_monitors_2018.txt
-rw-rw-r-- 1 www-data www-data   8434 Sep 23 17:55 O3_NAA_Sites_v2_short_names.txt
-rw-rw-r-- 1 www-data www-data   4257 Sep 23 17:55 O3_NAA_Sites_v2_no_names.txt
drwxrwxr-x 2 www-data www-data   4096 Sep 23 17:55 images
-rw-rw-r-- 1 www-data www-data   6475 Sep 23 17:55 run_info_met.template
-rw-r--r-- 1 www-data www-data  10671 Sep 25 18:41 index.html.back
-rw-rw-r-- 1 www-data www-data    286 Sep 25 19:47 index.html.sv
-rwxrwxr-x 1 www-data www-data 259423 Sep 29 18:30 querygen_met.php
-rw-rw-r-- 1 www-data www-data   3861 Oct 10 17:10 amet-lib.php
-rwxrwxr-x 1 www-data www-data   2061 Oct 10 17:24 amet-config.R
-rw-rw-r-- 1 www-data www-data   2084 Oct 10 17:27 amet-www-config.php
-rw-rw-r-- 1 www-data www-data  11397 Oct 10 17:30 run_info.template
-rwxrwxr-x 1 ubuntu   ubuntu   362697 Oct 10 19:58 querygen_aq.php
```

Edited the querygen_aq.php to login to the mysql database

When starting a new EC2 instance from a saved AMI, you will need to verify that the apache webserver is running

```
sudo netstat -tnlp | grep :443
```

I will likely have failed, as the new EC2 instance has a different internal IP address than what is in the port.conf file.
 
Edit the apache2 ports.conf file to specify the private IP address for the EC2 instance that is being used to run AMETv1.6

sudo vi /etc/apache2/ports.conf

```
cat /etc/apache2/ports.conf
```

Output:

```
### If you just change the port or add more ports here, you will likely also
### have to change the VirtualHost statement in
### /etc/apache2/sites-enabled/000-default.conf

Listen 80
Listen 172.31.16.32:443
#Listen 3306

<IfModule ssl_module>
        Listen 443
</IfModule>

<IfModule mod_gnutls.c>
        Listen 443
</IfModule>


<VirtualHost 172.31.16.32:443>

## This first-listed virtual host is also the default for *:80

ServerName http://localhost

DocumentRoot /var/www/html
</VirtualHost>
```

After the file is edited to use the private ip address, then restart the apache web server.

```
sudo systemctl restart apache2
```

To view the website, use the public IP address for the ec2 server in the following command on a web browser:

```
http://54.89.147.142:443/querygen_aq.php
```


