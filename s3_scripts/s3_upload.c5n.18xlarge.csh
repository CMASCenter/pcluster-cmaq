#!/bin/csh -f
# Script to upload output data to S3 bucket
# NOTE: a new bucket needs to be created to store each set of cluster runs

aws s3 mb s3://c5n-head-c5n.18xlarge-compute-conus-output
aws s3 cp --recursive /fsx/data/output/output_CCTM_v533_gcc_2016_CONUS_10x18pe s3://c5n-head-c5n.18xlarge-compute-conus-output/fsx/data/output/output_CCTM_v533_gcc_2016_CONUS_10x18pe

