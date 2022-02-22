# Install Input Data on Parallel Cluster

## Install AWS CLI to obtain data from AWS S3 Bucket

see https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

`cd /shared`

`curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install`

### Verify you can run the aws command

` aws --help`

If not, you may need to logout and back in.

Set up your credentials for using s3 copy (you can skip this if you do not have credentials)

`aws configure`


## Copy Input Data from S3 Bucket to lustre filesystem
Note: AWS Parallel Cluster configured with the lustre file system allows users to either copy data from S3 Bucket or pre-load data at cluster build time. Pre-loading or importing the data from an S3 Bucket at the time that the Parallel Cluster is created is covered below.

Verify that the /fsx directory exists this is a lustre file system where the I/O is fastest

`ls /fsx`


## Use the S3 script to copy the CONUS input data from the CMAS s3 bucket
Data will be saved to the /fsx file system

`/shared/pcluster-cmaq/s3_scripts/s3_copy_nosign_conus_cmas_to_fsx.csh`

if the first method works, then you can skip the alternative method listed next..

## Use Alternative S3 script to copy the CONUS input data from the EPA s3 bucket to /fsx volume on the cluster.

`/shared/pcluster-cmaq/s3_scripts/s3_copy_nosign_conus_epa_to_fsx.csh`

check that the resulting directory structure matches the run script

Note, this input data requires 44 GB of disk space  (if you use the yaml file to import the data to the lustre file system rather than copying the data you save this space)

`cd /fsx/data/CONUS`

`du -sh`

output:

```
44G     .
```

CMAQ Parallel Cluster is configured to have 1.2 Terrabytes of space on /fsx filesystem (minimum size allowed for lustre /fsx), to allow multiple output runs to be stored.


## For Parallel Cluster: Obtain the Input data from a public S3 Bucket
A second method is available to import the data on the lustre file system using the yaml file to specify the s3 bucket location, rather than using the above aws s3 copy commands. 

### Second Method: Import the data by specifying it in the yaml file - example available in c5n-18xlarge.ebs_shared.yaml

```
  - MountDir: /fsx
    Name: name2
    StorageType: FsxLustre
    FsxLustreSettings:
      StorageCapacity: 1200
      ImportPath: s3://conus-benchmark-2day    <<<  specify name of S3 bucket
```
This requires that the S3 bucket specified is publically available

