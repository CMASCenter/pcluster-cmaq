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

```
| Landing Page
|
| ---> | Single VM
       | -----------> Configure VM using AWS Console using CMAQ AMI
       | -----------> Configure VM using AWS CLI using CMAQ AMI
|
| ---> | Building a Parallel Cluster (many VMs) using "CMAQ Snapshot"
| ---> | Developers Guide (How to install all the CMAQ software and libraries from scratch -- requirement if you want to use a Single VM or ParallelCluster uinsg "Default Stock AMI".)
| ---> | Performance Cost and Optimization
| ---> | Additional Resources
| ---> | Future Work
| ---> | How to contribute to this work

<br>

### Single VM Tutorials
The Single VM Tutorial will show you how to create a single virtual machine using an AMI that has the software and data pre-loaded and give instructions for creating the virtual machine using ec2 instances that have different number of cores, and are matched to the benchmark domain. 

### Parallel Cluster Tutorials
The CMAQv Parallel Cluster Intermediate Chapter will show you how to create a Parallel Cluster and run CMAQ benchmarks using pre-loaded software and input data. 

### Developer Guide
Install CMAQ software and libraries on Single VM and create custom environment modules.
Install CMAQ software and libraries on Parallel Cluster.

### Performance Cost and Optimization

### Post-processing and clean-up 

Instructions on post-processing CMAQ output, comparing output and runtimes from multiple simulations, and copying output from ParallelCluster to an AWS Simple Storage Service (S3) bucket.

### Additional Resources 

### How to contribute to this work


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
