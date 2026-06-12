# Create Cost Allocation Tags for Analysis using AWS Cost Explorer. 

Step by step instructions for using cost allocation tags. This method was obtained from the following website: <br>
<a href="https://aws.amazon.com/blogs/compute/using-cost-allocation-tags-with-aws-parallelcluster">Using Cost Allocation Tags with AWS ParallelCluster"</a>  
Note, these instructions to use the post_install.sh script don't work any more because tags assigned to parallel cluster must be done at start up, and can't be modified after the cluster is created.

Steps 1&2 have already been implemented for the CMAS Center Account.<br>


## Activation of an AWS Defined tag: createdBy in the Console

Go to the Billing and Cost Management.<br>
On the left panel select Cost Allocation Tags<br>
On the AWS Generated cost allocation tags tab <br>
search for aws:createdBy<br>
Select and then click on activate.<br>

## Creation and activation of a user defined tag (method to use a post_install.sh script no longer works, but users can set tags in the yaml file, see below)
The post_install.sh script saved to the s3 bucket will create the user defined tags. <br>
Link to post_install.sh script: <a href="https://github.com/lizadams/cost-alloc-tag-pcluster-s3bucket/blob/main/post_install.sh">post_install.sh</a>

```
aws-parallelcluster-username
aws-parallelcluster-jobid
aws-parallelcluster-project
```
<br>
The values for these tags will be set in the yaml file used to create the parallel cluster.<br>


## Creation of the  pclusterTagsAndBudget IAM Policy 
This was done via the AWS console.<br>
Edited a policy named pclusterTagsAndBudget<br>
Implemented the following policies<br>

```
    Type: 'AWS::IAM::ManagedPolicy'
    Properties:
      ManagedPolicyName: pclusterTagsAndBudget
      Path: /
      PolicyDocument:
        Version: 2012-10-17
        Statement:
          - Effect: Allow
            Action:
              - 'ec2:DeleteTags'
              - 'ec2:DescribeTags'
              - 'ec2:CreateTags'
            Resource: '*'
          - Effect: Allow
            Action:
              - 'budgets:ViewBudget'
            Resource: 'arn:aws:budgets::*:budget/*'
```

The above definition is from the pcluster_env.yml file, but I didn't see how that code was used, so I implemented it through the console.

## An S3 bucket named: cost-alloc-tag-pcluster was created to host files that were obtained and then modified according to the tutorial for the CMAS Account:

```
pcluster_env.yml
post_install.sh
projects_list.conf
sbatch
```

### Review each of the files that will be placed in the S3 bucket. <br>
The top of the script will alert you to what needs to be modified.<br>

For example, the sbatch script needs to be edited to specify your account ID.<br>

Example sbatch script: <br>
Link to sbatch script: <a href="https://github.com/lizadams/cost-alloc-tag-pcluster-s3bucket/blob/main/sbatch">sbatch</a>

```
# The script is used as wrapper to the Slurm sbatch command. Replace <account_id> with the id of your account.
```

Also, the sbatch script has a setting that turns on or off the budgeting capability.<br>
For users to be notified that they have exceeded their budget allocation, then you would turn this on.<br>
See the AWS Tutorial for information about how to set up a budget.<br>
<br>
Example projects_list.conf:<br>
Link to projects_list.conf <a href="https://github.com/lizadams/cost-alloc-tag-pcluster-s3bucket/blob/main/projects_list.conf">projects_list.conf</a>

```
ec2-user=lizadams, manishsoni, ubuntu
lizadams=CMASOps, ProjectA
manishsoni=O3MAT, ProjectB
ubuntu=ProjectA, ProjectB, CMASOps, O3MAT
```

Note, currently we use one login ID, ubuntu to login IDs for the parallel cluster.<br>

<br>

Permissions need to be added to the s3 bucket for each user that will be using these cost allocation tags by defining a bucket policy with permissions.<br>
<br>
Example Bucket Policy (use console to create) - replace <accountID> and <username>  <br>
```
"Id": "Bucket-policy-cost-alloc",
    "Statement": [
        {
            "Sid": "Bucket-policy-cost-alloc",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::<accountID>:user/<username>"
            },
            "Action": [
                "s3:GetObject",
                "s3:GetBucketLocation",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::cost-alloc-tag-pcluster/*",
                "arn:aws:s3:::cost-alloc-tag-pcluster"
            ]
        }
    ]
}
```

This s3 bucket will be called by the yaml file used to create the cluster.<br>

## Review example yaml file that has the lines that need to be added highlighted by !!

```
Region: us-east-1
Image:
  Os: ubuntu2404
HeadNode:
  InstanceType: c7g.large
  Networking:
    SubnetId: <subnet-id>
  Ssh:
    KeyName: <key>
  CustomActions:                                                     !! Add this code without the !! markers and text  to your yaml file
    OnNodeConfigured:                                                !!
      Script: s3://<bucket>/post_install.sh                          !!  <bucket> is replaced by s3 bucket name: cost-alloc-tag-pcluster (or create a and use a new bucket name)
  Iam:                                                               !!
    S3Access:                                                        !!
      - BucketName: <bucket>                                         !!
        EnableWriteAccess: False                                     !!
    AdditionalIamPolicies:                                            !!
      - Policy: arn:aws:iam::<account_id>:policy/pclusterTagsAndBudget !!
Scheduling:
  Scheduler: slurm
  SlurmSettings:
    ScaledownIdletime: 5
  SlurmQueues:
    - Name: queue1
      CapacityType: ONDEMAND
      Networking:
        SubnetIds:
          - <subnet-id>
        PlacementGroup:
          Enabled: true
      ComputeResources:
        - Name: hpc7g4xlarge
          InstanceType: hpc7g.4xlarge
          MinCount: 0
          MaxCount: 4
          DisableSimultaneousMultithreading: true
          Efa:
            Enabled: true
            GdrSupport: false
      CustomActions:                                                         !!
        OnNodeConfigured:                                                    !!
          Script: s3://<bucket>/post_install.sh                              !!
      Iam:                                                                   !!
        S3Access:                                                            !!
          - BucketName: <bucket>                                             !!
            EnableWriteAccess: False                                         !!
        AdditionalIamPolicies:                                               !!
          - Policy: arn:aws:iam::<account_id>:policy/pclusterTagsAndBudget   !!
Tags:                                                                        !!
  - Key: aws-parallelcluster-username                                        !!
    Value: <name>                                                            !!
  - Key: aws-parallelcluster-jobid                                           !!
    Value: listos.hpc7g.4xlarge                                              !!
  - Key: aws-parallelcluster-project                                         !!
    Value: CMASOPS                                                           !!
```

## Use above template to modify your cluster yaml to add cost allocation tags

Cut and paste the lines that have !! comments and add them to your cluster yaml file.

## Review Example Cost Allocation Yaml

```
cd pcluster-cmaq/yaml/
```

## Review example yaml

```
cat hpc7g.4xlarge.cost-alloc-tags-no-update-allowed.yaml
```

 

## Use the modified yaml file to create the cluster

```
pcluster create-cluster --cluster-configuration hpc7g.4xlarge.cost-alloc-tags-no-update-allowed.yaml  --cluster-name cmaq-cost-alloc-testing --region us-east-1
```

### Check on the cluster status

Use this command to check on the status of the cluster until the clusterStatus is CREATE_COMPLETE.

```
pcluster describe-cluster --region=us-east-1 --cluster-name cmaq
```

### login to your cluster

```
pcluster ssh -v -Y -i ~/cmas.pem --region=us-east-1 --cluster-name cmaq
```

### Resize the EBS Volume

To resize the EBS volume, run the following command:<br>

```
sudo resize2fs /dev/nvme1n1
```

### Obtain the Listos Benchmark Case from the S3 bucket
Note, my original instructions were to put the data on /shared/data, but after having issue running, it is better to move to /fsx to avoid error not finding CONC file due to slower disk speed of /shared volume.

```
cd /fsx
aws s3 --no-sign-request cp --region=us-east-1 --recursive s3://cmas-cmaq/CMAQv5.4_2018_12LISTOS_Benchmark_3Day_Input .
```

### Obtain the Listos Run script from the S3 bucket

```
cp /shared/pcluster-cmaq/run_scripts/c6a/run_cctm_2018_12US1_listos.csh /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/
```


### Modify the version number in the run script to match the precompiled code version

```
 set VRSN      = v54+              #> Code Version
```

### Modify the run script to add CMAQ_DATA environment variable and modify INPDIR to match what is available after downloading the inputs, and modify number of processos used

Add the following SLURM instructions to the top of the run script

```
#!/bin/csh -f
## For Parallel Cluster 16 cores x 2 = 32
## data on /fsx or lustre data directory
## https://dataverse.unc.edu/dataset.xhtml?persistentId=doi:10.15139/S3/LDTWKH
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=16
#SBATCH --exclusive
#SBATCH -J CMAQ
#SBATCH -o cmaq_cost_alloc_tag_%j.txt
```

Modify this section of the run script #> Set Working, Input, and Output Directories to use:

```
setenv CMAQ_DATA /fsx
setenv INPDIR  ${CMAQ_DATA}/12LISTOS_Training
   @ NPCOL  =  4; @ NPROW =  8
```


### Load the modules to get the libraries and compiler

```
module use --append /shared/build/Modules/modulefiles
```

### Check modules that are now available

```
module avail
```

### Load the library modules

```
module load libfabric-aws/2.3.1amzn1.0  openmpi/4.1.7  ioapi-3.2/gcc-9.5-netcdf  netcdf-4.8.1/gcc-9.5
```

### Submit job to slurm using the --comment flag to specify the project name

```
sbatch --comment ProjectA run_cctm_2018_12US1_listos.csh
```
 
Note that the projects are listed in the projects_list.conf that is on the s3 bucket, and it may be modified to use different project names.

### Use squeue to check on status of runs

```
squeue
```

Output

```
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 4    queue1     CMAQ   ubuntu  R       1:24      2 queue1-dy-compute-resource-1-[2-3]
```


### Verify that the run completes successfully


```
grep -i error CTM_LOG*
tail cmaq_cost_alloc_tag*.txt
```

Output

```
==================================
  ***** CMAQ TIMING REPORT *****
==================================
Start Day: 2018-08-05
End Day:   2018-08-07
Number of Simulation Days: 3
Domain Name:               2018_12Listos
Number of Grid Cells:      21875  (ROW x COL x LAY)
Number of Layers:          35
Number of Processes:       16
   All times are in seconds.

Num  Day        Wall Time
01   2018-08-05   57.0
02   2018-08-06   63.7
03   2018-08-07   57.6
     Total Time = 178.30
      Avg. Time = 59.43
```


### Check the status of the cluster via the console and the command line to verify that the compute nodes have shut down

```
pcluster describe-cluster --cluster-name cmaq --region us-east-1
```

### Terminate the cluster after the compute nodes have successfully terminated.

```
pcluster delete-cluster --cluster-name cmaq --region us-east-1
```

### It takes 24 hours for the cost data to appear in the Cost Explorer. Once 24 hours has elapsed check the AWS Website Cost Explorer and select by tags.


### Verify that the cost allocation tags are visible on the head node and compute nodes using the AWS Console

Login to aws console
search for ec2 
look for the headnode and compute nodes that are running.
Select the headnode, and then click on the Tags (all the way on the right)

![AWS Console EC2 Display Tags applied to headnode](aws_console_ec2_display_tags_of_headnode.png)


![AWS Console EC2 Display Tags applied to compute node](aws_console_ec2_display_tags_of_compute_node.png)

### Tried updating the cluster to use different values for tags

Error message:

```

pcluster update-cluster --cluster-configuration hpc7g.test2  --cluster-name pcluster --region us-east-1
{
  "message": "Update failure",
  "updateValidationErrors": [
    {
      "parameter": "Tags[aws-parallelcluster-jobid].Value",
      "requestedValue": "12LISTOS_Training_hpc7g.16xlarge",
      "message": "Update actions are not currently supported for the 'Value' parameter. Restore 'Value' value to '12US1CMAQ.hpc7g.4xlarge'. If you need this change, please consider creating a new cluster instead of updating the existing one.",
      "currentValue": "12US1CMAQ.hpc7g.4xlarge"
    },
    {
      "parameter": "Tags[aws-parallelcluster-project].Value",
      "requestedValue": "CMASOPS-12LISTOS_Training",
      "message": "Update actions are not currently supported for the 'Value' parameter. Restore 'Value' value to 'CMASOPS'. If you need this change, please consider creating a new cluster instead of updating the existing one.",
      "currentValue": "CMASOPS"
    }
  ],
  "changeSet": [
    {
      "parameter": "Tags[aws-parallelcluster-jobid].Value",
      "requestedValue": "12LISTOS_Training_hpc7g.16xlarge",
      "currentValue": "12US1CMAQ.hpc7g.4xlarge"
    },
    {
      "parameter": "Tags[aws-parallelcluster-project].Value",
      "requestedValue": "CMASOPS-12LISTOS_Training",
      "currentValue": "CMASOPS"
    }
  ]
}

```

### Stop the compute fleet before trying to update tags

```
pcluster update-compute-fleet --cluster-name pcluster --region us-east-1 --status STOP_REQUESTED
```

```
 pcluster describe-cluster --cluster-name pcluster --region us-east-1   
{
  "creationTime": "2026-06-04T18:54:48.482Z",
  "headNode": {
    "launchTime": "2026-06-04T19:08:04.000Z",
    "instanceId": "i-01453c1a12388173e",
    "publicIpAddress": "13.221.205.184",
    "instanceType": "c7g.large",
    "state": "running",
    "privateIpAddress": "10.0.10.204"
  },
  "version": "3.14.2",
  "clusterConfiguration": {
  },
  "tags": [
    {
      "value": "3.14.2",
      "key": "parallelcluster:version"
    },
    {
      "value": "12US1CMAQ.hpc7g.4xlarge",
      "key": "aws-parallelcluster-jobid"
    },
    {
      "value": "pcluster",
      "key": "parallelcluster:cluster-name"
    },
    {
      "value": "CMASOPS",
      "key": "aws-parallelcluster-project"
    },
    {
      "value": "lizadams",
      "key": "aws-parallelcluster-username"
    }
  ],
  "cloudFormationStackStatus": "CREATE_COMPLETE",
  "clusterName": "pcluster",
  "computeFleetStatus": "STOPPED",
  "cloudformationStackArn": "arn:aws:cloudformation:us-east-1:440858712842:stack/pcluster/dc2e8710-6046-11f1-8fe5-0e525b316913",
  "lastUpdatedTime": "2026-06-04T18:54:48.482Z",
  "region": "us-east-1",
  "clusterStatus": "CREATE_COMPLETE",
  "scheduler": {
    "type": "slurm"
  }
}
``` 

### try to update the cluster tag aws-parallelcluster-jobid now that the compute nodes are stopped.

still failed

```
 pcluster update-cluster --cluster-name pcluster --region us-east-1 --cluster-configuration hpc7g.test2
{
  "message": "Update failure",
  "updateValidationErrors": [
    {
      "parameter": "Tags[aws-parallelcluster-jobid].Value",
      "requestedValue": "12LISTOS_Training_hpc7g.16xlarge",
      "message": "Update actions are not currently supported for the 'Value' parameter. Restore 'Value' value to '12US1CMAQ.hpc7g.4xlarge'. If you need this change, please consider creating a new cluster instead of updating the existing one.",
      "currentValue": "12US1CMAQ.hpc7g.4xlarge"
    }
  ],
  "changeSet": [
    {
      "parameter": "Tags[aws-parallelcluster-jobid].Value",
      "requestedValue": "12LISTOS_Training_hpc7g.16xlarge",
      "currentValue": "12US1CMAQ.hpc7g.4xlarge"
    }
  ]
}
```

So, it looks like once the tags and values are specified when the parallel cluster is created, then they can't be changed.

If you need different values, you need to create a new cluster and delete the old one.

### Found an error in the yaml file I was using

<a href="https://docs.aws.amazon.com/parallelcluster/latest/ug/custom-bootstrap-actions-config-v3.html">Review Custom Bootstrap Actions in Config file</a>

Need to retry

May need to specify a different script for the head node and the compute node.


Tried using 

```
pcluster create-cluster  --cluster-name pcluster --region us-east-1 --cluster-configuration hpc7g.test2
```

When I submitted the job the compute nodes started and then died, and there were no log files.

Ran out of time, so I am deleting the cluster


