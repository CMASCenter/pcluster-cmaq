## VPC Management

There is a limit on the number of VPCs that are allowed per account - limit is 5.

What is the difference between a private and a public vpc? (what setting is used in the yaml file, and why is one preferred over the other?)

Note, there is a default VPC, that is used to create EC2 instances, that should not be deleted.

Q1. is there a separate default VPC for each region?

Q2. Each time you run a configure cluster command, does the Parallel Cluster create a new VPC?

Q3. Why don't the VPC and subnet IDs get deleted when the Parallel Clusters are deleted?


### Deleting VPCs
If pcluster configure created a new VPC, you can delete that VPC by deleting the AWS CloudFormation stack it created. The name will start with "parallelclusternetworking-" and contain the creation time in a "YYYYMMDDHHMMSS" format. You can list the stacks using the list-stacks command.
The following instructions are available here: 

<a href="https://docs.aws.amazon.com/parallelcluster/latest/ug/install-v3-configuring.html">Instructions for Cleaning Up VPCs</a>

```
$ aws --region us-east-2 cloudformation list-stacks \
   --stack-status-filter "CREATE_COMPLETE" \
   --query "StackSummaries[].StackName" | \
   grep -e "parallelclusternetworking-""parallelclusternetworking-pubpriv-20191029205804"
```

The stack can be deleted using the delete-stack command.

```
$ aws --region us-west-2 cloudformation delete-stack \
   --stack-name parallelclusternetworking-pubpriv-20191029205804
```

If pcluster configure created a new VPC, you can delete that VPC by deleting the AWS CloudFormation stack it created. 
The name will start with "parallelclusternetworking-" and contain the creation time in a "YYYYMMDDHHMMSS" format. You can list the stacks using the list-stacks command.

<a href="https://docs.aws.amazon.com/parallelcluster/latest/ug/pcluster.configure.html">Pcluster Configure</a>

Note: I can see why you wouldn't want to delete the VPC, if you want to reuse the yaml file that contains the SubnetID that is tied to that VPC.

I was able to use the Amazon Website to find the SubnetID, and then identify the VPC that it is part of.

I currently have the following VPCs


| Name | VPC ID | State | IPv4 CIDR |  IPv6 CIDR (Network border group) | IPv6 pool |DHCP options set | Main route table | Main network ACL | Tenancy | Default VPC | Owner ID |
| ---- | -----  | ----  | --------  |  -------------------------------  | --------  | -------------   | ---------------- | ---------------  | ------- | ----------- | -------- |
| ParallelClusterVPC-20211210200003 | vpc-0445c3fa089b004d8  |	Available  |	10.0.0.0/16 |	–  |	–   |	dopt-eaeaf888 |	rtb-048c503f3e6b9acc3 | 	acl-0fecfa7ff42e04ead |	Default	| No| 	xxxx |
|ParallelClusterVPC-20211021183813  |	vpc-00e3f4e34aaf80f06 | 	Available | 	10.0.0.0/16 | 	– |	– |	dopt-eaeaf888 | rtb-0a5b7ac9873486bcb |	acl-0852d06b1170db68c |	Default	| No |	xxxx | 
| - | vpc-3cfc5759 | 	Available | 	172.31.0.0/16 | 	– |	– | 	dopt-eaeaf888 | 	rtb-99cd64fc |	acl-bb9b39de | 	Default	| Yes	| 440858712842 |
| ParallelClusterVPC-20210419174552 |	vpc-0ab948b66554c71ea |	Available |	10.0.0.0/16 |	– |	– |	dopt-eaeaf888 |	rtb-03fd47f05eac5379f |	acl-079fe1be7ff972858 |	Default	 | No |	xxxx |
| ParallelClusterVPC-20211021174405 |	vpc-0f34a572da1515e49 |	Available |	10.0.0.0/16 | 	– |	– |	dopt-eaeaf888 |	rtb-0b6310d9ea70a699e |	acl-01fa1529b65545e91 |	Default	| No |	xxxx |


This is the subnet id that I am currently using in the yaml files: subnet-018cfea3edf3c4765

I currently have 11 subnet IDs - how many are no longer being used?

| Name | Subnet ID | State |  VPC | IPv4 CIDR | IPv6 CIDR | Available IPv4 addresses | Availability Zone | Availability Zone ID | Network border group | Route table | Network ACL | Default subnet|  Auto-assign public IPv4 address | Auto-assign customer-owned IPv4 address | Customer-owned IPv4 pool | Auto-assign IPv6 address | Owner ID |
| --   | -------   | ----  | ---- | --------- | ---------- | ---------------------- | ----------------- | -------------------- | -------------------  | ----------- | ----------  | ------------- | ------------------------------   | --------------------------------------  | -----------------------  | -----------------------  | -------- |
| parallelcluster:public-subnet |	subnet-018cfea3edf3c4765 |	Available |	vpc-0445c3fa089b004d8-ParallelClusterVPC-20211210200003 |	10.0.0.0/20 |	– |	4091 | us-east-1a |	use1-az6 |	us-east-1 |	rtb-034bcab9e4b8c4023-parallelcluster:route-table-public |	acl-0fecfa7ff42e04ead |	No |	Yes |	No |	- |	No |	xx |


