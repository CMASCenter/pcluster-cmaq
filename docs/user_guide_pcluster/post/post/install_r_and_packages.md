## Install R, Rscripts and Packages

First check to see if R is already installed.

`R --version`

If not, Install R on Ubuntu 2004 instructions available in the link below.

```{seealso}
<a href="https://linuxize.com/post/how-to-install-r-on-ubuntu-20-04">Install R on Ubuntu 2004</a>
```

`sudo apt install build-essential`

```{seealso}
<a href="https://grasswiki.osgeo.org/wiki/Compile_and_Install_Ubuntu">ubuntu install</a>
```

Install geospatial dependencies

be sure to have an updated system

`sudo apt-get update && sudo apt-get upgrade -y`

install PROJ

`sudo apt-get install libproj-dev proj-data proj-bin unzip -y`

optionally, install (selected) datum grid files

`sudo apt-get install proj-data`

install GEOS

`sudo apt-get install libgeos-dev -y`

install GDAL

`sudo apt-get install libgdal-dev python3-gdal gdal-bin -y`

install PDAL (optional)

`sudo apt-get install libpdal-dev pdal libpdal-plugin-python -y`


recommended to give Python3 precedence over Python2 (which is end-of-life since 2019)

`sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1`

Install software for diagram

`sudo apt-get install graphviz`

`pip install diagrams`

Install further compilation dependencies (Ubuntu 20.04)

```
sudo apt-get install \
  build-essential \
  flex make bison gcc libgcc1 g++ ccache \
  python3 python3-dev \
  python3-opengl python3-wxgtk4.0 \
  python3-dateutil libgsl-dev python3-numpy \
  wx3.0-headers wx-common libwxgtk3.0-gtk3-dev \
  libwxbase3.0-dev   \
  libncurses5-dev \
  libbz2-dev \
  zlib1g-dev gettext \
  libtiff5-dev libpnglite-dev \
  libcairo2 libcairo2-dev \
  sqlite3 libsqlite3-dev \
  libpq-dev \
  libreadline6-dev libfreetype6-dev \
  libfftw3-3 libfftw3-dev \
  libboost-thread-dev libboost-program-options-dev  libpdal-dev\
  subversion libzstd-dev \
  checkinstall \
  libglu1-mesa-dev libxmu-dev \
  ghostscript wget -y
```

For NVIZ on Ubuntu 20.04:

```
sudo apt-get install \
  ffmpeg libavutil-dev ffmpeg2theora \
  libffmpegthumbnailer-dev \
  libavcodec-dev \
  libxmu-dev \
  libavformat-dev libswscale-dev
```

ncdf4 package REQUIRES the netcdf library be version 4 or above, AND installed with HDF-5 support (i.e., the netcdf library must be compiled with the --enable-netcdf-4 flag).
Building netcdf with HDF5 support requires curl.

```
sudo apt-get install curl
sudo apt-get install libcurl4-openssl-dev
```

`cd /shared/pcluster-cmaq`

Install libraries with hdf5 support

Load modules

`module load openmpi/4.1.1 `

`module load libfabric-aws/1.13.2amzn1.0`

`./gcc_install_hdf5.pcluster.csh`

Install ncdf4 package from source:

`cd /shared/pcluster-cmaq/qa_scripts/R_packages`

`sudo R CMD INSTALL ncdf4_1.13.tar.gz --configure-args="--with-nc-config=/shared/build-hdf5/install/bin/nc-config"`

Install packages used in the R scripts
```
sudo -i R
install.packages("rgdal")
install.packages("M3")
install.packages("fields")
install.packages("mapdata")
install.packages("ggplot2")
install.packages("patchwork")
```

Install M3 

`cd /shared/pcluster-cmaq/qa_scripts/R_packages`

`sudo R CMD INSTALL M3_0.3.tar.gz'

Install pdftoppm to convert pdf files to images

`sudo apt install poppler-utils`

To view the script, install imagemagick

`sudo apt-get install imagemagick`

Install X11

`sudo apt install x11-apps`

Enable X11 forwarding

`sudo vi /etc/ssh/sshd_config`

add line

X11Forwarding yes

Verify that it was added

`sudo cat /etc/ssh/sshd_config | grep -i X11Forwarding`

Restart ssh

`sudo service ssh restart`

Exit the cluster

`exit`


Be sure that you have Xquartz running if your local machine is a mac.
Also that the DISPLAY environment variable is set.

For example in my .zshrc, I use the following setting

`export DISPLAY=:0`

If you modify your .zshrc, then resource it

`source ~/.zshrc`

Re-login to the cluster

`pcluster ssh -v -Y -i ~/your-key.pem --cluster-name cmaq`


Test display

`display xclock`

Install firefox

```
sudo apt-get install firefox
```


```{seealso}
<a href=https://docs.aws.amazon.com/parallelcluster/latest/ug/dcv.html>NICE DCV Settings in YAML</a>
```

Note, it looks like the examples are using the older config or CLI 2 format, and need to convert this to a yaml format to try it out.

```{seealso}
<a href="https://github.com/aws/aws-parallelcluster/issues/1508">X11 forwarding no loner enabled on master node</a>
```

The bug says that you can use a custom post installation script to re-enable X11 Forwarding.

```{seealso}
<a href="https://docs.aws.amazon.com/en_us/parallelcluster/latest/ug/pre_post_install.html">Custom Bootstrap Actions</a>
```


