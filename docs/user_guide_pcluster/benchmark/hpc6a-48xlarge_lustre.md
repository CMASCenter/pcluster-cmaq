Intermediate Tutorial

## Use ParallelCluster pre-installed with software and data.

Step by step instructions for running the CMAQ 12US2 Benchmark for 2 days on a ParallelCluster.

### Obtain YAML file pre-loaded with input data and software 

#### Choose a directory on your local machine to obtain a copy of the github repo.

`cd /your/local/machine/install/path/`

#### Use a configuration file from the github by cloning the repo to your local machine 

`git clone -b main https://github.com/CMASCenter/pcluster-cmaq.git pcluster-cmaq`


`cd pcluster-cmaq`

```{note} To find the default settings for Lustre see:
<a href="https://docs.aws.amazon.com/parallelcluster/latest/ug/SharedStorage-v3.html#SharedStorage-v3-FsxLustreSettings">Lustre Settings for ParallelCluster</a>
```

### Examine Diagram of the YAML file to build pre-installed software and input data. 
Includes Snapshot ID of volume pre-installed with CMAQ software stack and name of S3 Bucket to import data to the Lustre Filesystem

Figure 1. Diagram of YAML file used to configure a ParallelCluster with a c5n.large head node and c5n.18xlarge compute nodes with Software and Data Pre-installed (linked on lustre filesystem)

![hpc6a-48xlarge Software+Data Pre-installed yaml configuration](../../yml_plots/aws_parallel_cluster.png)

### Edit Yaml file 

This Yaml file specifies the /shared directory that contains the CMAQv5.3.3 and libraries, and the input data that will be imported from an S3 bucket to the /fsx lustre file system
Note, the following yaml file is using a hpc6a-48xlarge compute node, and is using ONDEMAND pricing. 

```{note}
Edit the hpc6a.48xlarge.ebs_unencrypted_installed_public_ubuntu2004.ebs_200.fsx_import_east-2b.yaml file to specify your subnet-id and your keypair prior to creating the cluster
```

`vi hpc6a.48xlarge.ebs_unencrypted_installed_public_ubuntu2004.ebs_200.fsx_import_east-2b.yaml`

Output:

```
Region: us-east-2
Image:
  Os: ubuntu2004
HeadNode:
  InstanceType: c6a.xlarge
  Networking:
    SubnetId: subnet-xx-xx-xx                           <<< replace subnetID
  DisableSimultaneousMultithreading: true
  Ssh:
    KeyName: your-key                                   <<< replace keyname
  LocalStorage:
    RootVolume:
      Encrypted: false
Scheduling:
  Scheduler: slurm
  SlurmSettings:
    ScaledownIdletime: 5
  SlurmQueues:
    - Name: queue1
      CapacityType: ONDEMAND 
      Networking:
        SubnetIds:
          - subnet-xx-xx-xxx                            <<< replace subnetID
        PlacementGroup:
          Enabled: true
      ComputeResources:
        - Name: compute-resource-1
          InstanceType: hpc6a.48xlarge
          MinCount: 0
          MaxCount: 10
          DisableSimultaneousMultithreading: true
          Efa:
            Enabled: true
            GdrSupport: false
SharedStorage:
  - MountDir: /shared
    Name: ebs-shared
    StorageType: Ebs
    EbsSettings:
      VolumeType: gp3
      Size: 500
      Encrypted: false
      SnapshotId: snap-0f9592e0ea1749b5b
  - MountDir: /fsx
    Name: name2
    StorageType: FsxLustre
    FsxLustreSettings:
      StorageCapacity: 1200
      ImportPath: s3://cmas-cmaq-conus2-benchmark
```


## Create CMAQ ParallelCluster with software/data pre-installed

`pcluster create-cluster --cluster-configuration hpc6a.48xlarge.ebs_unencrypted_installed_public_ubuntu2004.ebs_200.fsx_import_east-2b.yaml --cluster-name cmaq --region us-east-2`

Output:

```
{
  "cluster": {
    "clusterName": "cmaq",
    "cloudformationStackStatus": "CREATE_IN_PROGRESS",
    "cloudformationStackArn": "arn:aws:cloudformation:us-east-2:440858712842:stack/cmaq/6cfb1a50-6e99-11ec-8af1-0ea2256597e5",
    "region": "us-east-2",
    "version": "3.0.2",
    "clusterStatus": "CREATE_IN_PROGRESS"
  }
}

```

Check status again

`pcluster describe-cluster --region=us-east-2 --cluster-name cmaq`

Output:

```
{
  "creationTime": "2022-01-06T02:36:18.119Z",
  "version": "3.0.2",
  "clusterConfiguration": {
    "url": "
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
  "cloudformationStackArn": 
  "lastUpdatedTime": "2022-01-06T02:36:18.119Z",
  "region": "us-east-2",
  "clusterStatus": "CREATE_IN_PROGRESS"
}
```

After 5-10 minutes, check the status again and recheck until you see the following status: "clusterStatus": "CREATE_COMPLETE"

Check status again

`pcluster describe-cluster --region=us-east-2 --cluster-name cmaq`

Output:

```
  "cloudFormationStackStatus": "CREATE_COMPLETE",
  "clusterName": "cmaq",
  "computeFleetStatus": "RUNNING",
  "cloudformationStackArn": "arn:aws:cloudformation:us-east-1:440858712842:stack/cmaq/3cd2ba10-c18f-11ec-9f57-0e9b4dd12971",
  "lastUpdatedTime": "2022-04-21T16:22:28.879Z",
  "region": "us-east-2",
  "clusterStatus": "CREATE_COMPLETE"
```

Start the compute nodes, if the computeFleetStatus is not set to RUNNING

`pcluster update-compute-fleet --region us-east-1 --cluster-name cmaq --status START_REQUESTED`

## Log into the new cluster
```{note}
replace your-key.pem with your Key Name
```

`pcluster ssh -v -Y -i ~/your-key.pem --region=us-east-2 --cluster-name cmaq`

## Change shell to use tcsh

```
sudo usermod -s /bin/tcsh ubuntu
```

Log out and then log back in to have the shell take effect.

Copy a file to set paths

```
cd /shared/cyclecloud-cmaq
cp dot.cshrc.vm ~/.cshrc
```

## Verify Software

The software is pre-loaded on the /shared volume of the ParallelCluster.  The software was previously loaded and saved to the snapshot.

`ls /shared/build`

Create a .cshrc file by copying it from the git repo that is on /shared/pcluster-cmaq

`cp /shared/pcluster-cmaq/dot.cshrc.pcluster ~/.cshrc`

Source shell

`csh`

Load the modules

`module avail`

Output:

```
------------------------------------------------------------ /usr/share/modules/modulefiles -------------------------------------------------------------
dot  libfabric-aws/1.13.2amzn1.0  module-git  module-info  modules  null  openmpi/4.1.1  use.own
```

Load the modules openmpi and libfabric

`module load openmpi/4.1.1`

`module load libfabric-aws/1.13.2amzn1.0`


## Verify Input Data

The input data was imported from the S3 bucket to the lustre file system (/fsx).

`cd /fsx/data/CMAQ_Modeling_Platform_2016/CONUS/12US2/`

Notice that the data doesn't take up much space, it must be linked, rather than copied.

`du -h`

Output:

```
27K     ./land
33K     ./MCIP
28K     ./emissions/ptegu
55K     ./emissions/ptagfire
27K     ./emissions/ptnonipm
55K     ./emissions/ptfire_othna
27K     ./emissions/pt_oilgas
26K     ./emissions/inln_point/stack_groups
51K     ./emissions/inln_point
28K     ./emissions/cmv_c1c2_12
28K     ./emissions/cmv_c3_12
28K     ./emissions/othpt
55K     ./emissions/ptfire
407K    ./emissions
27K     ./icbc
518K    .
```

Change the group and ownership permissions on the /fsx/data directory

`sudo chown ubuntu /fsx/data`

`sudo chgrp ubuntu /fsx/data`

Create the output directory

`mkdir -p /fsx/data/output`

## Examine CMAQ Run Scripts

The run scripts are available in two locations, one in the CMAQ scripts directory. 

Another copy is available in the pcluster-cmaq repo.
Do a git pull to obtain the latest scripts in the pcluster-cmaq repo.

`cd /shared/pcluster-cmaq`

`git pull`

Copy the run scripts from the repo.
Note, there are different run scripts depending on what compute node is used. This tutorial assumes hpc6a-48xlarge is the compute node.

`cp /shared/pcluster-cmaq/run_scripts/hpc6a_shared/*.pin.codemod.csh /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/`

```{note}
The time that it takes the 2 day CONUS benchmark to run will vary based on the number of CPUs used, and the compute node that is being used, and what disks are used for the I/O (EBS or lustre).
The Benchmark Scaling Plot for hpc6a-48xlarge on fsx and shared (include here).
```

Examine how the run script is configured

`head -n 30 /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/run_cctm_2016_12US2.576pe.6x96.24x24.pcluster.hpc6a.48xlarge.fsx.pin.codemod.csh`

```
#!/bin/csh -f
## For hpc6a.48xlarge (96 cpu)
## works with cluster-ubuntu.yaml
## data on /fsx directory
#SBATCH --nodes=6
#SBATCH --ntasks-per-node=96
#SBATCH --exclusive
#SBATCH -J CMAQ
#SBATCH -o /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/run_cctmv5.3.3_Bench_2016_12US2.hpc6a.48xlarge.576.6x96.24x24pe.2day.pcluster.fsx.pin.codemod.log
#SBATCH -e /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/run_cctmv5.3.3_Bench_2016_12US2.hpc6a.48xlarge.576.6x96.24x24pe.2day.pcluster.fsx.pin.codemod.log
```

```{note}
In this run script, slurm or SBATCH requests 6 nodes, each node with 96 pes, or 6x96 = 576 pes
```

Verify that the NPCOL and NPROW settings in the script are configured to match what is being requested in the SBATCH commands that tell slurm how many compute nodes to  provision. 
In this case, to run CMAQ using on 108 cpus (SBATCH --nodes=6 and --ntasks-per-node=69), use NPCOL=24 and NPROW=24.

`grep NPCOL /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/run_cctm_2016_12US2.576pe.6x96.24x24.pcluster.hpc6a.48xlarge.fsx.pin.codemod.csh`

Output:

```
   setenv NPCOL_NPROW "1 1"; set NPROCS   = 1 # single processor setting
   @ NPCOL  =  24; @ NPROW = 24
   @ NPROCS = $NPCOL * $NPROW
   setenv NPCOL_NPROW "$NPCOL $NPROW"; 

```


## Submit Job to Slurm Queue

`cd /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/`

`sbatch run_cctm_2016_12US2.576pe.6x96.24x24.pcluster.hpc6a.48xlarge.fsx.pin.codemod.csh`


### Check status of run

`squeue `

Output:

```
JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 1    queue1     CMAQ   ubuntu PD       0:00      6 (BeginTime)
```

### Successfully started run

`squeue`

```
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 5    queue1     CMAQ   ubuntu  R      22:39      6 queue1-dy-compute-resource-1-[1-6]
```

### Once the job is successfully running 

Check on the log file status

`grep -i 'Processing completed.' CTM_LOG_001*_gcc_2016*`

Output:

```
            Processing completed...    6.5 seconds
            Processing completed...    6.5 seconds
            Processing completed...    6.5 seconds
            Processing completed...    6.5 seconds
            Processing completed...    6.4 seconds
```

Once the job has completed running the two day benchmark check the log file for the timings.

`tail -n 5 run_cctmv5.3.3_Bench_2016_12US2.hpc6a.48xlarge.576.6x96.24x24pe.2day.pcluster.fsx.pin.codemod.2.log`

Output:

```
Num  Day        Wall Time
01   2015-12-22   1028.33
02   2015-12-23   916.31
     Total Time = 1944.64
      Avg. Time = 972.32
```




```{note}
if you see the following message, you may want to submit a job that requires fewer PEs.
```

```
ip-10-0-5-165:/shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts% squeue
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 1    queue1     CMAQ   ubuntu PD       0:00      6 (Nodes required for job are DOWN, DRAINED or reserved for jobs in higher priority partitions)
```

### If you repeatedly see that the job is not successfully provisioned, cancel the job.

To cancel the job use the following command

`scancel 1`

### Try submitting a smaller job to the queue.

`sbatch run_cctm_2016_12US2.96pe.1x96.16x8.pcluster.hpc6a.48xlarge.fsx.pin.codemod.csh`

### Check status of run

`squeue `

### Check to view any errors in the log on the parallel cluster

`vi /var/log/parallelcluster/slurm_resume.log`

 An error occurred (MaxSpotInstanceCountExceeded) when calling the RunInstances operation: Max spot instance count exceeded

```{note}
If you encounter this error, you will need to submit a request to increase this spot instance limit using the AWS Website.
```


### if the job will not run using SPOT pricing, then update the compute nodes to use ONDEMAND pricing
(note - hpc6a-48xlarge does not offer SPOT pricing!)

To do this, exit the cluster, stop the compute nodes, then edit the yaml file to modify SPOT to ONDEMAND.

`exit`


On your local computer use the following command to stop the compute nodes

`pcluster update-compute-fleet --region us-east-2 --cluster-name cmaq --status STOP_REQUESTED`


Edit the yaml file to modify SPOT to ONDEMAND, then update the cluster using the following command:

`pcluster update-cluster --region us-east-2 --cluster-name cmaq --cluster-configuration  hpc6a.48xlarge.ebs_unencrypted_installed_public_ubuntu2004.ebs_200.fsx_import_east-2b.yaml`

Output:

```
{
  "cluster": {
    "clusterName": "cmaq",
    "cloudformationStackStatus": "UPDATE_IN_PROGRESS",
    "cloudformationStackArn": "xx-xxx-xx",
    "region": "us-east-2",
    "version": "3.1.1",
    "clusterStatus": "UPDATE_IN_PROGRESS"
  },
  "changeSet": [
    {
      "parameter": "Scheduling.SlurmQueues[queue1].CapacityType",
      "requestedValue": "ONDEMAND",
      "currentValue": "SPOT"                                      <<<  Modify to use ONDEMAND
    }
  ]
}
```

Check status of updated cluster

`pcluster describe-cluster --region=us-east-2 --cluster-name cmaq`

Output:

```
"clusterStatus": "UPDATE_IN_PROGRESS"
```

once you see

```
  "clusterStatus": "UPDATE_COMPLETE"
```

Restart the compute nodes

`pcluster update-compute-fleet --region us-east-2 --cluster-name cmaq --status START_REQUESTED`


Verify that compute nodes have started

`pcluster describe-cluster --region=us-east-2 --cluster-name cmaq`

Output:

```
 "computeFleetStatus": "RUNNING",
```

Re-login to the cluster


`pcluster ssh -v -Y -i ~/your-key.pem --region=us-east-2 --cluster-name cmaq`


### Submit a new job using the updated ondemand compute nodes

`sbatch run_cctm_2016_12US2.576pe.6x96.24x24.pcluster.hpc6a.48xlarge.fsx.pin.codemod.csh`

```{note}
If you still have difficulty running a job in the slurm queue, there may be other issues that need to be resolved.
```

Verify that your IAM Policy has been created for your account.

Someone with administrative permissions should eable the spot instances IAM Policy: AWSEC2SpotServiceRolePolicy

An alternative way to enable this policy is to login to the EC2 Website and launch a spot instance.
The service policy will be automatically created, that can then be used by ParallelCluster.

### Submit a 576 pe job 6 nodes x 96 cpus on the EBS volume /shared

`sbatch run_cctm_2016_12US2.576pe.6x96.24x24.pcluster.hpc6a.48xlarge.shared.pin.csh`

`grep -i 'Processing completed.' CTM_LOG_036.v533_gcc_2016_CONUS_6x12pe_20151223`

Output:

```
            Processing completed...    5.1 seconds
            Processing completed...    2.0 seconds
            Processing completed...    2.0 seconds
            Processing completed...    1.9 seconds
            Processing completed...    1.9 seconds
            Processing completed...    2.0 seconds
            Processing completed...    2.0 seconds
            Processing completed...    1.9 seconds

```


`tail -n 18`

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
Number of Processes:       576
   All times are in seconds.

Num  Day        Wall Time
01   2015-12-22   1043.09
02   2015-12-23   932.98
     Total Time = 1976.07
      Avg. Time = 988.03

```

## Submit a minimum of 2 benchmark runs

Ideally, two CMAQ runs should be submitted to the slurm queue, using two different NPCOLxNPROW configurations, to create output needed for the QA and Post Processing Sections in Chapter 6.
If the NPCOL are different, then the answers in the ACONC file will not be identical, and you will see the differences in the QA step.
