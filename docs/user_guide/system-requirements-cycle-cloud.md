## System Requirements for Cycle Cloud

### Please set up a alarm on Azure 
Set alarm to receive an email alert if you exceed $100 per month (or what ever monthly spending limit you need).
It may be possible to set up daily or weekly spending alarms as well.

### Software Requirements

* Git
* Compilers (C, C++, and Fortran) - GNU compilers version ≥ 9.2
* MPI (Message Passing Interface) -  OpenMPI ≥ 4.1.0
* NetCDF (with C, C++, and Fortran support)
* I/O API
* Slurm Scheduler

### Hardware Requirements

#### Recommended Minimum Requirements

The size of hardware depends on the domain size and resolution for  your CMAQ case, and how quickly your turn-around requirements are.
Larger hardware and memory configurations are also required for instrumented versions of CMAQ incuding CMAQ-ISAM and CMAQ-DDM3D.


#### Recommended Cycle Cloud Configuration for CONUS Domain

Scheduler node:

* D12v2

Compute Node for HTC Queue:

* F2sV2

Compute Node for HPC Queue:

*  HBv3-120 instance running Centos7 

<a href="https://docs.microsoft.com/en-us/azure/virtual-machines/workloads/hpc/hbv3-series-overview#software-specifications">HBv3-series Software Specification</a>

448 GB of RAM, and no hyperthreading with 350 GB/sec of memory bandwidth, up to 32 MB of L3 cache per core, up to 7 GB/s of block device SSD performance, and clock frequencies up to 3.675 GHz.

Figure 1. Cycle Cloud Recommended Cluster Configuration (Number of compute nodes depends on setting for NPCOLxNPROW and #SBATCH --nodes=XX #SBATCH --ntasks-per-node=YY )

![Azure Minimum Viable Product Configuration](../diagrams/azure_minimum_viable_product.png)

#### Azure CycleCloud does not make job allocation or scaling decisions. It simple tries to launch, terminate, and maintain resources according to Slurm’s instructions.

Number of compute nodes dispatched by the slurm scheduler is specified in the run script using #SBATCH --nodes=XX #SBATCH --ntasks-per-node=YY where the maximum value of tasks per node or YY limited by many CPUs are on the compute node.  

For HBv3-120, there are 120 CPUs, so maximum value of YY is 120 or --ntask-per-node=120.  

If running a job with 180 processors, this would require the --nodes=XX or XX to be set to 2 compute nodes, as 90x2=180.  

The setting for NPCOLxNPROW must also be a maximum of 180, ie. 18 x 10 or 10 x 18 to use all of the CPUs in the parallel cluster.


<a href="https://docs.microsoft.com/en-us/azure/virtual-machines/hbv3-series">HBv3-120 instance </a>


Software: 

* Centos7
* Spot or OnDemand Pricing 
* /shared/build volume install software from git repo
* 1. TB Shared file system 
* Slurm Placement Group enabled
* Elastic Fabric Adapter Enabled on HBv3-120


<a href="https://azure.com/e/a5d6f8654d634e8b93973574cbda428d">Azure HBv3-120 Pricing</a>



Table 1. Azure Instance On-Demand versus Spot Pricing (price is subject to change)

| Instance Name	| CPUs |  RAM      |  Memory Bandwidth	| Network Bandwidth | Linux On-Demand Price | Linux Spot Price | 
| ------------  | ----- | --------  | ---------------   | ---------------   | --------------------  | ---------------  |
| HBv3-120	| 120	|  448 GiB   |	 350 Gbps	        | 200 Gbps(Infiniband)          |   $3.6/hour         | $?/hour     |


Table 2. Timing Results for CMAQv5.3.3 2 Day CONUS2 Run on Cycle Cloud with ? head node and HBv3-120 Compute Nodes

| Number of PEs | #Nodesx#CPU | NPCOLxNPROW | Day1 Timing (sec) | Day2 Timing (sec) | Total Time(2days)(sec) | SBATCH --exclusive | Data Imported or Copied | DisableSimultaneousMultithreading| Answers Matched | Cost using Spot Pricing | Cost using On Demand Pricing | compiler flag | 
| ------------- | -----------    | -----------   | ----------------     | ---------------      | -------------------        | ------------------ | --------------          | ---------                              |   -------- | --------- | ------ | ---------------      |
| 90           |   1x90     |    9x10            |   3153.33            |  2758.12             |   5911.45                  |  no                | copied                  |  false                                              | ?hr * 2 nodes * 1.642 hr = $?             |  3.6/hr * 1 nodes * 1.642 hr = $ $5.911           |  without -march=native compiler flag |
| 120          |   1x120    |    10x12           | 2829.84              |  2516.07             |   5345.91                  |  no                | copied                  |  false                                 |            |  ?hr * 2 nodes * 1.484 hr = $?            | 3.6/hr * 1 nodes * 1.484 hr = $5.34                     | without -march=native compiler flag            |
| 180           |  2x90          | 10x18         | 2097.37              | 1809.84              |    3907.21                 |  no                | copied                  |  false                                 |            | ?hr * 2 nodes * 1.307 hr = $? | 3.6/hr * 2 nodes * 1.08 hr = $7.81 | with -march=native compiler flag |
| 180          |   2x90     |    10 x 18         | 1954.20              | 1773.86              |    3728.06                 |  no                | copied                  |  false                                 |             | ?hr * 2 nodes * 1.036 hr = $? | 3.6/hr * 2 nodes * 1.036 hr = $7.46 | without -march=native compiler flag |
| 240          |   2x120    |   20x12            |  1856.50             | 1667.68                     |    3524.18                |  no                | copied                  |  false                            |             |   ?hr * 2 nodes * .97 hr = $?           |  3.6/hr * 2 nodes * .97 hr = $6.984   | without -march=native compiler flag |  
| 270           |  3x90          | 15x18         | 1703.19              | 1494.17              |    3197.36                 |  no                | copied                  |  false                   |  | ?/hr * 3 nodes * .888 = $? | 3.6/hr * 3 nodes * .888 = $9.59  | with -march=native compiler flag |
| 360           |  3x120     |  20x18             | 1520.29              |  1375.54             |    2895.83                 |  no                | copied                  |  false                  |   | ?/hr * 4 nodes * .804 = $? | 3.6/hr * 3 nodes * .804 = $8.687 | with -march=native compiler flag | 

Total HBv3-120 compute cost of Running Benchmarking Suite using SPOT pricing = $?

Figure 2. Cost by Instance Type - update for Azure 

![Azure Cost Management Console - Cost by Instance Type](../qa_plots/cost_plots/Azure_Bench_Cost.png)


Figure 3. Cost by Usage Type - Azure Console

![Azure Cost Management Console - Cost by Usage Type](../qa_plots/cost_plots/Azure_Bench_Usage_Type_Cost.png)

Figure 4. Cost by Service Type - Azure Console

![Azure Cost Management Console - Cost by Service Type](../qa_plots/cost_plots/Azure_Bench_Service_Type_Cost.png)

Head node ? compute cost = entire time that the parallel cluster is running ( creation to deletion) = 6 hours * $0.0324/hr = $ .1944 using spot pricing, 6 hours * $.108/hr = $.648 using on demand pricing.

Total HBv3-120 cost of Running Benchmarking Suite using ONDEMAND pricing = $?


Using 270 cpus on the Cycle Cloud Cluster, it would take ~4.832 days to run a full year, using 3 HBv3-120 compute nodes.

Table 3. Extrapolated Cost of HBv3-120 used for CMAQv5.3.3 Annual Simulation based on 2 day CONUS benchmark

| Benchmark Case | Number of PES |  Number of HBv3-120 Nodes | Pricing    |   Cost per node | Time to completion (hour)   | Extrapolate Cost for Annual Simulation                 |  
| -------------  | ------------  |  --------------- | -------    |  -------------- | ------------------          |  --------------------------------------------------    |
| 2 day CONUS    |  270          |          3       |    SPOT    |    ?/hour |     3197.36/3600 = .8881  |    .8881/2 * 365 = 162 hours/node * 3 nodes = 486 * $? = $? |
| 2 day CONUS    |  270          |          3       |  ONDEMAND  |    3.6/hour   | 3197.36/3600 = .8881  |    .8881/2 * 365 = 162 hours/node * 3 nodes = 486 * $3.6 = $1,750 |



<a href="https://docs.microsoft.com/en-us/azure/virtual-machines/disks-shared">Azure SSD Disk Pricing</a>


Table 4. Shared SSD File System Pricing (need to update for Azure - this is lustre pricing.

| Storage Type | Storage options   | 	Pricing with data compression enabled*	| Pricing (monthly)  |  Pricing (hourly) |
| --------     | ----------------  |   ------------------------------------    | -----------------  |  ---------------  |
| Persistant   | 125 MB/s/TB       | 	$0.073                                  |	$0.145/month |                   |
| Persistant   | 250 MB/s/TB       | 	$0.105                                  |	$0.210/month |                   |
| Persistant   | 500 MB/s/TB       | 	$0.170                                  | 	$0.340/month |                   |
| Persistant   | 1,000 MB/s/TB     |   $0.300                                  | 	$0.600/month | .0008333/hour     | 
| Scratch      | 200/MB/s/TiB      |    $0.070 	                               |        $0.140/month | 0.000192/hour     |	

Q. What is the difference between TiB and TB (I obtained the syntax from the AWS Pricing Table see link above)

Scratch SSD 200 MB/s/TB is tier of the storage pricing that we have configured in the yaml for the cmaq parallel cluster.

<a href="https://docs.aws.amazon.com/parallelcluster/latest/ug/SharedStorage-v3.html#SharedStorage-v3-FsxLustreSettings">FSxLustreSettings</a>

Cost example:
    0.14 USD per month / 730 hours in a month = 0.00019178 USD per hour

Note: 1.2 TB is the minimum file size that you can specify for the lustre file system

    1,200 GB x 0.00019178 USD per hour x 24 hours x 5 days = 27.6 USD

Question is 1.2 TB enough for the output of a yearly CMAQ run?

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


Cost for annual simulation

     31,572.5 GB x 0.00019178 USD per hour x 24 hours x 5 days = $726.5 USD


Table 5. Extrapolated Cost of Lustre File system for CMAQv5.3.3 Annual Simulation based on 2 day CONUS benchmark

Need to create table


Also need estimate for S3 Bucket cost for storing an annual simulation


### Recommended Workflow

Post-process monthly save output and/or post-processed outputs to S3 Bucket at the end of each month.

Still need to determine size of post-processed output (combine output, etc).

      86.5 GB * 31 days = 2,681.5 GB  =  2.6815 TB

Cost for lustre storage of a monthly simulation

      2,681.5 GB x 0.00019178 USD per hour x 24 hours x 5 days = $61.7 USD

Goal is to develop a reproducable workflow that does the post processing after every month, and then copies what is required to the S3 Bucket, so that only 1 month of output is stored at a time on the lustre scratch file system.
This workflow will help with preserving the data in case the cluster or scratch file system gets pre-empted.

