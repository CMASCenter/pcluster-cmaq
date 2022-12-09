#!/bin/csh -f
# Script to upload output data to S3 bucket
# NOTE: a new bucket needs to be created to store each set of cluster runs

#cd /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts
#cp -rp run*.log /fsx/data/output
#cp -rp run*.csh /fsx/data/output

set BUCKET=s3://c5n-head-s3-hpc6a.48xlarge-compute-conus-output

#aws s3 --region us-east-1 mb s3://c5n-head-s3-hpc6a.48xlarge-compute-conus-output
#aws s3 --region us-east-1 cp --recursive /fsx/data/output/scripts_logs s3://c5n-head-s3-hpc6a.48xlarge-compute-conus-output
aws s3 cp --recursive /fsx/data/output/ s3://c5n-head-s3-hpc6a.48xlarge-compute-conus-output --exclude "*.nc" --exclude "*.cfg"



