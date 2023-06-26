# CMAQv5.4 on Single Virtual Machine Intermediate (software pre-installed)

Creating an EC2 instance from the Command Line is easy to do. In this tutorial we will give examples on how to create and run using ec2 instances that vary in size depending on the size of the CMAQ benchmarks.

<a href="https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2.html">Using Amazon EC2 with the AWS CLI</a>
<a href="https://aws.amazon.com/ec2/spot/pricing/">SPOT Pricing</a>

| Benchmark Name | Grid Domain | EC2 Instance| vCPU   |  Cores | Memory | Network Performance | Storage | On Demand Hourly Cost | Spot Hourly Cost |
| -------------- | ----------- | ----------  | ------ | ---    |----    | ---------------       | ----  | -------------------   | -------------    |
| Training 12km Listos | (25x25x35)   | c6a.2xlarge    | 8 | 4 | 16 GiB | Up to 12500 Megabit | EBS Only | 0.306 | 0.2879 |
| 12NE3                | (100x100x35) | c6a.8xlarge   | 32  | 16 | 64 GiB | 12500 Megabit  | EBS Only | 1.224  | 1.0008 |
| 12US1                | (459x299x35) | c6a.48xlarge | 192 | 96|  384 GiB | 50000 Megabit | EBS only | 7.344  | 5.5809 |

Data in table above is from the following:
<a href="https://calculator.aws/#/addService/ec2-enhancement?nc2=h_ql_pr_calc">Sizing and Price Calculator from AWS</a>


Run CMAQv5.4+ on a single Virtual Machine (VM) using an ami with software pre-loaded to run on a c6a.48xlarge instance with io2 filesystem.

```{toctree}
aws_cli_launch_vm.md
```
