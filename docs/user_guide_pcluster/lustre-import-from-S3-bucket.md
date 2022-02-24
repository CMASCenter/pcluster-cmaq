## Run CMAQ using Parallel Cluster YAML that is pre-loaded with input data and software 

### Importing data from S3 Bucket to Lustre

1. Saves storage cost
2. Removes need to copy data from S3 bucket to Lustre file system. FSx for Lustre integrates natively with Amazon S3, making it easy for you to process HPC data sets stored in Amazon S3
3. Simplifies running HPC workloads on AWS
4. Amazon FSx for Lustre uses parallel data transfer techniques to transfer data to and from S3 at up to hundreds of GBs/s.

<a href="https://www.amazonaws.cn/en/fsx/lustre/faqs/">Lustre FAQs</a>

<a href="https://docs.amazonaws.cn/en_us/fsx/latest/LustreGuide/performance.html">Lustre Performance Documentation</a>

To find the default settings for Lustre see:
<a href="https://docs.aws.amazon.com/parallelcluster/latest/ug/SharedStorage-v3.html#SharedStorage-v3-FsxLustreSettings">Lustre Settings for Parallel Cluster</a>

### Diagram of the YAML file to build pre-installed software and input data. 
Includes Snapshot ID of volume pre-installed with CMAQ software stack and name of S3 Bucket to import data to the Lustre Filesystem

Figure 1. Diagram of YAML file used to configure a Parallel Cluster with a c5n.large head node and c5n.18xlarge compute nodes with Software and Data Pre-installed

![c5n-18xlarge Software+Data Pre-installed yaml configuration](../yml_plots/c5n-18xlarge.ebs_shared-yaml.fsx_import.png)

### Create cluster using ebs /shared directory with CMAQv5.3.3 and libraries installed, and the input data imported from an S3 bucket to the /fsx lustre file system

Note - you need to edit the c5n-18xlarge.ebs_unencrypted_installed_public_ubuntu2004.fsx_import.yaml file to specify your subnet-id and your keypair prior to creating the cluster

```
vi c5n-18xlarge.ebs_unencrypted_installed_public_ubuntu2004.fsx_import.yaml
```

```
Region: us-east-1
Image:
  Os: ubuntu2004
HeadNode:
  InstanceType: c5n.large
  Networking:
    SubnetId: subnet-xx-xx-xx                           <<< replace subnetID
  DisableSimultaneousMultithreading: true
  Ssh:
    KeyName: your-key                                   <<< replace keyname
Scheduling:
  Scheduler: slurm
  SlurmSettings:
    ScaledownIdletime: 5
  SlurmQueues:
    - Name: queue1
      CapacityType: SPOT
      Networking:
        SubnetIds:
          - subnet-xx-xx-xxx                            <<< replace subnetID
        PlacementGroup:
          Enabled: true
      ComputeResources:
        - Name: compute-resource-1
          InstanceType: c5n.18xlarge
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
      SnapshotId: snap-065979e115804972e
  - MountDir: /fsx
    Name: name2
    StorageType: FsxLustre
    FsxLustreSettings:
      StorageCapacity: 1200
      ImportPath: s3://conus-benchmark-2day
```


### Create the CMAQ MVP Parallel Cluster with software/data pre-installed

```
pcluster create-cluster --cluster-configuration c5n-18xlarge.ebs_unencrypted_installed_public_ubuntu2004.fsx_import.yaml --cluster-name cmaq --region us-east-1
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
  "region": "us-east-1",
  "clusterStatus": "CREATE_IN_PROGRESS"
}
```

After 5-10 minutes, you see the following status: "clusterStatus": "CREATE_COMPLETE"

Start the compute nodes

```
pcluster update-compute-fleet --region us-east-1 --cluster-name cmaq --status START_REQUESTED
```

log into the new cluster
(note replace your-key.pem with your Key)

```
pcluster ssh -v -Y -i ~/your-key.pem --cluster-name cmaq
```

### Verified that starting the Parallel Cluster with the /shared volume from the EBS drive snapshot

```
ls /shared/build
```

### The .cshrc file was not saved, so I copied it from the git repo

```
cp /shared/pcluster-cmaq/dot.cshrc.pcluster ~/.cshrc
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

### Load the modules openmpi and libfabric

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

### Verify that the run scripts are updated and pre-configured for the parallel cluster by comparing with what is available in the github repo

`cd /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts`

Example:

`diff /shared/pcluster-cmaq/run_scripts/cmaq533/run_cctm_2016_12US2.180pe.5x36.pcluster.csh .`

Only if needed, copy the run scripts from the repo.

`cp /shared/pcluster-cmaq/run_scripts/cmaq533/run*pcluster.csh /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/`

### Examine how the run script is configured

`head  /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/run_cctm_2016_12US2.256pe.8x32.pcluster.csh`

Output:

```
#!/bin/csh -f
## For c5n.18xlarge (72 vcpu - 36 cpu)         <<< this run script is configured to run on c5n.18xlarge with hyperthreading turned off (36 cpus)
## works with cluster-ubuntu.yaml
## data on /fsx directory
#SBATCH --nodes=8
#SBATCH --ntasks-per-node=32                   <<<  note, there are 36 cpus per node, but we only need 32 of them to run a 256 cpu job (8x32)
#SBATCH -J CMAQ
#SBATCH --exclusive
#SBATCH -o /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/run_cctmv5.3.3_Bench_2016_12US2.16x16pe.2day.pcluster.log        << NPCOLxNPROW = 16 x 16
#SBATCH -e /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/run_cctmv5.3.3_Bench_2016_12US2.16x16pe.2day.pcluster.log
```

### Verify that the NPCOL and NPROW settings are configured to run on 256 processors

`grep NPCOL /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/run_cctm_2016_12US2.256pe.8x32.pcluster.csh`

Output:

```
   setenv NPCOL_NPROW "1 1"; set NPROCS   = 1 # single processor setting
   @ NPCOL  =  16; @ NPROW = 16
   @ NPROCS = $NPCOL * $NPROW
   setenv NPCOL_NPROW "$NPCOL $NPROW"; 
```


### Submit the job to the slurm queue

```
cd /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/
sbatch run_cctm_2016_12US2.256pe.8x32.pcluster.csh
```


### Check status of run

`squeue `

Output:

```
JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 1    queue1     CMAQ   ubuntu PD       0:00      8 (BeginTime)
```

Note if you see the following message, you may want to submit a job that requires fewer PES.

```
ip-10-0-5-165:/shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts% squeue
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 1    queue1     CMAQ   ubuntu PD       0:00      8 (Nodes required for job are DOWN, DRAINED or reserved for jobs in higher priority partitions)
```

`scancel `

`sbatch run_cctm_2016_12US2.180pe.5x36.pcluster.csh`

Or - you may need to update the compute nodes to use ONDEMAND instead of SPOT pricing.

`pcluster update-cluster --region us-east-1 --cluster-name cmaq --cluster-configuration  c5n-18xlarge.ebs_unencrypted_installed_public_ubuntu2004.fsx_import.yaml`

Output:

```
{
  "cluster": {
    "clusterName": "cmaq",
    "cloudformationStackStatus": "UPDATE_IN_PROGRESS",
    "cloudformationStackArn": "xx-xxx-xx",
    "region": "us-east-1",
    "version": "3.1.1",
    "clusterStatus": "UPDATE_IN_PROGRESS"
  },
  "changeSet": [
    {
      "parameter": "Scheduling.SlurmQueues[queue1].CapacityType",
      "requestedValue": "ONDEMAND",
      "currentValue": "SPOT"
    }
  ]
}
```

`pcluster describe-cluster --region=us-east-1 --cluster-name cmaq`

Output:

```
"clusterStatus": "UPDATE_IN_PROGRESS"
```

once you see

```
  "clusterStatus": "UPDATE_COMPLETE"
```

Restart the compute nodes

`pcluster update-compute-fleet --region us-east-1 --cluster-name cmaq --status START_REQUESTED`


Verify that compute nodes have started

`pcluster describe-cluster --region=us-east-1 --cluster-name cmaq`

Output:

```
 "computeFleetStatus": "RUNNING",
```

Re-login to the cluster

```
pcluster ssh -v -Y -i ~/your-key.pem --cluster-name cmaq
```

Scancel any jobs left in the queue

Submit a new job

```
sbatch run_cctm_2016_12US2.180pe.5x36.pcluster.csh
```


NOte, I am trying this from a new AWS account, and the compute nodes don't appear to be provisioning.

I checked and found this:

If you are unable to access AWS Services, please note that some services may take up to 24 hours to fully activate. If you’re still unable to access AWS Services after that time, please visit AWS Support.

Note, I had to enable spot instances IAM Policy: AWSEC2SpotServiceRolePolicy

One way to accomplish this is to have each user login to the EC2 Website and launch a spot instance.
The service policy will be automatically created.


Check to see the log on the parallel cluster

`vi /var/log/parallelcluster/slurm_resume.log`

 An error occurred (MaxSpotInstanceCountExceeded) when calling the RunInstances operation: Max spot instance count exceeded


Trying to submit a 72 pe job 2 nodes x 36 cpus

That appears to be working now.

`sbatch run_cctm_2016_12US2.72pe.2x36.pcluster.csh`

`grep -i 'Processing completed.' CTM_LOG_036.v533_gcc_2016_CONUS_6x12pe_20151223`

```
 Processing completed...    9.0 seconds
            Processing completed...   12.0 seconds
            Processing completed...   11.2 seconds
            Processing completed...    9.0 seconds
            Processing completed...    9.1 seconds
```


`tail -n 20 run_cctmv5.3.3_Bench_2016_12US2.72.6x12pe.2day.pcluster.log `


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
Number of Processes:       72
   All times are in seconds.

Num  Day        Wall Time
01   2015-12-22   3562.50
02   2015-12-23   3151.21
     Total Time = 6713.71
      Avg. Time = 3356.85
```


`sbatch run_cctm_2016_12US2.108pe.3x36.pcluster.csh`

grep -i 'Processing Completed' CTM_LOG_000.v533_gcc_2016_CONUS_9x12pe_20151222

```
            Processing completed...    6.0 seconds
            Processing completed...    6.0 seconds
            Processing completed...    8.3 seconds
            Processing completed...    8.2 seconds
            Processing completed...    6.0 seconds
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


### Results from Parallel Cluster Started with the EBS Volume software with data imported from S3 Bucket


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
I added the #SBATCH --exclusive option.  Perhaps that made a difference.


```
tail -n 18 run_cctmv5.3.3_Bench_2016_12US2.10x18pe.2day.log
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
Number of Processes:       180
   All times are in seconds.

Num  Day        Wall Time
01   2015-12-22   1585.67
02   2015-12-23   1394.52
     Total Time = 2980.19
      Avg. Time = 1490.09
```
