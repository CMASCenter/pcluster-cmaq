#!/bin/csh -f
# Script to upload output data to S3 bucket
# NOTE: a new bucket needs to be created to store each set of cluster runs


aws s3 mb s3://c5n-head-c5n.9xlarge-compute-conus-output-04-21-2022
aws s3 cp --recursive /fsx/data/output/ s3://c5n-head-c5n.9xlarge-compute-conus-output-04-21-2022
