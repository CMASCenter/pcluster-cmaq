# Scripts and code to configure an AWS Parallel Cluster for CMAQ
The goal is to demonstrate how to create a parallel cluster, modify or update the cluster, and run CMAQv533 for two days on the CONUS2 domain obtaining input data from an S3 Bucket and saving the output to the S3 Bucket.

Note: The scripts have been set up to run on the AWS Parallel Cluster that has both a /shared ebs file system, and a /fsx lustre file system.  It is possible to also test the install scripts on a local machine prior to running on the AWS Parallel Cluster.  This will require modification the path that is used to install/build the libraries, CMAQ and the CONUS input data.  These paths may need to be changed in your .cshrc, install scripts, build scripts, run scripts etc.  Compiler GCC 8+ or higher and openmpi 4+ are required.

## Obtain code from github.

`git clone -b main https://github.com/lizadams/pcluster-cmaq.git pcluster-cmaq`

## Install AWS CLI
### Follow the instructions for configuring the Parallel Cluster v3.0 command line that uses yaml files for configuring the pcluster.
<a href="https://docs.aws.amazon.com/parallelcluster/latest/ug/parallelcluster-version-3.html">Instructions for Installing Parallel Cluster CLI v3.0</a>

### Another workshop to learn the AWS CLI 3.0
<a href="https://hpc.news/pc3workshop">Workshop on learning AWS CLI 3.0</a>

### Youtube video
<a href="https://www.youtube.com/watch?v=a-99esKLcls">Youtube video on AWS CLI 3.0</a>

