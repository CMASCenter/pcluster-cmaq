## Scripts and code to configure an AWS Parallel Cluster for CMAQ
The goal is to demonstrate how to create a parallel cluster, modify or update the cluster, and run CMAQv533 for two days on the CONUS2 domain obtaining input data from an S3 Bucket and saving the output to the S3 Bucket.

Note: The scripts have been set up to run on the AWS Parallel Cluster that has both a /shared ebs file system, and a /fsx lustre file system.  It is possible to also test the install scripts on a local machine prior to running on the AWS Parallel Cluster.  This will require modification the path that is used to install/build the libraries, CMAQ and the CONUS input data.  These paths may need to be changed in your .cshrc, install scripts, build scripts, run scripts etc.  Compiler GCC 8+ or higher and openmpi 4+ are required.

### To obtain this code use the following command. Note, you need a copy of the configure scripts for the local workstation. You will also run this command on the Parallel Cluster once it is created.

```
git clone -b main https://github.com/lizadams/pcluster-cmaq.git pcluster-cmaq
```

### Please follow the instructions for configuring the Parallel Cluster using the v3.0 command line, which uses yaml files for configuring the pcluster.
https://docs.aws.amazon.com/parallelcluster/latest/ug/parallelcluster-version-3.html

### This tutorial from AWS on how to create an HPC Cluster using Parallel Cluster uses the older v2.0 command line, that uses configure files to configure the parallel cluster. 
https://d1.awsstatic.com/Projects/P4114756/deploy-elastic-hpc-cluster_project.pdf'

### Another workshop to learn the AWS CLI 3.0
https://hpc.news/pc3workshop

### Youtube video
https://www.youtube.com/watch?v=a-99esKLcls

### To configure the cluster start a virtual environment on your local linux or MacOS machine and install aws-parallelcluster

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

Note, there are two versions of the parallel cluster command line options V2 and V3.  

The remainder of these instructions are using the V3 version, which uses a yaml formatted configuration file.

https://docs.aws.amazon.com/parallelcluster/latest/ug/cluster-configuration-file-v3.html
For examples see https://github.com/aws/aws-parallelcluster/tree/release-3.0/cli/tests/pcluster/example_configs

#### Create a yaml configuration file for the cluster following these instructions
https://docs.aws.amazon.com/parallelcluster/latest/ug/install-v3-configuring.html

```
pcluster configure --config new-hello-world.yaml
```

Allowed values for AWS Region ID:
15. us-east-1

The key pair is selected from the key pairs registered with Amazon EC2 in the selected Region. Choose the key pair: 
(this requires user to have created a AWS EC2 instance and created a EC2 Key pair.)

Choose the scheduler to use with your cluster.
Allowed values for Scheduler:
1. slurm

Choose the operating system.

Allowed values for Operating System:
1. alinux2
2. centos7
3. ubuntu1804
4. ubuntu2004

Select:
```
4. ubuntu2004
```

Choose head node instance type:

Head node instance type [t2.micro]:

Choose compute node instance type:

t2.micro

#### Examine the yaml file that was created

```
vi new-hello-world.yaml
```

note that the yaml file format seems to be sensitive to using 2 spaces for indentation
The Key pair and SubnetId that were generated during the pcluster configure generated a new-hello-world.yaml that contains settings unique to your account, and will be needed later in this tutorial.

Note, there isn't a way to detemine what config.yaml file was used to create a cluster, so it is important to keep track of what yaml configuration file was used to create the cluster. 

### Configure the cluster
      

The settings in the cluster configuration file allow you to 
   1) specify the head node, and what compute nodes are available (Note, the compute nodes can be updated/changed, but the head node cannot be updated.)
   2) specify the maximum number of compute nodes that can be requested using slurm
   3) specify the network used (elastic fabric adapter (efa) - only supported on larger instances https://docs.aws.amazon.com/parallelcluster/latest/ug/efa.html)
   4) specify that the compute nodes are on the same network (see placement groups and networking https://docs.aws.amazon.com/parallelcluster/latest/ug/troubleshooting.html
   5) specify if hyperthreading is used or not (can be done using config, much easier than earlier methods: https://aws.amazon.com/blogs/compute/disabling-intel-hyper-threading-technology-on-amazon-linux/
   6) specify the type of disk that is used, ie ebs or fsx and the size of /shared disk that is available  (can't be updated) 
   (Note the /shared disks are persistent as you can't turn them off, they will acrue charges until the cluster is deleted so you need to determine the size and type requirements carefully.)
   7) GNU gcc 8.3.1 or higher is required version of the compiler, if you need intel compiler, you need separate config settings and license to get access to intel compiler
  (Note: you can use intelmpi with the gcc compiler, it isn't a requirement to use ifort as the base compiler.)
   8) specify the name of the snapshot containing the application software to use as the /shared directory.  This requires a previous Parallel Cluster installation where the software was installed using the install scripts, tested, and then the /shared directory saved as a snapshot.
   9) Need to determine how to share Snapshots across different accounts (can snapshots be made public?)
   10) specify the s3 bucket to import to the lustre file system when creating the parallel cluster
  

### Create the demo cluster 

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
pcluster update-compute-fleet --region us-east-1 --cluster-name hello-pcluster --status START_REQUESTED
```

### SSH into cluster
(note, replace the centos.pem with your Key Pair)

```
pcluster ssh -v -Y -i ~/centos.pem --cluster-name hello-pcluster
```

### Note, the following commands are used when you are logged into the cluster.

login prompt should look something like (this will depend on what OS was chosen in the yaml file).

[ip-xx-x-xx-xxx pcluster-cmaq]


### Check what modules are available on the Parallel Cluster

```
module avail
```

### Check what version of the compiler is available

```
gcc --version
```

### Delete the demo cluster

```
pcluster delete-cluster --cluster-name hello-pcluster --region us-east-1
```


### To learn more about the pcluster commands

```
pcluster --help
```


### Use a configuration file from the github repo that was cloned to your local machine

```
cd pcluster-cmaq
```

### NOTE: the c5n-4xlarge.yaml is configured to use SPOT instances for the compute nodes
You will need to edit the c5n-4xlarge.yaml to specify your KeyName and SubnetId (use the values generated in your new-hello-world.yaml)
This yaml file specifies ubuntu2004 as the OS, c5n.large for the head node, c5n.4xlarge as the compute nodes and both a /shared Ebs directory(for software install) and a /fsx Lustre File System (for Input and Output Data).

```
vi c5n-4xlarge.yaml
```

### Create the c5n-4xlarge pcluster

```
pcluster create-cluster --cluster-configuration c5n-4xlarge.yaml --cluster-name cmaq --region us-east-1
```

### Check on status of cluster

```
pcluster describe-cluster --region=us-east-1 --cluster-name cmaq
```

After 5-10 minutes, you see the following status:
"clusterStatus": "CREATE_COMPLETE"

### Start the compute nodes

```
pcluster update-compute-fleet --region us-east-1 --cluster-name cmaq --status START_REQUESTED

```

### Login to cluster
(note, replace the centos.pem with your Key Pair)

```
pcluster ssh -v -Y -i ~/centos.pem --cluster-name cmaq
```

## Show compute nodes

```
scontrol show nodes
```

### Before building the software, verify that you can upgrade the compute nodes from the c5n.4xlarge to the c5n.18xlarge
The c5n.18xlarge requires that the elastic network adapter is enabled in the yaml file.
Exit the pcluster and return to your local command line

### Stop the compute nodes

```
pcluster update-compute-fleet --region us-east-1 --cluster-name cmaq --status STOP_REQUESTED
```

### Verify that the compute nodes are stopped

```
pcluster describe-cluster --region=us-east-1 --cluster-name cmaq
```

keep rechecking until you see the following status
"computeFleetStatus": "STOPPED",


### To update compute node from c5n4xlarge to c5n.n18xlarge
You will need to edit the c5n-18xlarge.yaml to specify your KeyName and SubnetId (use the values generated in your new-hello-world.yaml)
This yaml file specifies ubuntu2004 as the OS, c5n.large for the head node, c5n.18xlarge as the compute nodes and both a /shared Ebs directory(for software install) and a /fsx Lustre File System (for Input and Output Data).

```
pcluster update-cluster --region us-east-1 --cluster-name cmaq --cluster-configuration c5n-18xlarge.yaml
```

### Verify that the compute nodes have been updated

```
pcluster describe-cluster --region=us-east-1 --cluster-name cmaq
```

### Re-start the compute nodes

pcluster update-compute-fleet --region us-east-1 --cluster-name cmaq --status START_REQUESTED


### Login to updated cluster
(note, replace the centos.pem with your Key Pair)

```
pcluster ssh -v -Y -i ~/centos.pem --cluster-name cmaq
```


## Check to make sure elastic network adapter (ENA) is enabled

```
modinfo ena
lspci
```
A link to the Amazon website (https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/enhanced-networking-ena.html#test-enhanced-networking-ena)

### Managing the cluster
  1) The head node can be stopped from the AWS Console after stopping compute nodes of the cluster, as long as it is restarted before issuing the pcluster start -c config.[name] command to restart the cluster.
  2) The pcluster slurm queue system will create and destroy the compute nodes, so that helps reduce manual cleanup for the cluster.
  3) The compute nodes are terminated after they have been idle for a period of time.  The yaml setting used for this is as follows:
SlurmSettings:
    ScaledownIdletime: 5
  4) The default idle time is 10 minutes, but I have seen the compute nodes stay up longer than that, so it is important to double check, as you are charged when the compute nodes are available, even if they are not running a job.
  5) It is best to copy/backup the outputs and logs to an s3 bucket for follow-up analysis
  6) After copying output and log files to the s3 bucket the cluster can be deleted
  7) Once the pcluster is deleted all of the volumes, head node, and compute node will be terminated.
 

### Pcluster User Manual
https://docs.aws.amazon.com/parallelcluster/latest/ug/what-is-aws-parallelcluster.html


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
module load openmpi/4.1.1
```



```
module load libfabric-aws/1.13.0amzn1.0
```


### Check what version of the gcc compiler is available

```
 gcc --version
```

gcc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0
Copyright (C) 2019 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.


### Change directories to install and build the libraries and CMAQ

```
cd /shared
git clone https://github.com/lizadams/pcluster-cmaq.git
```


### Build netcdf C and netcdf F libraries - these scripts work for the gcc 8+ compiler

```
cd pcluster-cmaq
./gcc_netcdf_pcluster.csh
```

### A .cshrc script with LD_LIBRARY_PATH was copied to your home directory, enter the shell again and check environment variables that were set using

```
cat ~/.cshrc
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
./gcc_ioapi_pcluseter.csh
```

### Build CMAQ

```
./gcc_cmaq_pcluster.csh
```

## Copy the input data from a S3 bucket (this bucket is not public and needs credentials)
### Note you do no need to copy the data from the S3 Bucket - you can IMPORT the data from the S3 Bucket location when you use an /fsx volume, this import is done in the yaml file prior to creating the cluster.
## set the aws credentials
##  If you don't have credentials, please contact the manager of your aws account. 

### Verify that the /fsx directory exists this is a lustre file system where the I/O is fastest

```
ls /fsx
```

```
aws configure
```

## Use the S3 script to copy the CONUS input data to the /fsx/data volume on the cluster

```
/shared/pcluster-cmaq/s3_scripts/s3_copy_need_credentials_conus.csh
```


## If you get a permissions error, try using this script

```
/shared/pcluster-cmaq/s3_scripts/s3_copy_nosign.csh  ! check that the resulting directory structure matches the run script
```

## Note, this input data requires 44 GB of disk space

```
cd /fsx/data/CONUS
du -sh
```
```
44G	.
```


## For the output data, assuming 2 day CONUS Run, 1 layer, 12 var in the CONC output

```
cd /fsx/data/output/output_CCTM_v532_gcc_2016_CONUS_16x8pe
du -sh
```
18G	.

### For the output data, assuming 2 day CONUS Run, all 35 layers, all 244 variables in CONC output

```
cd /fsx/data/output/output_CCTM_v532_gcc_2016_CONUS_16x8pe_full
du -sh
```

173G	.

### This cluster is configured to have 1.2 Terrabytes of space on /fsx filesystem (minimum size allowed for lustre /fsx), to allow multiple output runs to be stored.

```
 df -h
```

output:
```
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
cd /shared/pcluster-cmaq/run_scripts/cmaq533
cp run*  /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts
cd  /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts
```

#### To run the CONUS Domain

 ```
cd /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/
sbatch run_cctm_2016_12US2.180pe.csh
```
Note, it will take about 3-5 minutes for the compute notes to start up
This is reflected in the Status (ST) of CF (configuring)

```
squeue -u ubuntu
```

output:
```
JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 2    queue1     CMAQ   ubuntu CF       3:00      5 queue1-dy-computeresource1-[1-5]
```


### If the job does not get scheduled, you may need to stop the compute nodes and edit the yaml file to change the instance type from SPOT to ONDEMAND

```
squeue -u ubuntu 
```

output:
```

             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 3   compute     CMAQ   ubuntu  CG      0      10    (BeginTime) 

```

```
squeue -u ubuntu 
```

output:
```

             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON) 
                 3   compute     CMAQ   ubuntu  R      16:50      8 compute-dy-c5n18xlarge-[1-8] 

```

### The 180 pe job should take 80 minutes to run (40 minutes per day)

### If you edit the yaml file, you will need to exit the cluster and stop the comput instances

```
pcluster update-compute-fleet --region us-east-1 --cluster-name cmaq --status STOP_REQUESTED
```

### Then update the yaml file

### Then restart the comput nodes

### you can check on the status of the cluster using CloudWatch

```
https://console.aws.amazon.com/cloudwatch/home?region=us-east-1#dashboards:name=cmaq-us-east-1
https://aws.amazon.com/blogs/compute/monitoring-dashboard-for-aws-parallelcluster/
```


## Note, there are times when the second day run fails, looking for the input file that was output from the first day.

1. This occurs when you use a different file system for the input and output data.
2. Verify that the script specifies the INPUT and OUTPUT Directory are both using the /fsx file system to read the input and write the output.

### Note this may help with networking on the parallel cluster
If the head node must be in the placement group, use the same instance type and subnet for both the head as well as all of the compute nodes. By doing this, the compute_instance_type parameter has the same value as the master_instance_type parameter, the placement parameter is set to cluster, and the compute_subnet_id parameter isn't specified. With this configuration, the value of the master_subnet_id parameter is used for the compute nodes. 
https://docs.aws.amazon.com/parallelcluster/latest/ug/troubleshooting.html


### Note - check the timings while the job is still running using the following command

```
grep 'Processing completed' CTM_LOG_001*
```

output:

```
            Processing completed...    8.8 seconds
            Processing completed...    7.4 seconds
```


### When the job has completed, use tail to view the timing from the log file.

```
tail run_cctmv5.3.3_Bench_2016_12US2.10x18pe.2day.log
```

output:

```
==================================
  ***** CMAQ TIMING REPORT *****
==================================
Start Day: 2015-12-22
End Day:   2015-12-23
Number of Simulation Days: 2
Domain Name:               12US2
Number of Grid Cells:      3409560  (ROW x COL x LAY)
Number of Layers:          35
Number of Processes:       180
   All times are in seconds.

Num  Day        Wall Time
01   2015-12-22   2481.55
02   2015-12-23   2225.34
     Total Time = 4706.89
      Avg. Time = 2353.44
```


### Submit a job to run on 360 processors

```
sbatch run_cctm_2016_12US2.360pe.csh
```

Note, you may get the following message

```
squeue -u ubuntu
```

output:

```
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 5    queue1     CMAQ   ubuntu PD       0:00     10 (Nodes required for job are DOWN, DRAINED or reserved for jobs in higher priority partitions)
```

It seems like the 5 compute nodes used by the 180 pe run are not being released.
I decided to cancel the job, and verify that they are no longer running using the AWS Web interface.
It seems like even after there are not jobs in the queue, the compute nodes are not stopping.

### Force the comput nodes to stop

exit out of the cluster

```
pcluster update-compute-fleet --region us-east-1 --cluster-name cmaq --status STOP_REQUESTED
```

Verify that the compute nodes have stopped in the AWS Web Interface

### Restart the compute nodes

```
pcluster update-compute-fleet --region us-east-1 --cluster-name cmaq --status START_REQUESTED
```


### Login to the pcluster
(note, replace the centos.pem with your Key Pair)

```
pcluster ssh -v -Y -i ~/centos.pem --cluster-name cmaq  
```

### Resbumit the 360 pe job

```
 cd  /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts
 sbatch run_cctm_2016_12US2.360pe.csh
```

### obtained the same message 

```
squeue -u ubuntu
```

output:

```
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 6    queue1     CMAQ   ubuntu PD       0:00     10 (Nodes required for job are DOWN, DRAINED or reserved for jobs in higher priority partitions)
```

### Cancel the 360 pe job

```
scancel 6
```

### Submit a request for a 288 pe job ( 8 x 36 pe) or 8 nodes instead of 10 nodes

```
sbatch run_cctm_2016_12US2.288pe.csh
```

```
squeue -u ubuntu
```

output:

```
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 7    queue1     CMAQ   ubuntu CF       3:06      8 queue1-dy-computeresource1-[1-8]
```

Note, it takes about 5 minutes for the compute nodes to be initialized, once the job is running the ST or status will change from CF (configure) to R

```
squeue -u ubuntu
```

output:

```
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 7    queue1     CMAQ   ubuntu  R      24:57      8 queue1-dy-computeresource1-[1-8]
```

### Check the status of the run 

```
tail CTM_LOG_025.v533_gcc_2016_CONUS_16x18pe_20151222
```

### Check whether the scheduler thinks there are cpus or vcpus

```
sinfo -lN
```

output:

```
Wed Jan 05 19:34:05 2022
NODELIST                       NODES PARTITION       STATE CPUS    S:C:T MEMORY TMP_DISK WEIGHT AVAIL_FE REASON              
queue1-dy-computeresource1-1       1   queue1*       mixed 72     72:1:1      1        0      1 dynamic, none                
queue1-dy-computeresource1-2       1   queue1*       mixed 72     72:1:1      1        0      1 dynamic, none                
queue1-dy-computeresource1-3       1   queue1*       mixed 72     72:1:1      1        0      1 dynamic, none                
queue1-dy-computeresource1-4       1   queue1*       mixed 72     72:1:1      1        0      1 dynamic, none                
queue1-dy-computeresource1-5       1   queue1*       mixed 72     72:1:1      1        0      1 dynamic, none                
queue1-dy-computeresource1-6       1   queue1*       mixed 72     72:1:1      1        0      1 dynamic, none                
queue1-dy-computeresource1-7       1   queue1*       mixed 72     72:1:1      1        0      1 dynamic, none                
queue1-dy-computeresource1-8       1   queue1*       mixed 72     72:1:1      1        0      1 dynamic, none                
queue1-dy-computeresource1-9       1   queue1*       idle~ 72     72:1:1      1        0      1 dynamic, Scheduler health che
queue1-dy-computeresource1-10      1   queue1*       idle~ 72     72:1:1      1        0      1 dynamic, Scheduler health che
```


### Expected run time: 31 minutes per day (62 minutes total)
Check log file to verify

```
==================================
  ***** CMAQ TIMING REPORT *****
==================================
Start Day: 2015-12-22
End Day:   2015-12-23
Number of Simulation Days: 2
Domain Name:               12US2
Number of Grid Cells:      3409560  (ROW x COL x LAY)
Number of Layers:          35
Number of Processes:       288
   All times are in seconds.

Num  Day        Wall Time
01   2015-12-22   1873.00
02   2015-12-23   1699.24
     Total Time = 3572.24
      Avg. Time = 1786.12

```


Again, the compute nodes were not stopped, even when they were idled for more than 15 minutes.  There were no jobs in the queue, but the compute nodes are not stopping.

### Force the comput nodes to stop

exit out of the cluster

```
pcluster update-compute-fleet --region us-east-1 --cluster-name cmaq --status STOP_REQUESTED
```

Verify that the compute nodes have stopped in the AWS Web Interface


Also updated the yaml file to specify an idle time of 5 minutes after which the compute nodes should be deleted.

```
SlurmSettings:
    ScaledownIdletime: 5
```

And also specified to turn multithreading off at the compute node level (previously I had only specified this for the head node) 
```
DisableSimultaneousMultithreading: true
```

```
sinfo -lN
```

output:

```
Wed Jan 05 20:54:01 2022
NODELIST                       NODES PARTITION       STATE CPUS    S:C:T MEMORY TMP_DISK WEIGHT AVAIL_FE REASON              
queue1-dy-computeresource1-1       1   queue1*       idle~ 36     36:1:1      1        0      1 dynamic, none                
queue1-dy-computeresource1-2       1   queue1*       idle~ 36     36:1:1      1        0      1 dynamic, none                
queue1-dy-computeresource1-3       1   queue1*       idle~ 36     36:1:1      1        0      1 dynamic, none                
queue1-dy-computeresource1-4       1   queue1*       idle~ 36     36:1:1      1        0      1 dynamic, none                
queue1-dy-computeresource1-5       1   queue1*       idle~ 36     36:1:1      1        0      1 dynamic, none                
queue1-dy-computeresource1-6       1   queue1*       idle~ 36     36:1:1      1        0      1 dynamic, none                
queue1-dy-computeresource1-7       1   queue1*       idle~ 36     36:1:1      1        0      1 dynamic, none                
queue1-dy-computeresource1-8       1   queue1*       idle~ 36     36:1:1      1        0      1 dynamic, none                
queue1-dy-computeresource1-9       1   queue1*       idle~ 36     36:1:1      1        0      1 dynamic, none                
queue1-dy-computeresource1-10      1   queue1*       idle~ 36     36:1:1      1        0      1 dynamic, none   
```


The other option is to update the yaml file to use an ONDEMAND instead of SPOT instance, if you need to run on 360 processors.


### Run another jobs using 180 pes - need to update the compute nodes

### Stop the compute nodes


```
pcluster update-compute-fleet --region us-east-1 --cluster-name cmaq --status STOP_REQUESTED
```
### To update compute node from C5n4xlarge to C5n.n18xlarge

```
pcluster update-cluster --region us-east-1 --cluster-name cmaq --cluster-configuration C5n-18xlarge.yaml
```



### The CTM_LOG files don't contain any information about the compute nodes that the jobs were run on.
Note, it is important to keep a record of the NPCOL, NPROW setting and the number of nodes and tasks used as specified in the run script: #SBATCH --nodes=16 #SBATCH --ntasks-per-node=8
It is also important to know what volume was used to read and write the input and output data, so it is recommended to save a copy of the standard out and error logs, and a copy of the run scripts to the OUTPUT directory for each benchmark.

```
cd /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts
cp run*.log /fsx/data/output
cp run*.csh /fsx/data/output
```

### Investigate any errors in the CCTM_LOG files


```
cd /fsx/data/output/output_CCTM_v533_gcc_2016_CONUS_10x18pe/LOGS
```

```
grep -i error CTM_LOG_000.v533_gcc_2016_CONUS_10x18pe_20151223
```

output:

```
Error opening file at path-name:
     netCDF error number  -51  processing file "BNDY_SENS_1"
     Error closing netCDF file 
     netCDF error number  -33
      *** FATAL ERROR shutting down Models-3 I/O ***

     Checking header data for file: BNDY_CONC_1
     Error opening file at path-name:
     netCDF error number  -51  processing file "BNDY_SENS_1"
     NetCDF: Unknown file format
     /


     >>> WARNING in subroutine SHUT3 <<<
     Error closing netCDF file
     File name:  CTM_DRY_DEP_1
     netCDF error number  -33


      *** FATAL ERROR shutting down Models-3 I/O ***
```


### To run the CONUS domain to output all layers, all variables in the CONC file

```
cd /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts
sbatch run_cctm_2016_12US2.180pe.full.csh
```

### Check on the status - note that the yaml configuratipn file was modified to remove hyperthreading, so performance may be improved.

```
grep 'Processing completed' CTM_LOG_151.v533_gcc_2016_CONUS_10x18pe_full_20151222
```

output:

```
            Processing completed...    4.6 seconds
            Processing completed...    4.1 seconds
            Processing completed...    4.0 seconds
            Processing completed...    4.0 seconds
            Processing completed...    4.0 seconds
            Processing completed...    4.0 seconds
            Processing completed...    4.0 seconds
            Processing completed...    4.0 seconds
            Processing completed...    4.1 seconds
            Processing completed...    3.9 seconds
            Processing completed...    3.9 seconds
            Processing completed...    3.9 seconds
            Processing completed...    3.8 seconds
            Processing completed...    3.8 seconds
            Processing completed...    5.5 seconds
            Processing completed...    6.3 seconds
            Processing completed...    3.9 seconds
```



### When the run has completed, use the tail command to examing the timing information.

```
tail run_cctmv5.3.3_Bench_2016_12US2.10x18pe.2day.full.log
```

output:

```

==================================
  ***** CMAQ TIMING REPORT *****
==================================
Start Day: 2015-12-22
End Day:   2015-12-23
Number of Simulation Days: 2
Domain Name:               12US2
Number of Grid Cells:      3409560  (ROW x COL x LAY)
Number of Layers:          35
Number of Processes:       180
   All times are in seconds.

Num  Day        Wall Time
01   2015-12-22   2378.73
02   2015-12-23   2210.19
     Total Time = 4588.92
      Avg. Time = 2294.46
```

Results from an older run using CMAQv5.3.2 model on 256 processors

```
tail  run_cctmv5.3.2_Bench_2016_12US2.16x16pe.2day.full.log
```

output:

```
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

```
Older Timing report on 256 processors
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


### Note - the compute nodes have been idle for more than 5 minutes, but they are not being automatically shut down.

Log file was written at -rw-rw-r-- 1 ubuntu ubuntu 563897 Jan  5 22:35 run_cctmv5.3.3_Bench_2016_12US2.10x18pe.2day.full.log


```
sinfo -lN
```

output:

```
Wed Jan 05 22:41:24 2022
NODELIST                       NODES PARTITION       STATE CPUS    S:C:T MEMORY TMP_DISK WEIGHT AVAIL_FE REASON              
queue1-dy-computeresource1-1       1   queue1*       idle% 36     36:1:1      1        0      1 dynamic, none                
queue1-dy-computeresource1-2       1   queue1*       idle% 36     36:1:1      1        0      1 dynamic, none                
queue1-dy-computeresource1-3       1   queue1*       idle% 36     36:1:1      1        0      1 dynamic, none                
queue1-dy-computeresource1-4       1   queue1*       idle% 36     36:1:1      1        0      1 dynamic, none                
queue1-dy-computeresource1-5       1   queue1*       idle% 36     36:1:1      1        0      1 dynamic, none                
queue1-dy-computeresource1-6       1   queue1*       idle~ 36     36:1:1      1        0      1 dynamic, Scheduler health che
queue1-dy-computeresource1-7       1   queue1*       idle~ 36     36:1:1      1        0      1 dynamic, Scheduler health che
queue1-dy-computeresource1-8       1   queue1*       idle~ 36     36:1:1      1        0      1 dynamic, Scheduler health che
queue1-dy-computeresource1-9       1   queue1*       idle~ 36     36:1:1      1        0      1 dynamic, Scheduler health che
queue1-dy-computeresource1-10      1   queue1*       idle~ 36     36:1:1      1        0      1 dynamic, Scheduler health che
```


Actually, I checked again thru the web interface, and the ec2 instances are being terminated after 5+ minutes of idle time.

```
HeadNode	i-099e56e3677d64743	
Running
c5n.large	
2/2 checks passed	
No alarms
us-east-1a	ec2-52-70-13-180.compute-1.amazonaws.com	52.70.13.180	–	–	disabled	cmaq-HeadNodeSecurityGroup-XFONDG0QLJ8D	centos	2022/01/05 11:12 GMT-5
	Compute	i-0ff2de727100abe26	
Terminated
c5n.18xlarge	–	No alarms
us-east-1a	–	18.206.184.46	–	–	disabled	–	–	2022/01/05 16:15 GMT-5 Compute	i-0b9c01acf6664f64c	Terminated c5n.18xlarge	–	No alarms
us-east-1a	–	34.228.213.97	–	–	disabled	–	–	2022/01/05 16:15 GMT-5 Compute	i-02432d9aca69572c2	Terminated c5n.18xlarge	–	No alarms
us-east-1a	–	100.24.1.20	–	–	disabled	–	–	2022/01/05 16:15 GMT-5 Compute	i-01573e1b477a4cb51	Terminated c5n.18xlarge	–	No alarms 
us-east-1a	–	52.206.146.28	–	–	disabled	–	–	2022/01/05 16:15 GMT-5 Compute	i-07a808910c554ef54	Terminated c5n.18xlarge
```


### Submit  288 full CONC output run

```
sbatch run_cctm_2016_12US2.288pe.full.csh
```

review log file

```

==================================
  ***** CMAQ TIMING REPORT *****
==================================
Start Day: 2015-12-22
End Day:   2015-12-23
Number of Simulation Days: 2
Domain Name:               12US2
Number of Grid Cells:      3409560  (ROW x COL x LAY)
Number of Layers:          35
Number of Processes:       288
   All times are in seconds.

Num  Day        Wall Time
01   2015-12-22   1976.35
02   2015-12-23   1871.61
     Total Time = 3847.96
      Avg. Time = 1923.98
```


### Submit 256 pe run

```
sbatch run_cctm_2016_12US2.256pe.csh
```
review log file

```
==================================
  ***** CMAQ TIMING REPORT *****
==================================
Start Day: 2015-12-22
End Day:   2015-12-23
Number of Simulation Days: 2
Domain Name:               12US2
Number of Grid Cells:      3409560  (ROW x COL x LAY)
Number of Layers:          35
Number of Processes:       256
   All times are in seconds.

Num  Day        Wall Time
01   2015-12-22   1289.59
02   2015-12-23   1164.53
     Total Time = 2454.12
      Avg. Time = 1227.06
```



 ### Examine the output files

```
cd /fsx/data/output/output_CCTM_v533_gcc_2016_CONUS_16x18pe_full
ls -lht 
```

output:

```
total 173G
drwxrwxr-x 2 ubuntu ubuntu 145K Jan  5 23:53 LOGS
-rw-rw-r-- 1 ubuntu ubuntu 3.2G Jan  5 23:53 CCTM_CGRID_v533_gcc_2016_CONUS_16x18pe_full_20151223.nc
-rw-rw-r-- 1 ubuntu ubuntu 2.2G Jan  5 23:52 CCTM_ACONC_v533_gcc_2016_CONUS_16x18pe_full_20151223.nc
-rw-rw-r-- 1 ubuntu ubuntu  78G Jan  5 23:52 CCTM_CONC_v533_gcc_2016_CONUS_16x18pe_full_20151223.nc
-rw-rw-r-- 1 ubuntu ubuntu 348M Jan  5 23:52 CCTM_APMDIAG_v533_gcc_2016_CONUS_16x18pe_full_20151223.nc
-rw-rw-r-- 1 ubuntu ubuntu 1.5G Jan  5 23:52 CCTM_WETDEP1_v533_gcc_2016_CONUS_16x18pe_full_20151223.nc
-rw-rw-r-- 1 ubuntu ubuntu 1.7G Jan  5 23:52 CCTM_DRYDEP_v533_gcc_2016_CONUS_16x18pe_full_20151223.nc
-rw-rw-r-- 1 ubuntu ubuntu 3.6K Jan  5 23:22 CCTM_v533_gcc_2016_CONUS_16x18pe_full_20151223.cfg
-rw-rw-r-- 1 ubuntu ubuntu 3.2G Jan  5 23:22 CCTM_CGRID_v533_gcc_2016_CONUS_16x18pe_full_20151222.nc
-rw-rw-r-- 1 ubuntu ubuntu 2.2G Jan  5 23:21 CCTM_ACONC_v533_gcc_2016_CONUS_16x18pe_full_20151222.nc
-rw-rw-r-- 1 ubuntu ubuntu  78G Jan  5 23:21 CCTM_CONC_v533_gcc_2016_CONUS_16x18pe_full_20151222.nc
-rw-rw-r-- 1 ubuntu ubuntu 348M Jan  5 23:21 CCTM_APMDIAG_v533_gcc_2016_CONUS_16x18pe_full_20151222.nc
-rw-rw-r-- 1 ubuntu ubuntu 1.5G Jan  5 23:21 CCTM_WETDEP1_v533_gcc_2016_CONUS_16x18pe_full_20151222.nc
-rw-rw-r-- 1 ubuntu ubuntu 1.7G Jan  5 23:21 CCTM_DRYDEP_v533_gcc_2016_CONUS_16x18pe_full_20151222.nc
-rw-rw-r-- 1 ubuntu ubuntu 3.6K Jan  5 22:49 CCTM_v533_gcc_2016_CONUS_16x18pe_full_20151222.cfg
```

Check disk space

```
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
```
```
setenv AFILE output_CCTM_v533_gcc_2016_CONUS_10x18pe_full/CCTM_ACONC_v533_gcc_2016_CONUS_10x18pe_full_20151222.nc
setenv BFILE output_CCTM_v533_gcc_2016_CONUS_16x18pe_full/CCTM_ACONC_v533_gcc_2016_CONUS_16x18pe_full_20151222.nc
```

```
m3diff
```
hit return several times to accept the default options

```
grep A:B REPORT
```

Should see all zeros. There are some non-zero values. TO DO: need to investigate to determine if this is sensitive to the compiler version.
It appears to have all zeros if the domain decomposition  is the same NPCOL, here, NPCOL differes (10 vs 16)
NPCOL  =  10; @ NPROW = 18
NPCOL  =  16; @ NPROW = 18

```
grep A:B REPORT
```

output

```
 A:B  4.54485E-07@(316, 27, 1) -3.09199E-07@(318, 25, 1)  1.42188E-11  2.71295E-09
 A:B  4.73112E-07@(274,169, 1) -2.36556E-07@(200,113, 1)  3.53046E-11  3.63506E-09
 A:B  7.37607E-07@(226,151, 1) -2.98955E-07@(274,170, 1)  3.68974E-11  5.29013E-09
 A:B  3.15718E-07@(227,150, 1) -2.07219E-07@(273,170, 1)  2.52149E-11  3.60005E-09
 A:B  2.65893E-07@(299,154, 1) -2.90573E-07@(201,117, 1)  1.78237E-12  4.15726E-09
 A:B  3.11527E-07@(300,156, 1) -7.43195E-07@(202,118, 1) -9.04127E-12  6.38413E-09
 A:B  4.59142E-07@(306,160, 1) -7.46921E-07@(203,119, 1) -2.57731E-11  8.06486E-09
 A:B  5.25266E-07@(316,189, 1) -5.90459E-07@(291,151, 1) -2.67232E-11  9.36312E-09
 A:B  5.31785E-07@(294,156, 1) -6.33299E-07@(339,201, 1)  3.01644E-11  1.12862E-08
 A:B  1.01421E-06@(297,168, 1) -5.08502E-07@(317,190, 1)  9.97206E-11  1.35965E-08
 A:B  1.28523E-06@(297,168, 1) -2.96347E-06@(295,160, 1)  1.57728E-10  1.88143E-08
 A:B  1.69873E-06@(298,169, 1) -6.47269E-07@(343,205, 1)  1.99673E-10  1.96824E-08
 A:B  2.10665E-06@(298,170, 1) -8.53091E-07@(290,133, 1)  2.75009E-10  2.38824E-08
 A:B  2.77534E-06@(298,166, 1) -1.38395E-06@(339,201, 1)  4.32676E-10  3.19499E-08
 A:B  4.05498E-06@(298,166, 1) -2.29478E-06@(292,134, 1)  5.94668E-10  4.56470E-08
 A:B  1.64844E-06@(380,195, 1) -1.24970E-05@(312,119, 1)  2.99392E-10  6.27748E-08
 A:B  2.40747E-06@(350,207, 1) -2.38372E-06@(313,120, 1) -1.23841E-11  4.06153E-08
 A:B  2.54810E-06@(353,207, 1) -1.68476E-06@(258,179, 1)  4.69896E-10  4.00601E-08
 A:B  2.92342E-06@(259,180, 1) -1.84122E-06@(258,180, 1)  3.00556E-10  3.75263E-08
 A:B  4.37256E-06@(259,180, 1) -1.51433E-06@(258,180, 1)  3.44610E-10  4.03537E-08
 A:B  5.51227E-06@(313,160, 1) -1.60793E-06@(312,160, 1)  6.49188E-10  4.60905E-08
 A:B  5.58607E-06@(259,182, 1) -6.47921E-06@(278,186, 1)  3.40245E-11  4.89799E-08
 A:B  3.61912E-06@(259,183, 1) -4.28502E-06@(278,187, 1)  2.10923E-10  4.86613E-08
 A:B  2.02795E-06@(278,185, 1) -3.63495E-06@(278,187, 1)  5.26566E-10  5.32271E-08
 A:B  1.25729E-07@(225,183, 1) -8.38190E-08@(200,114, 1)  2.04043E-12  7.34096E-10
 A:B  9.66247E-08@(225,151, 1) -4.09782E-07@(225,182, 1) -6.33767E-12  1.73157E-09
 A:B  2.10712E-07@(225,151, 1) -2.71946E-07@(200,114, 1) -5.41618E-12  1.65727E-09
 A:B  5.45755E-07@(225,182, 1) -1.04494E-06@(200,115, 1) -1.47753E-11  4.57864E-09
 A:B  4.30271E-07@(200,114, 1) -7.39470E-07@(200,116, 1) -3.24581E-11  5.33182E-09
 A:B  7.71135E-07@(225,181, 1) -7.92556E-07@(201,117, 1) -2.74377E-11  6.31589E-09
 A:B  6.33299E-07@(225,182, 1) -6.53090E-07@(202,118, 1) -2.86715E-11  4.42746E-09
 A:B  6.25849E-07@(225,182, 1) -2.21189E-07@(225,184, 1) -5.32567E-12  2.66906E-09
 A:B  3.64147E-07@(306,158, 1) -3.12924E-07@(175,  2, 1)  3.15538E-12  2.74893E-09
```



### To restart the cluster using the software pre-installed on the /shared volume

* Go to the AWS Console
* Select the Master Compute node
* Select the Storage Tab
* Select the Block Device /dev/sv1b
* Click on that volume ID
* Then save as a snapshot.
* Select Snapshots
* find the snapshot that is being created
* Copy the Snapshot ID and place it in the configuration file.
* Delete the old cluster
* Specify the S3 Bucket with the 2 Days of CONUS Input to be imported from the S3 Bucket  (may require permissions)
FsxLustreSettings:
      StorageCapacity: 1200
      ImportPath: s3://conus-benchmark-2day
* Create a new cluster with the /shared directory from the snapshot.

```
pcluster delete-cluster --region=us-east-1 --cluster-name cmaq
```

```
pcluster describe-cluster --region=us-east-1 --cluster-name cmaq
```

output:

```
{
  "creationTime": "2022-01-05T16:04:00.314Z",
  "version": "3.0.2",
  "clusterConfiguration": {
    "url": "https://parallelcluster-92e22c6ec33aa106-v1-do-not-delete.s3.amazonaws.com/parallelcluster/3.0.2/clusters/cmaq-inuy5d6gethxjlya/configs/cluster-config.yaml?versionId=OQmsC5fc9NKl2ZS1vLiohzdaqaHaLz3o&AWSAccessKeyId=AKIAWNJJ2DMFE3ARDU6L&Signature=joadwppofH0dmAWd6VIEoY%2F0klM%3D&Expires=1641439711"
  },
  "tags": [
    {
      "value": "3.0.2",
      "key": "parallelcluster:version"
    }
  ],
  "cloudFormationStackStatus": "DELETE_IN_PROGRESS",
  "clusterName": "cmaq",
  "computeFleetStatus": "UNKNOWN",
  "cloudformationStackArn": "arn:aws:cloudformation:us-east-1:440858712842:stack/cmaq/18477ab0-6e41-11ec-886e-0ee339b6c777",
  "lastUpdatedTime": "2022-01-05T20:47:08.353Z",
  "region": "us-east-1",
  "clusterStatus": "DELETE_IN_PROGRESS"
```

Check cluster status again
```
pcluster describe-cluster --region=us-east-1 --cluster-name cmaq
```

output:

```
{
  "message": "Cluster 'cmaq' does not exist or belongs to an incompatible ParallelCluster major version."
```

Create cluster using ebs /shared directory with CMAQv5.3.3 and libraries installed, and the input data imported from an S3 bucket to the /fsx lustre file system

```
pcluster create-cluster --cluster-configuration c5n-18xlarge.ebs_shared.yaml --cluster-name cmaq --region us-east-1
```

output:

```
{
  "cluster": {
    "clusterName": "cmaq",
    "cloudformationStackStatus": "CREATE_IN_PROGRESS",
    "cloudformationStackArn": "arn:aws:cloudformation:us-east-1:440858712842:stack/cmaq/6cfb1a50-6e99-11ec-8af1-0ea2256597e5",
    "region": "us-east-1",
    "version": "3.0.2",
    "clusterStatus": "CREATE_IN_PROGRESS"
  }
}

 ```

Check status again

```
pcluster describe-cluster --region=us-east-1 --cluster-name cmaq
```

output:

```
{
  "creationTime": "2022-01-06T02:36:18.119Z",
  "version": "3.0.2",
  "clusterConfiguration": {
    "url": "https://parallelcluster-92e22c6ec33aa106-v1-do-not-delete.s3.amazonaws.com/parallelcluster/3.0.2/clusters/cmaq-h466ns1cchvrf3wd/configs/cluster-config.yaml?versionId=3F5xBNZqTGz5UDMBvk8Dj27JDaBlfQwQ&AWSAccessKeyId=AKIAWNJJ2DMFE3ARDU6L&Signature=PJ02HkkiKU3joL1QVHd5ZnNisrE%3D&Expires=1641440204"
  },
  "tags": [
    {
      "value": "3.0.2",
      "key": "parallelcluster:version"
    }
  ],
  "cloudFormationStackStatus": "CREATE_IN_PROGRESS",
  "clusterName": "cmaq",
  "computeFleetStatus": "UNKNOWN",
  "cloudformationStackArn": "arn:aws:cloudformation:us-east-1:440858712842:stack/cmaq/6cfb1a50-6e99-11ec-8af1-0ea2256597e5",
  "lastUpdatedTime": "2022-01-06T02:36:18.119Z",
  "region": "us-east-1",
  "clusterStatus": "CREATE_IN_PROGRESS"
}
```

Start the compute nodes
```
pcluster update-compute-fleet --region us-east-1 --cluster-name cmaq --status START_REQUESTED
```

log into the new cluster
(note replace centos.pem with your Key)

```
pcluster ssh -v -Y -i ~/centos.pem --cluster-name cmaq
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
csh
```

### Load the modules


### change shell and submit job

```
module avail
------------------------------------------------------------ /usr/share/modules/modulefiles -------------------------------------------------------------
dot  libfabric-aws/1.13.2amzn1.0  module-git  module-info  modules  null  openmpi/4.1.1  use.own  
```

```
module load openmpi/4.1.1
module load libfabric-aws/1.13.2amzn1.0
```

Change directories
```
cd /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/
```


### Verify that the input data was imported from the S3 bucket

```
cd /fsx/12US2
```

Notice that the data doesn't take up much space, it must be linked, rather than copied.

```
du -h
```

output

```
27K	./land
33K	./MCIP
28K	./emissions/ptegu
55K	./emissions/ptagfire
27K	./emissions/ptnonipm
55K	./emissions/ptfire_othna
27K	./emissions/pt_oilgas
26K	./emissions/inln_point/stack_groups
51K	./emissions/inln_point
28K	./emissions/cmv_c1c2_12
28K	./emissions/cmv_c3_12
28K	./emissions/othpt
55K	./emissions/ptfire
407K	./emissions
27K	./icbc
518K	.
```

The run scripts are expecting the data to be located under
/fsx/data/CONUS/12US2

Need to make this directory and then link it to the path created when the data was imported by the parallel cluster

```
mkdir -p /fsx/data/CONUS
cd /fsx/data/CONUS
ln -s /fsx/12US2 .
```

Also may need to create the output directory

```
mkdir -p /fsx/data/output
```

### Submit the job to the slurm queue

```
cd /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/
sbatch run_cctm_2016_12US2.256pe.csh
```



### Results from the Parallel Cluster Started with the EBS Volume software from input data copied to /fsx from S3 Bucket

```
==================================
  ***** CMAQ TIMING REPORT *****
==================================
Start Day: 2015-12-22
End Day:   2015-12-23
Number of Simulation Days: 2
Domain Name:               12US2
Number of Grid Cells:      3409560  (ROW x COL x LAY)
Number of Layers:          35
Number of Processes:       256
   All times are in seconds.

Num  Day        Wall Time
01   2015-12-22   1305.99
02   2015-12-23   1165.30
     Total Time = 2471.29
      Avg. Time = 1235.64
```


Information in the log file:

```
Start Model Run At  Thu Jan 6 03:07:08 UTC 2022
information about processor including whether using hyperthreading
Architecture:                    x86_64
CPU op-mode(s):                  32-bit, 64-bit
Byte Order:                      Little Endian
Address sizes:                   46 bits physical, 48 bits virtual
CPU(s):                          36
On-line CPU(s) list:             0-35
Thread(s) per core:              1
Core(s) per socket:              18
Socket(s):                       2
NUMA node(s):                    2
Vendor ID:                       GenuineIntel
CPU family:                      6
Model:                           85
Model name:                      Intel(R) Xeon(R) Platinum 8124M CPU @ 3.00GHz
Stepping:                        4
CPU MHz:                         2999.996
BogoMIPS:                        5999.99
Hypervisor vendor:               KVM
Virtualization type:             full
L1d cache:                       1.1 MiB
L1i cache:                       1.1 MiB
L2 cache:                        36 MiB
L3 cache:                        49.5 MiB
NUMA node0 CPU(s):               0-17
NUMA node1 CPU(s):               18-35
Vulnerability Itlb multihit:     KVM: Mitigation: VMX unsupported
Vulnerability L1tf:              Mitigation; PTE Inversion
Vulnerability Mds:               Vulnerable: Clear CPU buffers attempted, no microcode; SMT Host state unknown
Vulnerability Meltdown:          Mitigation; PTI
Vulnerability Spec store bypass: Vulnerable
Vulnerability Spectre v1:        Mitigation; usercopy/swapgs barriers and __user pointer sanitization
Vulnerability Spectre v2:        Mitigation; Full generic retpoline, STIBP disabled, RSB filling
Vulnerability Srbds:             Not affected
Vulnerability Tsx async abort:   Vulnerable: Clear CPU buffers attempted, no microcode; SMT Host state unknown
Flags:                           fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ss ht syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon rep_good nopl xtopology nonstop_tsc cpuid aperfmperf tsc_known_freq pni pclmulqdq monitor ssse3 fma cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand hypervisor lahf_lm abm 3dnowprefetch invpcid_single pti fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm mpx avx512f avx512dq rdseed adx smap clflushopt clwb avx512cd avx512bw avx512vl xsaveopt xsavec xgetbv1 xsaves ida arat pku ospke
information about cluster
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
queue1*      up   infinite      2  idle~ queue1-dy-computeresource1-[9-10]
queue1*      up   infinite      8  alloc queue1-dy-computeresource1-[1-8]
information about filesystem
Filesystem             Size  Used Avail Use% Mounted on
/dev/root               34G   17G   18G  48% /
devtmpfs                93G     0   93G   0% /dev
tmpfs                   93G     0   93G   0% /dev/shm
tmpfs                   19G  1.1M   19G   1% /run
tmpfs                  5.0M     0  5.0M   0% /run/lock
tmpfs                   93G     0   93G   0% /sys/fs/cgroup
/dev/loop0              25M   25M     0 100% /snap/amazon-ssm-agent/4046
/dev/loop2              56M   56M     0 100% /snap/core18/2246
/dev/loop5              68M   68M     0 100% /snap/lxd/21545
/dev/loop3              33M   33M     0 100% /snap/snapd/13640
/dev/loop4              62M   62M     0 100% /snap/core20/1169
/dev/loop6              44M   44M     0 100% /snap/snapd/14295
10.0.5.119:/home        34G   17G   18G  48% /home
10.0.5.119:/opt/intel   34G   17G   18G  48% /opt/intel
10.0.5.119:/shared      35G  1.5G   31G   5% /shared
/dev/loop7              56M   56M     0 100% /snap/core18/2253
/dev/loop8              62M   62M     0 100% /snap/core20/1270
10.0.12.184@tcp:/fsx   1.1T   44G  1.1T   4% /fsx
10.0.5.119:/opt/slurm   34G   17G   18G  48% /opt/slurm
/dev/loop1              68M   68M     0 100% /snap/lxd/21835
list the mounted volumes
Export list for localhost:
Compiler is set to gcc

Working Directory is /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts
Build Directory is /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/BLD_CCTM_v533_gcc
Output Directory is /fsx/data/output/output_CCTM_v533_gcc_2016_CONUS_16x16pe
Log Directory is /fsx/data/output/output_CCTM_v533_gcc_2016_CONUS_16x16pe/LOGS
Executable Name is CCTM_v533.exe

---CMAQ EXECUTION ID: CMAQ_CCTMv533_ubuntu_20220106_030708_720705625 ---

Set up input and output files for Day 2015-12-22.

Existing Logs and Output Files for Day 2015-12-22 Will Be Deleted
/bin/rm: No match.

CMAQ Processing of Day 20151222 Began at Thu Jan  6 03:07:09 UTC 2022

        CTM_APPL  |  v533_gcc_2016_CONUS_16x16pe_20151222
================================================================================
|                                                                              |
|               The Community Multiscale Air Quality (CMAQ) Model              |
|                                   Version 5.3.3                              |
|                                                                              |
|                          Built and Maintained by the                         |
|                        Office of Research and Development                    |
|                   United States Environmental Protection Agency              |
|                                                                              |
|                            https://www.epa.gov/cmaq                          |
|                                                                              |
|       Source Code:   https://www.github.com/USEPA/cmaq/tree/main             |
|       Documentation: https://www.github.com/USEPA/cmaq/tree/main/DOCS        |
|                                                                              |
|         The CMAQ Model is tested and released with cooperation from          |
|         the Community Modeling and Analysis System (CMAS) Center via         |
|         contract support. CMAS is managed by the Institute for the           |
|         Environment, University of North Carolina at Chapel Hill.            |
|         CMAS URL: (https://www.cmascenter.org)                               |
|                                                                              |
================================================================================

     This program uses the EPA-AREAL/MCNC-EnvPgms/BAMS Models-3
     I/O Applications Programming Interface, [I/O API] which is
     built on top of the netCDF I/O library (Copyright 1993, 1996
     University Corporation for Atmospheric Research/Unidata
     Program) and the PVM parallel-programming library (from
     Oak Ridge National Laboratory).
     Copyright (C) 1992-2002 MCNC,
     (C) 1992-2018 Carlie J. Coats, Jr.,
     (C) 2003-2012 Baron Advanced Meteorological Systems, LLC, and
     (C) 2014-2021 UNC Institute for the Environment.
     Released under the GNU LGPL  License, version 2.1.  See URL

         https://www.gnu.org/licenses/old-licenses/lgpl-2.1.html

     for conditions of use.

     ioapi-3.2: $Id: init3.F90 200 2021-05-10 14:06:20Z coats $
     netCDF version 4.7.1 of Jan  5 2022 16:32:07 $


     ===========================================
     |>---   ENVIRONMENT VARIABLE REPORT   ---<|
     ===========================================

     |> Grid and High-Level Model Parameters:
     +=========================================
      --Env Variable-- | --Value--
      --------------------------------------------------------------------------------
             BLD  |             (default)
          OUTDIR  |  /fsx/data/output/output_CCTM_v533_gcc_2016_CONUS_16x16pe
       NEW_START  |          T
  ISAM_NEW_START  |  Y (default)
       GRID_NAME  |  12US2
       CTM_TSTEP  |       10000
      CTM_RUNLEN  |      240000
    CTM_PROGNAME  |  DRIVER (default)
      CTM_STDATE  |     2015356
      CTM_STTIME  |           0
     NPCOL_NPROW  |  16 16
     CTM_MAXSYNC  |         300
     CTM_MINSYNC  |          60

     |> Multiprocess control, output and error checking:
     +====================================================
      --Env Variable-- | --Value--
      --------------------------------------------------------------------------------
 PRINT_PROC_TIME  |          T
     FL_ERR_STOP  |          F
       CTM_CKSUM  |          T
AVG_FILE_ENDTIME  |          F
   AVG_CONC_SPCS  |  ALL
       CONC_SPCS  |  O3 NO ANO3I ANO3J NO2 FORM ISOP NH3 ANH4I ANH4J ASO4I ASO4J
 ACONC_BLEV_ELEV  |   1 1
  CONC_BLEV_ELEV  |   1 1
 IOAPI_LOG_WRITE  |          F
         VERTEXT  |          F
VERTEXT_COORD_PA  |  /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/lonlat.csv
   gc_matrix_nml  |  /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/BLD_CCTM_v533_gcc/GC_cb6r3_ae7_aq.nml
   ae_matrix_nml  |  /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/BLD_CCTM_v533_gcc/AE_cb6r3_ae7_aq.nml
   nr_matrix_nml  |  /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/BLD_CCTM_v533_gcc/NR_cb6r3_ae7_aq.nml
   tr_matrix_nml  |  /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/BLD_CCTM_v533_gcc/Species_Table_TR_0.nml

     |> Chemistry and Photolysis:
     +=============================
      --Env Variable-- | --Value--
      --------------------------------------------------------------------------------
    CTM_PHOTDIAG  |          F
CORE_SHELL_OPTIC  |          F (default)
 OPTICS_MIE_CALC  |          F (default)
       GEAR_ATOL  |   0.100E-08 (default)
       GEAR_RTOL  |   0.100E-02 (default)
         RB_RTOL  |   0.100E-02 (default)
         RB_ATOL  |   0.100E-06 (default)

     |> Aerosols:
     +=============
      --Env Variable-- | --Value--
      --------------------------------------------------------------------------------
    CTM_AVISDIAG  |          F (default)
  CTM_ZERO_PCSOA  |          F (default)
         CTM_AOD  |          F (default)
      CTM_PMDIAG  |          F
     CTM_APMDIAG  |          T
APMDIAG_BLEV_ELE  |  1 1
 AVG_PMDIAG_SPCS  |             (default)
    STM_SO4TRACK  |          T
      STM_ADJSO4  |          T

     |> Cloud Processes:
     +====================
      --Env Variable-- | --Value--
      --------------------------------------------------------------------------------
        CLD_DIAG  |          F

     |> Air-Surface Exchange Processes:
     +===================================
      --Env Variable-- | --Value--
      --------------------------------------------------------------------------------
      PX_VERSION  |          T
      CTM_ABFLUX  |          F
      CTM_MOSAIC  |          F
    CTM_SFC_HONO  |          T
     CLM_VERSION  |          F
    NOAH_VERSION  |          F
       CTM_STAGE  |          F (default)
   CTM_DEPV_FILE  |          F
      CTM_HGBIDI  |          F
CTM_BIDI_FERT_NH  |          T
 CTM_WBDUST_BELD  |  BELD3
     |> Transport Processes:
     +========================
      --Env Variable-- | --Value--
      --------------------------------------------------------------------------------
CTM_VDIFF_DIAG_F  |          F (default)
  SIGMA_SYNC_TOP  |   0.700E+00
    ADV_HDIV_LIM  |   0.900E+00 (default)
     CTM_ADV_CFL  |   0.950E+00
           KZMIN  |          T
        CTM_WVEL  |          T
   CTM_GRAV_SETL  |          T

     |> Emissions Parameters:
     +=========================
      --Env Variable-- | --Value--
      --------------------------------------------------------------------------------
   EMISSCTRL_NML  |  /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/BLD_CCTM_v533_gcc/EmissCtrl_cb6r3_ae7_aq.nml
      CTM_EMLAYS  |           0 (default)
       N_EMIS_GR  |           2
       N_EMIS_TR  |           0 (default)
     CTM_EMISCHK  |          F
    CTM_BIOGEMIS  |          F
       BIOG_SPRO  |  DEFAULT (default)
        BIOSW_YN  |          F (default)
       SUMMER_YN  |          T (default)
      B3GTS_DIAG  |          F
    CTM_MGEMDIAG  |          F (default)
  CTM_OCEAN_CHEM  |          T
     CTM_WB_DUST  |          F
 CTM_DUSTEM_DIAG  |          F
    CTM_SSEMDIAG  |          F
     CTM_LTNG_NO  |          F
   LTNG_ASSIM_DT  |           0 (default)
          LTNGNO  |  InLine (default)
        USE_NLDN  |          F (default)
        LTNGDIAG  |          F
         MOLSNCG  |   0.350E+03 (default)
         MOLSNIC  |   0.350E+03 (default)
       N_EMIS_PT  |           9
          IPVERT  |           0 (default)
        EMISDIAG  |  F
   EMIS_SYM_DATE  |          F (default)

     |> Process Analysis Parameters:
     +================================
      --Env Variable-- | --Value--
      --------------------------------------------------------------------------------
      CTM_PROCAN  |          F
    PA_BCOL_ECOL  |             (default)
    PA_BROW_EROW  |             (default)
    PA_BLEV_ELEV  |             (default)
       MET_TSTEP  |       10000 (default)

     MET data determined based on WRF ARW version 3.8


          -=-  MPP Processor-to-Subdomain Map  -=-
                 Number of Processors = 256
    ____________________________________________________
    |                                                  |
    |  PE    #Cols    Col_Range     #Rows    Row_Range |
    |__________________________________________________|
    |                                                  |
    |  0       25      1:  25         16      1:  16   |
    |  1       25     26:  50         16      1:  16   |
    |  2       25     51:  75         16      1:  16   |
    |  3       25     76: 100         16      1:  16   |
    |  4       25    101: 125         16      1:  16   |
    |  5       25    126: 150         16      1:  16   |
    |  6       25    151: 175         16      1:  16   |
    |  7       25    176: 200         16      1:  16   |
    |  8       25    201: 225         16      1:  16   |
    |  9       25    226: 250         16      1:  16   |
    | 10       25    251: 275         16      1:  16   |
    | 11       25    276: 300         16      1:  16   |
    | 12       24    301: 324         16      1:  16   |
    | 13       24    325: 348         16      1:  16   |
    | 14       24    349: 372         16      1:  16   |
    | 15       24    373: 396         16      1:  16   |
    | 16       25      1:  25         16     17:  32   |
    | 17       25     26:  50         16     17:  32   |
    | 18       25     51:  75         16     17:  32   |
    | 19       25     76: 100         16     17:  32   |
    | 20       25    101: 125         16     17:  32   |
    | 21       25    126: 150         16     17:  32   |
    | 22       25    151: 175         16     17:  32   |
    | 23       25    176: 200         16     17:  32   |
    | 24       25    201: 225         16     17:  32   |
    | 25       25    226: 250         16     17:  32   |
    | 26       25    251: 275         16     17:  32   |
    | 27       25    276: 300         16     17:  32   |
    | 28       24    301: 324         16     17:  32   |
    | 29       24    325: 348         16     17:  32   |
    | 30       24    349: 372         16     17:  32   |
    | 31       24    373: 396         16     17:  32   |
    | 32       25      1:  25         16     33:  48   |
    | 33       25     26:  50         16     33:  48   |
    | 34       25     51:  75         16     33:  48   |
    | 35       25     76: 100         16     33:  48   |
    | 36       25    101: 125         16     33:  48   |
    | 37       25    126: 150         16     33:  48   |
    | 38       25    151: 175         16     33:  48   |
    | 39       25    176: 200         16     33:  48   |
    | 40       25    201: 225         16     33:  48   |
    | 41       25    226: 250         16     33:  48   |
    | 42       25    251: 275         16     33:  48   |
    | 43       25    276: 300         16     33:  48   |
    | 44       24    301: 324         16     33:  48   |
    | 45       24    325: 348         16     33:  48   |
    | 46       24    349: 372         16     33:  48   |
    | 47       24    373: 396         16     33:  48   |
    | 48       25      1:  25         16     49:  64   |
    | 49       25     26:  50         16     49:  64   |
    | 50       25     51:  75         16     49:  64   |
    | 51       25     76: 100         16     49:  64   |
    | 52       25    101: 125         16     49:  64   |
    | 53       25    126: 150         16     49:  64   |
    | 54       25    151: 175         16     49:  64   |
    | 55       25    176: 200         16     49:  64   |
    | 56       25    201: 225         16     49:  64   |
    | 57       25    226: 250         16     49:  64   |
    | 58       25    251: 275         16     49:  64   |
    | 59       25    276: 300         16     49:  64   |
    | 60       24    301: 324         16     49:  64   |
    | 61       24    325: 348         16     49:  64   |
    | 62       24    349: 372         16     49:  64   |
    | 63       24    373: 396         16     49:  64   |
    | 64       25      1:  25         16     65:  80   |
    | 65       25     26:  50         16     65:  80   |
```


### Results from Parallel Cluster Started with the EBS Volume software with data imported from S3 Bucket

This seems a bit slower than when the data is copied from the S3 Bucket to /fsx

```
==================================
  ***** CMAQ TIMING REPORT *****
==================================
Start Day: 2015-12-22
End Day:   2015-12-23
Number of Simulation Days: 2
Domain Name:               12US2
Number of Grid Cells:      3409560  (ROW x COL x LAY)
Number of Layers:          35
Number of Processes:       256
   All times are in seconds.

Num  Day        Wall Time
01   2015-12-22   1564.90
02   2015-12-23   1381.80
     Total Time = 2946.70
      Avg. Time = 1473.35
```

Older results using CMAQv5.3.2
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

Timing for a 288 pe run

```
tail -n 18 run_cctmv5.3.3_Bench_2016_12US2.16x18pe.2day.log
```

Output:

```

==================================
  ***** CMAQ TIMING REPORT *****
==================================
Start Day: 2015-12-22
End Day:   2015-12-23
Number of Simulation Days: 2
Domain Name:               12US2
Number of Grid Cells:      3409560  (ROW x COL x LAY)
Number of Layers:          35
Number of Processes:       288
   All times are in seconds.

Num  Day        Wall Time
01   2015-12-22   1197.19
02   2015-12-23   1090.45
     Total Time = 2287.64
      Avg. Time = 1143.82
```

Note this performance seems better than earlier runs..
I've added the #SBATCH --exclusive option.  Perhaps that made a difference.


```
tail -n 18 run_cctmv5.3.3_Bench_2016_12US2.10x18pe.2day.log
```

output:

```
==================================
  ***** CMAQ TIMING REPORT *****
==================================
Start Day: 2015-12-22
End Day:   2015-12-23
Number of Simulation Days: 2
Domain Name:               12US2
Number of Grid Cells:      3409560  (ROW x COL x LAY)
Number of Layers:          35
Number of Processes:       180
   All times are in seconds.

Num  Day        Wall Time
01   2015-12-22   1585.67
02   2015-12-23   1394.52
     Total Time = 2980.19
      Avg. Time = 1490.09
```


### Compare the output

```
setenv AFILE /fsx/data/output/output_CCTM_v533_gcc_2016_CONUS_16x16pe/CCTM_ACONC_v533_gcc_2016_CONUS_16x16pe_20151222.nc
setenv BFILE /fsx/data/output/output_CCTM_v533_gcc_2016_CONUS_16x18pe/CCTM_ACONC_v533_gcc_2016_CONUS_16x18pe_20151222.nc
m3diff
```

```
grep A:B REPORT
```

NPCOL  =  16; @ NPROW = 16
NPCOL  =  16; @ NPROW = 18

NPCOL was the same for both runs

Resulted in zero differences in the output

```
 A:B  0.00000E+00@(  1,  0, 0)  0.00000E+00@(  1,  0, 0)  0.00000E+00  0.00000E+00
 A:B  0.00000E+00@(  1,  0, 0)  0.00000E+00@(  1,  0, 0)  0.00000E+00  0.00000E+00
 A:B  0.00000E+00@(  1,  0, 0)  0.00000E+00@(  1,  0, 0)  0.00000E+00  0.00000E+00
 A:B  0.00000E+00@(  1,  0, 0)  0.00000E+00@(  1,  0, 0)  0.00000E+00  0.00000E+00
 A:B  0.00000E+00@(  1,  0, 0)  0.00000E+00@(  1,  0, 0)  0.00000E+00  0.00000E+00
 A:B  0.00000E+00@(  1,  0, 0)  0.00000E+00@(  1,  0, 0)  0.00000E+00  0.00000E+00
 A:B  0.00000E+00@(  1,  0, 0)  0.00000E+00@(  1,  0, 0)  0.00000E+00  0.00000E+00
 A:B  0.00000E+00@(  1,  0, 0)  0.00000E+00@(  1,  0, 0)  0.00000E+00  0.00000E+00
 A:B  0.00000E+00@(  1,  0, 0)  0.00000E+00@(  1,  0, 0)  0.00000E+00  0.00000E+00
 A:B  0.00000E+00@(  1,  0, 0)  0.00000E+00@(  1,  0, 0)  0.00000E+00  0.00000E+00
 A:B  0.00000E+00@(  1,  0, 0)  0.00000E+00@(  1,  0, 0)  0.00000E+00  0.00000E+00
 A:B  0.00000E+00@(  1,  0, 0)  0.00000E+00@(  1,  0, 0)  0.00000E+00  0.00000E+00
 A:B  0.00000E+00@(  1,  0, 0)  0.00000E+00@(  1,  0, 0)  0.00000E+00  0.00000E+00
 A:B  0.00000E+00@(  1,  0, 0)  0.00000E+00@(  1,  0, 0)  0.00000E+00  0.00000E+00
 A:B  0.00000E+00@(  1,  0, 0)  0.00000E+00@(  1,  0, 0)  0.00000E+00  0.00000E+00
 A:B  0.00000E+00@(  1,  0, 0)  0.00000E+00@(  1,  0, 0)  0.00000E+00  0.00000E+00
 A:B  0.00000E+00@(  1,  0, 0)  0.00000E+00@(  1,  0, 0)  0.00000E+00  0.00000E+00
 A:B  0.00000E+00@(  1,  0, 0)  0.00000E+00@(  1,  0, 0)  0.00000E+00  0.00000E+00
 A:B  0.00000E+00@(  1,  0, 0)  0.00000E+00@(  1,  0, 0)  0.00000E+00  0.00000E+00
```


I am going to try a 18x16 pe run for comparison 
NPCOL  =  18; @ NPROW = 16
NPCOL  =  16; @ NPROW = 18

```
tail -n 18 run_cctmv5.3.3_Bench_2016_12US2.18x16pe.2day.log
```

output:

```

==================================
  ***** CMAQ TIMING REPORT *****
==================================
Start Day: 2015-12-22
End Day:   2015-12-23
Number of Simulation Days: 2
Domain Name:               12US2
Number of Grid Cells:      3409560  (ROW x COL x LAY)
Number of Layers:          35
Number of Processes:       288
   All times are in seconds.

Num  Day        Wall Time
01   2015-12-22   1206.01
02   2015-12-23   1095.76
     Total Time = 2301.77
      Avg. Time = 1150.88
```

Then I need to try

NPCOL  =  10 NPROW 16


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


### Exit the cluster

```
exit
```

### Delete cluster from your local machine virtual environment

 ```
 pcluster delete-cluster --region us-east-1 --cluster-name cmaq  ! don't use this yet, it is an example syntax.
 ```


### Timing Information

| Number of PEs | Number of Nodes| NPCOLxNPROW | 1st day Timing | 2nd day of Timing | SBATCH --exclusive | Data Imported or Copied | 
|---------------| -----------    | ----------- | ----------     | ---------------   | ------------------ | ----------  |
| 180           |  5x36          | 10x18       | 2481.55        | 2225.34           | no                 | copied      |
| 180           |  5x36          | 10x18       | 2378.73        | 2378.73           | no                 | copied      |
| 180           |  5x36          | 10x18       | 1585.67        | 1394.52           | yes                | imported    |
| 256           |  8x36          | 16x16       |  1289.59       | 1164.53           | no                 |             | 
| 256           |  8x36          | 16x16       |  1305.99       | 1165.30           |  no                |   imported  | 
| 256           |  8x36          | 16x16       |  1564.90       | 1381.80           |  no                |   imported  |
| 288           |  8x36          |  16x18      |  1976.35       | 1871.61           |  no                |  Copied     |
| 288           |  8x36          | 16x18       |  1197.19       | 1090.45           |  yes               |  Copied     | 
| 288           |  8x36          | 18x16       | 1206.01        | 1095.76           |  yes               |  imported   |

                 


