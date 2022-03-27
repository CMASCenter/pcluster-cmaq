# Use Elastic Fabric Adapter/Elastic Network Adapter for better performance

In order to make the most of the available network bandwidth, you need to be using the latest Elastic Network Adapter (ENA) drivers (available in the latest Amazon Linux, Red Hat 7.6, and Ubuntu AMIs, and in the upstream Linux kernel) and you need to make use of multiple traffic flows. Flows within a Placement Group can reach 10 Gbps; the rest can reach 5 Gbps. When using multiple flows on the high-end instances, you can transfer 100 Gbps between EC2 instances in the same region (within or across AZs), S3 buckets, and AWS services such as Amazon Relational Database Service (RDS), Amazon ElastiCache, and Amazon EMR.

from the following link

<a href="https://aws.amazon.com/blogs/aws/new-c5n-instances-with-100-gbps-networking/">C5n Instances</a>


<a href="https://aws.amazon.com/hpc/faqs/">Elastic Fabric Adapter for HPC systems</a>

EFA is currently available on c5n.18xlarge, c5n.metal, i3en.24xlarge, i3en.metal, inf1.24xlarge, m5dn.24xlarge, m5n.24xlarge, r5dn.24xlarge, r5n.24xlarge, p3dn.24xlarge, p4d, m6i.32xlarge, m6i.metal, c6i.32xlarge, c6i.metal, r6i.32xlarge, and r6i.metal instances.

What are the differences between an EFA ENI and an ENA ENI?

An ENA ENI provides traditional IP networking features necessary to support VPC networking. An EFA ENI provides all the functionality of an ENA ENI, plus hardware support for applications to communicate directly with the EFA ENI without involving the instance kernel (OS-bypass communication) using an extended programming interface. Due to the advanced capabilities of the EFA ENI, EFA ENIs can only be attached at launch or to stopped instances.

Q: What are the pre-requisites to enabling EFA on an instance?

EFA support can be enabled either at the launch of the instance or added to a stopped instance. EFA devices cannot be attached to a running instance.

<a href"https://aws.amazon.com/blogs/aws/now-available-elastic-fabric-adapter-efa-for-tightly-coupled-hpc-workloads/"</Elastic Fabric Adapter for Tightly Coupled Workloads"</a>

An EFA can still handle IP traffic, but also supports an important access model commonly called OS bypass. This model allows the application (most commonly through some user-space middleware) access the network interface without having to get the operating system involved with each message. Doing so reduces overhead and allows the application to run more efficiently. Here’s what this looks like (source):


The MPI Implementation and libfabric layers of this cake play crucial roles:

MPI – Short for Message Passing Interface, MPI is a long-established communication protocol that is designed to support parallel programming. It provides functions that allow processes running on a tightly-coupled set of computers to communicate in a language-independent way.

libfabric – This library fits in between several different types of network fabric providers (including EFA) and higher-level libraries such as MPI. EFA supports the standard RDM (reliable datagram) and DGRM (unreliable datagram) endpoint types; to learn more, check out the libfabric Programmer’s Manual. EFA also supports a new protocol that we call Scalable Reliable Datagram; this protocol was designed to work within the AWS network and is implemented as part of our Nitro chip.

Working together, these two layers (and others that can be slotted in instead of MPI), allow you to bring your existing HPC code to AWS and run it with little or no change.

You can use EFA today on c5n.18xlarge and p3dn.24xlarge instances in all AWS regions where those instances are available. The instances can use EFA to communicate within a VPC subnet, and the security group must have ingress and egress rules that allow all traffic within the security group to flow. Each instance can have a single EFA, which can be attached when an instance is started or while it is stopped.

You will also need the following software components:

EFA Kernel Module – The EFA Driver is in the Amazon GitHub repo; read Getting Started with EFA to learn how to create an EFA-enabled AMI for Amazon Linux, Amazon Linux 2, and other popular Linux distributions.

Libfabric Network Stack – You will need to use an AWS-custom version for now; again, the Getting Started document contains installation information. We are working to get our changes into the next release (1.8) of libfabric.

Note the parallel cluster deplopyment takes care of setting this up for you.


What I am not sure of, is the relationship between ENA/EFA and VPCs, and created ENIs.


