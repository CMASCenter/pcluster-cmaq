% pcluster-cmaq documentation master file, created by
%   sphinx-quickstart on Tue Jan 11 11:07:40 2022.
%   You can adapt this file completely to your liking, but it should at least
%   contain the root `toctree` directive.

# CMAQ on AWS Tutorials

```{warning}
This documentation is under continuous development
Previous version is available here: <a href="https://pcluster-cmaq.readthedocs.io/en/cmaqv5.3.3/">CMAQv5.3.3 on AWS Tutorial</a>
```

## Community Multiscale Air Quality Model (CMAQ)

CMAQ is a Linux-based suite of models that requires significant computational resources and specific system configurations to run. CMAQ combines current knowledge in atmospheric science and air quality modeling, multi-processor computing techniques, and an open-source framework to deliver fast, technically sound estimates of ozone, particulates, toxics and acid deposition. <br>
For additional background on CMAQ please visit: <a href="http://www.epa.gov/CMAQ">U.S. EPA CMAQ Website</a> <br>
CMAQ is a community modeling effort that is supported by the <a href="http://www.cmascenter.org">CMAS Center</a> <br>

## Tutorial Overview

This document provides tutorials and information on how users can create High Performance Computers on Amazon Web Services (AWS). The tutorials will walk you through running a CMAQ benchmark case on a single virtual machine (VM) and on the AWS ParallelCluster which uses many VMs. The benchmark case is provided with pre-installed software allowing you to jump right into running CMAQ and post-processing model output for analysis and visualization.  The Developers Guide Chapter (Chapter 4) describes how to do the software installation process yourself in order to set up simulations tailored to your own applications.  The tutorials are aimed at users with cloud computing experience that are already familiar with AWS.  For those with no cloud computing experience we recommend signing up for a free <a href="https://aws.amazon.com/education/awseducate/">AWS Educate account</a>, as it is open to any individual, regardless of where they are in their education, technical experience, or career journey. There are also low-cost tutorials available to learn Parallel Cluster from AWS: <a href="https://catalog.us-east-1.prod.workshops.aws/workshops/6735ed89-c2de-4180-904c-40ac9fba7419/en-US/intro">Parallel Cluster Tutorial</a> and <a href="https://workshops.aws/categories/HPC">AWS Workshops on HPC Computing</a>.

## User Support

Please share any issues or suggestions for running CMAQ on the Cloud to the CMAS User Forum, under the Cloud Computing Category. <a href="https://forum.cmascenter.org/t/about-the-cloud-computing-category/4285">Cloud Computing Category on CMAS User Forum</a> This forum is available for users and developers to discuss issues related to using the CMAQ system on the cloud. 

To submit edits to this documentation see instructions available in <a href="https://cyclecloud-cmaq.readthedocs.io/en/latest/user_guide_cyclecloud/contribute/contribute.html">Contribute to this Tutorial</a>


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
