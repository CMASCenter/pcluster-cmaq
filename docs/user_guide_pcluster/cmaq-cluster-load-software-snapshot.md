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

 

