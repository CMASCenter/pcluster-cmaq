# Use Elastic Fabric Adapter/Elastic Network Adapter for better performance

In order to make the most of the available network bandwidth, you need to be using the latest Elastic Network Adapter (ENA) drivers (available in the latest Amazon Linux, Red Hat 7.6, and Ubuntu AMIs, and in the upstream Linux kernel) and you need to make use of multiple traffic flows. Flows within a Placement Group can reach 10 Gbps; the rest can reach 5 Gbps. When using multiple flows on the high-end instances, you can transfer 100 Gbps between EC2 instances in the same region (within or across AZs), S3 buckets, and AWS services such as Amazon Relational Database Service (RDS), Amazon ElastiCache, and Amazon EMR.

from the following link

<a href="https://aws.amazon.com/blogs/aws/new-c5n-instances-with-100-gbps-networking/">C5n Instances</a>


<a href="https://aws.amazon.com/hpc/faqs/">Elastic Fabric Adapter for HPC systems</a>

EFA is currently available on c5n.18xlarge, c5n.metal, i3en.24xlarge, i3en.metal, inf1.24xlarge, m5dn.24xlarge, m5n.24xlarge, r5dn.24xlarge, r5n.24xlarge, p3dn.24xlarge, p4d, m6i.32xlarge, m6i.metal, c6i.32xlarge, c6i.metal, r6i.32xlarge, and r6i.metal instances.
