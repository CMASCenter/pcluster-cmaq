# CMAQv5.3.3 Advanced Tutorial (optional)

* Learn how to upgrade the ParallelCluster, by first creating a cluster that uses c5n.4xlarge as the compute nodes, and then upgrading the cluster to use c5n.18xlarge as the compute nodes.
* Learn how to install CMAQ software and underlying libraries, copy input data, and run CMAQ.
```{admonition} Notice
:class: warning

Skip this tutorial if you successfully completed the Intermediate Tutorial and wish to proceed to the post-processing and QA instructions.
Note, you may wish to build the underlying libraries and CMAQ and code if you wish to create a ParallelCluster using a different family of compute nodes, such as the c6gn.16xlarge compute nodes AMD Graviton.

```

```{toctree}
aws-pcluster-cluster.md
input-data-install_pcluster.md
software-install-pcluster.md
run-cmaq-benchmark-pcluster.md
```
