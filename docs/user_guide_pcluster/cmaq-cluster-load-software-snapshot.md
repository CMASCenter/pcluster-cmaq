## Create parallel cluster with an un-encrypted EBS volume and load software to share publically

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
    SubnetId: subnet-018cfea3edf3c4765      <<<   replace with your subnet ID
  DisableSimultaneousMultithreading: true
  Ssh:
    KeyName: centos                         <<<   replace with your KeyName
Scheduling:
  Scheduler: slurm
  SlurmSettings:
    ScaledownIdletime: 5
  SlurmQueues:
    - Name: queue1
      CapacityType: SPOT
      Networking:
        SubnetIds:
          - subnet-018cfea3edf3c4765        <<< replace with your subnet ID
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
(note, replace the centos.pem with your Key Pair)

`pcluster ssh -v -Y -i ~/centos.pem --cluster-name cmaq`

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


###  Follow instructions to Install CMAQ software on parallel cluster

#### Submit 180 pe job for CMAQ 2 day Benchmark

#### Submit 288 pe job  (note, can't seem to get 360 pe job to be provisioned by the parallel cluster)

#### Run Post-processing

#### Save Logs and Output to S3 Bucket

### Save the EBS Volume as a snapshot in the AWS interface

### Change the permissions of the EBS Volume to be PUBLIC
    Record the snapshot ID and use it in the yaml file for pre-loaded software install
