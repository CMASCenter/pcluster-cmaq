#!/bin/csh -f
#Script to download enough data to run START_DATE 201522 and END_DATE 201523 for CONUS Domain
#Requires installing aws command line interface
#https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html#cliv2-linux-install
#Total storage required is 44 G
# test using --dryrun option, example aws --no-sign-request s3 cp --dryrun ...
# Assumes you have a /shared directory to copy the files to /shared/data.

setenv AWS_REGION "us-east-1"
aws --no-sign-request s3 cp --recursive s3://cmas-cmaq/CMAQv5.4_2018_12LISTOS_Benchmark_3Day_Input/ /21dayscratch/scr/l/i/lizadams/CMAQ/openmpi_gcc/CMAQ_v54+/data

