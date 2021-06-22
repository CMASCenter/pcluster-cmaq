#!@ip-10-0-0-219 pcluster-cmaq]$ vi 
bin/csh -f
#Script to download enough data to run START_DATE 201522 and END_DATE 201523 for 12km SE Domain
#Requires installing aws command line interface
#https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html#cliv2-linux-install
#Total storage required is 21 G

setenv AWS_REGION "us-east-1"

aws s3 cp --recursive s3://cmaqv5.3.2-bench-2day-2016-12se1-input /shared/CMAQv5.3.2_Benchmark_2Day_Input
