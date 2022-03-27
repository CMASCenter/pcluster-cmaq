## FAQ

Q. Can you update a cluster with a Snapshot ID, ie. update a cluster to use the /shared/build pre-installed software.

A. No. An existing cluster can not be updated with a Snapshot ID, solution is to delete the cluster and re-create it. see error:

`pcluster update-cluster --region us-east-1 --cluster-name cmaq --cluster-configuration c5n-18xlarge.ebs_unencrypted.fsx_import.yaml`

Output:

```

{
  "message": "Update failure",
  "updateValidationErrors": [
    {
      "parameter": "SharedStorage[ebs-shared].EbsSettings.SnapshotId",
      "requestedValue": "snap-065979e115804972e",
      "message": "Update actions are not currently supported for the 'SnapshotId' parameter. Remove the parameter 'SnapshotId'. If you need this change, please consider creating a new cluster instead of updating the existing one."
    }
  ],
  "changeSet": [
    {
      "parameter": "SharedStorage[ebs-shared].EbsSettings.SnapshotId",
      "requestedValue": "snap-065979e115804972e"
    }
  ]
}
```

Q. How do you figure out why a job isn't successfully running in the slurm queue

A. Check the logs available in the following link

<a href="https://docs.aws.amazon.com/parallelcluster/latest/ug/troubleshooting.html">Pcluster Troubleshooting</a>

`vi /var/log/parallelcluster/slurm_resume.log`

Output:

```
2022-03-23 21:04:23,600 - [slurm_plugin.instance_manager:_launch_ec2_instances] - ERROR - Failed RunInstances request: 0c6422af-c300-4fe6-b942-2b7923f7b362
2022-03-23 21:04:23,600 - [slurm_plugin.instance_manager:add_instances_for_nodes] - ERROR - Encountered exception when launching instances for nodes (x3) ['queue1-dy-compute-resource-1-4', 'queue1-dy-compute-resource-1-5', 'queue1-dy-compute-resource-1-6']: An error occurred (InsufficientInstanceCapacity) when calling the RunInstances operation (reached max retries: 1): We currently do not have sufficient c5n.18xlarge capacity in the Availability Zone you requested (us-east-1a). Our system will be working on provisioning additional capacity. You can currently get c5n.18xlarge capacity by not specifying an Availability Zone in your request or choosing us-east-1b, us-east-1c, us-east-1d, us-east-1f.
```

Q. How do I determine what node(s) the job is running on?

A. echo $SLURM_JOB_NODELIST

<a href="https://hpcc.umd.edu/hpcc/help/slurmenv.html">Slurm Environment Variables</a>

Q. If I find an issue, or need help with this CMAQ Parallel Cluster Tutorial what do I do?

A. Please file an issue using github.

https://github.com/lizadams/pcluster-cmaq/issues

Please indicate the issue you are having, and include a link from the read the doc section that you are referring to.



