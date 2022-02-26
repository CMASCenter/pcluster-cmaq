# List of ideas for future work

<b>AWS Parallel Cluster</b>

1. Create MVP yaml and software install scripts for intel compiler
2. Benchmark 2 day case using intel compiler version of CMAQ and compare to GCC timings
3. Repeat Benchmark Runs using c6gn.16xlarge compute nodes AMD Graviton and compare to Azure Cycle Cloud HBV3 compute nodes.
4. Save OS with R and R packages installed and EBS /shared volume with CMAQ sofware stack as an AMI that can be loaded to create a new Parallel Cluster. (requires frequent updates, security clean-ups, and maintenance). Create both the OS and /shared volumes as unencrypted using the YAML file, then save the AMI, then make it public. Be sure not to store the AWS Credentials on the AMI before saving it.
5. Create script for installing all software and R packages as a custom bootstrap as the Parallel Cluster is created. 
6. Create method to automatically checkpoint and save a job prior to it being bumped from the schedule if running on spot instances.
7. Set up an additional slurm queue that uses a smaller compute node to do the post-processing and learn how to submit the post processing jobs to this queue, rather than running them on the head node.


<b>Azure Cycle Cloud</b>

1. Test creation of Cycle Cloud on new account to verify instructions for user account permission settings and cycle cloud options to login, build and run CMAQ.

<b>Documentation</b>

1. Finalize documentation and implement a version for the documentation in github.  Read-the-docs will automatically use the version information in the documentation.
2. Learn how to submit the post-processig jobs to the HTC rather than the HPC queue.


