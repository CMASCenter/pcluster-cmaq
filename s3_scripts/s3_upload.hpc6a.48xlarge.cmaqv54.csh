#!/bin/csh -f
# Script to upload output data to S3 bucket
# NOTE: a new bucket needs to be created to store each set of cluster runs

cd /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/
cp -rp run*.log /fsx/data/output
cp -rp run*.csh /fsx/data/output

set BUCKET=s3://cmaqv5.4.c6a.large.head.hpc6a.48xlarge-output

aws s3 mb s3://cmaqv5.4.c6a.large.head.hpc6a.48xlarge-output
aws s3 cp --recursive /fsx/data/output/ s3://cmaqv5.4.c6a.large.head.hpc6a.48xlarge-output



