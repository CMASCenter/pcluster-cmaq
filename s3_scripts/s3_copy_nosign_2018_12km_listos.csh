#!/bin/csh -f
#Script to download enough data to run START_DATE 2018-08-05 and END_DATE 2018-08-07 for 12km Listos Domain
#Requires installing aws command line interface
#https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html#cliv2-linux-install
#Total storage required is 1.7 G

setenv AWS_REGION "us-east-1"

aws s3 --no-sign-request  cp --recursive s3://cmas-cmaq/2018-listos /shared/data/2018-listos
