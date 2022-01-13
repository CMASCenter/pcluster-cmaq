### VPC Management

There is a limit on the number of VPCs that are allowed per account - limit is 5.

Note, there is a default VPC, that is used to create EC2 instances.

Q1. is there a separate default VPC for each region?

Q2. does configure cluster command create a new VPC?

Q3. why doesn't the VPC and subnet IDs get deleted when the Parallel Clusters are deleted.

I can see why you wouldn't want to delete the VPC, if you want to reuse the yaml file that contains the SubnetID that is tied to that VPC.

I was able to use the Amazon Website to find the SubnetID, and then identify the VPC that it is part of.

I currently have the following VPCs

| Name | VPC ID | State | IPv4 CIDR |  IPv6 CIDR (Network border group) | IPv6 pool |DHCP options set | Main route table | Main network ACL | Tenancy | Default VPC | Owner ID |
| ---- | -----  | ----  | --------  |  -------------------------------  | --------  | -------------   | ---------------- | ---------------  | ------- | ----------- | -------- |
| ParallelClusterVPC-20211210200003 | vpc-0445c3fa089b004d8  |	Available  |	10.0.0.0/16 |	–  |	–   |	dopt-eaeaf888 |	rtb-048c503f3e6b9acc3 | 	acl-0fecfa7ff42e04ead |	Default	No| 	440858712842 |
|ParallelClusterVPC-20211021183813  |	vpc-00e3f4e34aaf80f06 | 	Available | 	10.0.0.0/16 | 	– |	– |	dopt-eaeaf888 | rtb-0a5b7ac9873486bcb |	acl-0852d06b1170db68c |	Default	No |	440858712842 | 
| - | vpc-3cfc5759 | 	Available | 	172.31.0.0/16 | 	– |	– | 	dopt-eaeaf888 | 	rtb-99cd64fc |	acl-bb9b39de | 	Default	| Yes	| 440858712842 |
| ParallelClusterVPC-20210419174552 |	vpc-0ab948b66554c71ea |	Available |	10.0.0.0/16 |	– |	– |	dopt-eaeaf888 |	rtb-03fd47f05eac5379f |	acl-079fe1be7ff972858 |	Default	 | No |	440858712842 |
| ParallelClusterVPC-20211021174405 |	vpc-0f34a572da1515e49 |	Available |	10.0.0.0/16 | 	– |	– |	dopt-eaeaf888 |	rtb-0b6310d9ea70a699e |	acl-01fa1529b65545e91 |	Default	| No |	440858712842 |
