# Create CMAQ Cluster using SPOT pricing

## Use an existing yaml file to create a cluster

### Use a configuration file from the github repo that was cloned to your local machine

```
cd pcluster-cmaq
```

###  edit the c5n-4xlarge.yaml
NOTE: the c5n-4xlarge.yaml is configured to use SPOT instances for the compute nodes

```
vi c5n-4xlarge.yaml
```

### replace the key pair and subnet ID in the c5n-4xlarge.yaml file with the values created when you configured the demo cluster

```
Region: us-east-1
Image:
  Os: ubuntu2004
HeadNode:
  InstanceType: c5n.large
  Networking:
    SubnetId: subnet-018cfea3edf3c4765  << replace
  DisableSimultaneousMultithreading: true
  Ssh:
    KeyName: centos                     << replace
Scheduling:
  Scheduler: slurm
  SlurmQueues:
    - Name: queue1
      CapacityType: SPOT
      Networking:
        SubnetIds:
          - subnet-018cfea3edf3c4765    << replace
      ComputeResources:
        - Name: compute-resource-1
          InstanceType: c5n.4xlarge
          MinCount: 0
          MaxCount: 10
          DisableSimultaneousMultithreading: true
SharedStorage:
  - MountDir: /shared
    Name: ebs-shared
    StorageType: Ebs
  - MountDir: /fsx
    Name: name2
    StorageType: FsxLustre
    FsxLustreSettings:
      StorageCapacity: 1200
```

## Create the c5n-4xlarge pcluster

```
pcluster create-cluster --cluster-configuration c5n-4xlarge.yaml --cluster-name cmaq --region us-east-1
```

### Check on status of cluster

```
pcluster describe-cluster --region=us-east-1 --cluster-name cmaq
```
After 5-10 minutes, you see the following status: "clusterStatus": "CREATE_COMPLETE"

### Start the compute nodes

```
pcluster update-compute-fleet --region us-east-1 --cluster-name cmaq --status START_REQUESTED
```

## Login to cluster
(note, replace the centos.pem with your Key Pair)

```
pcluster ssh -v -Y -i ~/centos.pem --cluster-name cmaq
```

### Show compute nodes

```
scontrol show nodes
```

## Update the compute nodes

### Before building the software, verify that you can update the compute nodes from the c5n.4xlarge to c5n.18xlarge 

The c5n.18xlarge requires that the elastic network adapter is enabled in the yaml file. Exit the pcluster and return to your local command line

### Exit the cluster

```
exit
```


### Stop the compute nodes

```
pcluster update-compute-fleet --region us-east-1 --cluster-name cmaq --status STOP_REQUESTED
```

### Verify that the compute nodes are stopped

```
pcluster describe-cluster --region=us-east-1 --cluster-name cmaq
```

keep rechecking until you see the following status "computeFleetStatus": "STOPPED",

### Update compute node from c5n4xlarge to c5n.n18xlarge

You will need to edit the c5n-18xlarge.yaml to specify your KeyName and SubnetId (use the values generated in your new-hello-world.yaml) This yaml file specifies ubuntu2004 as the OS, c5n.large for the head node, c5n.18xlarge as the compute nodes and both a /shared Ebs directory(for software install) and a /fsx Lustre File System (for Input and Output Data) and enables the elastic fabric adapter.

```
vi c5n-18xlarge.yaml
```

```
Region: us-east-1
Image:
  Os: ubuntu2004
HeadNode:
  InstanceType: c5n.large
  Networking:
    SubnetId: subnet-018cfea3edf3c4765      <<<  replace
  DisableSimultaneousMultithreading: true
  Ssh:
    KeyName: centos                         <<<  replace
Scheduling:
  Scheduler: slurm
  SlurmSettings:
    ScaledownIdletime: 5
  SlurmQueues:
    - Name: queue1
      CapacityType: SPOT
      Networking:
        SubnetIds:
          - subnet-018cfea3edf3c4765         <<<  replace
        PlacementGroup:
          Enabled: true
      ComputeResources:
        - Name: compute-resource-1
          InstanceType: c5n.18xlarge
          MinCount: 0
          MaxCount: 10
          DisableSimultaneousMultithreading: true
          Efa:                                     <<< Note new section that enables elastic fabric adapter
            Enabled: true
            GdrSupport: false
SharedStorage:
  - MountDir: /shared
    Name: ebs-shared
    StorageType: Ebs
  - MountDir: /fsx
    Name: name2
    StorageType: FsxLustre
    FsxLustreSettings:
      StorageCapacity: 1200
```

### Update cluster to use c5n.18xlarge compute node

```
pcluster update-cluster --region us-east-1 --cluster-name cmaq --cluster-configuration c5n-18xlarge.yaml
```

### Verify that the compute nodes have been updated

```
pcluster describe-cluster --region=us-east-1 --cluster-name cmaq
```

### Re-start the compute nodes

```
pcluster update-compute-fleet --region us-east-1 --cluster-name cmaq --status START_REQUESTED
```

## Install CMAQ sofware on parallel cluster

### Login to updated cluster
(note, replace the centos.pem with your Key Pair)

```
pcluster ssh -v -Y -i ~/centos.pem --cluster-name cmaq
```

### Check to make sure elastic network adapter (ENA) is enabled

```
modinfo ena
lspci
```

### Check what modules are available on the cluster

```
module avail
```

### Load the openmpi module

```
module load openmpi/4.1.1
```

### Load the Libfabric module

```
module load libfabric-aws/1.13.0amzn1.0
```

### Verify the gcc compiler version is greater than 8.0

```
 gcc --version
```

output:

```
gcc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0 Copyright (C) 2019 Free Software Foundation, Inc. This is free software; see the source for copying conditions. There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

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
./gcc_ioapi_pcluster.csh
```

### Build CMAQ

```
./gcc_cmaq_pcluster.csh
```

## Obtain the Input data from a public S3 Bucket
Two methods are available either importing the data on the lustre file system using the yaml file to specify the s3 bucket location or copying the data using s3 copy commands.

### First Method: Import the data by specifying it in the yaml file - example available in c5n-18xlarge.ebs_shared.yaml

```
  - MountDir: /fsx
    Name: name2
    StorageType: FsxLustre
    FsxLustreSettings:
      StorageCapacity: 1200
      ImportPath: s3://conus-benchmark-2day    <<<  specify name of S3 bucket
```
This requires that the S3 bucket specified is publically available


### Second Method: Copy the data using the s3 command line

### set the aws credentials
If you don't have credentials, please contact the manager of your aws account.

### Verify that the /fsx directory exists this is a lustre file system where the I/O is fastest

```
ls /fsx
```

### Set up your credentials for using s3 copy

```
aws configure
```

### Use the S3 script to copy the CONUS input data to the /fsx/data volume on the cluster
(note this script is only for use by CMAS staff (due to permissions issue))

```
/shared/pcluster-cmaq/s3_scripts/s3_copy_need_credentials_conus.csh
```

### Public S3 script to copy the CONUS input data to /fsx/data volume on the cluster

```
/shared/pcluster-cmaq/s3_scripts/s3_copy_nosign.csh  ! check that the resulting directory structure matches the run script
```

### Note, this input data requires 44 GB of disk space  (if you use the yaml file to import the data to the lustre file system rather than copying the data you save this space)

```
cd /fsx/data/CONUS
du -sh
```

output:

```
44G	.
```

### CMAQ Cluster is configured to have 1.2 Terrabytes of space on /fsx filesystem (minimum size allowed for lustre /fsx), to allow multiple output runs to be stored.

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

## Run CMAQv5.3.3 on Parallel Cluster

### Copy the run scripts to the run directory

```
cd /shared/pcluster-cmaq/run_scripts/cmaq533
cp run*  /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts
cd  /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts
```

### Run the CONUS Domain on 180 pes

```
cd /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/
sbatch run_cctm_2016_12US2.180pe.csh
```

Note, it will take about 3-5 minutes for the compute notes to start up This is reflected in the Status (ST) of CF (configuring)

### Check the status in the queue

```
squeue -u ubuntu
```

output:

```
JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 2    queue1     CMAQ   ubuntu CF       3:00      5 queue1-dy-computeresource1-[1-5]
```
After 5 minutes the status will change once the compute nodes have been created and the job is running

```
squeue -u ubuntu 
```

output:

```

             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON) 
                 3   compute     CMAQ   ubuntu  R      16:50      8 compute-dy-c5n18xlarge-[1-8] 
```

The 180 pe job should take 60 minutes to run (30 minutes per day)

### check on the status of the cluster using CloudWatch

```
https://console.aws.amazon.com/cloudwatch/home?region=us-east-1#dashboards:name=cmaq-us-east-1
https://aws.amazon.com/blogs/compute/monitoring-dashboard-for-aws-parallelcluster/
```

### check the timings while the job is still running using the following command

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

### Submit a request for a 288 pe job ( 8 x 36 pe) or 8 nodes instead of 10 nodes

```
sbatch run_cctm_2016_12US2.288pe.csh
```

### Check on the status in the queue

```
squeue -u ubuntu
```

Note, it takes about 5 minutes for the compute nodes to be initialized, once the job is running the ST or status will change from CF (configure) to R

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

Note: on a c5n.18xlarge, the number of virtual cpus is 72, if you run with 
### edit run script to use
SBATCH --exclusive 

### edit the yaml file to use
DisableSimultaneousMultithreading: true, then you should only see 36 CPUS



A link to the Amazon website (https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/enhanced-networking-ena.html#test-enhanced-networking-ena)

### Tips to managing the parallel cluster

1. The head node can be stopped from the AWS Console after stopping compute nodes of the cluster, as long as it is restarted before issuing the command to restart the cluster.
2. The pcluster slurm queue system will create and destroy the compute nodes, so that helps reduce manual cleanup for the cluster.
3. The compute nodes are terminated after they have been idle for a period of time. The yaml setting used for this is as follows: SlurmSettings: ScaledownIdletime: 5
4. The default idle time is 10 minutes, but I have seen the compute nodes stay up longer than that, so it is important to double check, as you are charged when the compute nodes are available, even if they are not running a job.
5. copy/backup the outputs and logs to an s3 bucket for follow-up analysis
6. After copying output and log files to the s3 bucket the cluster can be deleted
7. Once the pcluster is deleted all of the volumes, head node, and compute node will be terminated, and costs will only be incurred by the S3 Bucket storage.

## Pcluster User Manual

https://docs.aws.amazon.com/parallelcluster/latest/ug/what-is-aws-parallelcluster.html


