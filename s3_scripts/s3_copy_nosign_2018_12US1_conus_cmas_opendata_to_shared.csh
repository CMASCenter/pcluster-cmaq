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
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*20180701*" --include "*20180702*" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/met/WRFv4.3.3_LTNG_MCIP5.3.3_compressed /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/met/WRFv4.3.3_LTNG_MCIP5.3.3_compressed
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*20180701*" --include "*20180702*" --include "smk_merge_dates_201807.txt" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/emis /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/emis
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*stack_groups*" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/emis /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/emis
aws --no-sign-request s3 cp --recursive  s3://cmas-cmaq-modeling-platform-2018/2018_12US1/emis/emis_dates /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/emis/emis_dates
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*20180709*" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/emis/cb6r3_ae6_20190604/ptnonipm /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/emis/cb6r3_ae6_20190604/ptnonipm
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*20180715*" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/emis/cb6r3_ae6_20190604/ptnonipm /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/emis/cb6r3_ae6_20190604/ptnonipm
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*20180715*" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/emis/cb6r3_ae6_20190604/othpt /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/emis/cb6r3_ae6_20190604/othpt
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*20180709*" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/emis/cb6r3_ae6_20190604/othpt /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/emis/cb6r3_ae6_20190604/othpt
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*20180709*" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/emis/cb6r3_ae6_20190604/pt_oilgas /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/emis/cb6r3_ae6_20190604/pt_oilgas
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*20180715*" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/emis/cb6r3_ae6_20190604/pt_oilgas /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/emis/cb6r3_ae6_20190604/pt_oilgas
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*20180710*" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/emis/cb6r3_ae6_20190604/cmv_c3 /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/emis/cb6r3_ae6_20190604/cmv_c3
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*20180701*" --recursive s3://cmas-cmaq-modeling-platform-2018/2018_12US1/epic /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/epic
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*20180702*" --recursive s3://cmas-cmaq-modeling-platform-2018/2018_12US1/epic /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/epic
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*20180710*" --recursive s3://cmas-cmaq-modeling-platform-2018/2018_12US1/epic /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/epic
aws --no-sign-request s3 cp --recursive s3://cmas-cmaq-modeling-platform-2018/2018_12US1/surface /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/surface
aws --no-sign-request s3 cp --recursive s3://cmas-cmaq-modeling-platform-2018/2018_12US1/misc /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/misc
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*20171221*" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/icbc /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/icbc
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*201807*"  s3://cmas-cmaq-modeling-platform-2018/2018_12US1/icbc /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/icbc
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*GRIDDESC*" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/ /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*run_cctm_2018*" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/ /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*20180709*" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/emis/cb6r3_ae6_20200131_MYR/ /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/emis/cb6r3_ae6_20200131_MYR/
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*20180715*" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/emis/cb6r3_ae6_20200131_MYR/ /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/emis/cb6r3_ae6_20200131_MYR/
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*20180710*" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/emis/cb6r3_ae6_20200131_MYR/ /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/emis/cb6r3_ae6_20200131_MYR/
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*20171222*" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/emis/cb6r3_ae6_20200131_MYR/ /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/emis/cb6r3_ae6_20200131_MYR/
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*20171223*" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/emis/cb6r3_ae6_20200131_MYR/ /$DISK/data/CMAQ_Modeling_Platform_2018/2018_12US1/emis/cb6r3_ae6_20200131_MYR/
