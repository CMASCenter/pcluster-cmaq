# Scripts to run combine and post processing 


### Build the POST processing routines

cd /shared/build/openmpi_gcc/CMAQ_v533/POST/combine/scripts
./bldit_combine.csh gcc |& tee ./bldit_combine.gcc.log

cd /shared/build/openmpi_gcc/CMAQ_v533/POST/calc_tmetric/scripts
./bldit_calc_tmetric.csh gcc |& tee ./bldit_calc_tmetric.gcc.log

cd /shared/build/openmpi_gcc/CMAQ_v533/POST/hr2day/scripts
./bldit_hr2day.csh gcc |& tee ./bldit_hr2day.gcc.log

cd /shared/build/openmpi_gcc/CMAQ_v533/POST/bldoverlay/scripts
./bldit_bldoverlay.csh gcc |& tee ./bldit_bldoverlay.gcc.log

