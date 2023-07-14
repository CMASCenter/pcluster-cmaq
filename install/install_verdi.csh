#!/bin/csh -f

#  ---------------------------
#  Install VERDI 2.1.2 
#  ---------------------------



## Install java
###To solve binary incompatibility issue for version of java installed with package

   sudo apt install openjdk-17-jdk

   cd /shared/build
   wget https://github.com/CEMPD/VERDI/releases/download/2.1.1/VERDI_2.1.2_linux64_20211221.tar.gz
   tar -xvf VERDI_2.1.2_linux64_20211221.tar.gz
 
   cd   /shared/build/VERDI_2.1.2/
   sed -i 's/..\/..\/jre\/bin\/java/\/usr\/bin\/java/g' verdi.sh

### Add module file for VERDI
   cd  /shared/build/Modules/modulefiles
   mkdir -p verdi
   cd verdi
   cp /shared/pcluster-cmaq/install/verdi-2.1.2 .
