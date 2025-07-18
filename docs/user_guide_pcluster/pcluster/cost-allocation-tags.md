# Create Cost Allocation Tags and Analysis using AWS Cost Analyzer. 

Step by step instructions for using cost allocation tags. This method was obtained from the following website: 
https://aws.amazon.com/blogs/compute/using-cost-allocation-tags-with-aws-parallelcluster/  

The following have already been implemented for the CMAS Center Account.

## Creation of the  pclusterTagsAndBudget IAM Policy 
This was done via the AWS console.
Edited a policy named pclusterTagsAndBudget
Implemented the following policies
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

The above content is from the pcluster_env.yml file, but I didn't see how that code was used, so I implemented it through the console.

## Creationg of an S3 bucket named: cost-alloc-tag-pcluster that contains the following files that were obtained and then modified according to the tutorial for the CMAS Account:
pcluster_env.yml
post_install.sh
projects_list.conf
sbatch

This s3 bucket should allow use of this by Manish Soni using a bucket policy with permissions.
This s3 bucket will be called by the yaml file used to create the cluster.
An example yaml file is provided in the documentation, and is available here

```
Image:
  Os: alinux2
HeadNode:
  InstanceType: t2.micro
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
  SlurmQueues:
    - Name: queue1
      Networking:
        SubnetIds:
          - <subnet-id>
      ComputeResources:
        - Name: compute-resource1
          InstanceType: t2.micro
          MinCount: 0
          MaxCount: 10
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
    Value: NA                                                                !!
  - Key: aws-parallelcluster-jobid                                           !!
    Value: NA                                                                !!
  - Key: aws-parallelcluster-project                                         !!
    Value: NA                                                                !!
```


## Use your modified yaml file to create the cluster

```
pcluster create-cluster --cluster-configuration test_cost_alloc_cluster.yaml  --cluster-name cmaq --region us-east-1
```

### Check on the cluster status

Use this command to check on the status of the cluster

```
pcluster describe-cluster --region=us-east-1 --cluster-name cmaq
```

### login to your cluster

```
pcluster ssh -v -Y -i ~/cmas.pem --region=us-east-1 --cluster-name cmaq
```

### Obtain the Listos Benchmark Case from the S3 bucket

### Obtain the Listos Run script from the S3 bucket

### Link the executable to the CMAQv5.4+.exe

```
ln -s CMAQv5.4+.exe CMAQv5.4.exe
```

### Load the modules to get the libraries and compiler

### Obtain the run script for the Listos Benchmark


cp run_cctm_2018_12US1_listos.csh

### Submit job to slurm using the --comment flag to specify the project name


### Verify that the run completes successfully


### Check the status of the cluster via the console and the command line to verify that the compute nodes have shut down

pcluster describe-cluster --cluster-name cmaq --region us-east-1

### Terminate the cluster after the compute nodes have successfully terminated.

pcluster delete-cluster --cluster-name cmaq --region us-east-1






 

