# pcluster-cmaq

## Scripts and code to configure an AWS pcluster for CMAQ

## To obtain this code use the following command:

```
git clone -b main https://github.com/lizadams/pcluster-cmaq.git pcluster-cmaq
```

## To configure the cluster start a virtual environment on your local linux machine and install aws-parallelcluster

```
python3 -m virtualenv ~/apc-ve
source ~/apc-ve/bin/activate
python --version

python3 -m pip install --upgrade aws-parallelcluster
pcluster version
```

### Edit the configuration file for the cluster

```
vi ~/.parallelcluster/config
```

### Configure the cluster
      

The settings in the cluster configuration file allow you to 
   1) specify the head node, and what compute nodes are available (Note, the compute nodes can be updated/changed, but the head node cannot be updated.)
   2) specify the maximum number of compute nodes that can be requested using slurm
   3) specify the network used (elastic fabric adapter (efa) - only supported on larger instances https://docs.aws.amazon.com/parallelcluster/latest/ug/efa.html)
   4) specify that the compute nodes are on the same network (see placement groups and networking https://docs.aws.amazon.com/parallelcluster/latest/ug/troubleshooting.html
   5) specify if hyperthreading is used or not (can be done using config, much easier than earlier methods: https://aws.amazon.com/blogs/compute/disabling-intel-hyper-threading-technology-on-amazon-linux/
   6) specify the type of disk that is used, ie ebs or fsx and the size of /shared disk that is available  (can't be updated) 
   (Note the /shared disks are persistent as you can't turn them off, they will acrue charges until the cluster is deleted so you need to determine the size and type requirements carefully.)
   7) specify availability of the intel compiler - need separate config settings and license to get access to intel compiler
  (Note: you can use intelmpi with the gcc compiler, it isn't a requirement to use ifort as the base compiler.)
   8) specify the name of an existing ebs volume to use as a shared directory  - this can then be saved and available even after the pcluster is deleted. (?) Is this volume shared across the cluster, how do we ensure the file permissions are set correctly for each user?
   
  
```
pcluster configure pcluster -c /Users/lizadams/.parallelcluster/config
```

### Create the cluster

```
pcluster create cmaq
```

### Stop cluster

```
pcluster stop cmaq
```

### Start cluster

```
pcluster start cmaq
```

### Update the cluster

```
pcluster update -c /Users/lizadams/.parallelcluster/config cmaq
```

### To learn more about the pcluster commands

```
pcluster --help
```

### List the available clusters

```
pcluster list
```

cmaq-c5-4xlarge  UPDATE_COMPLETE  2.10.4
cmaq-conus       CREATE_COMPLETE  2.10.4
cmaq-large       UPDATE_COMPLETE  2.10.3
cmaq             UPDATE_COMPLETE  2.10.3

### Check status of cluster

```
pcluster status cmaq-c5-4xlarge
```

Status: UPDATE_COMPLETE
MasterServer: RUNNING
ClusterUser: centos
MasterPrivateIP: 10.0.0.219
ComputeFleetStatus: RUNNING

### This cluster was created using the following command. I am not sure how to report out the config file used to create a pcluster.
pcluster create cmaq-c5-4xlarge -c /Users/lizadams/.parallelcluster/config-c5.4xlarge

### The CTM_LOG files don't contain any information about the compute nodes that the jobs were run on.
We need a record of the NPCOL, NPROW setting and the number of nodes and tasks used as specified in the run script: #SBATCH --nodes=16 #SBATCH --ntasks-per-node=8
We need to save a copy of the standard out and error logs, and a copy of the run scripts to the OUTPUT directory.

```
cd /shared/build/openmpi_4.1.0_gcc_8.3.1/CMAQ_v532/CCTM/scripts
cp run*.log /shared/build/openmpi_4.1.0_gcc_8.3.1/CMAQ_v532/data/output
cp run*.csh /shared/build/openmpi_4.1.0_gcc_8.3.1/CMAQ_v532/data/output
```

### Managing the cluster
  1) You can turn off the head node after stopping the cluster, as long as you restart it before restaring the cluster
  2) The pcluster slurm queue system will create and destroy the compute nodes, so that helps reduce manual cleanup for the cluster.
  3) It is best to copy/backup the outputs and logs to an s3 bucket for follow-up analysis

### Pcluster User Manual
https://docs.aws.amazon.com/parallelcluster/latest/ug/what-is-aws-parallelcluster.html

### Configuring Pcluster for HPC
https://jimmielin.me/2019/wrf-gc-aws/

### Login to cluster using the permissions file

```
pcluster ssh cmaq -i ~/downloads/centos.pem
```

### Once you are on the cluster change from default bash shell to csh
csh

### Check what modules are available

```
module avail
```

### Load the openmpi module

```
module load openmpi/4.1.0
```

### Change directories to Install and build the libraries and CMAQ

```
cd /shared/pcluster-cmaq
```

### Build netcdf C and netcdf F libraries

```
./gcc9_install.csh
```

### A .cshrc script with LD_LIBRARY_PATH was copied to your home directory, enter the shell again and check environment variables that were set using

```
csh
env
```

### Buiild I/O API library

```
./gcc9_ioapi.csh
```

### Build CMAQ

```
./gcc9_cmaq.csh
```

## Copy the input data from a S3 bucket (this bucket is not public and needs credentials)
## set the aws credentials

```
aws credentials
```

## Use the script to copy the CONUS input data to the cluster

```
./s3_copy_need_credentials_conus.csh
```

### For the 12km SE Domain, copy the input data and then untar it, or use the pre-install script in the pcluster configuration file.
### Note: it is faster to copy all of the data to an S3 bucket without using tar.gz

```
cd /shared/
aws s3 cp --recursive s3://cmaqv5.3.2-benchmark-2day-2016-12se1-input .
tar -xzvf CMAQv5.3.2_Benchmark_2Day_Input.tar.gz
```

## Link the CONUS and 12km SE Domain input benchmark directory to your run script area

```
cd /shared/build/openmpi_4.1.0_gcc_8.3.1/CMAQ_v532/data
ln -s /shared/CONUS .
ln -s /shared/CMAQv5.3.2_Benchmark_2Day_Input .
```


## Copy a preinstall script to the S3 bucket (may be able to install all software and input data on spinup)
## This example is for the 12km SE domain (not implemented for CONUS domain yet).

```
aws s3 cp --acl public-read parallel-cluster-pre-install.sh s3://cmaqv5.3.2-benchmark-2day-2016-12se1-input/
```

### Copy the run scripts to the run directory

```
cd /shared/pcluster-cmaq
cp run*  /shared/build/openmpi_4.1.0_gcc_8.3.1/CMAQ_v532/CCTM/scripts
cd  /shared/build/openmpi_4.1.0_gcc_8.3.1/CMAQ_v532/CCTM/scripts
```


#### Once you have logged into the queue you can submit multiple jobs to the slurm job scheduler.

 ```
sbatch run_cctm_2016_12US2.64pe.csh
sbatch run_cctm_2016_12US2.256pe.csh
```

```
squeue -u centos
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON) 
                27   compute     CMAQ   centos  R      47:41      2 compute-dy-c59xlarge-[1-2] 
                28   compute     CMAQ   centos  R      10:58      8 compute-dy-c59xlarge-[3-10] 
 ```

## Note, there are times when the second day run fails, looking for the input file that was output from the first day.

1. Need to put in a sleep command between the two days.
2. Temporary fix is to restart the second day.

### Note this may help with networking on the parallel cluster
If the head node must be in the placement group, use the same instance type and subnet for both the head as well as all of the compute nodes. By doing this, the compute_instance_type parameter has the same value as the master_instance_type parameter, the placement parameter is set to cluster, and the compute_subnet_id parameter isn't specified. With this configuration, the value of the master_subnet_id parameter is used for the compute nodes. 
https://docs.aws.amazon.com/parallelcluster/latest/ug/troubleshooting.html


### Note you can check the timings while the job is still running using the following command

```
grep 'Processing completed' CTM_LOG_034.v532_gcc_2016_CONUS_8x12pe_20151222
```


            Processing completed...    8.8 seconds
            Processing completed...    7.4 seconds


### Sometimes get an error when shutting down 
 *** FATAL ERROR shutting down Models-3 I/O ***
 
### run m3diff to compare the output data

```
cd /shared/build/openmpi_4.1.0_gcc_8.3.1/CMAQ_v532/data/output
ls */*CONC*

setenv AFILE output_CCTM_v532_gcc_2016_CONUS_16x8pe/CCTM_CONC_v532_gcc_2016_CONUS_16x8pe_20151222.nc
setenv BFILE output_CCTM_v532_gcc_2016_CONUS_8x12pe/CCTM_CONC_v532_gcc_2016_CONUS_8x12pe_20151222.nc

m3diff

grep A:B REPORT
```

should see all zeros but we don't.

```
[centos@ip-10-0-0-219 output]$ grep A:B REPORT
 A:B  0.00000E+00@(  1,  0, 0)  0.00000E+00@(  1,  0, 0)  0.00000E+00  0.00000E+00
 A:B  0.00000E+00@(  1,  0, 0)  0.00000E+00@(  1,  0, 0)  0.00000E+00  0.00000E+00
 A:B  2.04891E-07@(293, 70, 1) -1.47149E-07@(272, 52, 1)  3.32936E-12  9.96093E-10
 A:B  2.98023E-08@(291, 71, 1) -2.60770E-08@(277,160, 1) -2.20486E-13  5.66325E-10
 A:B  1.13621E-07@(308,184, 1) -1.89990E-07@(240, 67, 1) -8.85402E-12  1.61171E-09
 A:B  7.63685E-08@(310,180, 1) -7.37607E-07@(273, 52, 1) -5.05276E-12  3.60038E-09
 A:B  5.55068E-07@(185,231, 1) -1.24797E-07@(255,166, 1)  2.47303E-11  3.99435E-09
 A:B  5.87665E-07@(285,167, 1) -4.15370E-07@(182,232, 1)  2.54544E-11  5.64502E-09
 A:B  3.10000E-05@(280,148, 1) -1.03656E-05@(279,148, 1)  2.16821E-10  1.07228E-07
 A:B  1.59163E-06@(181,231, 1) -7.91997E-06@(281,148, 1) -3.21571E-10  4.46658E-08
```

