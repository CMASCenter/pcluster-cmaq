# Instructions for choosing filesystem or disk for fast I/O Performance and obtaining input data

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


## AWS Parallel Cluster configured with the lustre file system provides advantages to pre-load data at cluster build time.

Verify that the /fsx directory exists this is a lustre file system where the I/O is fastest

`ls /fsx`

If it does not exist, you can place the data directory on the /shared filesystem

`mkdir /shared/data`


## Azure Cyclecloud bilt to allow the input data to be installed on the /shared/data directory

`mkdir /shared/data`

`ls /shared/data`

`df -h`

Output:

`/dev/mapper/vg_cyclecloud_builtinshared-lv0 1000G   66G  935G   7% /shared `


## Use the S3 script to copy the CONUS input data if you have credentials set up for aws cli 
Modify the script if you want to change where the data is saved to.  Script currently uses /shared/data Modify it if you want to copy the data to the /fsx/data volume on the cluster

`/shared/pcluster-cmaq/s3_scripts/s3_copy_need_credentials_conus.csh`

## Use Alternative S3 script to copy the CONUS input data to /fsx/data volume on the cluster (does not need aws credentials)
this download script appears to be missing the GRIDDESC file, obtain a copy from the pcluster-cmaq git repo

`/shared/pcluster-cmaq/s3_scripts/s3_copy_nosign.csh`

check that the resulting directory structure matches the run script

Note, this input data requires 44 GB of disk space  (if you use the yaml file to import the data to the lustre file system rather than copying the data you save this space)

`cd /shared/data/CONUS`

`du -sh`

output:

```
44G     .
```

CMAQ Parallel Cluster is configured to have 1.2 Terrabytes of space on /fsx filesystem (minimum size allowed for lustre /fsx), to allow multiple output runs to be stored.
CMAQ Cycle Cloud is configured to have 1 Terrabytes of space on the /shared filesystem, to allow multiple output runs to be stored.

