Performance Optimization

## ParallelCluster Configuration

Selection of the compute nodes depends on the domain size and resolution for the CMAQ case, and what your model run time requirements are.
Larger hardware and memory configurations may also be required for instrumented versions of CMAQ incuding CMAQ-ISAM and CMAQ-DDM3D.
The ParallelCluster allows you to run the compute nodes only as long as the job requires, and you can also update the compute nodes as needed for your domain.

### An explanation of why a scaling analysis is required for Multinode or Parallel MPI Codes

Quote from the following link.

"IMPORTANT: The optimal value of --nodes and --ntasks for a parallel code must be determined empirically by conducting a scaling analysis. As these quantities increase, the parallel efficiency tends to decrease. The parallel efficiency is the serial execution time divided by the product of the parallel execution time and the number of tasks. If multiple nodes are used then in most cases one should try to use all of the CPU-cores on each node."

```{note}
For the scaling analysis that was performed with CMAQ, the parallel efficiency was determined as the runtime for the smallest number of CPUs divided by the product of the parallel execution time and the number of additional cpus used. If smallest NPCOLxNPROW configuration was 18 cpus, the run time for that case was used, and then the parallel efficiency for the case where 36 cpus were used would be parallel efficiency = runtime_18cpu/(runtime_36cpu*2)*100
```

```{seealso}
<a href="https://researchcomputing.princeton.edu/support/knowledge-base/scaling-analysis">Scaling Analysis - see section on Multinode or Parallel MPI Codes</a>

<a href="https://researchcomputing.princeton.edu/support/knowledge-base/slurm#multinode">Example Slurm script for Multinode Runs</a>
```

## Slurm Compute Node Provisioning

AWS ParallelCluster relies on SLURM to make the job allocation and scaling decisions. The jobs are launched, terminated, and resources maintained according to the Slurm instructions in the CMAQ run script. The YAML file for Parallel Cluster is used to set the identity of the head node and the compute node, and the maximum number of compute nodes that can be submitted to the queue. The head node can't be updated after a cluster is created. The compute nodes, and the maximum number of compute nodes can be updated after a cluster is created. 

Number of compute nodes dispatched by the slurm scheduler is specified in the run script using #SBATCH --nodes=XX #SBATCH --ntasks-per-node=YY where the maximum value of tasks per node or YY limited by many CPUs are on the compute node.

Resources specified in the YAML file: 

* Ubuntu2004 
* Disable Simultaneous Multi-threading
* Spot Pricing 
* Shared EBS filesystem to install software

* 1.2 TiB Shared Lustre file system with imported S3 Bucket (1.2 TiB is the minimum file size that you can specify for Lustre File System) mounted as /fsx <b>or</b> EBS volume 500 GB size mounted as /shared/data

* Slurm Placement Group enabled
* Elastic Fabric Adapter Enabled

```{seealso}
<a href="https://aws.amazon.com/ec2/instance-types/c5/">EC2 Instance Types</a>
```

```{note}
Pricing information in the tables below are subject to change. The links from which this pricing data was collected are listed below.
```

```{seealso}
<a href="https://aws.amazon.com/ec2/spot/pricing/">EC2 SPOT Pricing</a>
```

```{seealso}
<a href="https://aws.amazon.com/ec2/pricing/on-demand">EC2 On-Demand Pricing</a>
```

```{seealso}
<a href="https://docs.aws.amazon.com/parallelcluster/latest/ug/spot.html">Working with Spot Instances - ParallelCluster</a>
```

## Spot versus On-Demand Pricing

Table 1. EC2 Instance On-Demand versus Spot Pricing (price is subject to change)

| Instance Name	| vCPUs |  RAM      |  EBS Bandwidth	| Network Bandwidth | Linux On-Demand Price | Linux Spot Price | 
| ------------  | ----- | --------  | ---------------   | ---------------   | --------------------  | ---------------  |
| c4.large	| 2	| 3.75 GiB  |   Moderate	|  500 Mbps         | 	$0.116/hour         | $0.0312/hour     |
| c4.8xlarge	| 36	| 60 GiB    |	10 Gbps	        |  4,000 Mbps       | 	$1.856/hour         | $0.5903/hour     |
| c5n.large	| 2	| 5.25 GiB  |	Up to 3.5 Gbps	| Up to 25 Gbps     |   $0.108/hour         | $0.0324/hour     |
| c5n.xlarge	| 4	| 10.5 GiB  |	Up to 3.5 Gbps	| Up to 25 Gbps     |   $0.216/hour         | $0.0648/hour     |
| c5n.2xlarge	| 8	| 21 GiB    |	Up to 3.5 Gbps	| Up to 25 Gbps     |   $0.432/hour         | $0.1740/hour     |
| c5n.4xlarge	| 16	| 42 GiB    | 	3.5 Gbps	| Up to 25 Gbps     |   $0.864/hour         | $0.2860/hour     |
| c5n.9xlarge	| 36	| 96 GiB    |	7 Gbps	        | 50 Gbps           |   $1.944/hour         | $0.5971/hour     |
| c5n.18xlarge	| 72	| 192 GiB   |	14 Gbps	        | 100 Gbps          |   $3.888/hour         | $1.1732/hour     |
| c6gn.16xlarge | 64	| 128 GiB   |                   |  100 Gbps         |   $2.7648/hour        | $0.6385/hour     |	
| c6a.48xlarge  | 192   | 384 GiB   |   40 Gbps         |  50 Gpbs          |   $7.344/hour         | $6.0793/hour     |
| hpc6a.48xlarge| 96    | 384 GiB   |                   | 100 Gbps          |   $2.88/hour          |  unavailable     |
| hpc7g.8xlarge | 32    | 128 GiB   |                   |                   |   $1.6832/hour        |  unavailable     |
| hpc7g.16xlarge| 64    | 128 GiB   |                   |                   |   $1.6832/hour        |  unavailable     |

*Hpc6a instances have simultaneous multi-threading disabled to optimize for HPC codes. This means that unlike other EC2 instances, Hpc6a vCPUs are physical cores, not threads.

*Hpc6a instances available in US East (Ohio) and GovCloud (US-West)

*HPC6a is available ondemand only (no spot pricing)

*hpc7g instances have simultaneous multi-threading disabled to optimize for HPC codes. The instances with fewer cores, 16, 32 pes are custom to only those instances, you are not sharing a slice of an instance (this also removes the need for pinning).

<a href="https://aws.amazon.com/blogs/hpc/application-deep-dive-into-the-graviton3e-based-amazon-ec2-hpc7g-instance/">hpc7g offers 16, 32 or 64 physical cpu instance size at launch</a>

```{note}
Sometimes, the nodes are not available for SPOT pricing in the region you are using. 
If this is the case, the job will not start runnning in the queue, see AWS Troubleshooting. 
<a href="https://docs.aws.amazon.com/parallelcluster/latest/ug/troubleshooting.html">ParallelCluster Troubleshooting</a>
```


## Benchmark Timings for CMAQv5.4 12US1 Benchmark 

### Benchmark Timing for c6a.48xlarge

Table 6. Timing Results for CMAQv5.4 2 Day 12US1 Run on Parallel Cluster with c6a.xlarge head node and c6a.48xlarge Compute Nodes with Disable Simultaneous Multithreading turned on (using physical cores, not vcpus) 

| CPUs | NodesxCPU | COLROW | Day1 Timing (sec) | Day2 Timing (sec) | TotalTime | CPU Hours/day InputData   |    InputData | Equation using Spot Pricing | SpotCost | Equation using On Demand Pricing | OnDemandCost |
| ---- | ------    | ---   |  -------------     | ------------      | --------- | ------------------------  | ----------   | ------------------------------ | ----     | ------------------------------  |  ------  |
| 96   | 1x96 | 12x8    |           3153.2      |  3485.9          | 6639.10    | 1.844                     |    /fsx         |  $5.5809/hr * 1 node * 1.844 = | 10.29 | 7.34/hr * 1 node * 1.844 = | 13.53 |
| 192     | 2x96 | 16x12   |  1853.4     | 2035.1           |  3888.50  | 1.08      | /fsx            | $5.5809/hr * 2 node * 1.08 = | 12.05 | 7.34/hr * 2 node * 1.08 = | 15.85  |
| 288     | 3x96 | 16x18 | 1475.9      |  1580.7          | 3056.60   | .849        |  /fsx           |  5.5809/hr * 3 node * .849 = | 14.21  | 7.34/hr * 3 node * .849 = | 18.6 |


### Benchmark Timing for hpc7g.8xlarge with 32 processors per node

Table 7. Timing Results for CMAQv5.4 2 Day 12US1 Run on Parallel Cluster with c7g.large head node and hpc7g.8xlarge Compute Nodes with 32 processors per node.

| CPUs | NodesxCPU | COLROW | Day1 Timing (sec) | Day2 Timing (sec) | TotalTime | CPU Hours/day |  InputData   |    Equation using On Demand Pricing | OnDemandCost |
| ---- | ------    | ----   | ------------     | -------------      | --------- | ------------  | ------------ | -------------------------------- |    -- |
| 32     | 1x32 | 4x8    |  6933.3      |  6830.2         | 13763.50   | 3.82      |  yes          |   N/A  |  no    | yes        |    /fsx         |  n/a   | n/a | 1.6832/hr * 1 node * 3.82 = | 6.435 |
| 64     | 2x32 | 8x8   |  3080.9     |  3383.5     | 6464.40  | 1.795        | /fsx            | 1.6832/hr * 2 node * 1.795 = | 6.044  |
| 96     | 3x32 | 12x8   |  2144.2     |  2361.9     | 4506.10  | 1.252       | /fsx            | 1.6832/hr * 3 node * 1.252 = | 6.32  |
| 128    | 4x32 | 16x8   |  1696.6     |  1875.7     | 3572.30  | .992        | /fsx            | 1.6832/hr * 4 node * .992 = | 6..678  |


### Benchmark Timing for hpc7g.16xlarge with 64 processors per node

Table 8. Timing Results for CMAQv5.4 2 Day 12US1 Run on Parallel Cluster with c7g.large head node and hpc7g.16xlarge Compute Nodes with 64 processors per node.

| CPUs | NodesxCPU | COLROW | Day1 Timing (sec) | Day2 Timing (sec) | TotalTime | CPU Hours/day |  InputData   |    Equation using On Demand Pricing | OnDemandCost |
| ---- | ---       | ----   | -------------     | ------------    | --------- |  -----------    | ------------ | -------------------------------- | --- |
| 64   | 1x64      | 8x8    |  crash            |  crash          | crash     |  n/a            |    /fsx      | 1.6832/hr * 1 node * n/a = | n/a |
| 128       | 2x64 | 8x16   |  2074.2           | 2298.9          | 4373.10   | 1.215           |    /fsx      | 1.6832/hr * 2 node * 1.214 = | 4.089  |
| 192       | 3x64 | 12x16  | 1617.1            | 1755.3          | 3372.40   | .937            | /fsx/        | 1.6832/hr * 3 node * .937  = | 4.730  |
| 256       | 4x64 | 16x16  | 1347.3            | 1501.4          | 2848.70   | .7913           | /fsx/        | 1.6832/hr * 4 node * .7913  = | 5.327  |
| 320       | 5x64 | 16x20  | 1177.0            | 1266.6          | 2443.60   | .6788           | /fsx/        | 1.6832/hr * 5 node * .6788  = | 5.713  |



# Benchmark Scaling Plots for CMAQv5.4 12US1 Benchmark

## Benchmark Scaling Plot for c6a.48xlarge

Figure 1. Scaling per Node on c6a.48xlarge Compute Nodes (96 cores/node)

![Scaling per Node for c6a.48xlarge Compute Nodes (36cpu/node](../../qa_plots/scaling_plots/c6a.48xlarge_Scaling_Node.png)


```
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=96
```

 
Figure 2. Scaling per CPU on hpc7g.8xlarge compute node (32 cores/node)

![Scaling per CPU for hpc7g.8xlarge Compute Nodes (32cores/node](../../qa_plots/timing_plots/HPC7gpes_32_64.png)



Figure 3.  Scaling per Node on hpc7g.16xlarge Compute Nodes (64 cores/node)

![Scaling per Node for hpc7g.16xlarge Compute Nodes (32cores/node](../../qa_plots/timing_plots/HPC7g.18xlargepes_64_128.png)


## Total Time and Cost versus CPU Plot for hpc7g.8xlarge 

Figure 4. Plot of Total Time and On Demand Cost varies as additional CPUs are used. Note that the run script and yaml settings used for the c5n.9xlarge used settings that were optimized for running CMAQ on the cluster.


Figure 5. Plot of Total Time and On Demand Cost versus CPUs for c6a.48xlarge

![Plot of Total Time and On Demand Cost versus CPUs for c6a.48xlarge](../../qa_plots/scaling_plots/6a48xlarge_Time_CPUs.png)


# Cost Information 

Cost information is available within the AWS Web Console for your account as you use resources, and there are also ways to forecast your costs using the pricing information available from AWS.

### Cost Explorer

Example screenshots of the AWS Cost Explorer Graphs were obtained after running several of the CMAQ Benchmarks, varying # nodes and # cpus and NPCOL/NPROW.  These costs are of a two day session of running CMAQ on the ParallelCluster, and should only be used to understand the relative cost of the EC2 instances (head node and compute nodes), compared to the storage, and network costs.

In Figure 10 The Cost Explorer Display shows the cost of different EC2 Instance Types: note that c5n.18xlarge is highest cost - as these are used as the compute nodes

Figure 10. Cost by Instance Type - AWS Console 

![AWS Cost Management Console - Cost by Instance Type](../../qa_plots/cost_plots/AWS_Bench_Cost.png)

In Figure 11 The Cost Explorer displays a graph of the cost categorized by usage by spot or OnDemand, NatGateway, or Timed Storage. Note: spot-c5n.18xlarge is highest generating cost resource, but other resources such as storage on the EBS volume and the network NatGatway or SubnetIDs also incur costs

Figure 11. Cost by Usage Type - AWS Console 

![AWS Cost Management Console - Cost by Usage Type](../../qa_plots/cost_plots/AWS_Bench_Usage_Type_Cost.png)

In Figure 12. The Cost Explorer Display shows the cost by Services including EC2 Instances, S3 Buckets, and FSx Lustre File Systems

Figure 12. Cost by Service Type - AWS Console

![AWS Cost Management Console - Cost by Service Type](../../qa_plots/cost_plots/AWS_Bench_Service_Type_Cost.png)


### Compute Node Cost Estimate

Head node c5n.large compute cost = entire time that the parallel cluster is running ( creation to deletion) = 6 hours * $0.0324/hr = $ .1944 using spot pricing, 6 hours * $.108/hr = $.648 using on demand pricing.

Using 288 cpus on the ParallelCluster, it would take ~4.83 days to run a full year, using 8 c5n.18xlarge (36cpu/node) compute nodes.

Using 288 cpus on the ParallelCluster, it would take ~ 6.37 days to run a full year using 2 hpc6a.48xlarge (96cpu/node) compute nodes.

Using 126 cpus  on the ParallelCluster, it would take ~8.92 days to run a full year, using 7 c5n.9xlarge (18cpu/node) compute nodes.

Table 8. Extrapolated Cost of compute nodes used for CMAQv5.3.3 Annual Simulation based on 2 day CONUS benchmark

| Benchmark Case | Compute Node | Number of PES |  Number of Nodes | Pricing    |   Cost per node | Time to completion (hour)   | Equation Extrapolate Cost for Annual Simulation | Annual Cost                | Days to Complete Annual Simulation | 
| -------------  | --------     |------------  |  --------------- | -------    |  -------------- | ------------------          |  ------------------------------------------- | ----    |  -------------------------------    |
| 2 day 12US2 |  c5n.18xlarge | 108         |           3       |    SPOT   |    1.1732/hour  |    4550.72/3600 = 1.264   |   1.264/2 * 365 = 231 hours/node * 3 nodes = 692 hr * $1.1732/hr = | $811.9 | 9.61   | 
| 2 day 12US2    |  c5n.18xlarge | 108         |           3       |  ONDEMAND   |    3.888/hour  |    4550.72/3600 = 1.264   |   1.264/2 * 365 = 231 hours/node * 3 nodes = 692 hr * $3.888/hr = | $2690.4 | 9.61   |
| 2 day 12US2    |  c5n.18xlarge | 180          |          5       |    SPOT    |    1.1732/hour |     2980.19/3600 = .8278  |    .8278/2 * 365 = 151 hours/node * 5 nodes = 755 hr * $1.1732/hr = | $886 |   6.29  |
| 2 day 12US2    |  c5n.18xlarge | 180          |          5       |  ONDEMAND  |    3.888/hour   |     2980.19/3600 = .8278  |    .8278/2 * 365 = 151 hours/node * 5 nodes = 755 hr * $3.888/hr = | $2935.44 | 6.29 |
| 2 day 12US2    |  c5n.9xlarge  | 126          |          7       |    SPOT    |   .5971/hour    |    4042.71/3600 = 1.12      |    1.12/2 * 365 = 204.94 hours/node * 7 nodes = 1434.6 hr * $.5971/hr = | $856| 8.52 |
| 2 day 12US2    |  c5n.9xlarge  | 126          |          7       |  ONDEMAND    |   1.944/hour    |    4042.71/3600 = 1.12      |    1.12/2 * 365 = 204.94 hours/node * 7 nodes = 1434.6 hr * $1.944/hr = | $2788.8 | 8.52 |
| 2 day 12US2    | hpc6a.48xlarge | 96         |          1       |  ONDEMAND    |   $2.88/hour    |   5033.93/3600 = 1.40      |  1.40/2 * 365 = 255 hours/node * 1 nodes = 255 hr * $2.88/hr = | $734 | 10.6 |
| 2 day 12US2    | hpc6a.48xlarge | 192         |         2       |  ONDEMAND    |   $2.88/hour    |   3023.81/3600 = .839      |  .839/2 * 365 = 153.29 hours/node * 2 nodes = 306 hr * $2.88/hr = | $883 | 6.4 |
| 2 day 12US1    | hpc7g.16xlarge | 64          |         2       |  ONDEMAND    |   $1.6832/hour  |   4574.00/3600 = 1.27      |  1.27/2 * 365 = 231.87 hours/node * 2 nodes = 463.75 hr * $1.6832/hr = | $780 | 9.6 |
| 2 day 12US1    | hpc7g.16xlarge | 64          |         3       |  ONDEMAND    |   $1.6832/hour  |   3509.80/3600 = .9749      |  .9749/2 * 365 = 177.9 hours/node * 3 nodes = 533.75 hr * $1.6832/hr = | $898 | 7.4 |

```{note}
These cost estimates depend on the availability of number of nodes for the instance type. If fewer nodes are available, then it will take longer to complete the annual run, but the costs should be accurate, as the CONUS 12US2 Domain Benchmark scales well up to this number of nodes. The cost of running an annual simulation on 3 c5n.18xlarge nodes using OnDemand Pricing is $2690.4, the cost of running an annual simulation on 5 c5n.18xlarge nodes using OnDemand pricing is $2935.44, if only 3 nodes are available, then you would pay less, but wait longer for the run to be completed, 9.61 days using 3 nodes versus 6.29 days using 5 nodes.
```

### Storage Cost Estimate

```{seealso}
<a href="https://aws.amazon.com/fsx/lustre/pricing/">AWS Lustre Pricing</a>
```


Table 9. Lustre SSD File System Pricing for us-east-1 region

| Storage Type | Storage options   | 	Pricing with data compression enabled*	| Pricing (monthly)  |
| --------     | ----------------  |   ------------------------------------    | -----------------  |
| Persistent   | 125 MB/s/TB       | 	$0.073                                  |	$0.145/month |
| Persistent   | 250 MB/s/TB       | 	$0.105                                  |	$0.210/month |
| Persistent   | 500 MB/s/TB       | 	$0.170                                  | 	$0.340/month |
| Persistent   | 1,000 MB/s/TB     |   $0.300                                  | 	$0.600/month | 
| Scratch      | 200/MB/s/TiB      |    $0.070 	                               |        $0.140/month |	

Note, there is a difference in the storage sizing units that were obtained from AWS. 

```{seealso}
<a href="https://www.techtarget.com/searchstorage/definition/tebibyte-TiB#:~:text=Tebibyte%20vs.&text=One%20tebibyte%20is%20equal%20to,when%20talking%20about%20storage%20capacity">TB vs TiB</a>
```

Quote from the above website;
"One tebibyte is equal to 2^40 or 1,099,511,627,776 bytes. 
One terabyte is equal to 1012 or 1,000,000,000,000 bytes. 
A tebibyte equals nearly 1.1 TB. 
That's about a 10% difference between the size of a tebibyte and a terabyte, which is significant when talking about storage capacity."

Lustre Scratch SSD 200 MB/s/TiB is tier of the storage pricing that we have configured in the yaml for the cmaq parallel cluster.

```{seealso}
<a href="https://docs.aws.amazon.com/parallelcluster/latest/ug/SharedStorage-v3.html#SharedStorage-v3-FsxLustreSettings">YAML FSxLustreSettings</a>
```

Cost example:
    0.14 USD per month / 730 hours in a month = 0.00019178 USD per hour

Note: 1.2 TiB is the minimum file size that you can specify for the lustre file system

    1,200 GiB x 0.00019178 USD per hour x 24 hours x 5 days = 27.6 USD

Question is 1.2 TiB enough for the output of a yearly CMAQ run?

For the output data, assuming 2 day CONUS Run, all 35 layers, all 244 variables in CONC output

```
cd /fsx/data/output/output_CCTM_v532_gcc_2016_CONUS_16x8pe_full
du -sh
```

Size of output directory when CMAQ is run to output all 35 layers, all 244 variables in the CONC file, includes all other output files

```
173G .
```

So we need 86.5 GB per day

Storage requirement for an annual simulation if you assumed you would keep all data on lustre filesystem

     86.5 GB * 365 days = 31,572.5 GB  = 31.5 TB


### Annual simulation local storage cost estimate

Assuming it takes 5 days to complete the annual simulation, and after the annual simulation is completed, the data is moved to archive storage.

     31,572.5 GB x 0.00019178 USD per hour x 24 hours x 5 days = $726.5 USD


To reduce storage requirements; after the CMAQ run is completed for each month, the post-processing scripts are run and completed, and then the CMAQ Output data for that month is moved from the Lustre Filesystem to the Archived Storage. Monthly data volume storage requirements to store 1 month of data on the lustre file system is approximately 86.5 x 30 days = 2,595 GB or 2.6 TB.  

      2,595 GB x 0.00019178 USD per hour x 24 hours x 5 days = $60 USD


Estimate for S3 Bucket cost for storing an annual simulation

```{seealso}
<a href="https://aws.amazon.com/s3/pricing/?p=pm&c=s3&z=4">S3 Storage Pricing Tiers</a>
```

| S3 Standard - General purpose storage |    Storage Pricing  |
| ------------------------------------  |    --------------   |
| First 50 TB / Month                   |     $0.023 per GB   |
| Next 450 TB / Month                   |     $0.022 per GB   |
| Over 500 TB / Month                   |     $0.021 per GB   |


### Archive Storage cost estimate for annual simulation - assuming you want to save it for 1 year

31.5 TB * 1024 GB/TB * .023 per GB * 12 months  = $8,903

| S3 Glacier Flexible Retrieval (Formerly S3 Glacier) |    Storage Pricing |
| --------------------------------------------------  |    --------------  |
| long-term archives with retrieval option from 1 minute to 12 hours|      |	
| All Storage / Month| 	$0.0036 per GB   |

S3 Glacier Flexible Retrieval Costs 6.4 times less than the S3 Standard

31.5 TB * 1024 GB/TB * $.0036 per GB * 12 months  = $1393.0 USD

Lower cost option is S3 Glacier Deep Archive (accessed once or twice a year, and restored in 12 hours)

31.5 TB * 1024 GB/TB * $.00099 per GB * 12 months  = $383 USD


# Recommended Workflow for extending to annual run

Post-process monthly save output and/or post-processed outputs to S3 Bucket at the end of each month.

Still need to determine size of post-processed output (combine output, etc).

      86.5 GB * 31 days = 2,681.5 GB * 1 TB/1024 GB =  2.62 TB

Cost for lustre storage of a monthly simulation

      2,681.5 GB x 0.00019178 USD per hour x 24 hours x 5 days = $61.7 USD

Goal is to develop a reproducable workflow that does the post processing after every month, and then copies what is required to the S3 Bucket, so that only 1 month of output is imported at a time to the lustre scratch file system from the S3 bucket.
This workflow will help with preserving the data in case the cluster or scratch file system gets pre-empted.

