```{note}
Additional best practice of allowing the ParallelCluster to create a placement group.
<a href="https://docs.aws.amazon.com/parallelcluster/latest/ug/best-practices-v3.html">Network Performance</a>
<a href="https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html">Placement Groups</a>
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


