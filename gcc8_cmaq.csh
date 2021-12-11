#!/bin/csh -f

#  -----------------------
#  Download and build CMAQ
#  -----------------------
setenv IOAPI_DIR /shared/build/ioapi-3.2/Linux2_x86_64gfort
setenv NETCDF_DIR /shared/build/netcdf/lib
setenv NETCDFF_DIR /shared/build/netcdf/lib
cd /shared/build/
#git clone -b 5.3.2_singularity https://github.com/lizadams/CMAQ.git CMAQ_REPO
git clone -b main https://github.com/USEPA/CMAQ.git CMAQ_REPO_v533

echo "downloaded CMAQ"
cd CMAQ_REPO_v533
cp /shared/pcluster-cmaq/bldit_project_v533.csh /shared/build/CMAQ_REPO_v533
./bldit_project_v533.csh
module load openmpi
cd /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/
cp /shared/pcluster-cmaq/config_cmaq.csh ../../
./bldit_cctm.csh gcc |& tee ./bldit_cctm.log
cp /shared/pcluster-cmaq/run_scripts/run* /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/
cd /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/

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

# created a run script to use only 8 cpu per node for 128 pe job
#sbatch run_cctm_2016_12US2.128pe.csh
