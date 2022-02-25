# Scripts to post-process CMAQ output

### Note, the post-processing analysis should be done on the head node.
Verify that the compute nodes are no longer running if you have completed all of the benchmark runs

`squeue`

You should see that no jobs are running.

Show compute nodes

`scontrol show nodes`

### Stop the compute nodes

`pcluster update-compute-fleet --region us-east-1 --cluster-name cmaq --status STOP_REQUESTED`


### Edit, Build and Run the POST processing routines

You need to run the post processing scripts for every benchmark case.

The post processing scripts are set up for one of the cases:

setenv APPL 2016_CONUS_16x18pe

note, you will need to change the sed command to a different configuration if you ran another case, example: 

setenv APPL 2016_CONUS_9x12pe


Note, the following script was used to modify the base post processing scripts (set up for the Bench_2016_12SE1 case to the CONUS domain.

If you used the CMAQ Benchmark Option 1, with the pre-loaded software, then these scripts have already been modified.

If you used the CMAQ Bechmark Option 2 to install CMAQ yourself, you will need to save and run the following script.

```
setenv DIR /shared/build/openmpi_gcc/CMAQ_v533/

cd $DIR/POST/combine/scripts
sed -i 's/v532/v533/g' bldit_combine.csh
cp run_combine.csh run_combine_conus.csh
sed -i 's/Bench_2016_12SE1/2016_CONUS_16x18pe/g' run_combine_conus.csh
sed -i 's/intel/gcc/g' run_combine_conus.csh
./bldit_combine.csh gcc |& tee ./bldit_combine.gcc.log
sed -i 's/2016-07-01/2015-12-22/g' run_combine_conus.csh
sed -i 's/2016-07-14/2015-12-23/g' run_combine_conus.csh
setenv CMAQ_DATA /fsx/data
./run_combine_conus.csh

cd $DIR/POST/calc_tmetric/scripts
./bldit_calc_tmetric.csh gcc |& tee ./bldit_calc_tmetric.gcc.log
cp run_calc_tmetric.csh run_calc_tmetric_conus.csh
sed -i 's/Bench_2016_12SE1/2016_CONUS_16x18pe/g' run_calc_tmetric_conus.csh
sed -i 's/intel/gcc/g' run_calc_tmetric_conus.csh
sed -i 's/201607/201512/g' run_calc_tmetric_conus.csh
setenv CMAQ_DATA /fsx/data
./run_calc_tmetric_conus.csh

cd $DIR/POST/hr2day/scripts
sed -i 's/v532/v533/g' bldit_hr2day.csh
./bldit_hr2day.csh gcc |& tee ./bldit_hr2day.gcc.log
cp run_hr2day.csh run_hr2day_conus.csh
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
sed -i 's/Bench_2016_12SE1/2016_CONUS_16x18pe/g' run_bldoverlay_conus.csh
sed -i 's/intel/gcc/g' run_bldoverlay_conus.csh
sed -i 's/2016-07-01/2015-12-22/g' run_bldoverlay_conus.csh
sed -i 's/2016-07-02/2015-12-23/g' run_bldoverlay_conus.csh
setenv CMAQ_DATA /fsx/data
./run_bldoverlay_conus.csh

```

