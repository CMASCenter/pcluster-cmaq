# Run CMAQv5.4 on Single VM 
Using VM that was created using either the Web Console or the CLI

CMAQv5.4 Benchmarks

| Benchmark Name | Grid Domain | EC2 Instance| vCPU   |  Cores | Memory | Network Performance | Storage (EBS Only) | On Demand Hourly Cost | Spot Hourly Cost |
| -------------- | ----------- | ----------  | ------ | ---    |----    | ---------------       | ----  | -------------------   | -------------    |
| Training 12km Listos | (25x25x35)   | c6a.2xlarge    | 8 | 4 | 16 GiB | Up to 12500 Megabit | gp3 | 0.306 | 0.2879 |
| 12NE3                | (100x100x35) | c6a.8xlarge   | 32  | 16 | 64 GiB | 12500 Megabit  | gp3 | 1.224  | 1.0008 |
| 12US1                | (459x299x35) | c6a.48xlarge | 192 | 96|  384 GiB | 50000 Megabit  | gp3 | 7.344  | 5.5809 |

Data in table above is from the following:
<a href="https://calculator.aws/#/addService/ec2-enhancement?nc2=h_ql_pr_calc">Sizing and Price Calculator from AWS</a>

Run CMAQv5.4+ on a single Virtual Machine (VM) using an ami with software pre-loaded to run on either a c6a.2xlarge, c6a.8xlarge or c6a.48xlarge instance with gp3 filesystem.

```{toctree}
run_cmaq_c6a.2xlarge.md
run_cmaq_c6a.8xlarge.md
run_cmaq_c6a.48xlarge.md
```

