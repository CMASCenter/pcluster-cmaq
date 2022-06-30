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

# The script configures the Slurm cluster after the deployment. Replace <bucket> with your bucket name.

. "/etc/parallelcluster/cfnconfig"

bucket="<bucket>"

if [ "${cfn_node_type}" == "ComputeFleet" ];then
  exit 0
fi

aws s3 cp s3://${bucket}/slurm-aws-PrologSlurmctld.sh /opt/slurm/etc/
chmod +x /opt/slurm/etc/slurm-aws-PrologSlurmctld.sh

echo "PrologSlurmctld=/opt/slurm/etc/slurm-aws-PrologSlurmctld.sh" >> /opt/slurm/etc/slurm.conf

mv /opt/slurm/bin/sbatch /opt/slurm/sbin/sbatch
aws s3 cp s3://${bucket}/sbatch /opt/slurm/bin/sbatch
chmod +x /opt/slurm/bin/sbatch

mv /opt/slurm/bin/srun /opt/slurm/sbin/srun
ln -s /opt/slurm/bin/sbatch /opt/slurm/bin/srun

aws s3 cp s3://${bucket}/projects_list.conf /opt/slurm/etc/projects_list.conf


systemctl restart slurmctld
