#!/bin/csh -f
# Script to upload output data to S3 bucket
# NOTE: a new bucket needs to be created to store each set of cluster runs

#cd /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts
#cp run*.log /fsx/data/output
#cp run*.csh /fsx/data/output

aws s3 mb s3://c6a.xlarge-head-c6a.48xlarge-compute-12us1
aws s3 cp --recursive /fsx/data/ s3://c6a.xlarge-head-c6a.48xlarge-compute-12us1
