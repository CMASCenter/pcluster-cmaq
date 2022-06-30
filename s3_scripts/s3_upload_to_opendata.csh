#!/bin/csh -f
# Script to upload CMAQ CONUS2 Benchmark to S3 bucket
# NOTE: a new bucket needs to be created to store each set of cluster runs
# test script first using --dryrun option

aws s3 cp /fsx/data/CONUS  s3://cmas-cmaq-conus2-benchmark/data/CMAQ_Modeling_Platform_2016/CONUS --recursive
aws s3 cp /fsx/data/CONUS/12US2/README.txt s3://cmas-cmaq-conus2-benchmark/README.txt

