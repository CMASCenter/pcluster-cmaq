# Create a VM using the AWS Command Line 

If you are not able to use the AWS Web Interface to create the VM, then you can use the AWS Command Line (CLI).

Install the aws command line interface on your local computer using the following instructions:<br>
<a href="https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html#cliv2-linux-install">Install AWS CLI</a>

Note that the size of instance determines number of cores

The c6a.2xlarge EC2 instance contains 4 cores with hyperthreading turned off and is sized to run the 12LISTOS-training Benchmark.


The Public AMI contains all the software required to spin up your virtual server including OS, libraries (MPI, netCDF, I/O API, CMAQ) and data to run CMAQv5.4+.

Verify that you can see the public AMI on the us-east-1 region.


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

To use the AWS CLI, the user needs to have a key.pair that was created on an ec2.instance

```{seealso}
<a href="https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html">Guide to obtaining AWS Key Pair</a>
```


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

Use the publically available AMI to launch a spot c6a.2xlarge ec2 instance using a gp3 volume with hyperthreading disabled.

Specify the number of cores and set the number of threads per core to 1 to disable hyperthreading.

Use the command line option to specify the number of cores to match the selected ec2 instance type, and to disable hyperthreading:

`--cpu-options CoreCount=XX, ThreadsPerCore=1`

```
c6a.2xlarge, CoreCount=4
c6a.8xlarge, CoreCount=16
c6a.48xlarge, CoreCount=96 
```

## Create c6a.2xlarge ec2 instance

Note, you will need to obtain a security group id from your IT administrator that allows ssh login access.
If this is enabled by default, then you can remove the --security-group-ids launch-wizard-with-tcp-access

Example command: note launch-wizard-with-tcp-access needs to be replaced by your security group ID, and your-pem key needs to be replaced by the name of your-pem.pem key.

`aws ec2 run-instances --debug --key-name cmaqv5.4 --security-group-ids launch-wizard-179 --region us-east-1 --dry-run --ebs-optimized --cpu-options CoreCount=4,ThreadsPerCore=1 --cli-input-json file://runinstances-config.gp3.json`

Once you have verified that the command above works with the --dry-run option, rerun it without as follows.

`aws ec2 run-instances --debug --key-name cmaqv5.4 --security-group-ids launch-wizard-179 --region us-east-1 --ebs-optimized --cpu-options CoreCount=4,ThreadsPerCore=1 --cli-input-json file://runinstances-config.gp3.json`

Use the q command to return to the cursor 

Use the following command to obtain the public IP address of the machine.

`aws ec2 describe-instances --region=us-east-1 --filters "Name=image-id,Values=ami-051ba52c157e4070c" | grep -A 3 PublicIpAddress`

Also verify that it has switched from an initializing state to a running state.
