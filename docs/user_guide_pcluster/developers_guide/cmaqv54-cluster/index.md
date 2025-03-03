# Install CMAQv5.4 on ParallelCluster  (optional)

* Create the ParallelCluster with the base Ubutu OS using c7g.large head node and c7g.16xlarge as the compute node.
* Learn how to install CMAQ software and underlying libraries, copy input data, and run CMAQ.
```{admonition} Notice
:class: warning

Skip this tutorial if you do not want to learn how to install the CMAQv5.4 software and proceed to the post-processing and QA instructions.
Note, you may wish to build the underlying libraries and CMAQ and code if you wish to create a ParallelCluster using a different family of compute nodes, such as the c6gn.16xlarge compute nodes AMD Graviton.

```

```{toctree}
aws-pcluster_3.6.md
software-install-pcluster_v54_3.6.md
run-cmaq-benchmark-pcluster_v54_hpc7g.16xlarge.md
run-cmaq-benchmark-pcluster_v54_hpc7g.8xlarge.md
input-data-install_pcluster_v54.md
