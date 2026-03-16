# Use ParallelCluster with Software and Data pre-installed on hpc7g.16xlarge

Step by step instructions to configuring and running a ParallelCluster for the CMAQ 12US1 benchmark 

```{admonition} Notice
:class: warning

The CMAQ libraries were installed using the gcc compiler on c6g.large.

```


## Configure the ParallelCluster

Note, the latest version of pcluster requires a ed25519_key.
To create this key, login to your ec2 instance website for your account.
On the left menu, look for Key Pairs under Network and Security
Click on the orange button to `Create a key pair`

Specify a name.
Choose ED25519 as the key pair type
Choose pem as the format

Click `Create key pair`

Download the key pair to your local machine, and use the following command to set the permissions of your private key file.

`chmod 400 your_user_name-key-pair-region_name.pem`


Run another configure cluster to use the hpc7g.16xlarge compute nodes.

`pcluster configure --config hpc7g.test`

Allowed values for AWS Region ID: `15`

Allowed values for EC2 Key Pair Name:
Use the key pair that you created.

Allowed values for Scheduler: `1. Slurm`

Allowed values for Operating System: `4. ubuntu2404`

Head node instance type [c7i-flex.large]: `c7g.large`

Number of queues [1]: `1`

Name of queue 1 [queue1]: `queue1`

Number of compute resources for queue1 [1]: `1`

Compute instance type for compute resource 1 in queue1 [c7i-flex.large]: `hpc7g.16xlarge`

Compute instance type for compute resource 1 in queue1 [c7i-flex.large]: hpc7g.16xlarge
The EC2 instance selected supports enhanced networking capabilities using Elastic Fabric Adapter (EFA). EFA enables you to run applications requiring high levels of inter-node communications at scale on AWS at no additional charge (https://docs.aws.amazon.com/parallelcluster/latest/ug/efa-v3.html).
Enable EFA on hpc7g.16xlarge (y/n) [y]: `y`

Maximum instance count [10]: `10`

Enabling EFA requires compute instances to be placed within a Placement Group. Please specify an existing Placement Group name or leave it blank for ParallelCluster to create one.
Placement Group name []:
` `
Automate VPC creation? (y/n) [n]: `y`

Allowed values for VPC ID:
` `

The creation of a public and private subnet combination will result in
charges for NAT gateway creation that are not covered under the free tier.
Please refer to https://aws.amazon.com/vpc/pricing/ for more details.

Automate Subnet creation? (y/n) [y]: `y`

Allowed values for Availability Zone: `1. us-east-1a`

Allowed values for Network Configuration: `2. Head node and compute fleet in the same public subnet`


Use an existing yaml file from the git repo to create a ParallelCluster

`cd /your/local/machine/install/path/`

Use a configuration file from the github repo that was cloned to your local machine

`git clone -b main https://github.com/CMASCenter/pcluster-cmaq.git pcluster-cmaq`


`cd pcluster-cmaq/yaml`

Edit the hpc7g.16xlarge.ebs_unencrypted_installed_public_ubuntu2004.fsx_import_cheapest.yaml

`vi hpc7g.16xlarge.ebs_unencrypted_installed_public_ubuntu2004.fsx_import_cheapest.yaml`

```{note}
1. the hpc7g.16xlarge*.yaml is configured to use ONDEMAND instance pricing for the compute nodes.
2. the hpc7g.16xlarge*.yaml is configured to the the hpc7g.16xlarge as the compute node for the compute-resource-1 queue, with up to 10 compute nodes, specified by MaxCount: 12.
3. the hpc7g.16xlarge*.yaml is configured to the the hpc7g.8xlarge as the compute node for the compute-resource-1 queue, with up to 7 compute nodes.
3. the hpc7g.16xlarge*.yaml is configured to disable multithreading (This option restricts the computing to CPUS rather than allowing the use of all virtual CPUS. (128 virtual cpus reduced to 64 cpus)
4. the hpc7g.16xlarge*.yaml is configured to enable the setting of a placement group to allow low inter-node latency
5. the hpc7g.16xlarge*.yaml is configured to enables the elastic fabric adapter
6. given this yaml configuration, the maximum number of PEs that could be used to run CMAQ is 64 cpus x 10 = 640, the max settings for NPCOL, NPROW is NPCOL = 20, NPROW = 32 or NPCOL=32, NPROW=20 in the CMAQ run script. Note: CMAQ will need to be benchmarked using the 12US1 to determine the optimal number of compute nodes to use, as it likely gets less efficient as more cpus are added.
7. the lustre file system is configured to use the lowest cost PerUnitStorageThroughput value of 125, and also uses LZ4 data compression *** this is NEW **
```

Replace the key pair and subnet ID in the hpc7g.16xlarge*.yaml file with the values created when you configured the demo cluster

```
Region: us-east-1
Image:
  Os: ubuntu2204
HeadNode:
  InstanceType: c7g.large
  Networking:
    SubnetId: subnet-03a533b72486e9572  << replace
  Ssh:
    KeyName: your_ed25519_key  << replace
Scheduling:
  Scheduler: slurm
  SlurmQueues:
    - Name: queue1
      ComputeResources:
      - Name: hpc7g16xlarge
        Instances:
        - InstanceType: hpc7g.16xlarge
        MinCount: 0
        MaxCount: 10
        Efa:
          Enabled: true
      Networking:
        PlacementGroup:
          Enabled: true
        SubnetIds:
        - subnet-03a533b72486e9572 << replace
SharedStorage:
  - MountDir: /shared
    Name: ebs-shared
    StorageType: Ebs
    EbsSettings:
      Encrypted: false
      SnapshotId: snap-0049a7c309f238500  << replace
  - Name: FsxLustre0
    StorageType: FsxLustre
    MountDir: /fsx
    FsxLustreSettings:
      DeletionPolicy: Delete
      StorageCapacity: 1200
      DeploymentType: SCRATCH_2
      DataCompressionType: LZ4
      ImportPath: s3://cmas-cmaq
```

*note, PERSISTANT_2 lustre file systems do not support ImportPath or linking to s3 bucket.

The Yaml file for the hpc7g.16xlarge contains the settings as shown in the following diagram.

Figure 1. Diagram of YAML file used to configure a ParallelCluster with a c6g.large head node and hpc7g.16xlarge compute nodes using ONDEMAND pricing
![hpc7g.16xlarge yaml configuration](../../../yml_plots/hpc7g.16xlarge.png)

(to do!)


## Create the hpc7g pcluster

Note, this yaml file is configured to have 12 nodes of the hpc7g.16xlarge (64 pe per node) and 7 nodes of the hpc7g.8xlarge (32 pe per node).

`pcluster create-cluster --cluster-configuration hpc7g.16xlarge.ebs_unencrypted_installed_public_ubuntu2004.fsx_import.yaml --cluster-name cmaq --region us-east-1`

## Output recieved from command line: 

```
pcluster create-cluster --cluster-configuration hpc7g.16xlarge.ebs_encrypted_installed_public_ubuntu2004.fsx_import_cheapest.yaml --cluster-name cmaq-upgrade --region us-east-1
{
  "cluster": {
    "clusterName": "cmaq-upgrade",
    "cloudformationStackStatus": "CREATE_IN_PROGRESS",
    "cloudformationStackArn": "arn:aws:cloudformation:us-east-1:440858712842:stack/cmaq-upgrade/5acdf5d0-217a-11f1-af2b-12a98fd563d9",
    "region": "us-east-1",
    "version": "3.14.2",
    "clusterStatus": "CREATE_IN_PROGRESS",
    "scheduler": {
      "type": "slurm"
    }
  },
  "validationMessages": [
    {
      "level": "WARNING",
      "type": "EbsVolumeSizeSnapshotValidator",
      "message": "The specified volume size is larger than snapshot size. In order to use the full capacity of the volume, you'll need to manually resize the partition according to this doc: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/recognize-expanded-volume-linux.html"
    },
    {
      "level": "INFO",
      "type": "DeletionPolicyValidator",
      "message": "The DeletionPolicy is set to Delete. The storage 'ebs-shared' will be deleted when you remove it from the configuration when performing a cluster update or deleting the cluster."
    },
    {
      "level": "INFO",
      "type": "DeletionPolicyValidator",
      "message": "The DeletionPolicy is set to Delete. The storage 'FsxLustre0' will be deleted when you remove it from the configuration when performing a cluster update or deleting the cluster."
    }
  ]
}

```

Check on status of cluster

`pcluster describe-cluster --region=us-east-1 --cluster-name cmaq`


After 5-10 minutes, you see the following status: "clusterStatus": "CREATE_COMPLETE"

If the cluster fails to start, use the following command to check for an error

`pcluster get-cluster-stack-events --cluster-name cmaq --region us-east-1 --query 'events[?resourceStatus==`CREATE_FAILED`]'`
