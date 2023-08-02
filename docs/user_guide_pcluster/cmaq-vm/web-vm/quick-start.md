# Create c6a.2xlarge EC2 instance using Public AMI

This chapter describes the process used in the AWS Web interface to configure and create a c6a.2xlarge ec2 instance using a public ami. 
See chapter 3 for instructions to use ssh to login and run CMAQ for the 12LISTOS-training domain.

Software was pre-installed and saved to a public ami. The input data was also transferred from the AWS Open Data Program and installed on the EBS volume.

## Login to the AWS Consol and select EC2

<a href="https://aws.amazon.com/">Login to AWS Web Console</a>

![Login to AWS and then select EC2](../web-vm/aws_web_console_home_select_ec2.png)

### Click on the orange "Launch Instance" button

![Click on Launch Instance](../web-vm/aws_web_interface_launch_instance.png)

## Search for AMI

Enter the ami name: ami-051ba52c157e4070c in the Search box and return or enter.

![Search for AMI](../web-vm/aws_web_console_search_ami.png)

Click on the Community AMI tab and then and click on the orange "Select" button

![Choose Public AMI with CMAQ pre-installed](../web-vm/aws_web_interface_choose_ami.png)


### Note this AMI was built for the following architecture, and can be used by the c6a - hpc6a family of instances

Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2023-07-05

### Search for c6a.2xlarge Instance Type and select 
Note, the screenshots show the c6a.2xlarge instance type being selected.
You can repeat this process for creating a single VM for the c6a.8xlarge and c6a.48xlarge by just searching for and selecting those ec2-instances instead.


![Select c6a.2xlarge instance type](../web-vm/aws_web_console_select_c6a.2xlarge_ec2_instance.png)

## Select key pair name or create a new key pair

![Select key pair name or create new key pair](../web-vm/aws_web_console_select_key_pair.png)


## Use the default Network Settings

![Use default network settings](../web-vm/aws_web_console_network_settings_information.png)

## Review Storage Options

The AMI is preconfigured to use 500 GiB of gp3 as the root volume (Not encrypted)

![Review Storage](../web-vm/aws_web_console_storage_volume_information.png)

## Select the Pull-down options for Advanced details

![Select Advanced Details](../web-vm/aws_advanced_details.png)

### Select checkbox for Request Spot Instances

![Select Spot Instance Pricing](../web-vm/ec2_web_request_spot_instance.png)

Scroll down until you see option to Specify CPU cores

### Click the checkbox for "Specify CPU cores"

Then select 4 Cores, and 1 thread per core



![Advanced Details turn off hyperthreading](../web-vm/aws_advanced_details_specify_1_thread_per_core.png)

If you are building a VM using a different instance type, just select 1 thread per core and leave the number of cores to the value that is pre-set. 
c6a.2xlarge (4 Cores), c6a.8xlarge (16 cores), c6a.48x large (96 cores).


## In the Summary Menu, select Launch Instance

![Launch instance](../web-vm/aws_web_console_summary_launch_instance_c6a.2xlarge.png)

### Click on the link to the instance once it is successfully launched

![Successfully launched link](../web-vm/aws_web_console_successful_launch_c6a.2xlarge.png)

### Wait until the Status check has been completed and the Instance State is running

![Instance State running](../web-vm/Instance_State_wait_till_running.png)

### Click on the instance link and copy the Public IP address to your clipboard

![Instance IP address](../web-vm/Instance_Public_IP_Address.png)


## Use the ssh command to login to the c6a.2xlarge instance

```
ssh -v -Y -i ~/downloads/your-pem.pem ubuntu@xx.xxx.xxx.xxx
```


