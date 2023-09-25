#!/bin/csh

setenv BASE  /shared/build/openmpi_gcc/CMAQ_v54+/data/output/output_v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x64_classic/
setenv SENS  /shared/build/openmpi_gcc/CMAQ_v54+/data/output/output_v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x64_classic_DESID_REDUCE/
verdi.sh -f $BASE/CCTM_AELMO_v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x64_classic_20171222.nc -f $SENS/CCTM_AELMO_v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x64_classic_DESID_REDUCE_20171222.nc -configFile /shared/pcluster-cmaq/workshop/PM25_NY_PTEGU_EMIS_REDUCED_config -s "SO2[1]" -g tile -s "SO2[2]" -g tile -s "SO2[1]-SO2[2]" -g tile

