## Create parallel cluster with an un-encrypted EBS volume and load software to share publically


### Create Cluster with ebs volume set to be un-encrypted in the yaml file

`pcluster create-cluster --cluster-configuration c5n-18xlarge.ebs_unencrypted.fsx_import.yaml --cluster-name cmaq --region us-east-1`

### Check on status of the cluster

`pcluster describe-cluster --region=us-east-1 --cluster-name cmaq`

After 5-10 minutes, you see the following status: "clusterStatus": "CREATE_COMPLETE"

### Start the compute nodes

`pcluster update-compute-fleet --region us-east-1 --cluster-name cmaq --status START_REQUESTED`

### Login to cluster
(note, replace the centos.pem with your Key Pair)

`pcluster ssh -v -Y -i ~/centos.pem --cluster-name cmaq`

### Show compute nodes

`scontrol show nodes`

### Check to make sure elastic network adapter (ENA) is enabled

`modinfo ena`

`lspci`

### Check what modules are available on the cluster

`module avail`

### Load the openmpi module

`module load openmpi/4.1.1`

### Load the Libfabric module

`module load libfabric-aws/1.13.0amzn1.0`

### Verify the gcc compiler version is greater than 8.0

`gcc --version`


### Verify that the input data is imported to /fsx from the S3 Bucket

`cd /fsx/12US2`

Need to make this directory and then link it to the path created when the data is copied from the S3 Bucket This is to make the paths consistent between the two methods of obtaining the input data.

`mkdir -p /fsx/data/CONUS` 

`cd /fsx/data/CONUS` 

`ln -s /fsx/12US2 .`

Create the output directory

mkdir -p /fsx/data/output

### Next Steps

1. Follow instructions to Install CMAQ software on parallel cluster
2. Verify that a job runs successfully and compare the timing
3. Save the EBS Volume as a snapshot in the AWS interface
4. Change the permissions of the EBS Volume to be PUBLIC

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
Question - is this performance poor due to using Centos7 and the older gcc compiler?

`gcc --version`

Output:

```
gcc (GCC) 4.8.5 20150623 (Red Hat 4.8.5-44)
Copyright (C) 2015 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```
Only reason that I switched to centos7 over ubuntu2004 is that when I tried to create a parallel cluster with ubuntu2004 on Feb. 22, 2022, I could not find slurm or sbatch, so I could notsubmit jobs to the queue. (I had not run into this previously, when I saved the EBS Snapshot as encrypted.

Next idea is to try the Alinux/Amazon linux/Red Hat to see what gcc compiler, modules, and slurm versions are available

### Submit a 288 pe job

`sbatch run_cctm_2016_12US2.288pe.8x36.pcluster.csh`


`tail -n 50 run_cctmv5.3.3_Bench_2016_12US2.16x18pe.2day.pcluster.log`

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

