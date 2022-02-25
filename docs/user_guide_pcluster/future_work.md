# List of ideas for future work

<b>AWS Parallel Cluster</b>

1. Create MVP yaml and software install scripts for intel compiler
2. Benchmark 2 day case using intel compiler version of CMAQ and compare to GCC timings
3. Repeat Benchmark Runs using c6gn.16xlarge compute nodes with 64vcpu or 32 cpu per node with hyperthreading turned off.
4. Save OS with R and R packages installed and EBS /shared volume with CMAQ sofware stack as an AMI that can be loaded to create a new Parallel Cluster. (requires frequent updates, security clean-ups, and maintenance)
5. Create script for installing all software and R packages as a custom bootstrap as the Parallel Cluster is created. 
6. Create method to automatically checkpoint and save a job prior to it being bumped from the schedule if running on spot instances.


<b>Azure Cycle Cloud</b>

1. Test creation of Cycle Cloud on new account to verify instructions for user account permission settings and cycle cloud options to login, build and run CMAQ.

