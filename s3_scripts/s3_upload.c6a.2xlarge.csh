#!/bin/csh -f
# Script to upload output data to S3 bucket
# need to set up your AWS credentials prior to running this script
# aws configure
# NOTE: need permission to create a bucket and write to an s3 bucket. 
# 

mkdir /shared/data/output/logs
mkdir /shared/data/output/scripts

cp /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/*.logs /shared/data/output/logs
cp  /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/*.csh /shared/data/output/scripts

aws s3 mb s3://c6a.2xlarge.cmaqv5.4
aws s3 cp --recursive /shared/data/output s3://c6a.2xlarge.cmaqv5.4
