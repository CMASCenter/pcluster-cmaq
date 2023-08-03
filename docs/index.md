% pcluster-cmaq documentation master file, created by
%   sphinx-quickstart on Tue Jan 11 11:07:40 2022.
%   You can adapt this file completely to your liking, but it should at least
%   contain the root `toctree` directive.

# CMAQ on AWS Tutorials

```{warning}
This documentation is under continuous development
Previous version is available here: <a href="https://pcluster-cmaq.readthedocs.io/en/cmaqv5.3.3/">CMAQv5.3.3 on AWS Tutorial</a>
```

## Overview

This document provides tutorials and information on how users can create High Performance Computers on Amazon Web Services (AWS). The tutorials will walk you through running a CMAQ benchmark case on a single virtual machine (VM) and on the AWS ParallelCluster which uses many VMs. The benchmark case is provided with pre-installed software allowing you to jump right into running CMAQ and post-processing model output for analysis and visualization.  The Developers Guide Chapter (Chapter 6) describes how to do the software installation process yourself in order to set up simulations tailored to your own applications.  The tutorials are aimed at users with cloud computing experience that are already familiar with AWS.  For those with no cloud computing experience we recommend signing up for a free <a href="https://aws.amazon.com/education/awseducate/">AWS Educate account</a>, as it is open to any individual, regardless of where they are in their education, technical experience, or career journey. There are also low-cost tutorials available to learn Parallel Cluster from AWS: <a href="https://catalog.us-east-1.prod.workshops.aws/workshops/6735ed89-c2de-4180-904c-40ac9fba7419/en-US/intro">Parallel Cluster Tutorial</a> and <a href="https://workshops.aws/categories/HPC">AWS Workshops on HPC Computing</a>.

```{toctree}
   :numbered: 3
:caption: 'Contents:'
:maxdepth: 2

user_guide_pcluster/System-Req/index.md
user_guide_pcluster/cmaq-vm/index.md
user_guide_pcluster/run-vm/index.md
user_guide_pcluster/pcluster/index.md
user_guide_pcluster/Performance-Opt/index.md
user_guide_pcluster/developers_guide/index.md
user_guide_pcluster/post/index.md
user_guide_pcluster/logout/index.md
user_guide_pcluster/help/index.md
user_guide_pcluster/future/index.md
user_guide_pcluster/contribute/index.md
```
