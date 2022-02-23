#!/bin/csh -f
# Script to upload output data to S3 bucket
# NOTE: a new bucket needs to be created to store each set of cluster runs

aws s3 mb s3://c5n-head-c5n.18xlarge-compute-conus-output-01-05-2021
aws s3 cp --recursive /fsx/data/output/ s3://c5n-head-c5n.18xlarge-compute-conus-output
aws s3 cp --recursive /fsx/POST s3://c5n-head-c5n.18xlarge-compute-conus-output
