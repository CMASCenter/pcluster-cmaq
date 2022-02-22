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


### Follow instructions to Install CMAQ software on parallel cluster

### Verify that a job runs successfully and compare the timing

### Save the EBS Volume as a snapshot in the AWS interface

### Change the permissions of the EBS Volume to be PUBLIC


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
