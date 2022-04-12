# Future Work

<b>AWS Parallel Cluster</b>

* Create yaml and software install scripts for intel compiler
* Benchmark 2 day case using intel compiler version of CMAQ and compare to GCC timings
* Repeat Benchmark Runs using c6gn.16xlarge compute nodes AMD Graviton and compare to Azure Cycle Cloud HBV3 compute nodes.
* Save OS with R and R packages installed and EBS /shared volume with CMAQ sofware stack as an AMI that can be loaded to create a new Parallel Cluster. (requires frequent updates, security clean-ups, and maintenance). Create both the OS and /shared volumes as unencrypted using the YAML file, then save the AMI, then make it public. Be sure not to store the AWS Credentials on the AMI before saving it.
* Create script for installing all software and R packages as a custom bootstrap as the Parallel Cluster is created. 
* Create method to automatically checkpoint and save a job prior to it being bumped from the schedule if running on spot instances.
* Set up an additional slurm queue that uses a smaller compute node to do the post-processing and learn how to submit the post processing jobs to this queue, rather than running them on the head node.

<b>Documentation</b>

* Create instructions on how to create a parallel cluster using encrypted ebs volume and snapshot. 


