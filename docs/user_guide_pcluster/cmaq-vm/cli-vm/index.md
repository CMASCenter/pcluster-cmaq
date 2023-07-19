# CMAQv5.3.3 on Single Virtual Machine Intermediate (software pre-installed)

Creating an EC2 instance from the Command Line is easy to do. In this tutorial we will give examples on how to create and run using ec2 instances that vary in size depending on the size of the CMAQ benchmarks.

<a href="https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2.html">Using Amazon EC2 with the AWS CLI</a>
<a href="https://aws.amazon.com/ec2/spot/pricing/">SPOT Pricing</a>

| Benchmark Name | Grid Domain | EC2 Instance| vCPU   |  Cores | Memory | Network Performance | Storage | On Demand Hourly Cost | Spot Hourly Cost |
| -------------- | ----------- | ----------  | ------ | ---    |----    | ---------------       | ----  | -------------------   | -------------    |
| 2016_12SE1 | (100x80x35)   | c6a.2xlarge    | 8 | 4 | 16 GiB | Up to 12500 Megabit | EBS Only | 0.306 | 0.2879 |

Data in table above is from the following:
<a href="https://calculator.aws/#/addService/ec2-enhancement?nc2=h_ql_pr_calc">Sizing and Price Calculator from AWS</a>


Run CMAQv5.33 on a single Virtual Machine (VM) using an ami with software pre-loaded to run on either a c6a.2xlarge, c6a.8xlarge or c6a.48xlarge instance with gp3filesystem.

```{toctree}
aws_cli_launch_vm_c6a.2xlarge.md
aws_cli_launch_vm_c6a.8xlarge.md
aws_cli_launch_vm.md
aws_cli_launch_vm_troubleshoot.md
```
