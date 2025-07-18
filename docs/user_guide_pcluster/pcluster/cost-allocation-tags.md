# Create Cost Allocation Tags for Analysis using AWS Cost Analyzer. 

Step by step instructions for using cost allocation tags. This method was obtained from the following website: <br>
<a href="https://aws.amazon.com/blogs/compute/using-cost-allocation-tags-with-aws-parallelcluster">Using Cost Allocation Tags with AWS ParallelCluster"</a>  

Steps 1&2 have already been implemented for the CMAS Center Account.<br>

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

This s3 bucket should allow use of this by Manish Soni using a bucket policy with permissions.<br>
This s3 bucket will be called by the yaml file used to create the cluster.<br>

## Review example yaml file that has the lines that need to be added highlighted by !!

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

## Use above template to modify your cluster yaml to add cost allocation tags

Cut and paste the lines that have !! comments and add them to your cluster yaml file.

## Or - use the Listos Cost Allocation Yaml that is provided here (with the exception of the <account_id>)

cd pcluster-cmaq/yaml/

## Edit the <account_id> to use the value for your account
 

## Use the modified yaml file to create the cluster

```
pcluster create-cluster --cluster-configuration hpc7g.4xlarge.cost-alloc-tags.yaml  --cluster-name cmaq --region us-east-1
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

```
mkdir /shared/data
cd /shared/data
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
setenv CMAQ_DATA /shared/data
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
module load ioapi-3.2/gcc-9.5-netcdf  netcdf-4.8.1/gcc-9.5  libfabric-aws/1.19.0amzn4.0 openmpi/4.1.6  
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


### Check the status of the cluster via the console and the command line to verify that the compute nodes have shut down

```
pcluster describe-cluster --cluster-name cmaq --region us-east-1
```

### Terminate the cluster after the compute nodes have successfully terminated.

```
pcluster delete-cluster --cluster-name cmaq --region us-east-1
```

### It takes 24 hours for the cost data to appear in the Cost Analyzer. Once 24 hours has elapsed check the AWS Website Cost Analyzer and select by tags.




 

