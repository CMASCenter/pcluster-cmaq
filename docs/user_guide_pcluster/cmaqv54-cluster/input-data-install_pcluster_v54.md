## Install Input Data on ParallelCluster

### Verify AWS CLI is available obtain data from AWS S3 Bucket

Check to see if the aws command line interface (CLI) is installed

`which aws`

If it is installed, skip to the next step.

If it is not available please follow these instructions to install it.

```{seealso}
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
```

`cd /shared`

`curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"`

`unzip awscliv2.zip`

`sudo ./aws/install`

### Verify you can run the aws command

` aws --help`

If not, you may need to logout and back in.

```{note}
If you do not have credintials, skip this. The data is on a public bucket, so you do not need credentials.
```

Set up your credentials for using s3 copy (you can skip this if you do not have credentials)

`aws configure`


### Copy Input Data from S3 Bucket to lustre filesystem

Verify that the /fsx directory exists; this is a lustre file system where the I/O is fastest

`ls /fsx`

If you are unable to use the lustre file system, the data can be installed on the /shared volume, if you have resized the volume to be large enough to store the input and output data.

Install the parallel cluster scripts using the commands:

`cd /shared`

`git clone -b main https://github.com/CMASCenter/pcluster-cmaq.git pcluster-cmaq`

### Use the S3 script to copy the CONUS input data from the CMAS s3 bucket
Data will be saved to the /fsx file system

`/shared/pcluster-cmaq/s3_scripts/s3_copy_nosign_2018_12US1_conus_cmas_opendata_to_fsx.csh`

check that the resulting directory structure matches the run script

```{note}
The CONUS 12US1 input data requires 44 GB of disk space  
(if you use the yaml file to import the data to the lustre file system rather than copying the data you save this space)
```

`cd /fsx/data/CMAQ_Modeling_Platform_2016/CONUS/12US2/`

`du -sh`

output:

```
69G     .
```

CMAQ ParallelCluster is configured to have 1.2 Terrabytes of space on /fsx filesystem (minimum size allowed for lustre /fsx), to allow multiple output runs to be stored.


### For ParallelCluster: Import the Input data from a public S3 Bucket
A second method is available to import the data on the lustre file system using the yaml file to specify the s3 bucket location in the yaml file, rather than using the above aws s3 copy commands. 

```{seealso}
Example available in c5n-18xlarge.ebs_shared.fsx_import.yaml  
```

```
cd /shared/pcluster-cmaq/
vi c5n-18xlarge.ebs_shared.fsx_import.yaml   
```

Section that of the YAML file that specifies the name of the S3 Bucket.

```
  - MountDir: /fsx
    Name: name2
    StorageType: FsxLustre
    FsxLustreSettings:
      StorageCapacity: 1200
      ImportPath: s3://cmas-cmaq-modeling-platform-2018/2018_12US1    <<<  specify name of S3 bucket
```
This requires that the S3 bucket specified is publically available

