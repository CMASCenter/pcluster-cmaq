### Logout of cluster when you are done

To avoid incurring costs for the lustre file system and the c5n.xlarge compute node, it is best to delete the cluster after you have copied the output data to the S3 Bucket.

If you are logged into the Parallel Cluster then use the following command

`exit`

### Delete Cluster

Run the following command on your local computer.

`pcluster delete-cluster --region=us-east-1 --cluster-name cmaq`

### Verify that the cluster was deleted

`pcluster describe-cluster --region=us-east-1 --cluster-name cmaq`

Output:

```
"lastUpdatedTime": "2022-02-25T20:17:19.263Z",
  "region": "us-east-1",
  "clusterStatus": "DELETE_IN_PROGRESS"
```


Verify that you see the following output

`pcluster describe-cluster --region=us-east-1 --cluster-name cmaq`

Output:

```
pcluster describe-cluster --region=us-east-1 --cluster-name cmaq
{
  "message": "Cluster 'cmaq' does not exist or belongs to an incompatible ParallelCluster major version."
}
```



