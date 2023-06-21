# CMAQv5.4 on Single Virtual Machine Intermediate (software pre-installed)

Creating an EC2 instance from the Command Line is easy to do. In this tutorial we will give examples on how to create and run using ec2 instances that are vary in size depending on the size of the CMAQ benchmarks.

<a href="https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2.html">Using Amazon EC2 with the AWS CLI</a>

| Benchmark Name | Grid Domain | EC2 Instance| vCPU   |  Cores | Memory | Network Performance | Storage | On Demand Hourly Cost |
| -------------- | ----------- | ----------  | ------ | ---    |----    | ---------------       | ----  | -------------------   |
| Training 12km Listos | (25x25x35)   | c6a.large    | 2 | 1 | 4 GiB | 0Up to 12500 Megabit | EBS Only | .0765 |
| 12NE3                | (100x100x35) | c6a.xlarge   | 4 | 2 | 8 GiB | Up to 12500 Megabit  | EBS Only | 0.153  |
| 12US1                | (459x299x35) | c6a.48xlarge | 192 | 96|  384 GiB | 50000 Megabit | EBS only | 7.344  |

Data in table above is from the following:
<a href="https://calculator.aws/#/addService/ec2-enhancement?nc2=h_ql_pr_calc">Sizing and Price Calculator from AWS</a>


Review how to run CMAQv5.4+ on a single Virtual Machine (VM) using c6a.xlarge (4 CPUs) and Ubuntu 22.04.2 LTS (GNU/Linux 5.15.0-1031-aws x86_64), then use an ami with software pre-loaded to run on a c6a.48xlarge instance with gp3 or io1 filesystem.

```{toctree}
aws_cli_launch_vm.md
```
