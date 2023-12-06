Intermediate Tutorial

## Use CycleCloud pre-installed with software and data.

Step by step instructions for running the CMAQ 12US2 Benchmark for 2 days on a CycleCloud

https://docs.microsoft.com/en-us/azure/cyclecloud/download-cluster-templates?view=cyclecloud-8

Customized templates can be imported into CycleCloud using the CycleCloud CLI:

cyclecloud import_template -f templates/template-name.template.txt

Proximity Placement Groups
To get VMs as close as possible, achieving the lowest possible latency, you should deploy them within a proximity placement group.

A proximity placement group is a logical grouping used to make sure that Azure compute resources are physically located close to each other. Proximity placement groups are useful for workloads where low latency is a requirement.
https://docs.microsoft.com/en-us/azure/virtual-machines/linux/proximity-placement-groups
