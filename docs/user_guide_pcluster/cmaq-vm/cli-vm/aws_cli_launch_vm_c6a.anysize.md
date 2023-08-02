# Create c6a.(anysize) EC2 instance

## Size of instance determines number of cores

```
c6a.2xlarge EC2 instance contains 4 cores and is sized to run the 12LISTOS-training Benchmark.
c6a.8xlarge EC2 instance contains 16 cores and is sized to run the 12NE3 Benchmark.
c6a.48xlarge EC2 instance contains 96 cores and is sized to run the 12US1 Benchmark.
```


### Public AMI contains the software and data to run CMAQv5.4+

The input data for the 12US1, 12NE3, and 12LISTOS-training benchmarks was transferred from the AWS Open Data Program and installed on the EBS volume.

This chapter describes the process that was used to configure and create the c6a.2xlarge ec2 instance.

See chapter 3 for instructions to run CMAQv5.4 for the benchmark cases.


### Verify that you can see the public AMI on the us-east-1 region.


`aws ec2 describe-images --region us-east-1 --image-id ami-051ba52c157e4070c`


Output:

```
{
    "Images": [
        {
            "Architecture": "x86_64",
            "CreationDate": "2023-07-05T14:10:42.000Z",
            "ImageId": "ami-051ba52c157e4070c",
            "ImageLocation": "440858712842/cmaqv5.4_c6a_gp3_IOPS_16000_throughput_1000",
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
                        "Iops": 16000,
                        "SnapshotId": "snap-08789828f7ab945ed",
                        "VolumeSize": 500,
                        "VolumeType": "gp3",
                        "Throughput": 1000,
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
            "Description": "[Copied ami-01605a204650ede2f from us-east-1] cmaqv5.4_c6a_48xlarge_gp3_IOPS_16000_throughput_1000",
            "EnaSupport": true,
            "Hypervisor": "xen",
            "Name": "cmaqv5.4_c6a_gp3_IOPS_16000_throughput_1000",
            "RootDeviceName": "/dev/sda1",
            "RootDeviceType": "ebs",
            "SriovNetSupport": "simple",
            "VirtualizationType": "hvm",
            "DeprecationTime": "2025-07-05T14:10:42.000Z"
        }
    ]
}


```

Use q to exit out of the command line

Note, the AMI uses the default values of iops and throughput for the gp3 volume. 


To launch a Spot Instance with RunInstances API you create the configuration file as described below:

```
cat <<EoF > ./runinstances-config.gp3.json
{
    "DryRun": false,
    "MaxCount": 1,
    "MinCount": 1,
    "InstanceType": "c6a.2xlarge",
    "ImageId": "ami-051ba52c157e4070c",
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

## Use the publically available AMI to launch an ondemand c6a.(anysize) ec2 instance 

using a gp3 volume with hyperthreading disabled 


Note, we will be using a json file that has been preconfigured to specify the ImageId

## Obtain the code using git

`git clone -b main https://github.com/CMASCenter/pcluster-cmaq`

`cd pcluster-cmaq/json`


Note, you will need to obtain a security group id from your IT administrator that allows ssh login access.
If this is enabled by default, then you can remove the --security-group-ids launch-wizard-with-tcp-access 

Example command: note launch-wizard-with-tcp-access needs to be replaced by your security group ID, and your-pem key needs to be replaced by the name of your-pem.pem key.

`aws ec2 run-instances --debug --key-name your-pem --security-group-ids launch-wizard-with-tcp-access --dry-run --region us-east-1 --cli-input-json file://runinstances-config.json`

## Specify the number of cores

Use the aws --cpu-options CoreCount=XX, ThreadsPerCore=1 to specify the number of cores to match the selected ec2 instance type 
c6a.2xlarge has 4 cores, limit the ThreadsPerCore to 1 to disable hyperthreading.
c6a.8xlarge has 16 cores,limit the ThreadsPerCore to 1 to disable hyperthreading.
c6a.48xlarge has 96 cores, limit the ThreadsPerCore to 1 to disable hyperthreading.

## Create c6a.2xlarge ec2 instance

`aws ec2 run-instances --debug --key-name cmaqv5.4 --security-group-ids launch-wizard-179 --region us-east-1 --dry-run --ebs-optimized --cpu-options CoreCount=4,ThreadsPerCore=1 --cli-input-json file://runinstances-config.gp3.c6a.2xlarge.json`

Once you have verified that the command above works with the --dry-run option, rerun it without as follows.

`aws ec2 run-instances --debug --key-name cmaqv5.4 --security-group-ids launch-wizard-179 --region us-east-1 --ebs-optimized --cpu-options CoreCount=4,ThreadsPerCore=1 --cli-input-json file://runinstances-config.gp3.c6a.2xlarge.json`

Use the q command to return to the cursor 

## Or Create a c6a.8xlarge ec2 instance

`aws ec2 run-instances --debug --key-name cmaqv5.4 --security-group-ids launch-wizard-179 --region us-east-1 --dry-run --ebs-optimized --cpu-options CoreCount=16,ThreadsPerCore=1 --cli-input-json file://runinstances-config.gp3.c6a.8xlarge.json`

Once you have verified that the command above works with the --dry-run option, rerun it without as follows.

`aws ec2 run-instances --debug --key-name cmaqv5.4 --security-group-ids launch-wizard-179 --region us-east-1 --ebs-optimized --cpu-options CoreCount=16,ThreadsPerCore=1 --cli-input-json file://runinstances-config.gp3.c6a.8xlarge.json`

Use q to quit to return to the command prompt.

## Or Create a c6a.48xlarge ec2 instance

`aws ec2 run-instances --debug --key-name cmaqv5.4 --security-group-ids launch-wizard-179 --region us-east-1 --dry-run --ebs-optimized --cpu-options CoreCount=96,ThreadsPerCore=1 --cli-input-json file://runinstances-config.gp3.json`

Once you have verified that the command above works with the --dry-run option, rerun it without as follows.

`aws ec2 run-instances --debug --key-name cmaqv5.4 --security-group-ids launch-wizard-179 --region us-east-1 --ebs-optimized --cpu-options CoreCount=96,ThreadsPerCore=1 --cli-input-json file://runinstances-config.gp3.json`

### Use the following command to obtain the public IP address of the machine.


`aws ec2 describe-instances --region=us-east-1 --filters "Name=image-id,Values=ami-051ba52c157e4070c" | grep -A 3 PublicIpAddress`

Also verify that it has switched from an initializing state to a running state.



### Login to the ec2 instance

Note, the following command must be modified to specify your key, and ip address (obtained from the previous command):
Note, you will get a connection refused if you try to login prior to the ec2 instance being ready to run (takes ~5 minutes for initialization).

`ssh -v -Y -i ~/downloads/your-pem.pem ubuntu@ip.address`


### Login to the ec2 instance again, so that you have two windows logged into the machine.

`ssh -Y -i ~/downloads/your-pem.pem ubuntu@your-ip-address`
