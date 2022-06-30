#!/bin/csh -f
#Script to download enough data to run START_DATE 201522 and END_DATE 201523 for CONUS Domain
#Requires installing aws command line interface
#https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html#cliv2-linux-install
#Total storage required is 44 G
# test using --dryrun option, example aws --no-sign-request s3 cp --dryrun ...
# Assumes you have a /shared directory to copy the files to /shared/data.

setenv AWS_REGION "us-east-1"
mkdir -p /shared/data
setenv DISK shared
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*151222" --include "*151223" s3://cmas-cmaq-conus2-benchmark/data/CMAQ_Modeling_Platform_2016/CONUS/12US2/MCIP /$DISK/data/CMAQ_Modeling_Platform_2016/CONUS/12US2/MCIP
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*151222*" --include "*151223*" --include "smk_merge_dates_201512.txt" s3://cmas-cmaq-conus2-benchmark/data/CMAQ_Modeling_Platform_2016/CONUS/12US2/emissions /$DISK/data/CMAQ_Modeling_Platform_2016/CONUS/12US2/emissions
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*151222*" --include "*151223*" --include "*stack_groups*" s3://cmas-cmaq-conus2-benchmark/data/CMAQ_Modeling_Platform_2016/CONUS/12US2/emissions /$DISK/data/CMAQ_Modeling_Platform_2016/CONUS/12US2/emissions
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*160101*" --include "*160102*"  s3://cmas-cmaq-conus2-benchmark/data/CMAQ_Modeling_Platform_2016/CONUS/12US2/emissions /$DISK/data/CMAQ_Modeling_Platform_2016/CONUS/12US2/emissions
aws --no-sign-request s3 cp --recursive s3://cmas-cmaq-conus2-benchmark/data/CMAQ_Modeling_Platform_2016/CONUS/12US2/emissions/othpt /$DISK/data/CMAQ_Modeling_Platform_2016/CONUS/12US2/emissions/othpt
aws --no-sign-request s3 cp --recursive s3://cmas-cmaq-conus2-benchmark/data/CMAQ_Modeling_Platform_2016/CONUS/12US2/land /$DISK/data/CMAQ_Modeling_Platform_2016/CONUS/12US2/land
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*151222*" --include "*151223*"  s3://cmas-cmaq-conus2-benchmark/data/CMAQ_Modeling_Platform_2016/CONUS/12US2/icbc /$DISK/data/CMAQ_Modeling_Platform_2016/CONUS/12US2/icbc
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*GRIDDESC*" s3://cmas-cmaq-conus2-benchmark/data/CMAQ_Modeling_Platform_2016/CONUS/12US2 /$DISK/data/CMAQ_Modeling_Platform_2016/CONUS/12US2
aws --no-sign-request s3 cp --recursive --exclude "*" --include "README.txt" s3://cmas-cmaq-conus2-benchmark/data/CMAQ_Modeling_Platform_2016/CONUS/12US2 /$DISK/data/CMAQ_Modeling_Platform_2016/CONUS/12US2


