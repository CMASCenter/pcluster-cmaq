# Create a Parallel Cluster and run CMAQv5.3.3

## Why might I need to use ParallelCluster? 

The AWS ParallelCluster may be configured to be the equivalent of a High Performance Computing (HPC) environment, including using job schedulers such as Slurm, running on multiple nodes using code compiled with Message Passing Interface (MPI), and reading and writing output to a high performance, low latency shared disk.  The advantage of using the AWS ParallelCluster command line interface is that the compute nodes can be easily scaled up or down to match the compute requirements of a given simulation. In addition, the user can reduce costs by using Spot instances rather than On-Demand for the compute nodes. ParallelCluster also supports submitting multiple jobs to the job submission queue.

Our goal is make this user guide to running CMAQ on a ParallelCluster as helpful and user-friendly as possible. Any feedback is both welcome and appreciated.


Additional information on AWS ParallelCluster:

<a href="https://docs.aws.amazon.com/parallelcluster/latest/ug/what-is-aws-parallelcluster.html">AWS ParallelCluster documentation</a>

<a href="https://www.youtube.com/watch?v=r4RxT-IMtFY">AWS ParallelCluster training video</a>


```{toctree}
./demo/index.md
./cmaq-cluster/index.md
./benchmark/index.md
```

