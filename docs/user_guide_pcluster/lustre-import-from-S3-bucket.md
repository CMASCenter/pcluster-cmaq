# Use Lustre File System and Import S3 Bucket that contains input data 

1. Saves storage cost
2. Removes need to copy data from S3 bucket to Lustre file system
     a. FSx for Lustre integrates natively with Amazon S3, making it easy for you to process HPC data sets stored in Amazon S3
3. simplifies running HPC workloads on AWS
4. Amazon FSx for Lustre uses parallel data transfer techniques to transfer data to and from S3 at up to hundreds of GBs/s.


<a href="https://www.amazonaws.cn/en/fsx/lustre/faqs/">Lustre FAQs</a>

<a href="https://docs.amazonaws.cn/en_us/fsx/latest/LustreGuide/performance.html">Lustre Performance Documentation</a>

To find the default settings for Lustre see:
<a href="https://docs.aws.amazon.com/parallelcluster/latest/ug/SharedStorage-v3.html#SharedStorage-v3-FsxLustreSettings">Lustre Settings for Parallel Cluster</a>

### Diagram of the YAML file that contains a Snapshot ID to pre-install the software, and the path to an S3 Bucket for importing the data to the Lustre Filesystem

Figure 1. Diagram of YAML file used to configure a Parallel Cluster with a c5n.large head node and c5n.18xlarge compute nodes with Software and Data Pre-installed

![c5n-18xlarge Software+Data Pre-installed yaml configuration](../yml_plots/c5n-18xlarge.ebs_shared-yaml.png)

### Create cluster using ebs /shared directory with CMAQv5.3.3 and libraries installed, and the input data imported from an S3 bucket to the /fsx lustre file system

Note - you need to edit the c5n-18xlarge.ebs_shared.yaml file to specify your subnet-id and your keypair prior to creating the cluster

```
vi c5n-18xlarge.ebs_shared.yaml 
```


```
pcluster create-cluster --cluster-configuration c5n-18xlarge.ebs_shared.yaml --cluster-name cmaq --region us-east-1
```

output:

```
{
  "cluster": {
    "clusterName": "cmaq",
    "cloudformationStackStatus": "CREATE_IN_PROGRESS",
    "cloudformationStackArn": "arn:aws:cloudformation:us-east-1:440858712842:stack/cmaq/6cfb1a50-6e99-11ec-8af1-0ea2256597e5",
    "region": "us-east-1",
    "version": "3.0.2",
    "clusterStatus": "CREATE_IN_PROGRESS"
  }
}

```

Check status again

```
pcluster describe-cluster --region=us-east-1 --cluster-name cmaq
```
output:

```
{
  "creationTime": "2022-01-06T02:36:18.119Z",
  "version": "3.0.2",
  "clusterConfiguration": {
    "url": "https://parallelcluster-92e22c6ec33aa106-v1-do-not-delete.s3.amazonaws.com/parallelcluster/3.0.2/clusters/cmaq-h466ns1cchvrf3wd/configs/cluster-config.yaml?versionId=3F5xBNZqTGz5UDMBvk8Dj27JDaBlfQwQ&"
  },
  "tags": [
    {
      "value": "3.0.2",
      "key": "parallelcluster:version"
    }
  ],
  "cloudFormationStackStatus": "CREATE_IN_PROGRESS",
  "clusterName": "cmaq",
  "computeFleetStatus": "UNKNOWN",
  "cloudformationStackArn": "arn:aws:cloudformation:us-east-1:440858712842:stack/cmaq/6cfb1a50-6e99-11ec-8af1-0ea2256597e5",
  "lastUpdatedTime": "2022-01-06T02:36:18.119Z",
  "region": "us-east-1",
  "clusterStatus": "CREATE_IN_PROGRESS"
}
```

Start the compute nodes

```
pcluster update-compute-fleet --region us-east-1 --cluster-name cmaq --status START_REQUESTED
```

log into the new cluster
(note replace centos.pem with your Key)

```
pcluster ssh -v -Y -i ~/centos.pem --cluster-name cmaq
```

### Verified that starting the Parallel Cluster with the /shared volume from the EBS drive snapshot

```
ls /shared/build
```

### The .cshrc file wasn't saved, so I copied it

```
cp /shared/pcluster-cmaq/dot.cshrc ~/.cshrc
```

### Source shell

```
csh
```

### Load the modules


### change shell and submit job

```
module avail
------------------------------------------------------------ /usr/share/modules/modulefiles -------------------------------------------------------------
dot  libfabric-aws/1.13.2amzn1.0  module-git  module-info  modules  null  openmpi/4.1.1  use.own
```

### Load the modules openmpi and libfabric

```
module load openmpi/4.1.1
module load libfabric-aws/1.13.2amzn1.0
```

Change directories

```
cd /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/
```

### Verify that the input data was imported from the S3 bucket

```
cd /fsx/12US2
```

Notice that the data doesn't take up much space, it must be linked, rather than copied.

```
du -h
```

output

```
27K     ./land
33K     ./MCIP
28K     ./emissions/ptegu
55K     ./emissions/ptagfire
27K     ./emissions/ptnonipm
55K     ./emissions/ptfire_othna
27K     ./emissions/pt_oilgas
26K     ./emissions/inln_point/stack_groups
51K     ./emissions/inln_point
28K     ./emissions/cmv_c1c2_12
28K     ./emissions/cmv_c3_12
28K     ./emissions/othpt
55K     ./emissions/ptfire
407K    ./emissions
27K     ./icbc
518K    .
```

The run scripts are expecting the data to be located under
/fsx/data/CONUS/12US2

Need to make this directory and then link it to the path created when the data was imported by the parallel cluster

```
mkdir -p /fsx/data/CONUS
cd /fsx/data/CONUS
ln -s /fsx/12US2 .
```
Also may need to create the output directory

```
mkdir -p /fsx/data/output
```

### Copy the latest run scripts from the github repo

`cp /shared/pcluster-cmaq/run_scripts/cmaq533/run*pcluster.csh /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/`

### Submit the job to the slurm queue

```
cd /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/
sbatch run_cctm_2016_12US2.256pe.8x32.pcluster.csh
```

### Results from the Parallel Cluster Started with the EBS Volume software from input data copied to /fsx from S3 Bucket

```
==================================
  ***** CMAQ TIMING REPORT *****
==================================
Start Day: 2015-12-22
End Day:   2015-12-23
Number of Simulation Days: 2
Domain Name:               12US2
Number of Grid Cells:      3409560  (ROW x COL x LAY)
Number of Layers:          35
Number of Processes:       256
   All times are in seconds.

Num  Day        Wall Time
01   2015-12-22   1305.99
02   2015-12-23   1165.30
     Total Time = 2471.29
      Avg. Time = 1235.64
```


### Results from Parallel Cluster Started with the EBS Volume software with data imported from S3 Bucket


```
==================================
  ***** CMAQ TIMING REPORT *****
==================================
Start Day: 2015-12-22
End Day:   2015-12-23
Number of Simulation Days: 2
Domain Name:               12US2
Number of Grid Cells:      3409560  (ROW x COL x LAY)
Number of Layers:          35
Number of Processes:       256
   All times are in seconds.

Num  Day        Wall Time
01   2015-12-22   1564.90
02   2015-12-23   1381.80
     Total Time = 2946.70
      Avg. Time = 1473.35
```

Timing for a 288 pe run

```
tail -n 18 run_cctmv5.3.3_Bench_2016_12US2.16x18pe.2day.log
```

Output:

```
==================================
  ***** CMAQ TIMING REPORT *****
==================================
Start Day: 2015-12-22
End Day:   2015-12-23
Number of Simulation Days: 2
Domain Name:               12US2
Number of Grid Cells:      3409560  (ROW x COL x LAY)
Number of Layers:          35
Number of Processes:       288
   All times are in seconds.

Num  Day        Wall Time
01   2015-12-22   1197.19
02   2015-12-23   1090.45
     Total Time = 2287.64
      Avg. Time = 1143.82
```

Note this performance seems better than earlier runs..
I added the #SBATCH --exclusive option.  Perhaps that made a difference.


```
tail -n 18 run_cctmv5.3.3_Bench_2016_12US2.10x18pe.2day.log
```

Output:

```
==================================
  ***** CMAQ TIMING REPORT *****
==================================
Start Day: 2015-12-22
End Day:   2015-12-23
Number of Simulation Days: 2
Domain Name:               12US2
Number of Grid Cells:      3409560  (ROW x COL x LAY)
Number of Layers:          35
Number of Processes:       180
   All times are in seconds.

Num  Day        Wall Time
01   2015-12-22   1585.67
02   2015-12-23   1394.52
     Total Time = 2980.19
      Avg. Time = 1490.09
```

### logout of cluster when you are done

`exit`

### Delete Cluster

`pcluster delete-cluster --region=us-east-1 --cluster-name cmaq`

