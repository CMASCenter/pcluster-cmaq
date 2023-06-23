#!/bin/csh -f
set echo

#  --------------------------------------
#  Add /usr/local/lib to the library path
#  --------------------------------------
#   if [ -z ${LD_LIBRARY_PATH} ]
#   then
#      export LD_LIBRARY_PATH=/usr/local/lib
#   else
#      export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib
#   fi
#  ----------------------
#  Unpack and build IOAPI
#  ----------------------
   setenv DIR /shared/build
   setenv PDIR /shared/pcluster-cmaq
   cd $DIR
   git clone https://github.com/cjcoats/ioapi-3.2
   #git clone -b main https://github.com/lizadams/pcluster-cmaq.git pcluster-cmaq
   cd ioapi-3.2
   #git checkout -b 20200828
   setenv BASEDIR $DIR/ioapi-3.2
   setenv BIN Linux2_x86_64gfort
   mkdir $BASEDIR/$BIN
   setenv CPLMODE nocpl
   cd ioapi 
   # need to copy Makefile to fix BASEDIR setting from HOME to /shared/build/ioapi-3.2
   cp $PDIR/Makefile.basedir_fix $BASEDIR/ioapi/Makefile
   # need updated Makefile to include ‘-DIOAPI_NCF4=1’ to the MFLAGS make-variable to avoid multiple definition of `nf_get_vara_int64_’
   cp $PDIR/Makeinclude.Linux2_x86_64gfort $BASEDIR/ioapi/
   make HOME=$DIR |& tee make.log
   cd $BASEDIR/m3tools
   cp $PDIR/Makefile.fix_ioapi_lib_path Makefile
   make HOME=$DIR
