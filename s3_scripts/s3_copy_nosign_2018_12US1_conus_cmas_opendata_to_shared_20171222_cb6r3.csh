#!/bin/csh -f
#Script to download enough data to run START_DATE 20171222 and END_DATE 20171223 for CONUS Domain for the cb6r3_ae6_20200131_MYR mechanism
#https://dataverse.unc.edu/dataset.xhtml?persistentId=doi:10.15139/S3/LDTWKH
#Requires installing aws command line interface
#https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html#cliv2-linux-install
#Total storage required is 41 G
# test using --dryrun option, example aws --no-sign-request s3 cp --dryrun ...
# Assumes you have a /shared directory to copy the files to /shared/data.

setenv AWS_REGION "us-east-1"
mkdir -p /shared/data
setenv DISK shared/data
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*20171222*" --include "*20171223*" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/met/WRFv4.3.3_LTNG_MCIP5.3.3_compressed /$DISK/CMAQ_Modeling_Platform_2018/2018_12US1/met/WRFv4.3.3_LTNG_MCIP5.3.3_compressed
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*20171222*" --include "*20171223*" --include "*20181208*" --include "*20181209*" --include "smk_merge_dates_201712_for2018spinup.txt" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/emis/cb6r3_ae6_20200131_MYR /$DISK/CMAQ_Modeling_Platform_2018/2018_12US1/emis/cb6r3_ae6_20200131_MYR
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*stack_groups*20171222*" --include "*stack_groups*20171223*" --include "*stack_groups_ptegu*" --include "*stack_groups_cmv*" --include "*stack_groups_othpt*" --include "*stack_groups_pt_oilgas*" --include "*stack_groups_ptnonipm*" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/emis/cb6r3_ae6_20200131_MYR /$DISK/CMAQ_Modeling_Platform_2018/2018_12US1/emis/cb6r3_ae6_20200131_MYR
aws --no-sign-request s3 cp --recursive  s3://cmas-cmaq-modeling-platform-2018/2018_12US1/emis/emis_dates /$DISK/CMAQ_Modeling_Platform_2018/2018_12US1/emis/emis_dates
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*20171222*" --recursive s3://cmas-cmaq-modeling-platform-2018/2018_12US1/epic /$DISK/CMAQ_Modeling_Platform_2018/2018_12US1/epic
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*20171223*" --recursive s3://cmas-cmaq-modeling-platform-2018/2018_12US1/epic /$DISK/CMAQ_Modeling_Platform_2018/2018_12US1/epic
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*beld4_12US1_2011.nc4*" --include "*beis4_beld6_norm_emis.12US1*" --include "*2017r1_EPIC0509_12US1_soil.nc4*"  --recursive s3://cmas-cmaq-modeling-platform-2018/2018_12US1/epic /$DISK/CMAQ_Modeling_Platform_2018/2018_12US1/epic
aws --no-sign-request s3 cp --recursive s3://cmas-cmaq-modeling-platform-2018/2018_12US1/surface /$DISK/CMAQ_Modeling_Platform_2018/2018_12US1/surface
aws --no-sign-request s3 cp --recursive s3://cmas-cmaq-modeling-platform-2018/2018_12US1/misc /$DISK/CMAQ_Modeling_Platform_2018/2018_12US1/misc
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*cb6r5_ae7_aq_WR413*20171221*" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/icbc /$DISK/CMAQ_Modeling_Platform_2018/2018_12US1/icbc
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*BCON_CONC_12US1_CMAQv54_2018_108NHEMI_M3DRY_regrid_201712.nc*"  s3://cmas-cmaq-modeling-platform-2018/2018_12US1/icbc /$DISK/CMAQ_Modeling_Platform_2018/2018_12US1/icbc
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*GRIDDESC*" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/ /$DISK/CMAQ_Modeling_Platform_2018/2018_12US1
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*run_cctm_2018*" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/ /$DISK/CMAQ_Modeling_Platform_2018/2018_12US1
