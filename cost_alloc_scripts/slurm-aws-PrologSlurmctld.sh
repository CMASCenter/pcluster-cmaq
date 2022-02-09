#!/bin/bash


# MIT No Attribution
# Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# Permission is hereby granted, free of charge, to any person obtaining a copy of this
# software and associated documentation files (the "Software"), to deal in the Software
# without restriction, including without limitation the rights to use, copy, modify,
# merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


# The script assigns the required tags to the EC2 instances of the jobs.

#slurm directory
export SLURM_ROOT=/opt/slurm

AWS_DEFAULT_REGION=$(curl -sS http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk '{print $3}' | sed 's/"//g' | sed 's/,//g')

# wait until route53 is updated
sleep 10

#function used to convert the hostname to ip
function nametoip()
{
    nslookup $1 | awk '/^Address: / { print $2 }'
}

#load the comment of the job.
Project=$($SLURM_ROOT/bin/scontrol show job ${SLURM_JOB_ID} | grep Comment | awk -F'=' '{print $2}')
Project_Tag=""
if [ ! -z "${Project}" ];then
  Project_Tag="Key=aws-parallelcluster-project,Value=${Project}"
fi


#expand the hostnames
hosts=$($SLURM_ROOT/bin/scontrol show hostnames ${SLURM_JOB_NODELIST})

instance_id_list=""
#verify each host
for host in $hosts
  do
   private_ip=$(nametoip $host)
   #verify if the instance is running
   result=$(aws ec2 --region $AWS_DEFAULT_REGION describe-instances --filters "Name=network-interface.addresses.private-ip-address,Values=${private_ip}" --query Reservations[*].Instances[*].InstanceId --output text)
   if [ ! -z "${result}" ];then
     num_jobs=$($SLURM_ROOT/bin/squeue -h -w ${host} | wc -l)
     if [ "${num_jobs}" -eq 1 ];then
       instance_id_list="${instance_id_list} ${result}"
     fi
   fi
done


for host in $instance_id_list
do
  aws ec2 create-tags --region $AWS_DEFAULT_REGION --resources ${host} --tags Key=aws-parallelcluster-username,Value=${SLURM_JOB_USER} Key=aws-parallelcluster-jobid,Value=${SLURM_JOBID} Key=aws-parallelcluster-partition,Value=${SLURM_JOB_PARTITION} Key=aws-parallelcluster-account,Value=${SLURM_JOB_ACCOUNT} Key=aws-parallelcluster-jobname,Value=${SLURM_JOB_NAME} ${Project_Tag}
done

exit 0

