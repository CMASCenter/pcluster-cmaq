## Parallel Cluster Update

1. not all settings in the yaml file can be updated 
2. it is important to know what the policy is for each setting

Example Update policy: 

If this setting is changed, the update is not allowed.
After changing this setting, the cluster can't be updated. 
Either the change must be reverted or the cluster must be deleted (using pcluster delete-cluster), and then a new cluster created (using pcluster create-cluster) in the old cluster's place.

see more information

<a href="https://docs.aws.amazon.com/parallelcluster/latest/ug/using-pcluster-update-cluster-v3.html#update-policy-fail-v3">Parallel Cluster Update Policy"</a>
