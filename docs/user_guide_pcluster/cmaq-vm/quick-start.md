# Create a VM from the AWS Web Console

Here we will use an Amazon Elastic Compute Cloud (EC2) C6a instance to run a small CMAQ benchmark case.  The software needed to run the benchmark is pre-installed on a public AMI.  The input data is also publicly available through the AWS Open Data Program. 

<a href="https://aws.amazon.com/">Login to AWS Web Console</a> and select EC2

![Login to AWS and then select EC2](aws_web_console_home_select_ec2.png)

Click on the orange "Launch Instance" button

![Click on Launch Instance](aws_web_interface_launch_instance.png)

Search for AMI

Enter the ami name: ami-051ba52c157e4070c in the Search box and return or enter.

![Search for AMI](aws_web_console_search_ami.png)

Click on the Community AMI tab and then and click on the orange "Select" button

![Choose Public AMI with CMAQ pre-installed](aws_web_interface_choose_ami.png)


Note this AMI was built for the following architecture, and can be used by the c6a - hpc6a family of instances

Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2023-07-05

Search for c6a.2xlarge Instance Type and select it.

Note, the screenshots show the c6a.2xlarge instance type being selected.

If you were running a larger benchmark, you would want to select a larger sized instance such as a c6a.8xlarge or c6a.48xlarge. 

![Select c6a.2xlarge instance type](aws_web_console_select_c6a.2xlarge_ec2_instance.png)

Select key pair name or create a new key pair

![Select key pair name or create new key pair](aws_web_console_select_key_pair.png)


Use the default Network Settings

![Use default network settings](aws_web_console_network_settings_information.png)

Review Storage Options

The AMI is preconfigured to use 500 GiB of gp3 as the root volume (Not encrypted)

![Review Storage](aws_web_console_storage_volume_information.png)

Select the Pull-down options for Advanced details

![Select Advanced Details](aws_advanced_details.png)

Select checkbox for Request Spot Instances

![Select Spot Instance Pricing](ec2_web_request_spot_instance.png)

Scroll down until you see option to Specify CPU cores

Click the checkbox for "Specify CPU cores"

Then select 4 Cores, and 1 thread per core

![Advanced Details turn off hyperthreading](aws_advanced_details_specify_1_thread_per_core.png)

If you are building a VM using a different instance type, just select 1 thread per core and leave the number of cores to the value that is pre-set. 
c6a.2xlarge (4 Cores), c6a.8xlarge (16 cores), c6a.48x large (96 cores).


In the Summary Menu, select Launch Instance

![Launch instance](aws_web_console_summary_launch_instance_c6a.2xlarge.png)

Click on the link to the instance once it is successfully launched

![Successfully launched link](aws_web_console_successful_launch_c6a.2xlarge.png)

Wait until the Status check has been completed and the Instance State is running

![Instance State running](Instance_State_wait_till_running.png)

Click on the instance link and copy the Public IP address to your clipboard

![Instance IP address](Instance_Public_IP_Address.png)


You will use this Public IP address to login into the VM that you just created (c6a.2xlarge ec2 instance).

On your local computer, you will use the following command.

```
ssh -v -Y -i ~/downloads/your-pem.pem ubuntu@xx.xxx.xxx.xxx
```
