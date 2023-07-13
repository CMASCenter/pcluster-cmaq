# Scripts to run combine and post processing 

## Build the POST processing routines

Instructions on how to Post-process CMAQ using the utilities under the POST directory

```{note}
The post-processing analysis is run on the head node.
```

Verify that the compute nodes are no longer running if you have completed all of the benchmark runs

`squeue`

You should see that no jobs are running.

Show compute nodes

`scontrol show nodes`


## Edit, Build, and Run the POST processing routines

```
setenv DIR /shared/build/openmpi_gcc/CMAQ_v54+/

cd $DIR/POST/combine/scripts

sed -i 's/v54/v54+/g' bldit_combine.csh
./bldit_combine.csh gcc |& tee bldit_combine.log
cp run_combine.csh run_combine_12US1.csh
sed -i 's/v54/v54+/g' run_combine_12US1.csh
sed -i 's/Bench_2016_12SE1/2018_12US1_2x64_classic/g' run_combine_12US1.csh
sed -i 's/intel/gcc/g' run_combine_12US1.csh
sed -i 's/cb6r3_ae7_aq/cb6r5_ae7_aq/g' run_combine_12US1.csh
sed -i 's/2016-07-01/2017-12-22/g' run_combine_12US1.csh
sed -i 's/2016-07-14/2017-12-23/g' run_combine_12US1.csh
sed -i 's/${VRSN}_${compilerString}_${APPL}/${VRSN}_${MECH}_${compilerString}_${APPL}/g' run_combine_12US1.csh
setenv CMAQ_DATA /fsx/data
./run_combine_12US1.csh

cp run_calc_tmetric.csh run_calc_tmetric_12US1.csh
sed -i 's/Bench_2016_12SE1/2018_12US1_2x64_classic/g' run_calc_tmetric_12US1.csh
sed -i 's/intel/gcc/g' run_calc_tmetric_12US1.csh
sed -i 's/201607/201712/g' run_calc_tmetric_12US1.csh
setenv CMAQ_DATA /fsx/data
./run_calc_tmetric_12US1.csh

cd $DIR/POST/hr2day/scripts

cp run_hr2day.csh run_hr2day_12US1.csh
sed -i 's/Bench_2016_12SE1/2018_12US1_2x64_classic/g' run_hr2day_12US1.csh
sed -i 's/intel/gcc/g' run_hr2day_12US1.csh
sed -i 's/2016182/2015356/g' run_hr2day_12US1.csh
sed -i 's/2016195/2015357/g' run_hr2day_12US1.csh
setenv CMAQ_DATA /fsx/data
./run_hr2day_12US1.csh

#cd $DIR/POST/bldoverlay/scripts

#cp run_bldoverlay.csh run_bldoverlay_12US1.csh
#sed -i 's/Bench_2016_12SE1/2018_12US1_2x64_classic/g' run_bldoverlay_12US1.csh
#sed -i 's/intel/gcc/g' run_bldoverlay_12US1.csh
#sed -i 's/2016-07-01/2015-12-22/g' run_bldoverlay_12US1.csh
#sed -i 's/2016-07-02/2015-12-23/g' run_bldoverlay_12US1.csh
#setenv CMAQ_DATA /fsx/data
#./run_bldoverlay_12US1.csh

```
