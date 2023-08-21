% pcluster-cmaq documentation master file, created by
%   sphinx-quickstart on Tue Jan 11 11:07:40 2022.
%   You can adapt this file completely to your liking, but it should at least
%   contain the root `toctree` directive.

# CMAQ on AWS Tutorial

```{warning}
This documentation is under continuous development
Previous version is available here: <a href="https://pcluster-cmaq.readthedocs.io/en/cmaqv5.3.3/">CMAQv5.3.3 on AWS Tutorial</a>
```

## Community Multiscale Air Quality Model 

The Community Multiscale Air Quality (CMAQ) modeling system an active open-source development project of the U.S. EPA.  The CMAQ system is a Linux-based suite of models that requires significant computational resources and specific system configurations to run. CMAQ combines current knowledge in atmospheric science and air quality modeling, multi-processor computing techniques, and an open-source framework to deliver fast, technically sound estimates of ozone, particulates, toxics and acid deposition. <br>

* For additional background on CMAQ please visit the <a href="http://www.epa.gov/CMAQ">U.S. EPA CMAQ Website</a>.
* CMAQ is a community modeling effort that is supported by the <a href="http://www.cmascenter.org">Community Modeling and Analysis System (CMAS) Center</a> at the University of North Caroline at Chapel Hill.

## Tutorial Overview

This document provides tutorials on how to use Amazon Web Service (AWS) <a href="https://aws.amazon.com/hpc/">high performance computing services</a>. AWS's Elastic Compute Cloud (EC2) allows you to create and run a single Linux virtual machine, or <b>Single VM</b>, in the cloud. Another AWS resource, <b> ParallelCluster</b>, is a cluster management tool that helps you to deploy and manage many VMs in the cloud. ParallelCluster is well suited for large modeling applications as it automatically sets up the required compute resources, scheduler, and shared file system. 

The following tutorials will walk you through running a CMAQ benchmark case on both a Single VM and on the more advanced ParallelCluster. A benchmark case is provided with pre-installed software allowing you to jump right into running CMAQ and post-processing model output for analysis and visualization.  The Developers Guide provided in Chapter 4 describes how to do the software installation process yourself in order to set up simulations tailored to your own applications.  

The tutorials are aimed at users with cloud computing experience that are already familiar with AWS.  For those with no cloud computing experience we recommend signing up for a free <a href="https://aws.amazon.com/education/awseducate/">AWS Educate account</a>, as it is open to any individual, regardless of where they are in their education, technical experience, or career journey. If you are a new user to AWS, you can sign up for a <a href="https://aws.amazon.com/free/">free tier account</a>. There are also low-cost tutorials available to learn Parallel Cluster from AWS: <a href="https://catalog.us-east-1.prod.workshops.aws/workshops/6735ed89-c2de-4180-904c-40ac9fba7419/en-US/intro">Parallel Cluster Tutorial</a> and <a href="https://workshops.aws/categories/HPC">AWS Workshops on HPC Computing</a>.

## User Support

Please share any issues or suggestions for running CMAQ on the Cloud to the CMAS User Forum, under the <a href="https://forum.cmascenter.org/t/about-the-cloud-computing-category/4285">Cloud Computing Category</a>. This forum is available for users and developers to discuss issues related to using the CMAQ system on the cloud. 

To submit edits to this documentation see instructions available in <a href="https://cyclecloud-cmaq.readthedocs.io/en/latest/user_guide_cyclecloud/contribute/contribute.html">Contribute to this Tutorial.</a>

## Table of Contents 

```{toctree}
   :numbered: 3
:caption: 'Contents:'
:maxdepth: 1

user_guide_pcluster/cmaq-vm/index.md
user_guide_pcluster/pcluster/index.md
user_guide_pcluster/Performance-Opt/index.md
user_guide_pcluster/developers_guide/index.md
user_guide_pcluster/post/index.md
user_guide_pcluster/logout/index.md
user_guide_pcluster/help/index.md
user_guide_pcluster/future/index.md
user_guide_pcluster/contribute/index.md
```
