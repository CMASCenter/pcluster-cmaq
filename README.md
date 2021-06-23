# pcluster-cmaq

## Scripts and code to configure an AWS pcluster for CMAQ

## To obtain this code use the following command:

```
git clone -b main https://github.com/lizadams/pcluster-cmaq.git pcluster-cmaq
```

## To configure the cluster start a virtual environment on your local linux machine and install aws-parallelcluster

```
python3 -m virtualenv ~/apc-ve
source ~/apc-ve/bin/activate
python --version

python3 -m pip install --upgrade aws-parallelcluster
pcluster version
```

### Edit the configuration file for the cluster

```
vi ~/.parallelcluster/config
```

### Configure the cluster
      

The settings in the cluster configuration file allow you to 
   1) specify the head node, and what compute nodes are available (Note, the compute nodes can be updated/changed, but the head node cannot be updated.)
   2) specify the maximum number of compute nodes that can be requested using slurm
   3) specify the network used (elastic fabric adapter (efa) - only supported on larger instances https://docs.aws.amazon.com/parallelcluster/latest/ug/efa.html)
   4) specify that the compute nodes are on the same network (see placement groups and networking https://docs.aws.amazon.com/parallelcluster/latest/ug/troubleshooting.html
   5) specify if hyperthreading is used or not (can be done using config, much easier than earlier methods: https://aws.amazon.com/blogs/compute/disabling-intel-hyper-threading-technology-on-amazon-linux/
   6) specify the type of disk that is used, ie ebs or fsx and the size of /shared disk that is available  (can't be updated) 
   (Note the /shared disks are persistent as you can't turn them off, they will acrue charges until the cluster is deleted so you need to determine the size and type requirements carefully.)
   7) specify availability of the intel compiler - need separate config settings and license to get access to intel compiler
  (Note: you can use intelmpi with the gcc compiler, it isn't a requirement to use ifort as the base compiler.)
   8) specify the name of an existing ebs volume to use as a shared directory  - this can then be saved and available even after the pcluster is deleted. (?) Is this volume shared across the cluster, how do we ensure the file permissions are set correctly for each user?
   
  
```
pcluster configure pcluster -c /Users/lizadams/.parallelcluster/config
```

### Create the cluster

```
pcluster create cmaq
```

### Stop cluster

```
pcluster stop cmaq
```

### Start cluster

```
pcluster start cmaq
```

### Update the cluster

```
pcluster update -c /Users/lizadams/.parallelcluster/config cmaq
```

### To learn more about the pcluster commands

```
pcluster --help
```

### List the available clusters

```
pcluster list

cmaq-c5-4xlarge  UPDATE_COMPLETE  2.10.4
cmaq-conus       CREATE_COMPLETE  2.10.4
cmaq-large       UPDATE_COMPLETE  2.10.3
cmaq             UPDATE_COMPLETE  2.10.3
```

### Check status of cluster

```
pcluster status cmaq-c5-4xlarge
```

```
Status: UPDATE_COMPLETE
MasterServer: RUNNING
ClusterUser: centos
MasterPrivateIP: 10.0.0.219
ComputeFleetStatus: RUNNING
```

### This cluster was created using the following command. I am not sure how to report out the config file used to create a pcluster.
pcluster create cmaq-c5-4xlarge -c /Users/lizadams/.parallelcluster/config-c5.4xlarge

### The CTM_LOG files don't contain any information about the compute nodes that the jobs were run on.
We need a record of the NPCOL, NPROW setting and the number of nodes and tasks used as specified in the run script: #SBATCH --nodes=16 #SBATCH --ntasks-per-node=8
We need to save a copy of the standard out and error logs, and a copy of the run scripts to the OUTPUT directory.

```
cd /shared/build/openmpi_4.1.0_gcc_8.3.1/CMAQ_v532/CCTM/scripts
cp run*.log /shared/build/openmpi_4.1.0_gcc_8.3.1/CMAQ_v532/data/output
cp run*.csh /shared/build/openmpi_4.1.0_gcc_8.3.1/CMAQ_v532/data/output
```

### Managing the cluster
  1) You can turn off the head node after stopping the cluster, as long as you restart it before restaring the cluster
  2) The pcluster slurm queue system will create and destroy the compute nodes, so that helps reduce manual cleanup for the cluster.
  3) It is best to copy/backup the outputs and logs to an s3 bucket for follow-up analysis

### Pcluster User Manual
https://docs.aws.amazon.com/parallelcluster/latest/ug/what-is-aws-parallelcluster.html

### Configuring Pcluster for HPC
https://jimmielin.me/2019/wrf-gc-aws/

### Login to cluster using the permissions file

```
pcluster ssh cmaq -i ~/downloads/centos.pem
```

### Once you are on the cluster change from default bash shell to csh

```
csh
```

### Check what modules are available

```
module avail
```

### Load the openmpi module

```
module load openmpi/4.1.0
```

### Check what version of the gcc compiler is available

```
 gcc --version
gcc (GCC) 8.3.1 20191121 (Red Hat 8.3.1-5)
Copyright (C) 2018 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

### Change directories to Install and build the libraries and CMAQ

```
cd /shared/pcluster-cmaq
```

### Build netcdf C and netcdf F libraries - these scripts work for the gcc 8.3.1 compiler

```
./gcc8_install.csh
```

### A .cshrc script with LD_LIBRARY_PATH was copied to your home directory, enter the shell again and check environment variables that were set using

```
csh
env
```

### Buiild I/O API library

```
./gcc8_ioapi.csh
```

### Build CMAQ

```
./gcc8_cmaq.csh
```

## Copy the input data from a S3 bucket (this bucket is not public and needs credentials)
## set the aws credentials

```
aws credentials
```

## Use the script to copy the CONUS input data to the cluster, this 

```
./s3_copy_need_credentials_conus.csh
```

## Note, this input data requires 44 GB of disk space

```
cd /shared/CONUS
[centos@ip-10-0-0-219 CONUS]$ du -sh
44G	.
```

## For the output data, assuming 2 day CONUS Run, 1 layer, 12 var in the CONC output

```
cd /shared/build/openmpi_4.1.0_gcc_8.3.1/CMAQ_v532/data/output/output_CCTM_v532_gcc_2016_CONUS_16x8pe
du -sh
18G	.
```

### For the output data, assuming 2 day CONUS Run, all 35 layers, all 244 variables in CONC output

```
cd /shared/build/openmpi_4.1.0_gcc_8.3.1/CMAQ_v532/data/output/output_CCTM_v532_gcc_2016_CONUS_16x8pe_full
du -sh
173G	.
```

### This cluster is configured to have 2 Terrabytes of shared space, to allow multiple output runs to be stored.

```
 df -h
Filesystem      Size  Used Avail Use% Mounted on
devtmpfs         16G     0   16G   0% /dev
tmpfs            16G     0   16G   0% /dev/shm
tmpfs            16G   17M   16G   1% /run
tmpfs            16G     0   16G   0% /sys/fs/cgroup
/dev/nvme0n1p1  100G   16G   85G  16% /
/dev/nvme1n1    2.5T  289G  2.0T  13% /shared
tmpfs           3.1G  4.0K  3.1G   1% /run/user/1000
```

### Currently the /shared directory contains 296 G of data, and is only using 13% of available volume

### For the 12km SE Domain, copy the input data and then untar it, or use the pre-install script in the pcluster configuration file.
### Note: it is faster to copy all of the data to an S3 bucket without using tar.gz

```
cd /shared/
aws s3 cp --recursive s3://cmaqv5.3.2-benchmark-2day-2016-12se1-input .
tar -xzvf CMAQv5.3.2_Benchmark_2Day_Input.tar.gz
```

## Link the CONUS and 12km SE Domain input benchmark directory to your run script area

```
cd /shared/build/openmpi_4.1.0_gcc_8.3.1/CMAQ_v532/data
ln -s /shared/CONUS .
ln -s /shared/CMAQv5.3.2_Benchmark_2Day_Input .
```


## Copy a preinstall script to the S3 bucket (may be able to install all software and input data on spinup)
## This example is for the 12km SE domain (not implemented for CONUS domain yet).

```
aws s3 cp --acl public-read parallel-cluster-pre-install.sh s3://cmaqv5.3.2-benchmark-2day-2016-12se1-input/
```

### Copy the run scripts to the run directory

```
cd /shared/pcluster-cmaq
cp run*  /shared/build/openmpi_4.1.0_gcc_8.3.1/CMAQ_v532/CCTM/scripts
cd  /shared/build/openmpi_4.1.0_gcc_8.3.1/CMAQ_v532/CCTM/scripts
```


#### Once you have logged into the queue you can submit multiple jobs to the slurm job scheduler.

 ```
sbatch run_cctm_2016_12US2.64pe.csh
sbatch run_cctm_2016_12US2.256pe.csh
```

```
squeue -u centos
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON) 
                27   compute     CMAQ   centos  R      47:41      2 compute-dy-c59xlarge-[1-2] 
                28   compute     CMAQ   centos  R      10:58      8 compute-dy-c59xlarge-[3-10] 
 ```

## Note, there are times when the second day run fails, looking for the input file that was output from the first day.

1. Need to put in a sleep command between the two days.
2. Temporary fix is to restart the second day.

### Note this may help with networking on the parallel cluster
If the head node must be in the placement group, use the same instance type and subnet for both the head as well as all of the compute nodes. By doing this, the compute_instance_type parameter has the same value as the master_instance_type parameter, the placement parameter is set to cluster, and the compute_subnet_id parameter isn't specified. With this configuration, the value of the master_subnet_id parameter is used for the compute nodes. 
https://docs.aws.amazon.com/parallelcluster/latest/ug/troubleshooting.html


### Note you can check the timings while the job is still running using the following command

```
grep 'Processing completed' CTM_LOG_001*
```


            Processing completed...    8.8 seconds
            Processing completed...    7.4 seconds


### Sometimes get an error when shutting down 
 *** FATAL ERROR shutting down Models-3 I/O ***
 
### run m3diff to compare the output data

```
cd /shared/build/openmpi_4.1.0_gcc_8.3.1/CMAQ_v532/data/output
ls */*CONC*

setenv AFILE output_CCTM_v532_gcc_2016_CONUS_16x8pe/CCTM_CONC_v532_gcc_2016_CONUS_16x8pe_20151222.nc
setenv BFILE output_CCTM_v532_gcc_2016_CONUS_8x12pe/CCTM_CONC_v532_gcc_2016_CONUS_8x12pe_20151222.nc

m3diff

grep A:B REPORT
```

should see all zeros but we don't.

```
[centos@ip-10-0-0-219 output]$ grep A:B REPORT
 A:B  0.00000E+00@(  1,  0, 0)  0.00000E+00@(  1,  0, 0)  0.00000E+00  0.00000E+00
 A:B  0.00000E+00@(  1,  0, 0)  0.00000E+00@(  1,  0, 0)  0.00000E+00  0.00000E+00
 A:B  2.04891E-07@(293, 70, 1) -1.47149E-07@(272, 52, 1)  3.32936E-12  9.96093E-10
 A:B  2.98023E-08@(291, 71, 1) -2.60770E-08@(277,160, 1) -2.20486E-13  5.66325E-10
 A:B  1.13621E-07@(308,184, 1) -1.89990E-07@(240, 67, 1) -8.85402E-12  1.61171E-09
 A:B  7.63685E-08@(310,180, 1) -7.37607E-07@(273, 52, 1) -5.05276E-12  3.60038E-09
 A:B  5.55068E-07@(185,231, 1) -1.24797E-07@(255,166, 1)  2.47303E-11  3.99435E-09
 A:B  5.87665E-07@(285,167, 1) -4.15370E-07@(182,232, 1)  2.54544E-11  5.64502E-09
 A:B  3.10000E-05@(280,148, 1) -1.03656E-05@(279,148, 1)  2.16821E-10  1.07228E-07
 A:B  1.59163E-06@(181,231, 1) -7.91997E-06@(281,148, 1) -3.21571E-10  4.46658E-08
```

### information about your cluster
https://www.hpcworkshops.com/03-hpc-aws-parallelcluster-workshop/07-logon-pc.html

```
sinfo
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST 
compute*  inact   infinite     10  idle~ compute-dy-c524xlarge-[1-10] 
```

#### on a different cluster - running with hyperthreading turned off, on 64 processors, this is the output that shows only 8 compute processors are running, the other 8 that are available (according to setting maximum number of compute nodes in the pcluster configure file.

```
-rw-rw-r-- 1 centos centos 464516 Jun 22 23:20 CTM_LOG_044.v532_gcc_2016_CONUS_8x8pe_20151222
[centos@ip-10-0-0-219 scripts]$ squeue -u centos
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON) 
                10   compute     CMAQ   centos  R      40:37      8 compute-dy-c54xlarge-[1-8] 
[centos@ip-10-0-0-219 scripts]$ sinfo
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST 
compute*     up   infinite      8  idle~ compute-dy-c54xlarge-[9-16] 
compute*     up   infinite      8  alloc compute-dy-c54xlarge-[1-8] 
```

### verify the stats of the the different compute cluters

```
Model            vCPU 	Memory (GiB) Instance Storage (GiB) Network Bandwidth (Gbps) EBS Bandwidth (Mbps)
c5.4xlarge 	     16 	        32 	  EBS-Only 	             Up to 10 	4,750
c5.24xlarge 	96 	       192 	  EBS-Only 	                   25 	19,000
```

### Note, -this may not be the instance that was used for benchmarking, it look like my log files specified c5.9xlarge.  This is a risk of being able to update the compute nodes, you need to keep track of what the compute nodes are when you do the runs.
### We need to add the sinfo command to the run script, so we know what configuration of the cluster each slurm job is being run on.
### List mounted volumes. A few volumes are shared by the head-node and will be mounted on compute instances when they boot up. Both /shared and /home are accessible by all nodes.

```
showmount -e localhost
Export list for localhost:
/opt/slurm 10.0.0.0/16
/opt/intel 10.0.0.0/16
/home      10.0.0.0/16
/shared    10.0.0.0/16
```


### To determine if the cluster has hyperthreading turned off use lscpu and look at 'Thread(s) per core:'. 

```
lscpu
Architecture:        x86_64
CPU op-mode(s):      32-bit, 64-bit
Byte Order:          Little Endian
CPU(s):              8
On-line CPU(s) list: 0-7
Thread(s) per core:  1                < ---- this means that hyperthreading is off
Core(s) per socket:  8
Socket(s):           1
NUMA node(s):        1
Vendor ID:           GenuineIntel
CPU family:          6
Model:               85
Model name:          Intel(R) Xeon(R) Platinum 8275CL CPU @ 3.00GHz
Stepping:            7
CPU MHz:             3605.996
BogoMIPS:            5999.99
Hypervisor vendor:   KVM
Virtualization type: full
L1d cache:           32K
L1i cache:           32K
L2 cache:            1024K
L3 cache:            36608K
NUMA node0 CPU(s):   0-7
Flags:               fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ss ht syscall nx pdpe1gb rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid aperfmperf tsc_known_freq pni pclmulqdq ssse3 fma cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand hypervisor lahf_lm abm 3dnowprefetch invpcid_single pti fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid mpx avx512f avx512dq rdseed adx smap clflushopt clwb avx512cd avx512bw avx512vl xsaveopt xsavec xgetbv1 xsaves ida arat pku ospke
```


### Be careful how you name your s3 buckets, the name can't be changed. A new name can be created, and then the objects copied or synced to the new bucket and the old bucket can be removed using the aws command line

```
### make new bucket
aws s3 mb s3://t2large-head-c5.9xlarge-compute-conus-output
### sync old bucket with new bucket
aws s3 sync s3://t2large-head-c524xlarge-compute-pcluster-conus-output s3://t2large-head-c5.9xlarge-compute-conus-output
### remove old bucket
 aws s3 rb --force s3://t2large-head-c524xlarge-compute-pcluster-conus-output
```

### This is the configuration file that gave the fastest runtimes for the CONUS domain using EBS storage
### Note, it uses spot pricing, rather than on demand pricing
https://github.com/lizadams/pcluster-cmaq/blob/main/config-c5.4xlarge-nohyperthread

### This is the configuration file for the pcluster with the fastest performance using the Lustre Filesystem
### It was very oversized - 39 TB, and was very expensive as a result.  Do not use unless you resize it.
https://aws.amazon.com/blogs/storage/building-an-hpc-cluster-with-aws-parallelcluster-and-amazon-fsx-for-lustre/
https://github.com/lizadams/pcluster-cmaq/blob/main/config-lustre

### Note, I tried creating an EBS volume and then attaching it to the pcluster using the following settings
### it didn't work - need to retry this, as it would allow us to store the libraries and cmaq on an ebs volume rather than rebuilding each time

```
[cluster default]
ebs_settings = ebs,input,apps

[ebs apps]
shared_dir = /shared
ebs_volume_id = vol-0ef9a574ac8e5acbb
```

### Tried using parallel-io build of CMAQ, rebuilding the libraries to use pnetcdf and adding MPI: to the input files
### Did this on the lustre cluster and obtained the following error.



### Looking at the volumes on EC2, I can see that it is available, perhaps there is a conflict with the name /shared
### I was also trying to copy the software from an S3 Bucket, and it didn't work.  It couldn't find the executable, when the job was submitted.
### It may have been a permissions issue, or perhaps the volume wasn't shared?

```
Name Volume ID      Size    Volume Type IOPS Throughput (MB/s) Snapshot Created Availability Zone State Alarm Status Attachment Information Monitoring Volume Status
vol-0ef9a574ac8e5acbb 500 GiB   io1 3000 - snap-0f7bf48b384bbc975 June 21, 2021 at 3:33:24 PM UTC-4 us-east-1a  available       None
```


### Additional Benchmarking resource
https://github.com/aws/aws-parallelcluster/issues/1436

### The next thing to try is Graviton as a compute instance

```
Amazon EC2 C6g instances are powered by Arm-based AWS Graviton2 processors. They deliver up to 40% better price performance over current generation C5 instances for compute-intensive applications.
https://aws.amazon.com/ec2/instance-types/#instance-details

Instance Size 	vCPU 	Memory (GiB) 	Instance Storage (GiB) 	Network Bandwidth (Gbps) 	EBS Bandwidth (Mbps)
c6g.4xlarge 	16 	32 	EBS-Only 	Up to 10 	4750
c6g.8xlarge 	32 	64 	EBS-Only 	12 	9000
c6g.12xlarge 	48 	96 	EBS-Only 	20 	13500
c6g.16xlarge 	64 	128 	EBS-Only 	25 	19000
```
c6gd.4xlarge 	16 	32 	1 x 950 NVMe SSD 	Up to 10 	4,750


### Need to price out the different storage options
```
EBS, iot, gp2, lustre, etc
```

### Another question is would we have had even higher performance using lustre and turning off hyperthreading

### To use cloudwatch to report cpu usage for the cluster

https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/US_SingleMetricPerInstance.html

```
aws cloudwatch get-metric-statistics --namespace AWS/EC2 --metric-name CPUUtilization  --period 3600 \
--statistics Maximum --dimensions Name=InstanceId,Value=i-0dd4225d087abeb38 \
--start-time 2021-06-22T00:00:00 --end-time 2021-06-22T21:05:25

Each value represents the maximum CPU utilization percentage for a single EC2 instance. 
So, this must be for the head nodes, not the compute nodes.
{
    "Label": "CPUUtilization",
    "Datapoints": [
        {
            "Timestamp": "2021-06-22T20:00:00Z",
            "Maximum": 10.61,
            "Unit": "Percent"
        },
        {
            "Timestamp": "2021-06-22T17:00:00Z",
            "Maximum": 25.633760562676045,
            "Unit": "Percent"
        },
        {
            "Timestamp": "2021-06-22T15:00:00Z",
            "Maximum": 5.451666666666666,
            "Unit": "Percent"
        },
        {
            "Timestamp": "2021-06-22T21:00:00Z",
            "Maximum": 9.736666666666666,
            "Unit": "Percent"
        },
        {
            "Timestamp": "2021-06-22T19:00:00Z",
            "Maximum": 9.003333333333334,
            "Unit": "Percent"
        },
        {
            "Timestamp": "2021-06-22T18:00:00Z",
            "Maximum": 32.20446325894569,
            "Unit": "Percent"
        },
        {
            "Timestamp": "2021-06-22T16:00:00Z",
            "Maximum": 25.642905951567474,
            "Unit": "Percent"
        }
    ]
}
```

### Another resource

```
https://jiaweizhuang.github.io/blog/aws-hpc-guide/
```

Some of these tips don't work on the pcluster
 sinfo
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST 
compute*     up   infinite     16  idle~ compute-dy-c54xlarge-[1-16] 


### I don't see an ip address, only a name for the compute cluster, and I can't connect to it.

```
ssh compute-dy-c54xlarge-1
ssh: connect to host compute-dy-c54xlarge-1 port 22: Connection refused
```

### ifconfig

```
ifconfig
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 9001
        inet 10.0.0.219  netmask 255.255.255.0  broadcast 10.0.0.255
        inet6 fe80::b4:baff:fee9:331f  prefixlen 64  scopeid 0x20<link>
        ether 02:b4:ba:e9:33:1f  txqueuelen 1000  (Ethernet)
        RX packets 239726465  bytes 508716629442 (473.7 GiB)
        RX errors 0  dropped 46  overruns 0  frame 0
        TX packets 403287013  bytes 1900350587702 (1.7 TiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 42601  bytes 12642178 (12.0 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 42601  bytes 12642178 (12.0 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
 ```
        
###   network information  - from the above link "This means that "Enhanced Networking" is enabled 13. This should be the default on most modern AMIs, so you shouldn't need to change anything."

```
        ethtool -i eth0
driver: ena
version: 2.1.0K
firmware-version: 
expansion-rom-version: 
bus-info: 0000:00:05.0
supports-statistics: yes
supports-test: no
supports-eeprom-access: no
supports-register-dump: no
supports-priv-flags: no
```

### You can login to the compute nodes by going to the AWS console, and looking for the instances named compute
### Get the private IP address, and then use ssh from the head node to login to the private IP
ssh IP address

Using top, I can see 49 running tasks
top - 22:02:36 up 23 min,  1 user,  load average: 48.27, 44.83, 27.73
Tasks: 675 total,  49 running, 626 sleeping,   0 stopped,   0 zombie
%Cpu(s): 84.5 us, 14.8 sy,  0.0 ni,  0.0 id,  0.0 wa,  0.7 hi,  0.0 si,  0.0 st
MiB Mem : 191136.2 total, 132638.8 free,  50187.9 used,   8309.5 buff/cache
MiB Swap:      0.0 total,      0.0 free,      0.0 used. 139383.6 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                           
   7958 centos    20   0 1877772   1.0g  18016 R  99.7   0.5  11:12.78 CCTM_v532.exe                     
   7963 centos    20   0 1914288   1.0g  18004 R  99.7   0.5  11:12.90 CCTM_v532.exe                     
   7964 centos    20   0 1849700 997116  17908 R  99.7   0.5  11:12.04 CCTM_v532.exe                     
   7965 centos    20   0 1971236   1.1g  18028 R  99.7   0.6  11:10.30 CCTM_v532.exe                     
   7970 centos    20   0 2043228   1.1g  18048 R  99.7   0.6  11:11.22 CCTM_v532.exe                     
   7980 centos    20   0 1896544   1.0g  18088 R  99.7   0.5  11:12.57 CCTM_v532.exe                     
   8007 centos    20   0 1859792 987.4m  18120 R  99.7   0.5  11:09.91 CCTM_v532.exe                     
   8011 centos    20   0 1908064   1.0g  18240 R  99.7   0.5  11:09.21 CCTM_v532.exe                     
   8052 centos    20   0 1902952   1.0g  17944 R  99.7   0.5  11:10.44 CCTM_v532.exe                     
   7956 centos    20   0 1840280 996668  17828 R  99.3   0.5  11:12.00 CCTM_v532.exe                     
   7957 centos    20   0 1957164   1.1g  17780 R  99.3   0.6  11:10.21 CCTM_v532.exe                     
   7959 centos    20   0 1928932   1.0g  17892 R  99.3   0.6  11:10.52 CCTM_v532.exe                     
   7960 centos    20   0 1888204   1.0g  17972 R  99.3   0.5  11:10.70 CCTM_v532.exe                     
   7961 centos    20   0 1954500   1.1g  18032 R  99.3   0.6  11:10.35 CCTM_v532.exe                     
   7962 centos    20   0 1926924   1.0g  17868 R  99.3   0.5  11:13.01 CCTM_v532.exe                     
   7972 centos    20   0 1960388   1.1g  17992 R  99.3   0.6  11:10.29 CCTM_v532.exe                     
   7974 centos    20   0 1919348   1.0g  18052 R  99.3   0.5  11:12.88 CCTM_v532.exe                     
   7983 centos    20   0 1825104 974220  18184 R  99.3   0.5  11:11.58 CCTM_v532.exe                     
   7995 centos    20   0 1969536   1.1g  18032 R  99.3   0.6  11:10.56 CCTM_v532.exe                     
   8013 centos    20   0 1819860 970136  18196 R  99.3   0.5  11:12.34 CCTM_v532.exe                     
   8014 centos    20   0 1809228 961672  17744 R  99.3   0.5  11:11.85 CCTM_v532.exe                     
   8017 centos    20   0 1970864   1.1g  18008 R  99.3   0.6  11:09.37 CCTM_v532.exe                     
   8021 centos    20   0 1923016   1.0g  18068 R  99.3   0.5  11:09.78 CCTM_v532.exe                     
   8024 centos    20   0 1919768   1.0g  18076 R  99.3   0.5  11:11.29 CCTM_v532.exe                     
   8028 centos    20   0 1908988   1.0g  17992 R  99.3   0.5  11:10.51 CCTM_v532.exe                     
   8031 centos    20   0 1975896   1.1g  17920 R  99.3   0.6  11:08.06 CCTM_v532.exe                     
   8035 centos    20   0 1890020   1.0g  17888 R  99.3   0.5  11:08.24 CCTM_v532.exe                     
   8038 centos    20   0 1958252   1.1g  18488 R  99.3   0.6  11:09.83 CCTM_v532.exe                     
   8041 centos    20   0 1915840   1.0g  17916 R  99.3   0.5  11:09.67 CCTM_v532.exe                     
   8043 centos    20   0 1830916 980432  17900 R  99.3   0.5  11:08.43 CCTM_v532.exe                     
   8047 centos    20   0 2231128   1.3g  17964 R  99.3   0.7  11:08.91 CCTM_v532.exe                     
   8049 centos    20   0 1907696   1.0g  18280 R  99.3   0.5  11:10.44 CCTM_v532.exe                     
   8055 centos    20   0 2168272   1.3g  17860 R  99.3   0.7  11:10.73 CCTM_v532.exe                     
   8058 centos    20   0 1789948 936684  17784 R  99.3   0.5  11:09.20 CCTM_v532.exe   
     8064 centos    20   0 1810356 962336  17800 R  99.3   0.5  11:09.56 CCTM_v532.exe                     
   8066 centos    20   0 1820544 975396  17612 R  99.3   0.5  11:09.33 CCTM_v532.exe                     
   8069 centos    20   0 1871124   1.0g  18200 R  99.3   0.5  11:09.92 CCTM_v532.exe                     
   8074 centos    20   0 1848644 998840  18048 R  99.3   0.5  11:09.81 CCTM_v532.exe                     
   8078 centos    20   0 1924400   1.0g  18292 R  99.3   0.5  11:09.51 CCTM_v532.exe                     
   8083 centos    20   0 1899244   1.0g  18096 R  99.3   0.5  11:09.10 CCTM_v532.exe                     
   8086 centos    20   0 1806572 952816  17780 R  99.3   0.5  11:09.64 CCTM_v532.exe                     
   7986 centos    20   0 1955908   1.1g  18184 R  99.0   0.6  11:09.66 CCTM_v532.exe     

[centos@compute-dy-c5ad24xlarge-2 ~]$ lscpu
Architecture:        x86_64
CPU op-mode(s):      32-bit, 64-bit
Byte Order:          Little Endian
CPU(s):              48
On-line CPU(s) list: 0-47
Thread(s) per core:  1
Core(s) per socket:  48
Socket(s):           1
NUMA node(s):        1
Vendor ID:           AuthenticAMD
CPU family:          23
Model:               49
Model name:          AMD EPYC 7R32
Stepping:            0
CPU MHz:             3296.186
BogoMIPS:            5599.69
Hypervisor vendor:   KVM
Virtualization type: full
L1d cache:           32K
L1i cache:           32K
L2 cache:            512K
L3 cache:            16384K
NUMA node0 CPU(s):   0-47
Flags:               fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc cpuid extd_apicid aperfmperf tsc_known_freq pni pclmulqdq monitor ssse3 fma cx16 sse4_1 sse4_2 movbe popcnt aes xsave avx f16c rdrand hypervisor lahf_lm cmp_legacy cr8_legacy abm sse4a misalignsse 3dnowprefetch topoext perfctr_core ssbd ibrs ibpb stibp vmmcall fsgsbase bmi1 avx2 smep bmi2 rdseed adx smap clflushopt clwb sha_ni xsaveopt xsavec xgetbv1 clzero xsaveerptr wbnoinvd arat npt nrip_save rdpid

