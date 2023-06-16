## Configurations for running CMAQ on AWS ParallelCluster

### Recommend that users set up a spending alarm using AWS 

Configure alarm to receive an email alert if you exceed $100 per month (or what ever monthly spending limit you need).

```{seealso}
See the AWS Tutorial on setting up an alarm for AWS Free Tier.
<a href="https://aws.amazon.com/getting-started/hands-on/control-your-costs-free-tier-budgets">AWS Free Tier Budgets</a>
```

## Software Requirements for CMAQ on AWS ParallelCluster

Tier 1: Native OS and associated system libraries, compilers

* Operating System: Ubuntu2004 
* Tcsh shell
* Git
* Compilers (C, C++, and Fortran) - GNU compilers version ≥ 8.3
* MPI (Message Passing Interface) -  OpenMPI ≥ 4.0
* Slurm Scheduler

Tier 2: additional libraries required for installing CMAQ 

* NetCDF (with C, C++, and Fortran support)
* I/O API
* R Software and packages

Tier 3: Software distributed thru the CMAS Center

* CMAQv533 
or 
* CMAQv5.4+

* CMAQv533 Post Processors 
or 
CMAQv5.4+ Post Processors

Tier 4: R packages and Scripts

* R QA Scripts

Software on Local Computer

* AWS CLI v3.0 installed in a virtual environment
* pcluster is the primary AWS ParallelCluster CLI command. You use pcluster to launch and manage HPC clusters in the AWS Cloud and to create and manage custom AMI images
* run-instances is another AWS Command Line method to create a single virtual machine to run CMAQ described in chapter 6.
* Edit YAML Configuration Files using vi, nedit or other editor (yaml does not accept tabs as spacing)
* Git
* Mac - XQuartz for X11 Display
* Windows - MobaXterm  - to connect to ParallelCluster IP address

### AWS CLI v3.0 AWS Region Availability


```{note}
The scripts in this tutorial use the us-east-1 region, but the scripts can be modified to use any of the supported regions listed in the url below.
<a href="https://docs.aws.amazon.com/parallelcluster/latest/ug/supported-regions-v3.html">CLI v3 Supported Regions</a>
```



### CONUS 12US2 Domain Description

```
GRIDDESC
'12US2'
'12CONUS'     -2412000.0 -1620000.0 12000.0 12000.0 396 246 1
```

![CMAQ 12US2 Domain](../../qa_plots/tileplots/CMAQ_ACONC_12US2_Benchmark_Tileplot.png)

### CONUS 12US1 Domain Description

```
GRIDDESC
'12US1'
'LAM_40N97W'  -2556000.   -1728000.   12000.  12000.  459  299    1
```
(need to create)
![CMAQ 12US1 Domain](../../qa_plots/tileplots/CMAQ_ACONC_12US1_Benchmark_Tileplot.png)

##  ParallelCluster Configuration for CONUS 12US2 Domain

```{note}
It is recommended to use a head node that is in the same family a the compute node so that the compiler options and executable is optimized for that processor type.
```

Recommended configuration of the ParallelCluster HPC head node and compute nodes to run the CMAQ CONUS benchmark for two days:

Head node:

* c5n.large

or

* c6a.xlarge

(note that head node should match the processor family of the compute nodes)

Compute Node:

* c5n.9xlarge (16 cpus/node with Multithreading disabled)
with 96 GiB memory, 50 Gbps Network Bandwidth, 9,500 EBS Bandwidth (Mbps) and Elastic Fabric Adapter (EFA)

or

* c5n.18xlarge  (36 cpus/node with Multithreading disabled)
with 192 GiB memory, 100 Gbps Network Bandwidth, 19,000 EBS Bandwidth (Mbps) and Elastic Fabric Adapter (EFA)

or

* c6a.48xlarge (96 cpus/node with Multithreading disabled)
with 384 GiB memory, 50 Gigabit Network Bandwidth, 40 EBS Bandwidth (Gbps), Elastic Fabric Adapter (EFA) and Nitro Hypervisor

```{note}
CMAQ is developed using OpenMPI and can take advantage of increasing the number of CPUs and memory. 
ParallelCluster provides a ready-made auto scaling solution.
```

```{note}
Additional best practice of allowing the ParallelCluster to create a placement group.
<a href="https://docs.aws.amazon.com/parallelcluster/latest/ug/best-practices-v3.html>Network Performance</a>
<a href="https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html>Placement Groups</a>
```

This is specified in the yaml file in the slurm queue's network settings.

```
Networking:
  PlacementGroup:
    Enabled: true
```


```{note}
To provide the lowest latency and the highest packet-per-second network performance for your placement group, choose an instance type that supports enhanced networking. For more information, see Enhanced Networking.
<a href="https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/enhanced-networking.html">Enhanced Networking (ENA)</a>
```

To measure the network performance, you can use iPerf to measure network bandwidth.

<a href="https://iperf.fr/">Iperf</a>

```{note}
Elastic Fabric Adapter(EFA)
"EFA provides lower and more consistent latency and higher throughput than the TCP transport traditionally used in cloud-based HPC systems. It enhances the performance of inter-instance communication that is critical for scaling HPC and machine learning applications. It is optimized to work on the existing AWS network infrastructure and it can scale depending on application requirements." "An EFA is an Elastic Network Adapter (ENA) with added capabilities. It provides all of the functionality of an ENA, with an additional OS-bypass functionality. OS-bypass is an access model that allows HPC and machine learning applications to communicate directly with the network interface hardware to provide low-latency, reliable transport functionality."
<a href="https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/efa.html">Elastic Fabric Adapter(EFA)</a>
```

```{note}
Nitro Hypervisor 
"AWS Nitro System is composed of three main components: Nitro cards, the Nitro security chip, and the Nitro hypervisor. Nitro cards provide controllers for the VPC data plane (network access), Amazon Elastic Block Store (Amazon EBS) access, instance storage (local NVMe), as well as overall coordination for the host. By offloading these capabilities to the Nitro cards, this removes the need to use host processor resources to implement these functions, as well as offering security benefits. "
<a href="https://aws.amazon.com/blogs/hpc/bare-metal-performance-with-the-aws-nitro-system/">Bare metal performance with the Nitro Hypervisor</a>
<a href="https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-types.html#ec2-nitro-instances">EC2 Nitro Instances Available</a>
```

Importing data from S3 Bucket to Lustre

Justification for using the capability of importing data from an S3 bucket to the lustre file system over using elastic block storage file system and copying the data from the S3 bucket for the input and output data storage volume on the cluster.

1. Saves storage cost
2. Removes need to copy data from S3 bucket to Lustre file system. FSx for Lustre integrates natively with Amazon S3, making it easy for you to process HPC data sets stored in Amazon S3
3. Simplifies running HPC workloads on AWS
4. Amazon FSx for Lustre uses parallel data transfer techniques to transfer data to and from S3 at up to hundreds of GB/s.

```{seealso}
<a href="https://www.amazonaws.cn/en/fsx/lustre/faqs/">Lustre FAQs</a>
<a href="https://docs.amazonaws.cn/en_us/fsx/latest/LustreGuide/performance.html">Lustre Performance Documentation</a>
```

```{note} To find the default settings for Lustre see:
<a href="https://docs.aws.amazon.com/parallelcluster/latest/ug/SharedStorage-v3.html#SharedStorage-v3-FsxLustreSettings">Lustre Settings for ParallelCluster</a>
```



Figure 1. AWS Recommended ParallelCluster Configuration (Number of compute nodes depends on setting for NPCOLxNPROW and #SBATCH --nodes=XX #SBATCH --ntasks-per-node=YY )

![AWS ParallelCluster Configuration](../../diagrams/aws_parallel_cluster.png)

