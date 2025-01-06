#!/bin/csh -f
#Script to download enough data to run START_DATE 20180701 and END_DATE 20180702 for CONUS Domain
#Requires installing aws command line interface
#https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html#cliv2-linux-install
#Total storage required is 44 G
# test using --dryrun option, example aws --no-sign-request s3 cp --dryrun ...
# Assumes you have a updated to create a directory to copy the files to.

setenv AWS_REGION "us-east-1"
mkdir -p /21dayscratch/scr/l/i/lizadams/CMAQv5.5/openmpi_gcc/data
setenv DISK /21dayscratch/scr/l/i/lizadams/CMAQv5.5/openmpi_gcc
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*201712*" --include "*20180101*" --include "*20180102*" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/met/WRFv4.3.3_LTNG_MCIP5.3.3_compressed /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/met/WRFv4.3.3_LTNG_MCIP5.3.3_compressed
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*201712*" --include "*201801*"  --include "smk_merge_dates_201801.txt"  --include "smk_merge_dates_201712.txt" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/emis /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/emis
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*stack_groups*" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/emis /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/emis
aws --no-sign-request s3 cp --recursive  s3://cmas-cmaq-modeling-platform-2018/2018_12US1/emis/emis_dates /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/emis/emis_dates
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*201712*" --recursive s3://cmas-cmaq-modeling-platform-2018/2018_12US1/epic /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/epic
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*20180101*" --recursive s3://cmas-cmaq-modeling-platform-2018/2018_12US1/epic /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/epic
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*20180102*" --recursive s3://cmas-cmaq-modeling-platform-2018/2018_12US1/epic /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/epic
aws --no-sign-request s3 cp --recursive s3://cmas-cmaq-modeling-platform-2018/2018_12US1/surface /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/surface
aws --no-sign-request s3 cp --recursive s3://cmas-cmaq-modeling-platform-2018/2018_12US1/misc /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/misc
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*201712*" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/icbc /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/icbc
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*201801*"  s3://cmas-cmaq-modeling-platform-2018/2018_12US1/icbc/CMAQv54_2018_108NHEMI_CRACCM1_FROM_CB6R5M_STAGE_EMERSON/ /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/icbc/CMAQv54_2018_108NHEMI_CRACCM1_FROM_CB6R5M_STAGE_EMERSON/
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*GRIDDESC*" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/ /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*run_cctm_2018*" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/ /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*20181208*" --include "*20181222*" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/emis/WR705_2018gc2_cracmmv1/ /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/emis/WR705_2018gc2_cracmmv1/
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*2017*" --include "*201812*" --include "*20180101*" --include "*20180102*" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/emis/WR705_2018gc2_cracmmv1/ /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/emis/WR705_2018gc2_cracmmv1/

