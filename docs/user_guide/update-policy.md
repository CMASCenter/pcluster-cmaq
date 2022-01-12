## Parallel Cluster Update Policy

1. determine whether you can update the parallel cluster if a setting is modified.

Example:
Update policy: If this setting is changed, the update is not allowed.
After changing this setting, the cluster can't be updated. 
Either the change must be reverted or the cluster must be deleted (using pcluster delete-cluster), and then a new cluster created (using pcluster create-cluster) in the old cluster's place.

see more information

<a href="https://docs.aws.amazon.com/parallelcluster/latest/ug/using-pcluster-update-cluster-v3.html#update-policy-fail-v3">Parallel Cluster Update Policy"</a>
