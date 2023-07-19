#!/bin/csh -f
# Script to upload output data to S3 bucket
# need to set up your AWS credentials prior to running this script
# aws configure
# NOTE: need permission to create a bucket and write to an s3 bucket. 
# 

mkdir /shared/data/output/logs
mkdir /shared/data/output/scripts

cp /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/*.log /shared/data/output/output_CCTM_v533_gcc_Bench_2016_12SE1/logs/
cp  /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/run_cctm_Bench_2016_12SE1.csh /shared/data/output/output_CCTM_v533_gcc_Bench_2016_12SE1/scripts/

setenv BUCKET c6a.2xlarge.cmaqv533
aws s3 mb s3://$BUCKET
aws s3 cp --recursive /shared/data/output/output_CCTM_v533_gcc_Bench_2016_12SE1 s3://$BUCKET
