# Resources from AWS for diagnosing issues with running the Parallel Cluster

1. <a href="https://github.com/aws/aws-parallelcluster">Github for AWS Parallel Cluster</a>
2. <a href="https://docs.aws.amazon.com/parallelcluster/latest/ug/what-is-aws-parallelcluster.html">User Guide</a>
3. <a href="https://docs.aws.amazon.com/parallelcluster/latest/ug/getting_started.html">Getting Started Guide</a>
4. <a href="https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html">Guide to obtaining AWS Key Pair</a>
5. <a href="https://aws.amazon.com/fsx/lustre/faqs/">Lustre FAQ</a>
6. <a href="https://aws.amazon.com/hpc/faqs/#AWS_ParallelCluster">Parallel Cluster FAQ</a> (somewhat outdated..)
7. <a href="https://docs.aws.amazon.com/parallelcluster/latest/ug/pcluster3-config-converter.html">Tool to convert v2 config files to v3 yaml files for Parallel Cluster</a>
8. <a href="https://github.com/aws-samples/parallelcluster-spot-fsxlustre">Instructions for creating a fault tolerance parallel cluster using lustre filesystem</a>
9. <a href="https://repost.aws/tags/TAjBvP4otfT3eX8PswbXo9AQ">AWS HPC discussion forum</a>


## Issues

For AWS Parallel Cluster you can create a GitHub issue for feedback or issues: <a href="https://github.com/aws/aws-parallelcluster/issues">Github Issues</a>
There is also an active community driven Q&A site that may be helpful: <a href="https://repost.aws/">AWS re:Post a community-driven Q&A site</a>

## Tips to managing the parallel cluster

1. The head node can be stopped from the AWS Console after stopping compute nodes of the cluster, as long as it is restarted before issuing the command to restart the cluster.
2. The pcluster slurm queue system will create and delete the compute nodes, so that helps reduce manual cleanup for the cluster.
3. The compute nodes are terminated after they have been idle for a period of time. The yaml setting used for this is as follows: SlurmSettings: ScaledownIdletime: 5
4. The default idle time is 10 minutes, and can be reduced by specifing a shorter idle time in the YAML file.  It is important to verify that the are deleted after a job is finished, to avoid incurring unexpected costs.
5. copy/backup the outputs and logs to an s3 bucket for follow-up analysis
6. After copying output and log files to the s3 bucket the cluster can be deleted
7. Once the pcluster is deleted all of the volumes, head node, and compute node will be terminated, and costs will only be incurred by the S3 Bucket storage.
