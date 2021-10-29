# pcluster-cmaq

## Scripts and code to configure an AWS Parallel Cluster for CMAQ

## To obtain this code use the following command. Note, you need a copy of the configure scripts for the local workstation. You will also run this command on the Parallel Cluster once it is created.

```
git clone -b main https://github.com/lizadams/pcluster-cmaq.git pcluster-cmaq
```

## Please attempt this tutorial from AWS on how to create an HPC Cluster using Parallel Cluster prior to running the CMAQ Parallel Cluster instructions below.
https://d1.awsstatic.com/Projects/P4114756/deploy-elastic-hpc-cluster_project.pdf

## To configure the cluster start a virtual environment on your local linux machine and install aws-parallelcluster

```
python3 -m virtualenv ~/apc-ve
source ~/apc-ve/bin/activate
python --version

python3 -m pip install --upgrade aws-parallelcluster
pcluster version
```

Follow the Parallel Cluster User's Guide and install node.js

```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh 
chmod ug+x ~/.nvm/nvm.sh
source ~/.nvm/nvm.sh
nvm install node
node --version
python3 -m pip install --upgrade "aws-parallelcluster"
```

### Note, there are two versions of the parallel cluster command line options V2 and V3.  
### The remainder of these instructions are using the V3 version, which uses a yaml formatted configuration file.
### For examples see https://github.com/aws/aws-parallelcluster/tree/release-3.0/cli/tests/pcluster/example_configs

### Create a yaml configuration file for the cluster

```
pcluster configure --config new-hello-world.yaml
```

Note, there isn't a way to detemine what config.yaml file was used to create a cluster, so it is important to name your cluster to match the extension of the config file that was used to create it.

### Configure the cluster
      

The settings in the cluster configuration file allow you to 
   1) specify the head node, and what compute nodes are available (Note, the compute nodes can be updated/changed, but the head node cannot be updated.)
   2) specify the maximum number of compute nodes that can be requested using slurm
   3) specify the network used (elastic fabric adapter (efa) - only supported on larger instances https://docs.aws.amazon.com/parallelcluster/latest/ug/efa.html)
   4) specify that the compute nodes are on the same network (see placement groups and networking https://docs.aws.amazon.com/parallelcluster/latest/ug/troubleshooting.html
   5) specify if hyperthreading is used or not (can be done using config, much easier than earlier methods: https://aws.amazon.com/blogs/compute/disabling-intel-hyper-threading-technology-on-amazon-linux/
   6) specify the type of disk that is used, ie ebs or fsx and the size of /shared disk that is available  (can't be updated) 
   (Note the /shared disks are persistent as you can't turn them off, they will acrue charges until the cluster is deleted so you need to determine the size and type requirements carefully.)
   7) GNU gcc 8.3.1 is the default compiler, if you need intel compiler, you need separate config settings and license to get access to intel compiler
  (Note: you can use intelmpi with the gcc compiler, it isn't a requirement to use ifort as the base compiler.)
   8) specify the name of the snapshot containing the application software to use as the /shared directory.  This requires a previous Parallel Cluster installation where the software was installed using the install scripts, tested, and then the /shared directory saved as a snapshot.
   
  

### Create the cluster

```
pcluster create-cluster --cluster-configuration new-hello-world.yaml --cluster-name hello-pcluster --region us-east-1
```

### Check on the status of the cluster

```
pcluster describe-cluster --region=us-east-1 --cluster-name hello-pcluster
```

### List available clusters

```
pcluster list-clusters --region=us-east-1
```

### Starting the Compute nodes 

```
# AWS ParallelCluster v3 - Slurm fleets
$ pcluster update-compute-fleet --region us-east-1 --cluster-name hello-pcluster --status START_REQUESTED
```

### SSH into cluster

```
 pcluster ssh -v -Y -i ~/centos.pem --cluster-name hello-pcluster
```

### clone a copy of the Repo

```
git clone -b main https://github.com/lizadams/pcluster-cmaq.git pcluster-cmaq
```

### Create hellojob.sh

```
cat hellojob.sh
#!/bin/bash
sleep 30
echo "Hello World from $(hostname)"
```

### Submit job to queue

```
sbatch hellojob.sh
```

### examine the output

```
cat slurm-3.out
Hello World from queue1-dy-t2micro-1
```

### Submit mpirun version of hello_world
Following this tutorial
https://docs.aws.amazon.com/parallelcluster/latest/ug/tutorials_03_batch_mpi.html


```
module load openmpi
sbatch -n 3 submit_mpi.sh

```

### Stop the compute nodes

```
# AWS ParallelCluster v3 - Slurm fleets
$ pcluster update-compute-fleet --region us-east-1 --cluster-name hello-pcluster  --status STOP_REQUESTED
```

### To learn more about the pcluster commands

```
pcluster --help
```


### Use the configuration file from the github repo that was cloned to your local machine
Use this command to start the Parallel Cluster it is created using the following command: 

```
pcluster create-cluster --cluster-configuration config-C5n.4xlarge-cmaqebs.yaml --cluster-name c5n.4xlarge --region us-east-1
```


### Managing the cluster
  1) The head node can be stopped from the AWS Console after stopping compute nodes of the cluster, as long as it is restarted before issuing the pcluster start -c config.[name] command to restart the cluster.
  2) The pcluster slurm queue system will create and destroy the compute nodes, so that helps reduce manual cleanup for the cluster.
  3) It is best to copy/backup the outputs and logs to an s3 bucket for follow-up analysis
  4) After copying output and log files to the s3 bucket the cluster can be terminated using the following command.
  5) Once the pcluster is deleted all of the volumes, head node, and compute node will be terminated.
 
 ```
 pcluster delete cmaq.[name]  ! don't use this yet, it is an example syntax.
 ```

### Pcluster User Manual
https://docs.aws.amazon.com/parallelcluster/latest/ug/what-is-aws-parallelcluster.html

### Configuring Pcluster for HPC - example tutorial
https://jimmielin.me/2019/wrf-gc-aws/

### Login to cluster using the permissions file (need to obtain from AWS EC2 website using credentials).

```
pcluster ssh cmaq-c5n-18xlarge -i ~/downloads/centos.pem
```

### After logging into the head node of the parallel cluster, change from default bash shell to csh

```
csh
```

### Check what modules are available on the head node

```
module avail
```

### Load the openmpi module

```
module load openmpi/4.1.0
```

### Check what version of the gcc compiler is available

```
 gcc --version
gcc (GCC) 8.3.1 20191121 (Red Hat 8.3.1-5)
Copyright (C) 2018 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

### Change directories to install and build the libraries and CMAQ

```
cd /shared/pcluster-cmaq
```

### Build netcdf C and netcdf F libraries - these scripts work for the gcc 8.3.1 compiler

```
./gcc8_install.csh
```

### A .cshrc script with LD_LIBRARY_PATH was copied to your home directory, enter the shell again and check environment variables that were set using

```
ls ~/.cshrc
```

### If the .cshrc wasn't created use the following command to create it

```
cp dot.cshrc ~/.cshrc
```

### Execute the shell to activate it

```
csh
env
```

### Verify that you see the following setting 

```
LD_LIBRARY_PATH=/opt/amazon/openmpi/lib64:/shared/build/netcdf/lib:/shared/build/netcdf/lib
```

### Build I/O API library

```
./gcc8_ioapi.csh
```

### Build CMAQ

```
./gcc8_cmaq.csh
```

## Copy the input data from a S3 bucket (this bucket is not public and needs credentials)
## set the aws credentials
##  If you don't have credentials, please contact the owner of this github project.

```
aws credentials
```

### Use the S3 copy script to copy the 12km SE1 Domain input data to the /fsx/data volume on the cluster

```
cd /shared/pcluster/
./s3_copy_12km_SE_Bench.csh
```

### Note this input data requires 21 G of storage

```
cd /fsx/data/CMAQv5.3.2_Benchmark_2Day_Input
du -sh
21G	.
```

## Use the S3 script to copy the CONUS input data to the /fsx/data volume on the cluster

```
./shared/pcluster-cmaq/s3_copy_need_credentials_conus.csh
```

## If you get a permissions error, try using this script

```
./shared/pcluster-cmaq/s3_copy_nosign.csh  ! check that the resulting directory structure matches the run script
```

## Note, this input data requires 44 GB of disk space

```
cd /fsx/data/CONUS
[centos@ip-10-0-0-219 CONUS]$ du -sh
44G	.
```

### Storage for the output data for the 12SE Domain, assuming 2 day run, 1 layer, 13 var in the CONC output requires 1.4 G

```
ncdump -h CCTM_CONC_v532_gcc_Bench_2016_12SE1_20160702.nc
netcdf CCTM_CONC_v532_gcc_Bench_2016_12SE1_20160702 {
dimensions:
	TSTEP = UNLIMITED ; // (25 currently)
	DATE-TIME = 2 ;
	LAY = 1 ;
	VAR = 13 ;
	ROW = 80 ;
	COL = 100 ;
	
cd /fsx/data/output_CCTM_v532_gcc_Bench_2016_12SE1
[centos@ip-10-0-0-140 output_CCTM_v532_gcc_Bench_2016_12SE1]$ du -h
83M	./LOGS
1.4G	.

```


## Storage for the output data for the 12SE1 Domain, assuming 2 day run, 35 layer, 220 var in the CONC output requires 13G

```
ncdump -h CCTM_CONC_v532_gcc_Bench_2016_12SE1_20160701.nc

netcdf CCTM_CONC_v532_gcc_Bench_2016_12SE1_20160701 {
dimensions:
	TSTEP = UNLIMITED ; // (25 currently)
	DATE-TIME = 2 ;
	LAY = 35 ;
	VAR = 220 ;
	ROW = 80 ;
	COL = 100 ;


cd /fsx/data/output_CCTM_v532_gcc_Bench_2016_12SE1_full
du -h
83M	./LOGS
13G	.
```

## For the output data, assuming 2 day CONUS Run, 1 layer, 12 var in the CONC output

```
cd /fsx/data/output/output_CCTM_v532_gcc_2016_CONUS_16x8pe
du -sh
18G	.
```

### For the output data, assuming 2 day CONUS Run, all 35 layers, all 244 variables in CONC output

```
cd /fsx/data/output/output_CCTM_v532_gcc_2016_CONUS_16x8pe_full
du -sh
173G	.
```

### This cluster is configured to have 1.2 Terrabytes of space on /fsx filesystem (minimum size allowed for lustre /fsx), to allow multiple output runs to be stored.

```
 df -h
Filesystem           Size  Used Avail Use% Mounted on
devtmpfs             2.3G     0  2.3G   0% /dev
tmpfs                2.4G     0  2.4G   0% /dev/shm
tmpfs                2.4G   17M  2.4G   1% /run
tmpfs                2.4G     0  2.4G   0% /sys/fs/cgroup
/dev/nvme0n1p1       100G   16G   85G  16% /
/dev/nvme1n1          20G  1.6G   17G   9% /shared
10.0.0.186@tcp:/fsx  1.1T   47G  1.1T   5% /fsx
tmpfs                477M  4.0K  477M   1% /run/user/1000
```


### Copy the run scripts to the run directory

```
cd /shared/pcluster-cmaq
cp run*  /shared/build/openmpi_4.1.0_gcc_8.3.1/CMAQ_v532/CCTM/scripts
cd  /shared/build/openmpi_4.1.0_gcc_8.3.1/CMAQ_v532/CCTM/scripts
```

### To run the 12km SE Domain for 1 layer 12 variables in the CONC file

```
cd /shared/build/openmpi_4.1.0_gcc_8.3.1/CMAQ_v532/CCTM/scripts/
qsub run_cctm_Bench_2016_12SE1.csh
```

### When the job has completed examine the timing information at the end of the log file

```
tail run_cctm_Bench_2016_12SE1.8x8.log
Number of Grid Cells:      280000  (ROW x COL x LAY)
Number of Layers:          35
Number of Processes:       64
   All times are in seconds.

Num  Day        Wall Time
01   2016-07-01   304.86
02   2016-07-02   277.51
     Total Time = 582.37
      Avg. Time = 291.18
 
```

### The output directory of the 1 layer, 13 variables in the CONC file

```
cd /fsx/data/output_CCTM_v532_gcc_Bench_2016_12SE1
ls -rlt
total 1375394
-rw-rw-r-- 1 centos centos      3611 Jul  2 13:48 CCTM_v532_gcc_Bench_2016_12SE1_20160701.cfg
-rw-rw-r-- 1 centos centos    881964 Jul  2 13:53 CCTM_SOILOUT_v532_gcc_Bench_2016_12SE1_20160701.nc
-rw-rw-r-- 1 centos centos 104518560 Jul  2 13:53 CCTM_WETDEP1_v532_gcc_Bench_2016_12SE1_20160701.nc
-rw-rw-r-- 1 centos centos   3084636 Jul  2 13:53 CCTM_MEDIA_CONC_v532_gcc_Bench_2016_12SE1_20160701.nc
-rw-rw-r-- 1 centos centos 130645456 Jul  2 13:53 CCTM_DRYDEP_v532_gcc_Bench_2016_12SE1_20160701.nc
-rw-rw-r-- 1 centos centos  10416748 Jul  2 13:53 CCTM_CONC_v532_gcc_Bench_2016_12SE1_20160701.nc
-rw-rw-r-- 1 centos centos  29980192 Jul  2 13:53 CCTM_APMDIAG_v532_gcc_Bench_2016_12SE1_20160701.nc
-rw-rw-r-- 1 centos centos 173677956 Jul  2 13:53 CCTM_ACONC_v532_gcc_Bench_2016_12SE1_20160701.nc
-rw-rw-r-- 1 centos centos 249827776 Jul  2 13:53 CCTM_CGRID_v532_gcc_Bench_2016_12SE1_20160701.nc
-rw-rw-r-- 1 centos centos      3611 Jul  2 13:53 CCTM_v532_gcc_Bench_2016_12SE1_20160702.cfg
-rw-rw-r-- 1 centos centos    881964 Jul  2 13:57 CCTM_SOILOUT_v532_gcc_Bench_2016_12SE1_20160702.nc
-rw-rw-r-- 1 centos centos 104518560 Jul  2 13:57 CCTM_WETDEP1_v532_gcc_Bench_2016_12SE1_20160702.nc
-rw-rw-r-- 1 centos centos   3084636 Jul  2 13:57 CCTM_MEDIA_CONC_v532_gcc_Bench_2016_12SE1_20160702.nc
-rw-rw-r-- 1 centos centos 130645456 Jul  2 13:57 CCTM_DRYDEP_v532_gcc_Bench_2016_12SE1_20160702.nc
-rw-rw-r-- 1 centos centos  10416748 Jul  2 13:57 CCTM_CONC_v532_gcc_Bench_2016_12SE1_20160702.nc
-rw-rw-r-- 1 centos centos  29980192 Jul  2 13:57 CCTM_APMDIAG_v532_gcc_Bench_2016_12SE1_20160702.nc
-rw-rw-r-- 1 centos centos 173677956 Jul  2 13:57 CCTM_ACONC_v532_gcc_Bench_2016_12SE1_20160702.nc
-rw-rw-r-- 1 centos centos 249827776 Jul  2 13:57 CCTM_CGRID_v532_gcc_Bench_2016_12SE1_20160702.nc
drwxrwxr-x 2 centos centos     50176 Jul  2 13:57 LOGS

du -h
83M	./LOGS
1.4G	.
```


### To run the 12km SE Domain for all layers, all variables in the CONC file

```
cd /shared/build/openmpi_4.1.0_gcc_8.3.1/CMAQ_v532/CCTM/scripts/
qsub run_cctm_Bench_2016_12SE1.full.csh
```

### When the job has completed examine the timing information at the end of the log file

```
tail run_cctm_Bench_2016_12SE1.8x8.full.log
Number of Grid Cells:      280000  (ROW x COL x LAY)
Number of Layers:          35
Number of Processes:       64
   All times are in seconds.

Num  Day        Wall Time
01   2016-07-01   331.17
02   2016-07-02   302.13
     Total Time = 633.30
      Avg. Time = 316.65
 ```


### The output files for the full domain requires 12 G of storage

```
cd output_CCTM_v532_gcc_Bench_2016_12SE1_full
ls -rlt
total 13393467
-rw-rw-r-- 1 centos centos       3611 Jul  2 13:15 CCTM_v532_gcc_Bench_2016_12SE1_20160701.cfg
-rw-rw-r-- 1 centos centos     881964 Jul  2 13:20 CCTM_SOILOUT_v532_gcc_Bench_2016_12SE1_20160701.nc
-rw-rw-r-- 1 centos centos  104518560 Jul  2 13:20 CCTM_WETDEP1_v532_gcc_Bench_2016_12SE1_20160701.nc
-rw-rw-r-- 1 centos centos    3084636 Jul  2 13:20 CCTM_MEDIA_CONC_v532_gcc_Bench_2016_12SE1_20160701.nc
-rw-rw-r-- 1 centos centos  130645456 Jul  2 13:20 CCTM_DRYDEP_v532_gcc_Bench_2016_12SE1_20160701.nc
-rw-rw-r-- 1 centos centos   29980192 Jul  2 13:20 CCTM_APMDIAG_v532_gcc_Bench_2016_12SE1_20160701.nc
-rw-rw-r-- 1 centos centos 6160109240 Jul  2 13:20 CCTM_CONC_v532_gcc_Bench_2016_12SE1_20160701.nc
-rw-rw-r-- 1 centos centos  173677956 Jul  2 13:20 CCTM_ACONC_v532_gcc_Bench_2016_12SE1_20160701.nc
-rw-rw-r-- 1 centos centos  249827776 Jul  2 13:20 CCTM_CGRID_v532_gcc_Bench_2016_12SE1_20160701.nc
-rw-rw-r-- 1 centos centos       3611 Jul  2 13:20 CCTM_v532_gcc_Bench_2016_12SE1_20160702.cfg
-rw-rw-r-- 1 centos centos     881964 Jul  2 13:25 CCTM_SOILOUT_v532_gcc_Bench_2016_12SE1_20160702.nc
-rw-rw-r-- 1 centos centos    3084636 Jul  2 13:25 CCTM_MEDIA_CONC_v532_gcc_Bench_2016_12SE1_20160702.nc
-rw-rw-r-- 1 centos centos  130645456 Jul  2 13:25 CCTM_DRYDEP_v532_gcc_Bench_2016_12SE1_20160702.nc
-rw-rw-r-- 1 centos centos  104518560 Jul  2 13:25 CCTM_WETDEP1_v532_gcc_Bench_2016_12SE1_20160702.nc
-rw-rw-r-- 1 centos centos   29980192 Jul  2 13:25 CCTM_APMDIAG_v532_gcc_Bench_2016_12SE1_20160702.nc
-rw-rw-r-- 1 centos centos 6160109240 Jul  2 13:25 CCTM_CONC_v532_gcc_Bench_2016_12SE1_20160702.nc
-rw-rw-r-- 1 centos centos  173677956 Jul  2 13:25 CCTM_ACONC_v532_gcc_Bench_2016_12SE1_20160702.nc
-rw-rw-r-- 1 centos centos  249827776 Jul  2 13:25 CCTM_CGRID_v532_gcc_Bench_2016_12SE1_20160702.nc
drwxrwxr-x 2 centos centos      50176 Jul  2 13:25 LOGS

 ls -lht  CCTM_CONC_v532_gcc_Bench_2016_12SE1_20160702.nc
-rw-rw-r-- 1 centos centos 5.8G Jul  2 13:25 CCTM_CONC_v532_gcc_Bench_2016_12SE1_20160702.nc

du -h
83M	./LOGS
13G	.
```

#### To run the CONUS Domain

 ```
cd /shared/build/openmpi_4.1.0_gcc_8.3.1/CMAQ_v532/CCTM/scripts/
sbatch run_cctm_2016_12US2.256pe.csh
```

```
squeue -u centos

             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON) 
                 3   compute     CMAQ   centos  R      16:50      8 compute-dy-c5n18xlarge-[1-8] 

 ```

## Note, there are times when the second day run fails, looking for the input file that was output from the first day.

1. This results when you use a different file system for the input and output data.
2. Verify that the script specifies the INPUT and OUTPUT Directory are both using the /fsx file system to read the input and write the output.

### Note this may help with networking on the parallel cluster
If the head node must be in the placement group, use the same instance type and subnet for both the head as well as all of the compute nodes. By doing this, the compute_instance_type parameter has the same value as the master_instance_type parameter, the placement parameter is set to cluster, and the compute_subnet_id parameter isn't specified. With this configuration, the value of the master_subnet_id parameter is used for the compute nodes. 
https://docs.aws.amazon.com/parallelcluster/latest/ug/troubleshooting.html


### Note - check the timings while the job is still running using the following command

```
grep 'Processing completed' CTM_LOG_001*
```


            Processing completed...    8.8 seconds
            Processing completed...    7.4 seconds


### When the job has completed, use tail to view the timing from the log file.

```
tail run_cctmv5.3.2_Bench_2016_12US2.16x16pe.2day.log
Number of Grid Cells:      3409560  (ROW x COL x LAY)
Number of Layers:          35
Number of Processes:       256
   All times are in seconds.

Num  Day        Wall Time
01   2015-12-22   1354.65
02   2015-12-23   1216.64
     Total Time = 2571.29
      Avg. Time = 1285.64

```

### Run another jobs using 128 pes

```
sbatch run_cctm_2016_12US2.128pe.csh
```

### When the job has completed, use tail to view the timing from the log file.

```
tail run_cctmv5.3.2_Bench_2016_12US2.16x8pe.2day.log
Number of Grid Cells:      3409560  (ROW x COL x LAY)
Number of Layers:          35
Number of Processes:       128
   All times are in seconds.

Num  Day        Wall Time
01   2015-12-22   2221.42
02   2015-12-23   1951.84
     Total Time = 4173.26
      Avg. Time = 2086.63
      
```
      
### Compare the total time for the 2 days run 

| cpus     | time(sec)   |
| -------  | ----------- |
| 128 pe   |   4173.26   |
| 256 pe   |   2571.29   |

### The CTM_LOG files don't contain any information about the compute nodes that the jobs were run on.
Note, it is important to keep a record of the NPCOL, NPROW setting and the number of nodes and tasks used as specified in the run script: #SBATCH --nodes=16 #SBATCH --ntasks-per-node=8
It is also important to know what volume was used to read and write the input and output data, so it is recommended to save a copy of the standard out and error logs, and a copy of the run scripts to the OUTPUT directory for each benchmark.

```
cd /shared/build/openmpi_4.1.0_gcc_8.3.1/CMAQ_v532/CCTM/scripts
cp run*.log /fsx/data/output
cp run*.csh /fsx/data/output
```

### Investigate any errors in the CCTM_LOG files


```
cd /fsx/data/output/output_CCTM_v532_gcc_2016_CONUS_16x8pe/LOGS

grep -i error CTM_LOG*

CTM_LOG_127.v532_gcc_2016_CONUS_16x8pe_20151223:     Error opening file at path-name:
CTM_LOG_127.v532_gcc_2016_CONUS_16x8pe_20151223:     netCDF error number  -51  processing file "BNDY_SENS_1"
CTM_LOG_127.v532_gcc_2016_CONUS_16x8pe_20151223:     Error closing netCDF file 
CTM_LOG_127.v532_gcc_2016_CONUS_16x8pe_20151223:     netCDF error number  -33
CTM_LOG_127.v532_gcc_2016_CONUS_16x8pe_20151223:      *** FATAL ERROR shutting down Models-3 I/O ***


 tail CTM_LOG_127.v532_gcc_2016_CONUS_16x8pe_20151223
     >>> WARNING in subroutine SHUT3 <<<
     Error closing netCDF file
     File name:  CTM_CONC_1
     netCDF error number  -33


      *** FATAL ERROR shutting down Models-3 I/O ***
     The elapsed time for this simulation was    1947.9 seconds.

```


### To run the CONUS domain to output all layers, all variables

```
cd /shared/build/openmpi_4.1.0_gcc_8.3.1/CMAQ_v532/CCTM/scripts
sbatch run_cctm_2016_12US2.256pe.full.csh
```

### When the run has completed, use the tail command to examing the timing information.

```
tail  run_cctmv5.3.2_Bench_2016_12US2.16x16pe.2day.full.log
Number of Grid Cells:      3409560  (ROW x COL x LAY)
Number of Layers:          35
Number of Processes:       256
   All times are in seconds.

Num  Day        Wall Time
01   2015-12-22   2130.40
02   2015-12-23   1996.14
     Total Time = 4126.54
      Avg. Time = 2063.27
```

### Examine the output files

```
cd /fsx/data/output_CCTM_v532_gcc_2016_CONUS_16x16pe_full
ls -lht 
total 173G
drwxrwxr-x 2 centos centos 145K Jul  2 15:23 LOGS
-rw-rw-r-- 1 centos centos 3.2G Jul  2 15:23 CCTM_CGRID_v532_gcc_2016_CONUS_16x16pe_full_20151223.nc
-rw-rw-r-- 1 centos centos 2.2G Jul  2 15:23 CCTM_ACONC_v532_gcc_2016_CONUS_16x16pe_full_20151223.nc
-rw-rw-r-- 1 centos centos  78G Jul  2 15:23 CCTM_CONC_v532_gcc_2016_CONUS_16x16pe_full_20151223.nc
-rw-rw-r-- 1 centos centos 348M Jul  2 15:22 CCTM_APMDIAG_v532_gcc_2016_CONUS_16x16pe_full_20151223.nc
-rw-rw-r-- 1 centos centos 1.4G Jul  2 15:22 CCTM_WETDEP1_v532_gcc_2016_CONUS_16x16pe_full_20151223.nc
-rw-rw-r-- 1 centos centos 1.7G Jul  2 15:22 CCTM_DRYDEP_v532_gcc_2016_CONUS_16x16pe_full_20151223.nc
-rw-rw-r-- 1 centos centos 3.6K Jul  2 14:50 CCTM_v532_gcc_2016_CONUS_16x16pe_full_20151223.cfg
-rw-rw-r-- 1 centos centos 3.2G Jul  2 14:50 CCTM_CGRID_v532_gcc_2016_CONUS_16x16pe_full_20151222.nc
-rw-rw-r-- 1 centos centos 2.2G Jul  2 14:49 CCTM_ACONC_v532_gcc_2016_CONUS_16x16pe_full_20151222.nc
-rw-rw-r-- 1 centos centos  78G Jul  2 14:49 CCTM_CONC_v532_gcc_2016_CONUS_16x16pe_full_20151222.nc
-rw-rw-r-- 1 centos centos 348M Jul  2 14:49 CCTM_APMDIAG_v532_gcc_2016_CONUS_16x16pe_full_20151222.nc
-rw-rw-r-- 1 centos centos 1.4G Jul  2 14:49 CCTM_WETDEP1_v532_gcc_2016_CONUS_16x16pe_full_20151222.nc
-rw-rw-r-- 1 centos centos 1.7G Jul  2 14:49 CCTM_DRYDEP_v532_gcc_2016_CONUS_16x16pe_full_20151222.nc
-rw-rw-r-- 1 centos centos 3.6K Jul  2 14:15 CCTM_v532_gcc_2016_CONUS_16x16pe_full_20151222.cfg

 du -sh
173G	.
```


### Sometimes get an error when shutting down 
 *** FATAL ERROR shutting down Models-3 I/O ***
 Verify again that the same file system is being used to read and write the data to.
 Be sure that you are reading and writing the output to the same file system, ie to /fsx to avoid this error.
 Not sure what else may be causing these errors...
 
### run m3diff to compare the output data

```
cd /fsx/data/output
ls */*CONC*

setenv AFILE output_CCTM_v532_gcc_2016_CONUS_16x16pe/CCTM_CONC_v532_gcc_2016_CONUS_16x16pe_20151222.nc
setenv BFILE output_CCTM_v532_gcc_2016_CONUS_16x8pe/CCTM_CONC_v532_gcc_2016_CONUS_16x8pe_20151222.nc

m3diff

grep A:B REPORT
```

Should see all zeros. There are some non-zero values. TO DO: need to investigate to determine if this is sensitive to the compiler version.

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

### To restart the cluster using the software pre-installed on the /shared volume

```
Go to the AWS Console
Select the Master Compute node
Select the Block Device /dev/sv1b
Click on that volume ID
Then save as a snapshot.
Copy the Snapshot ID and place it in the configuration file.
Create a new cluster starting the /shared directory from the snapshot.

 pcluster create cmaq-c5n-18xlarge-cmaq-ebs -c /Users/lizadams/.parallelcluster/config-C5n.18xlarge-cmaqebs
 ```

### Verified that starting the Parallel Cluster with the /shared volume from the EBS drive snapshot

```
ls /shared/build
```

### The .cshrc file wasn't saved, so I copied it

```
cp /shared/pcluster-cmaq/dot.cshrc ~/.cshrc
```

### Source shell

```
source ~/.cshrc
```


### change shell and submit job

```
csh
sbatch run_cctm_2016_12US2.256pe.2.csh
### it failed with 
 EXECUTION_ID: CMAQ_CCTMv532_centos_20210701_022504_836895623
     MET_CRO_3D      :/fsx/data/CONUS/12US2/MCIP/METCRO3D.12US2.35L.151222

     >>--->> WARNING in subroutine OPEN3
     File not available.
     
    ```

### Need to copy the CONUS input data to the /fsx directory


### First set up aws credentials

```
aws configure
cd /shared/pcluster-cmaq
./s3_copy_need_credentials_conus.csh
```

### Then resubmit the job

```
cd /shared/build/openmpi_4.1.0_gcc_8.3.1/CMAQ_v532/CCTM/scripts/
sbatch run_cctm_2016_12US2.256pe.2.csh
```

### Results from the Parallel Cluster Started with the EBS Volume software

```
tail run_cctmv5.3.2_Bench_2016_12US2.16x16pe.2day.log
Number of Grid Cells:      3409560  (ROW x COL x LAY)
Number of Layers:          35
Number of Processes:       256
   All times are in seconds.

Num  Day        Wall Time
01   2015-12-22   1351.40
02   2015-12-23   1213.05
     Total Time = 2564.45
      Avg. Time = 1282.22

```


### To learn information about your cluster from the head node use the following commmand:
https://www.hpcworkshops.com/03-hpc-aws-parallelcluster-workshop/07-logon-pc.html

```
sinfo
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST 
compute*  inact   infinite     10  idle~ compute-dy-c524xlarge-[1-10] 
```

#### on a different cluster - running with hyperthreading turned off, on 64 processors, this is the output that shows only 8 nodes are running, the other 8 that are available (according to setting maximum number of compute nodes in the pcluster configure file) are idle. C5.4xlarge has 16 vcpu, and 8 cpus with hyperthreading turned off.

```
-rw-rw-r-- 1 centos centos 464516 Jun 22 23:20 CTM_LOG_044.v532_gcc_2016_CONUS_8x8pe_20151222
[centos@ip-10-0-0-219 scripts]$ squeue -u centos
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON) 
                10   compute     CMAQ   centos  R      40:37      8 compute-dy-c54xlarge-[1-8] 
[centos@ip-10-0-0-219 scripts]$ sinfo
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST 
compute*     up   infinite      8  idle~ compute-dy-c54xlarge-[9-16] 
compute*     up   infinite      8  alloc compute-dy-c54xlarge-[1-8] 
```

### Once you have the software installed on the /shared directory, this volume can be saved as a snapshot and then used in the Parallel Cluster Configuration File to start a new cluster.

See https://d1.awsstatic.com/Projects/P4114756/deploy-elastic-hpc-cluster_project.pdf



### verify the configuration of the the different EC2 instances that were selected as compute nodes by referring to the AWS online product guides.
https://aws.amazon.com/ec2/instance-types/c5/

```
Model            vCPU 	Memory (GiB) Instance Storage (GiB) Network Bandwidth (Gbps) EBS Bandwidth (Mbps)
c5.4xlarge 	     16 	        32 	  EBS-Only 	             Up to 10 	4,750
c5.24xlarge 	96 	       192 	  EBS-Only 	                   25 	19,000
c5n.18xlarge 	72 	       192 	  EBS-Only 	                  100 	19,000
```

### Note, -this may not be the instance that was used for benchmarking, it looks like the log files specified c5.9xlarge.  
This is a risk of being able to update the compute nodes, the user must keep track of the identify of the compute nodes while doing the run..
### add the sinfo command to the run script, to save the configuration information about the cluster when each slurm job is being run on.
### difficulty is the sinfo command only works on the head nodes, the compute nodes are running the run script, will need to figure out another option.
### List mounted volumes. A few volumes are shared by the head-node and will be mounted on compute instances when they boot up. Both /shared and /home are accessible by all nodes.  When the parallel cluster is configured to use the lustre file system, the results will be different.

```
showmount -e localhost
Export list for localhost:
/opt/slurm 10.0.0.0/16
/opt/intel 10.0.0.0/16
/home      10.0.0.0/16
/shared    10.0.0.0/16
```


### To determine if the cluster has hyperthreading turned off use lscpu and look at 'Thread(s) per core:'. 

```
lscpu
Architecture:        x86_64
CPU op-mode(s):      32-bit, 64-bit
Byte Order:          Little Endian
CPU(s):              8
On-line CPU(s) list: 0-7
Thread(s) per core:  1                < ---- this means that hyperthreading is off
Core(s) per socket:  8
Socket(s):           1
NUMA node(s):        1
Vendor ID:           GenuineIntel
CPU family:          6
Model:               85
Model name:          Intel(R) Xeon(R) Platinum 8275CL CPU @ 3.00GHz
Stepping:            7
CPU MHz:             3605.996
BogoMIPS:            5999.99
Hypervisor vendor:   KVM
Virtualization type: full
L1d cache:           32K
L1i cache:           32K
L2 cache:            1024K
L3 cache:            36608K
NUMA node0 CPU(s):   0-7
Flags:               fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ss ht syscall nx pdpe1gb rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid aperfmperf tsc_known_freq pni pclmulqdq ssse3 fma cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand hypervisor lahf_lm abm 3dnowprefetch invpcid_single pti fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid mpx avx512f avx512dq rdseed adx smap clflushopt clwb avx512cd avx512bw avx512vl xsaveopt xsavec xgetbv1 xsaves ida arat pku ospke
```


### Be careful how you name your s3 buckets, the name can't be changed. A new name can be created, and then the objects copied or synced to the new bucket and the old bucket can be removed using the aws command line

```
### make new bucket
aws s3 mb s3://t2large-head-c5.9xlarge-compute-conus-output
### sync old bucket with new bucket
aws s3 sync s3://t2large-head-c524xlarge-compute-pcluster-conus-output s3://t2large-head-c5.9xlarge-compute-conus-output
### remove old bucket
 aws s3 rb --force s3://t2large-head-c524xlarge-compute-pcluster-conus-output
```

### This is the configuration file that gave the fastest runtimes for the CONUS domain using EBS storage, scalability was poor.
### Note, it uses spot pricing, rather than on demand pricing
https://github.com/lizadams/pcluster-cmaq/blob/main/config-c5.4xlarge-nohyperthread

### This is the configuration file for the pcluster with the fastest performance using the Lustre Filesystem
### It was very oversized - 39 TB, and was very expensive as a result.  Do not use unless you resize it.
https://aws.amazon.com/blogs/storage/building-an-hpc-cluster-with-aws-parallelcluster-and-amazon-fsx-for-lustre/
https://github.com/lizadams/pcluster-cmaq/blob/main/config-lustre

### This is the configuration for the pcluster with lustre filesystem and EFA Enabled and turning off hyperthreading, that showed scaling to 288 processors using the c5n.18xlarge compute ndoes.
https://github.com/lizadams/pcluster-cmaq/blob/main/config-C5n.18xlarge



### Additional work that was not successfull

### Note, made an attempt to create an EBS volume and then attach it to the pcluster using the following settings
### it didn't work - need to retry this, as it would allow us to store the libraries and cmaq on an ebs volume rather than rebuilding each time

```
[cluster default]
ebs_settings = ebs,input,apps

[ebs apps]
shared_dir = /shared
ebs_volume_id = vol-0ef9a574ac8e5acbb
```

### Tried using parallel-io build of CMAQ, rebuilding the libraries to use pnetcdf and adding MPI: to the input files
### Did this on the lustre cluster and obtained the following error.



### Looking at the volumes on EC2, I can see that it is available, perhaps there is a conflict with the name /shared
### Also trying to copy the software from an S3 Bucket, and it didn't work.  It couldn't find the executable, when the job was submitted.
### It may have been a permissions issue, or perhaps the volume wasn't shared?

```
Name Volume ID      Size    Volume Type IOPS Throughput (MB/s) Snapshot Created Availability Zone State Alarm Status Attachment Information Monitoring Volume Status
vol-0ef9a574ac8e5acbb 500 GiB   io1 3000 - snap-0f7bf48b384bbc975 June 21, 2021 at 3:33:24 PM UTC-4 us-east-1a  available       None
```


### Additional Benchmarking resource
https://github.com/aws/aws-parallelcluster/issues/1436

### The next thing to try is Graviton as a compute instance with the EFA enabled c6g.16xlarge compute nodes.

```
Amazon EC2 C6g instances are powered by Arm-based AWS Graviton2 processors. They deliver up to 40% better price performance over current generation C5 instances for compute-intensive applications.
https://aws.amazon.com/ec2/instance-types/#instance-details

Instance Size 	vCPU 	Memory (GiB) 	Instance Storage (GiB) 	Network Bandwidth (Gbps) 	EBS Bandwidth (Mbps)
c6g.4xlarge 	16 	32 	EBS-Only 	Up to 10 	4750
c6g.8xlarge 	32 	64 	EBS-Only 	12 	9000
c6g.12xlarge 	48 	96 	EBS-Only 	20 	13500
c6g.16xlarge 	64 	128 	EBS-Only 	25 	19000
```
c6gd.4xlarge 	16 	32 	1 x 950 NVMe SSD 	Up to 10 	4,750


### Need to price out the different storage options
```
EBS, iot, gp2, lustre, etc
```


### To use cloudwatch command line to report cpu usage for the cluster

https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/US_SingleMetricPerInstance.html

```
aws cloudwatch get-metric-statistics --namespace AWS/EC2 --metric-name CPUUtilization  --period 3600 \
--statistics Maximum --dimensions Name=InstanceId,Value=i-0dd4225d087abeb38 \
--start-time 2021-06-22T00:00:00 --end-time 2021-06-22T21:05:25

Each value represents the maximum CPU utilization percentage for a single EC2 instance. 
So, this must be for the head nodes, not the compute nodes.
{
    "Label": "CPUUtilization",
    "Datapoints": [
        {
            "Timestamp": "2021-06-22T20:00:00Z",
            "Maximum": 10.61,
            "Unit": "Percent"
        },
        {
            "Timestamp": "2021-06-22T17:00:00Z",
            "Maximum": 25.633760562676045,
            "Unit": "Percent"
        },
        {
            "Timestamp": "2021-06-22T15:00:00Z",
            "Maximum": 5.451666666666666,
            "Unit": "Percent"
        },
        {
            "Timestamp": "2021-06-22T21:00:00Z",
            "Maximum": 9.736666666666666,
            "Unit": "Percent"
        },
        {
            "Timestamp": "2021-06-22T19:00:00Z",
            "Maximum": 9.003333333333334,
            "Unit": "Percent"
        },
        {
            "Timestamp": "2021-06-22T18:00:00Z",
            "Maximum": 32.20446325894569,
            "Unit": "Percent"
        },
        {
            "Timestamp": "2021-06-22T16:00:00Z",
            "Maximum": 25.642905951567474,
            "Unit": "Percent"
        }
    ]
}
```

### Another resource

```
https://jiaweizhuang.github.io/blog/aws-hpc-guide/
```

Some of these tips don't work on the pcluster
 sinfo
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST 
compute*     up   infinite     16  idle~ compute-dy-c54xlarge-[1-16] 


### I don't see an ip address, only a name for the compute cluster, and I can't connect to it from here, but it is possible to login to the Amazon AWS Console website and see the private IP address and then login using ssh

```
ssh compute-dy-c54xlarge-1
ssh: connect to host compute-dy-c54xlarge-1 port 22: Connection refused
```

### ifconfig

```
ifconfig
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 9001
        inet 10.0.0.219  netmask 255.255.255.0  broadcast 10.0.0.255
        inet6 fe80::b4:baff:fee9:331f  prefixlen 64  scopeid 0x20<link>
        ether 02:b4:ba:e9:33:1f  txqueuelen 1000  (Ethernet)
        RX packets 239726465  bytes 508716629442 (473.7 GiB)
        RX errors 0  dropped 46  overruns 0  frame 0
        TX packets 403287013  bytes 1900350587702 (1.7 TiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 42601  bytes 12642178 (12.0 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 42601  bytes 12642178 (12.0 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
 ```
        
###   network information  - from the above link "This means that "Enhanced Networking" is enabled 13. This should be the default on most modern AMIs, so you shouldn't need to change anything."

```
        ethtool -i eth0
driver: ena
version: 2.1.0K
firmware-version: 
expansion-rom-version: 
bus-info: 0000:00:05.0
supports-statistics: yes
supports-test: no
supports-eeprom-access: no
supports-register-dump: no
supports-priv-flags: no
```

### Trying a cluster configured with c5ad.24xlarge (AMD processor) 96 vcpu with hyperthreading is 48 cpu

```
running run_cctm_2016_12US2.96pe.csh
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=48
   @ NPCOL  =  8; @ NPROW = 12
   ```


### You can login to the compute nodes by going to the AWS console, and looking for the instances named compute
### Get the private IP address, and then use ssh from the head node to login to the private IP
ssh IP address

Using top, I can see 49 running tasks

```
top - 22:02:36 up 23 min,  1 user,  load average: 48.27, 44.83, 27.73
Tasks: 675 total,  49 running, 626 sleeping,   0 stopped,   0 zombie
%Cpu(s): 84.5 us, 14.8 sy,  0.0 ni,  0.0 id,  0.0 wa,  0.7 hi,  0.0 si,  0.0 st
MiB Mem : 191136.2 total, 132638.8 free,  50187.9 used,   8309.5 buff/cache
MiB Swap:      0.0 total,      0.0 free,      0.0 used. 139383.6 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                           
   7958 centos    20   0 1877772   1.0g  18016 R  99.7   0.5  11:12.78 CCTM_v532.exe                     
   7963 centos    20   0 1914288   1.0g  18004 R  99.7   0.5  11:12.90 CCTM_v532.exe                     
   7964 centos    20   0 1849700 997116  17908 R  99.7   0.5  11:12.04 CCTM_v532.exe                     
   7965 centos    20   0 1971236   1.1g  18028 R  99.7   0.6  11:10.30 CCTM_v532.exe                     
   7970 centos    20   0 2043228   1.1g  18048 R  99.7   0.6  11:11.22 CCTM_v532.exe                     
   7980 centos    20   0 1896544   1.0g  18088 R  99.7   0.5  11:12.57 CCTM_v532.exe                     
   8007 centos    20   0 1859792 987.4m  18120 R  99.7   0.5  11:09.91 CCTM_v532.exe                     
   8011 centos    20   0 1908064   1.0g  18240 R  99.7   0.5  11:09.21 CCTM_v532.exe                     
   8052 centos    20   0 1902952   1.0g  17944 R  99.7   0.5  11:10.44 CCTM_v532.exe                     
   7956 centos    20   0 1840280 996668  17828 R  99.3   0.5  11:12.00 CCTM_v532.exe                     
   7957 centos    20   0 1957164   1.1g  17780 R  99.3   0.6  11:10.21 CCTM_v532.exe                     
   7959 centos    20   0 1928932   1.0g  17892 R  99.3   0.6  11:10.52 CCTM_v532.exe                     
   7960 centos    20   0 1888204   1.0g  17972 R  99.3   0.5  11:10.70 CCTM_v532.exe                     
   7961 centos    20   0 1954500   1.1g  18032 R  99.3   0.6  11:10.35 CCTM_v532.exe                     
   7962 centos    20   0 1926924   1.0g  17868 R  99.3   0.5  11:13.01 CCTM_v532.exe                     
   7972 centos    20   0 1960388   1.1g  17992 R  99.3   0.6  11:10.29 CCTM_v532.exe                     
   7974 centos    20   0 1919348   1.0g  18052 R  99.3   0.5  11:12.88 CCTM_v532.exe                     
   7983 centos    20   0 1825104 974220  18184 R  99.3   0.5  11:11.58 CCTM_v532.exe                     
   7995 centos    20   0 1969536   1.1g  18032 R  99.3   0.6  11:10.56 CCTM_v532.exe                     
   8013 centos    20   0 1819860 970136  18196 R  99.3   0.5  11:12.34 CCTM_v532.exe                     
   8014 centos    20   0 1809228 961672  17744 R  99.3   0.5  11:11.85 CCTM_v532.exe                     
   8017 centos    20   0 1970864   1.1g  18008 R  99.3   0.6  11:09.37 CCTM_v532.exe                     
   8021 centos    20   0 1923016   1.0g  18068 R  99.3   0.5  11:09.78 CCTM_v532.exe                     
   8024 centos    20   0 1919768   1.0g  18076 R  99.3   0.5  11:11.29 CCTM_v532.exe                     
   8028 centos    20   0 1908988   1.0g  17992 R  99.3   0.5  11:10.51 CCTM_v532.exe                     
   8031 centos    20   0 1975896   1.1g  17920 R  99.3   0.6  11:08.06 CCTM_v532.exe                     
   8035 centos    20   0 1890020   1.0g  17888 R  99.3   0.5  11:08.24 CCTM_v532.exe                     
   8038 centos    20   0 1958252   1.1g  18488 R  99.3   0.6  11:09.83 CCTM_v532.exe                     
   8041 centos    20   0 1915840   1.0g  17916 R  99.3   0.5  11:09.67 CCTM_v532.exe                     
   8043 centos    20   0 1830916 980432  17900 R  99.3   0.5  11:08.43 CCTM_v532.exe                     
   8047 centos    20   0 2231128   1.3g  17964 R  99.3   0.7  11:08.91 CCTM_v532.exe                     
   8049 centos    20   0 1907696   1.0g  18280 R  99.3   0.5  11:10.44 CCTM_v532.exe                     
   8055 centos    20   0 2168272   1.3g  17860 R  99.3   0.7  11:10.73 CCTM_v532.exe                     
   8058 centos    20   0 1789948 936684  17784 R  99.3   0.5  11:09.20 CCTM_v532.exe   
     8064 centos    20   0 1810356 962336  17800 R  99.3   0.5  11:09.56 CCTM_v532.exe                     
   8066 centos    20   0 1820544 975396  17612 R  99.3   0.5  11:09.33 CCTM_v532.exe                     
   8069 centos    20   0 1871124   1.0g  18200 R  99.3   0.5  11:09.92 CCTM_v532.exe                     
   8074 centos    20   0 1848644 998840  18048 R  99.3   0.5  11:09.81 CCTM_v532.exe                     
   8078 centos    20   0 1924400   1.0g  18292 R  99.3   0.5  11:09.51 CCTM_v532.exe                     
   8083 centos    20   0 1899244   1.0g  18096 R  99.3   0.5  11:09.10 CCTM_v532.exe                     
   8086 centos    20   0 1806572 952816  17780 R  99.3   0.5  11:09.64 CCTM_v532.exe                     
   7986 centos    20   0 1955908   1.1g  18184 R  99.0   0.6  11:09.66 CCTM_v532.exe   
```

```
[centos@compute-dy-c5ad24xlarge-2 ~]$ lscpu
Architecture:        x86_64
CPU op-mode(s):      32-bit, 64-bit
Byte Order:          Little Endian
CPU(s):              48
On-line CPU(s) list: 0-47
Thread(s) per core:  1
Core(s) per socket:  48
Socket(s):           1
NUMA node(s):        1
Vendor ID:           AuthenticAMD
CPU family:          23
Model:               49
Model name:          AMD EPYC 7R32
Stepping:            0
CPU MHz:             3296.186
BogoMIPS:            5599.69
Hypervisor vendor:   KVM
Virtualization type: full
L1d cache:           32K
L1i cache:           32K
L2 cache:            512K
L3 cache:            16384K
NUMA node0 CPU(s):   0-47
Flags:               fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc cpuid extd_apicid aperfmperf tsc_known_freq pni pclmulqdq monitor ssse3 fma cx16 sse4_1 sse4_2 movbe popcnt aes xsave avx f16c rdrand hypervisor lahf_lm cmp_legacy cr8_legacy abm sse4a misalignsse 3dnowprefetch topoext perfctr_core ssbd ibrs ibpb stibp vmmcall fsgsbase bmi1 avx2 smep bmi2 rdseed adx smap clflushopt clwb sha_ni xsaveopt xsavec xgetbv1 clzero xsaveerptr wbnoinvd arat npt nrip_save rdpid
```

### I also submitted a job to run on 90 processors 2x45 (9 x 10)
This is waiting in the queue - perhaps because I requested spot pricing, and none are available at that price?

```
[centos@ip-10-0-0-104 scripts]$ squeue -u centos
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON) 
                 7   compute     CMAQ   centos PD       0:00      2 (BeginTime) 
                 5   compute     CMAQ   centos  R      37:21      2 compute-dy-c5ad24xlarge-[1-2] 
```
                 


