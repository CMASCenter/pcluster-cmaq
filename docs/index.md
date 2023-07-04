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

This document provides tutorials and information on how users can create High Performance Computers (Single Virtual Machine (VM) or ParallelCluster) on Amazon Web Service (AWS) using the AWS Web Interface or AWS Command Line Interface. The tutorials are aimed at users with cloud computing experience that are already familiar with Amazon Web Service (AWS).  For those with no cloud computing experience we recommend signing up for a free AWS Educate account, as it is open to any individual, regardless of where they are in their education, technical experience, or career journey. Learn, practice, and evaluate cloud skills in real time without creating an Amazon or AWS account. <a href="https://aws.amazon.com/education/awseducate/">AWS Educate</a>

 

## Format of this documentation

```
| ---> | System Requirements for Benchmarks
| ---> | Single VM
       | -----------> Configure VM using AWS Console using CMAQ AMI
       | -----------> Configure VM using AWS CLI using CMAQ AMI
| ---> | Building a Parallel Cluster (many VMs) using "CMAQ Snapshot"
| ---> | Developers Guide (How to install CMAQ software and libraries) 
requirement for Single VM with "Default Stock AMI" or ParallelCluster without "CMAQ Snapshot"
| ---> | Post-processing and saving to S3 Bucket
| ---> | Performance Cost and Optimization
| ---> | Additional Resources
| ---> | Future Work
| ---> | How to contribute to this work

```

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
