#!/bin/csh -f
#Script to download enough data to run START_DATE 2018-08-05 and END_DATE 2018-08-07 for 12km Listos Domain
#Requires installing aws command line interface
#https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html#cliv2-linux-install
#Total storage required is 2.2 G

setenv AWS_REGION "us-east-1"

aws s3 --no-sign-request --region=us-east-1 cp --recursive s3://cmas-cmaq/CMAQv5.4_2018_12LISTOS_Benchmark_3Day_Input /shared/data/
