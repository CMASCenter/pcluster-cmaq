% pcluster-cmaq documentation master file, created by
%   sphinx-quickstart on Tue Jan 11 11:07:40 2022.
%   You can adapt this file completely to your liking, but it should at least
%   contain the root `toctree` directive.

```{include} ../README.md
:relative-images:
```
```{warning}
This documentation is under continuous development
```

## Overview

This document provides tutorials and information on how users can create High Performance Computers (Single Virtual Machine (VM) or ParallelCluster) on Amazon Web Service (AWS) using the AWS Command Line Interface. The tutorials are aimed at users with cloud computing experience that are already familiar with Amazon Web Service (AWS).  For those with no cloud computing experience we recommend reviewing the Additional Resources listed in [chapter 16](user_guide_pcluster/help/index.md) of this document.

 

## Format of this documentation

This document provides several hands-on tutorials that are designed to be read in order.  

<br>

### Single VM Tutorials
The Single VM Tutorial will show you how to create a single virtual machine using an AMI that has the software and data pre-loaded and give instructions for creating the virtual machine using ec2 instances that have different number of cores, and are matched to the benchmark domain. 

### Parallel Cluster Tutorials
The CMAQv5.4 Parallel Cluster Intermediate Chapter will show you how to run a CMAQv5.4 benchmarks on ParallelCluster using pre-loaded software and input data.  

### Developer Guide
Install CMAQv5.4 software and libraries on Single VM and create custom environment modules.
Install CMAQv5.4 software and libraries on Parallel Cluster.

<br>
The remaining sections provide instructions on post-processing CMAQ output, comparing output and runtimes from multiple simulations, and copying output from ParallelCluster to an AWS Simple Storage Service (S3) bucket.</br>

 

## Why might I need to use ParallelCluster? 

The AWS ParallelCluster may be configured to be the equivalent of a High Performance Computing (HPC) environment, including using job schedulers such as Slurm, running on multiple nodes using code compiled with Message Passing Interface (MPI), and reading and writing output to a high performance, low latency shared disk.  The advantage of using the AWS ParallelCluster command line interface is that the compute nodes can be easily scaled up or down to match the compute requirements of a given simulation. In addition, the user can reduce costs by using Spot instances rather than On-Demand for the compute nodes. ParallelCluster also supports submitting multiple jobs to the job submission queue.

Our goal is make this user guide to running CMAQ on a ParallelCluster as helpful and user-friendly as possible. Any feedback is both welcome and appreciated.
 

Additional information on AWS ParallelCluster:

<a href="https://docs.aws.amazon.com/parallelcluster/latest/ug/what-is-aws-parallelcluster.html">AWS ParallelCluster documentation</a>

<a href="https://www.youtube.com/watch?v=r4RxT-IMtFY">AWS ParallelCluster training video</a>


```{toctree}
   :numbered: 3
:caption: 'Contents:'
:maxdepth: 2

user_guide_pcluster/System-Req/index.md
user_guide_pcluster/cmaq-vm/index.md
user_guide_pcluster/pcluster/index.md
user_guide_pcluster/developers_guide/index.md
user_guide_pcluster/post/index.md
user_guide_pcluster/qa/index.md
user_guide_pcluster/timing/index.md
user_guide_pcluster/output/index.md
user_guide_pcluster/logout/index.md
user_guide_pcluster/Performance-Opt/index.md
user_guide_pcluster/help/index.md
user_guide_pcluster/future/index.md
user_guide_pcluster/contribute/index.md
```
