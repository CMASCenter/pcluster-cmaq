### logout of cluster when you are done

`exit`

### Delete Cluster

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



