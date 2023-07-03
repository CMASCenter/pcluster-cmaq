# Future Work

<b>AWS ParallelCluster</b>

* Create yaml and software install scripts for intel compiler
* Benchmark 2 day case using intel compiler version of CMAQ and compare to GCC timings
* Repeat Benchmark Runs using c6gn.16xlarge compute nodes AMD Graviton and compare to Azure Cycle Cloud HBV3 compute nodes.
* Create script for installing all software and R packages as a custom bootstrap as the ParallelCluster is created. 
* Create method to automatically checkpoint and save a job prior to it being bumped from the schedule if running on spot instances.
* Set up an additional slurm queue that uses a smaller compute node to do the post-processing and learn how to submit the post processing jobs to this queue, rather than running them on the head node.
* Install software using SPACK
* Install netCDF-4 compressed version of I/O API Library and set up environment module to compile and run CMAQ for 2018_12US1 data that is nc4 compressed

<b>Documentation</b>

* Create instructions on how to create a ParallelCluster using encrypted ebs volume and snapshot. 


