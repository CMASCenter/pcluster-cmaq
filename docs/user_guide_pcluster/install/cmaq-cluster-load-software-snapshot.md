## Create parallelcluster with an un-encrypted EBS volume and load software to share publically

### Examine a yaml file that has specifies that the /shared ebs volume will be un-encrypted.

Change directories on your local machine to the location where the pcluster-cmaq github repo was installed.

`cd pluster-cmaq`

Edit the yaml file to use your account's subnet ID and KeyName

`vi c5n-18xlarge.ebs_unencrypted.fsx_import.yaml`

Output:

```
Region: us-east-1
Image:
  Os: ubuntu2004
HeadNode:
  InstanceType: c5n.large
  Networking:
    SubnetId: subnet-xx-xxx-xx                <<<   replace with your subnet ID
  DisableSimultaneousMultithreading: true
  Ssh:
    KeyName: your-key                         <<<   replace with your KeyName
Scheduling:
  Scheduler: slurm
  SlurmSettings:
    ScaledownIdletime: 5
  SlurmQueues:
    - Name: queue1
      CapacityType: SPOT
      Networking:
        SubnetIds:
          - subnet-xx-xx-xxx                 <<< replace with your subnet ID
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
      Encrypted: false                      <<<  notice option to make Encrypted is set to false (default is true)
  - MountDir: /fsx
    Name: name2
    StorageType: FsxLustre
    FsxLustreSettings:
      StorageCapacity: 1200
      ImportPath: s3://conus-benchmark-2day
```



### Create Cluster with ebs volume set to be un-encrypted in the yaml file

`pcluster create-cluster --cluster-configuration c5n-18xlarge.ebs_unencrypted.fsx_import.yaml --cluster-name cmaq --region us-east-1`

### Check on status of the cluster

`pcluster describe-cluster --region=us-east-1 --cluster-name cmaq`

After 5-10 minutes, you see the following status: "clusterStatus": "CREATE_COMPLETE"

### Start the compute nodes

`pcluster update-compute-fleet --region us-east-1 --cluster-name cmaq --status START_REQUESTED`

### Login to cluster
```{note}
Replace the your-key.pem with your Key Pair.
```

`pcluster ssh -v -Y -i ~/your-key.pem --cluster-name cmaq`

### Verify Environment on Cluster

#### Show compute nodes

`scontrol show nodes`

#### Check to make sure elastic network adapter (ENA) is enabled

`modinfo ena`

`lspci`

#### Check what modules are available on the cluster

`module avail`

#### Load the openmpi module

`module load openmpi/4.1.1`

#### Load the Libfabric module

`module load libfabric-aws/1.13.0amzn1.0`

#### Verify the gcc compiler version is greater than 8.0

`gcc --version`


### Verify that the input data is imported to /fsx from the S3 Bucket

`cd /fsx/12US2`

Need to make this directory and then link it to the path created when the data is copied from the S3 Bucket This is to make the paths consistent between the two methods of obtaining the input data.

`mkdir -p /fsx/data/CONUS` 

`cd /fsx/data/CONUS` 

`ln -s /fsx/12US2 .`

Create the output directory

`mkdir -p /fsx/data/output`


<<<<<<< HEAD:docs/user_guide_pcluster/cmaq-cluster-load-software-snapshot.md
### Submit a 180 pe job

`sbatch run_cctm_2016_12US2.180pe.5x36.pcluster.csh`

`tail -n 50 run_cctmv5.3.3_Bench_2016_12US2.10x18pe.2day.pcluster.log`

Output:

```
CMAQ Processing of Day 20151223 Finished at Tue Feb 22 22:54:32 UTC 2022

\\\\\=====\\\\\=====\\\\\=====\\\\\=====/////=====/////=====/////=====/////


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
01   2015-12-22   2241.14
02   2015-12-23   1963.18
     Total Time = 4204.32
      Avg. Time = 2102.16

```
`gcc --version`

Output:

```
gcc (GCC) 4.8.5 20150623 (Red Hat 4.8.5-44)
Copyright (C) 2015 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

### Submit a 288 pe job

`sbatch run_cctm_2016_12US2.288pe.8x36.pcluster.csh`


`tail -n 50 run_cctmv5.3.3_Bench_2016_12US2.16x18pe.2day.pcluster.log`

```
==============================
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
01   2015-12-22   1524.55
02   2015-12-23   1362.90
     Total Time = 2887.45
      Avg. Time = 1443.72

```

Using the Ubuntu2004 OS with gcc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0

tail -n 50 run_cctmv5.3.3_Bench_2016_12US2.16x18pe.2day.pcluster.log

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
01   2015-12-22   1472.69
02   2015-12-23   1302.84
     Total Time = 2775.53
      Avg. Time = 1387.76

```

1.  Follow instructions to Install CMAQ software on parallel cluster
2. Submit 180 pe job for CMAQ 2 day Benchmark
3. Submit 288 pe job  (note, can't seem to get 360 pe job to be provisioned by the parallel cluster)
4. Verify that a job runs successfully and compare the timing
5. Run QA Check
6. Run Post Processing
7. Save Logs and Output to S3 Bucket
8. Save the EBS Volume as a snapshot in the AWS interface
9. Change the permissions of the EBS Volume to be PUBLIC
10. Record the snapshot ID and use it in the yaml file for pre-loaded software install
=======
1. Follow instructions to Install CMAQ software on parallelcluster
2. Submit 180 pe job for CMAQ 2 day Benchmark
3. Submit 288 pe job for CMAQ 2 day Benchmark 
4. Run QA Check
5. Run Post Processing
6. Save Logs and Output to S3 Bucket
7. Save the EBS Volume as a snapshot in the AWS interface
8. Change the permissions of the EBS Volume to be PUBLIC
9. Record the snapshot ID and use it in the yaml file for pre-loaded software install
>>>>>>> 7d8784ed1938caf49a2b8496ed374e4a3553a973:docs/user_guide_pcluster/install/cmaq-cluster-load-software-snapshot.md
