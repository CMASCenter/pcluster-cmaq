#!/bin/csh -f

#  -----------------------
#  Download and build CMAQ
#  -----------------------
setenv BUILD /shared/build
setenv IOAPI_DIR $BUILD/ioapi-3.2/Linux2_x86_64gfort
setenv NETCDF_DIR $BUILD/netcdf/lib
setenv NETCDFF_DIR $BUILD/netcdf/lib
cd $BUILD
#git clone -b 5.3.2_singularity https://github.com/lizadams/CMAQ.git CMAQ_REPO
git clone -b 5.4+  https://github.com/USEPA/CMAQ.git CMAQ_REPO_v54+

echo "downloaded CMAQ"
cd CMAQ_REPO_v54+
setenv PCLUSTER /shared/pcluster-cmaq
cp $PCLUSTER/bldit_project_v54+_singlevm.csh /shared/build/CMAQ_REPO_v54+
./bldit_project_v54+_singlevm.csh
cd $BUILD/openmpi_gcc/CMAQ_v54+/CCTM/scripts/
cp $PCLUSTER/config_cmaq_singlevm.csh ../../config_cmaq.csh
./bldit_cctm.csh gcc |& tee ./bldit_cctm.log
cp $PCLUSTER/run_scripts/cmaq54+/run*pcluster.csh $BUILD/openmpi_gcc/CMAQ_v54+/CCTM/scripts/
cd $BUILD/openmpi_gcc/CMAQ_v54+/CCTM/scripts/

# submit job to the queue using 
# sbatch run_cctm_2016_12US2.256pe.csh
# if you get the following error it means the compute nodes are not running 
#sbatch: error: Batch job submission failed: Required partition not available (inactive or drain)
#  pcluster start [cluster-name]
# example
# use pcluster start cmaq-c5-4xlarge

# if you get this error
# sbatch run_cctm_2016_12US2.256pe.csh
#sbatch: error: Batch job submission failed: More processors requested than permitted


# Check the number of processors on the machine, and whether you have hyperthreading turned off
#!/bin/csh -f
#SBATCH --nodes=16
#SBATCH --ntasks-per-node=16
#Model 	vCPU 	Memory (GiB) 	Instance Storage (GiB)
# c5.4xlarge 	16 	32 	EBS-Only

