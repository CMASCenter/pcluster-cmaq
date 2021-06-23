#!/bin/csh -f
# Script to upload output data to S3 bucket
# NOTE: a new bucket needs to be created to store each set of cluster runs

aws s3 mb s3://c5.4xlarge-headandcompute-conus-output
aws s3 cp --recursive /shared/build/openmpi_4.1.0_gcc_8.3.1/CMAQ_v532/data/output s3://c5.4xlarge-headandcompute-conus-output/output

