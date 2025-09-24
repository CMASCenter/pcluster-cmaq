# Create EC2 instance for AMETv1.6 installation

## Launch EC2 instance from the AWS Console 

Name the instance AMETv1.6<br>
Select Ubuntu AMI from the quickstart option.<br>
Select the t3.medium instance type <br>
Create a pem key <br>
Configure storage, select 100 GB for root, and select new volume with 1000 GB of EBS storage<br>
Launch Instance<br>

## Login to EC2 instance using the pem key

## Update Linux

```
sudo apt-get update && sudo apt-get upgrade -y
```

### Reboot and then relogin

Use the console to reboot the instance

## Install Compilers and Libraries

### Install GCC 

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


### Try running

```
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


