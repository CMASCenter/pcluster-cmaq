# CMAQv5.4 on Single Virtual Machine Intermediate (software pre-installed)

Creating an EC2 instance from the Command Line is easy to do. In this tutorial we will give examples on how to create and run ec2 instances for different sized CMAQ benchmarks.

<a href="https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2.html">Using Amazon EC2 with the AWS CLI</a>

<table>
<tr>
<th>Size of Benchmark</th>   
<th>Size of EC2 instance</th>
</tr>
<tr>
<td>12Listos (25x25x35)</td>
<td>12NE3    (100x100x35)</td>
<td>12US1   </td> 
</tr>
<tr>
<td>c6a.xlarge (4 CPUs)</td>
<td>c6a.48xlarge</td>
<td>c6a.48xlarge</td>
</tr>
</table>

Review how to run CMAQv5.4+ on a single Virtual Machine (VM) using c6a.xlarge (4 CPUs) and Ubuntu 22.04.2 LTS (GNU/Linux 5.15.0-1031-aws x86_64), then use an ami with software pre-loaded to run on a c6a.48xlarge instance with gp3 or io1 filesystem.

```{toctree}
aws_cli_launch_vm.md
```
