CMAQv5.4 on Parallel Cluster Intermediate Tutorial

(still working on these instructions)

## Use ParallelCluster with Software and Data pre-installed

Step by step instructions to configuring and running a ParallelCluster for the CMAQ 12US1 benchmark 

```{admonition} Notice
:class: warning

The CMAQ libraries were installed using the gcc compiler on c6a.large.

```


### Create CMAQ Cluster using SPOT pricing

#### Use an existing yaml file from the git repo to create a ParallelCluster

`cd /your/local/machine/install/path/`

#### Use a configuration file from the github repo that was cloned to your local machine

`git clone -b main https://github.com/CMASCenter/pcluster-cmaq.git pcluster-cmaq`


`cd pcluster-cmaq`

####  Edit the c6a.large-48xlarge.ebs_unencrypted_installed_public_ubuntu2004.fsx_import.yaml 

`vi c6a.large-48xlarge.ebs_unencrypted_installed_public_ubuntu2004.fsx_import.yaml`

```{note}
1. the c6a.large-48xlarge*.yaml is configured to use SPOT instance pricing for the compute nodes.
2. the c6a.large-48xlarge*.yaml is configured to the the c6a-48xlarge as the compute node, with up to 10 compute nodes, specified by MaxCount: 10.
3. the c6a.large-48xlarge*.yaml is configured to disable multithreading (This option restricts the computing to CPUS rather than allowing the use of all virtual CPUS. (192 virtual cpus reduced to 96 cpus)
4. the c6a.large-48xlarge*.yaml is configured to enable the setting of a placement group to allow low inter-node latency
5. the c6a.large-48xlarge*.yaml is configured to enables the elastic fabric adapter
6. given this yaml configuration, the maximum number of PEs that could be used to run CMAQ is 96 cpus x 10 = 960, the max settings for NPCOL, NPROW is NPCOL = 24, NPROW = 40 or NPCOL=40, NPROW=24 in the CMAQ run script. Note: CMAQ does not scale well beyond 2-3 compute nodes.
```

#### Replace the key pair and subnet ID in the c6a.large-48xlarge*.yaml file with the values created when you configured the demo cluster

```
Region: us-east-1
Image:
  Os: ubuntu2004
HeadNode:
  InstanceType: c6a.large
  Networking:
    SubnetId: subnet-xx-xx-xx           << replace
  DisableSimultaneousMultithreading: true
  Ssh:
    KeyName: your_key                     << replace
  LocalStorage:
    RootVolume:
      Encrypted: true
Scheduling:
  Scheduler: slurm
  SlurmQueues:
    - Name: queue1
      CapacityType: SPOT
      Networking:
        SubnetIds:
          - subnet-xx-xx-x         x    << replace
        PlacementGroup:
          Enabled: true
      ComputeResources:
        - Name: compute-resource-1
          InstanceType: c6a.48xlarge
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
      Encrypted: true
      SnapshotId: snap-009fed2e4b6b98edc
  - MountDir: /fsx
    Name: name2
    StorageType: FsxLustre
    FsxLustreSettings:
      StorageCapacity: 1200
      ImportPath: s3://cmas-cmaq/CMAQv5.4_2018_12US1_Benchmark_2Day_Input/
```

#### The Yaml file for the c6a.48xlarge contains the settings as shown in the following diagram.

Figure 1. Diagram of YAML file used to configure a ParallelCluster with a c6a.large head node and c6a.48xlarge compute nodes using SPOT pricing
![c6a-48xlarge yaml configuration](../../yml_plots/c6a-48xlarge-yaml.png)

(to do!)


## Create the c6a.48xlarge pcluster

`pcluster create-cluster --cluster-configuration c6a.xlarge-48xlarge.ebs_unencrypted_installed_public_ubuntu2004.fsx_import.yaml --cluster-name cmaq --region us-east-1`

#### Check on status of cluster

`pcluster describe-cluster --region=us-east-1 --cluster-name cmaq`


After 5-10 minutes, you see the following status: "clusterStatus": "CREATE_COMPLETE"

### If the cluster fails to start, use the following command to check for an error

`pcluster get-cluster-stack-events --cluster-name cmaq --region us-east-1 --query 'events[?resourceStatus==`CREATE_FAILED`]'`

#### Login to cluster
```{note}
Replace the your-key.pem with your Key Pair.
```

`pcluster ssh -v -Y -i ~/your-key.pem --region=us-east-1 --cluster-name cmaq`

```{note}
Notice that the c6a.48xlarge yaml configuration file contains a setting for PlacementGroup.
```

```
PlacementGroup:
          Enabled: true
```
 
A placement group is used to get the lowest inter-node latency. 

A placement group guarantees that your instances are on the same networking backbone. 

### Check to make sure elastic network adapter (ENA) is enabled

`modinfo ena`

`lspci`

### Check what modules are available on the cluster

`module avail`

### Load the openmpi module

`module load openmpi/4.1.4`

### Load the Libfabric module

`module load libfabric-aws/1.16.1amzn1.0`

### Verify the gcc compiler version is greater than 8.0

`gcc --version`

output:

```
gcc (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0
Copyright (C) 2019 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

```

```{seealso}
<a href="https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/enhanced-networking-ena.html#test-enhanced-networking-ena">Link to the AWS Enhanced Networking Adapter Documentation</a>
```

```{seealso}
<a href="https://docs.aws.amazon.com/parallelcluster/latest/ug/what-is-aws-parallelcluster.html">ParallelCluster User Manual</a>
```
