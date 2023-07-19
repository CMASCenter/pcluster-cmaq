# Learn how to Use AWS CLI to launch c6a.8xlarge EC2 instance using Public AMI

## Public AMI contains the software and data to run 2016_12SE1 using CMAQv5.3.3

Software was pre-installed and saved to a public ami. 

The input data was also transferred from the AWS Open Data Program and installed on the EBS volume.

This chapter describes the process that was used to test and configure the c6a.8xlarge ec2 instance to run CMAQv5.3.3 for the 12SE1 domain.

Todo: Need to create command line options to copy a public ami to a different region.

### Verify that you can see the public AMI on the us-east-1 region.


`aws ec2 describe-images --region us-east-1 --image-id ami-088f82f334dde0c9f`


Output:

```
{
    "Images": [
        {
            "Architecture": "x86_64",
            "CreationDate": "2023-06-26T18:17:08.000Z",
            "ImageId": "ami-088f82f334dde0c9f",
            "ImageLocation": "440858712842/EC2CMAQv54io2_12LISTOS-training_12NE3_12US1",
            "ImageType": "machine",
            "Public": true,
            "OwnerId": "440858712842",
            "PlatformDetails": "Linux/UNIX",
            "UsageOperation": "RunInstances",
            "State": "available",
            "BlockDeviceMappings": [
                {
                    "DeviceName": "/dev/sda1",
                    "Ebs": {
                        "DeleteOnTermination": true,
                        "Iops": 100000,
                        "SnapshotId": "snap-042b05034228ec830",
                        "VolumeSize": 500,
                        "VolumeType": "io2",
                        "Encrypted": false
                    }
                },
                {
                    "DeviceName": "/dev/sdb",
                    "VirtualName": "ephemeral0"
                },
                {
                    "DeviceName": "/dev/sdc",
                    "VirtualName": "ephemeral1"
                }
            ],
            "EnaSupport": true,
            "Hypervisor": "xen",
            "Name": "EC2CMAQv54io2_12LISTOS-training_12NE3_12US1",
            "RootDeviceName": "/dev/sda1",
            "RootDeviceType": "ebs",
            "SriovNetSupport": "simple",
            "VirtualizationType": "hvm",
            "DeprecationTime": "2025-06-26T18:17:08.000Z"
        }
    ]
}


```

Use q to exit out of the command line

Note, the AMI uses the maximum value available on io2 for Iops of 100000.


### AWS Resources for the aws cli method to launch ec2 instances.
 
<a href="https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-instances.html">aws cli examples</a>

<a href="https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/run-instances.html">aws cli run instances command</a>

<a href="https://ec2spotworkshops.com/launching_ec2_spot_instances.html">Tutorial Launch Spot Instances</a>

(note, it discourages the use of run-instances for launching spot instances, but they do provide an example method)

<a href="https://ec2spotworkshops.com/launching_ec2_spot_instances/runinstances_api.html">Launching EC2 Spot Instances using Run Instances API</a>


Additional resources for spot instance provisioning.

<a href="https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/spot-requests.html">Spot Instance Requests</a>


To launch a Spot Instance with RunInstances API you create the configuration file as described below:

```
cat <<EoF > ./runinstances-config.json
{
    "DryRun": false,
    "MaxCount": 1,
    "MinCount": 1,
    "InstanceType": "c6a.8xlarge",
    "ImageId": "ami-088f82f334dde0c9f",
    "InstanceMarketOptions": {
        "MarketType": "spot"
    },
    "TagSpecifications": [
        {
            "ResourceType": "instance",
            "Tags": [
                {
                    "Key": "Name",
                    "Value": "EC2SpotCMAQv54"
                }
            ]
        }
    ]
}
EoF
```

## Use the publically available AMI to launch an ondemand c6a.8xlarge ec2 instance using a io2 volume with 100000 IOPS with hyperthreading disabled 


Note, we will be using a json file that has been preconfigured to specify the ImageId

## Obtain the code using git

`git clone -b main https://github.com/CMASCenter/pcluster-cmaq`

`cd pcluster-cmaq/json`


Note, you will need to obtain a security group id from your IT administrator that allows ssh login access.
If this is enabled by default, then you can remove the --security-group-ids launch-wizard-with-tcp-access 

Example command: note launch-wizard-with-tcp-access needs to be replaced by your security group ID, and your-pem key needs to be replaced by the name of your-pem.pem key.

`aws ec2 run-instances --debug --key-name your-pem --security-group-ids launch-wizard-with-tcp-access --dry-run --region us-east-1 --cli-input-json file://runinstances-config.json`

Command that works for UNC's security group and pem key:

`aws ec2 run-instances --debug --key-name cmaqv5.4 --security-group-ids launch-wizard-179 --region us-east-1 --dry-run --ebs-optimized --cpu-options CoreCount=16,ThreadsPerCore=1 --cli-input-json file://runinstances-config.io2.c6a.8xlarge.json`

Once you have verified that the command above works with the --dry-run option, rerun it without as follows.

`aws ec2 run-instances --debug --key-name cmaqv5.4 --security-group-ids launch-wizard-179 --region us-east-1 --ebs-optimized --cpu-options CoreCount=16,ThreadsPerCore=1 --cli-input-json file://runinstances-config.io2.c6a.8xlarge.json`

Use q to quit to return to the command prompt.

Example of security group inbound and outbound rules required to connect to EC2 instance via ssh.

![Inbound Rule](../cmaq-vm/security_group_inbound_rule.png)

![Outbound Rule](../cmaq-vm/security_group_inbound_rule.png)


Additional resources

<a href="https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-sg.html">CLI commands to create Security Group</a>

### Use the following command to obtain the public IP address of the machine.

This command is commented out, as the instance hasn't been created yet. keeping the instructions for documentation purposes.

`aws ec2 describe-instances --region=us-east-1 --filters "Name=image-id,Values=ami-088f82f334dde0c9f" | grep PublicIpAddress`

### Login to the ec2 instance (may need to wait 5 minutes for the ec2 instance to initialize and be ready for login)

Note, the following command must be modified to specify your key, and ip address (obtained from the previous command):

`ssh -v -Y -i ~/downloads/your-pem.pem ubuntu@ip.address`


### Login to the ec2 instance again, so that you have two windows logged into the machine.

`ssh -Y -i ~/your-pem.pem ubuntu@your-ip-address` 


## Load the environment modules

`module avail`

`module load ioapi-3.2/gcc-11.3.0-netcdf  mpi/openmpi-4.1.2  netcdf-4.8.1/gcc-11.3 `

## Update the pcluster-cmaq repo using git

`cd /shared/pcluster-cmaq`

`git pull`


## Run CMAQv5.3.3 for 2016_12SE1 1 Day benchmark Case


```
GRIDDESC

' '
'LamCon_40N_97W'
  2        33.000        45.000       -97.000       -97.000        40.000
' '
'SE53BENCH'
'LamCon_40N_97W'    792000.000  -1080000.000     12000.000     12000.000 100  80   1
'2016_12SE1'
'LamCon_40N_97W'    792000.000  -1080000.000     12000.000     12000.000 100  80   1

```

### Edit the run script to run on 16 cores 

```
cd /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/
cp run_cctm_Bench_2016_12SE1.csh run_cctm_Bench_2016_12SE1.16pe.csh
```

change NPCOLxNPROW to 4x4


### Use command line to submit the job. This single virtual machine does not have a job scheduler such as slurm installed.


```
cd /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/
./run_cctm_Bench_2016_12SE1.16pe.csh |& tee ./run_cctm_Bench_2016_12SE1.16pe.log
```

### Use HTOP to view performance.

`htop`

output


![Screenshot of HTOP](../cmaq-vm-intermed/htop_c6a.8xlarge_hyperthreading_off.png)

### Successful output

```

```


### Find the InstanceID using the following command on your local machine.

`aws ec2 describe-instances --region=us-east-1 | grep InstanceId`

Output

i-xxxx

### Stop the instance

`aws ec2 stop-instances --region=us-east-1 --instance-ids i-xxxx`


Get the following error message.

aws ec2 stop-instances --region=us-east-1 --instance-ids i-041a702cc9f7f7b5d

An error occurred (UnsupportedOperation) when calling the StopInstances operation: You can't stop the Spot Instance 'i-041a702cc9f7f7b5d' because it is associated with a one-time Spot Instance request. You can only stop Spot Instances associated with persistent Spot Instance requests.


Note sure how to do a persistent spot instance request .
### Terminate Instance

`aws ec2 terminate-instances --region=us-east-1 --instance-ids i-xxxx`

### Verify that the instance is being shut down.

`aws ec2 describe-instances --region=us-east-1`
