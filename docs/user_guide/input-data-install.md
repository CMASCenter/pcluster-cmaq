# Instructions for choosing filesystem or disk for fast I/O Performance and obtaining input data


### Verify that the /fsx directory exists this is a lustre file system where the I/O is fastest

`ls /fsx`


### If the lustre filesystem is not available install the input data on the /shared/data directory

'ls /shared/data'

### Set up your credentials for using s3 copy (you can skip this if you don't have credentials)

`aws configure`

### Use the S3 script to copy the CONUS input data to the /fsx/data volume on the cluster

`/shared/pcluster-cmaq/s3_scripts/s3_copy_need_credentials_conus.csh`

### Alternative S3 script to copy the CONUS input data to /fsx/data volume on the cluster (doesn't need aws credentials)

`/shared/pcluster-cmaq/s3_scripts/s3_copy_nosign.csh`

check that the resulting directory structure matches the run script

### Note, this input data requires 44 GB of disk space  (if you use the yaml file to import the data to the lustre file system rather than copying the data you save this space)

`cd /fsx/data/CONUS`

`du -sh`

output:

```
44G     .
```

### CMAQ Cluster is configured to have 1.2 Terrabytes of space on /fsx filesystem (minimum size allowed for lustre /fsx), to allow multiple output runs to be stored.

