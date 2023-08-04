# Create a Parallel Cluster and run CMAQv5.4

Why might I need to use ParallelCluster? 

The AWS ParallelCluster may be configured to be the equivalent of a High Performance Computing (HPC) environment, including using job schedulers such as Slurm, running on multiple nodes using code compiled with Message Passing Interface (MPI), and reading and writing output to a high performance, low latency shared disk.  The advantage of using the AWS ParallelCluster command line interface is that the compute nodes can be easily scaled up or down to match the compute requirements of a given simulation. HPC compute nodes such as hpc6a or hpc7g are available in a limited set of regions at significantly discounted pricing (60% below on demand costs). Users can also attempt to reduce costs by using Spot instances rather than On-Demand for the compute nodes. ParallelCluster also supports submitting multiple jobs to the job submission queue.

Our goal is make this user guide to running CMAQ on a ParallelCluster as helpful and user-friendly as possible. Any feedback is both welcome and appreciated.


```{toctree}
demo-cluster.md
aws-pcluster_v54_preloaded.md
run-cmaq-benchmark-pcluster_v54.md
aws-pcluster_v54_preloaded_hpc7g.16xlarge.md
run-cmaq-benchmark-pcluster_v54.hpc7g.16xlarge.md
```
