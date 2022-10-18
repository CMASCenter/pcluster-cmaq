## Scripts to run combine and post processing 


### Build the POST processing routines

cd /shared/build/openmpi_gcc/CMAQ_v533/POST/combine/scripts
./bldit_combine.csh gcc |& tee ./bldit_combine.gcc.log

cd /shared/build/openmpi_gcc/CMAQ_v533/POST/calc_tmetric/scripts
./bldit_calc_tmetric.csh gcc |& tee ./bldit_calc_tmetric.gcc.log

cd /shared/build/openmpi_gcc/CMAQ_v533/POST/hr2day/scripts
./bldit_hr2day.csh gcc |& tee ./bldit_hr2day.gcc.log

cd /shared/build/openmpi_gcc/CMAQ_v533/POST/bldoverlay/scripts
./bldit_bldoverlay.csh gcc |& tee ./bldit_bldoverlay.gcc.log


## Scripts to post-process CMAQ output

Instructions on how to Post-process CMAQ using the utilities under the POST directory

```{note}
The post-processing analysis is run on the head node.
```
>>>>>>> 7d8784ed1938caf49a2b8496ed374e4a3553a973:docs/user_guide_pcluster/post/post_process_pcluster.md

Verify that the compute nodes are no longer running if you have completed all of the benchmark runs

`squeue`

You should see that no jobs are running.

Show compute nodes

`scontrol show nodes`


### Edit, Build and Run the POST processing routines

```
setenv DIR /shared/build/openmpi_gcc/CMAQ_v533/

cd $DIR/POST/combine/scripts
sed -i 's/v532/v533/g' bldit_combine.csh
./bldit_combine.csh gcc |& tee ./bldit_combine.gcc.log

cp run_combine.csh run_combine_conus.csh
sed -i 's/v532/v533/g' run_combine_conus.csh
sed -i 's/Bench_2016_12SE1/2016_CONUS_16x18pe/g' run_combine_conus.csh
sed -i 's/intel/gcc/g' run_combine_conus.csh
sed -i 's/2016-07-01/2015-12-22/g' run_combine_conus.csh
sed -i 's/2016-07-14/2015-12-23/g' run_combine_conus.csh
setenv CMAQ_DATA /fsx/data
./run_combine_conus.csh

cd $DIR/POST/calc_tmetric/scripts
sed -i 's/v532/v533/g' bldit_calc_tmetric.csh
./bldit_calc_tmetric.csh gcc |& tee ./bldit_calc_tmetric.gcc.log

cp run_calc_tmetric.csh run_calc_tmetric_conus.csh
sed -i 's/v532/v533/g' run_calc_tmetric_conus.csh
sed -i 's/Bench_2016_12SE1/2016_CONUS_16x18pe/g' run_calc_tmetric_conus.csh
sed -i 's/intel/gcc/g' run_calc_tmetric_conus.csh
sed -i 's/201607/201512/g' run_calc_tmetric_conus.csh
setenv CMAQ_DATA /fsx/data
./run_calc_tmetric_conus.csh

cd $DIR/POST/hr2day/scripts
sed -i 's/v532/v533/g' bldit_hr2day.csh
./bldit_hr2day.csh gcc |& tee ./bldit_hr2day.gcc.log

cp run_hr2day.csh run_hr2day_conus.csh
sed -i 's/v532/v533/g' run_hr2day_conus.csh
sed -i 's/Bench_2016_12SE1/2016_CONUS_16x18pe/g' run_hr2day_conus.csh
sed -i 's/intel/gcc/g' run_hr2day_conus.csh
sed -i 's/2016182/2015356/g' run_hr2day_conus.csh
sed -i 's/2016195/2015357/g' run_hr2day_conus.csh
setenv CMAQ_DATA /fsx/data
./run_hr2day_conus.csh

cd $DIR/POST/bldoverlay/scripts
sed -i 's/v532/v533/g' bldit_bldoverlay.csh

./bldit_bldoverlay.csh gcc |& tee ./bldit_bldoverlay.gcc.log

cp run_bldoverlay.csh run_bldoverlay_conus.csh
sed -i 's/v532/v533/g' run_bldoverlay_conus.csh
sed -i 's/Bench_2016_12SE1/2016_CONUS_16x18pe/g' run_bldoverlay_conus.csh
sed -i 's/intel/gcc/g' run_bldoverlay_conus.csh
sed -i 's/2016-07-01/2015-12-22/g' run_bldoverlay_conus.csh
sed -i 's/2016-07-02/2015-12-23/g' run_bldoverlay_conus.csh
setenv CMAQ_DATA /fsx/data
./run_bldoverlay_conus.csh

```
