# Run CMAQ on c6a.48xlarge

## Login to cluster
```{note}
Replace the your-key.pem with your Key Pair.
```

`pcluster ssh -v -Y -i ~/your-key.pem --region=us-east-1 --cluster-name cmaq`

Check to make sure elastic network adapter (ENA) is enabled

`modinfo ena`

`lspci`

Change default shell to .tcsh

`sudo usermod -s /bin/tcsh ubuntu`

Copy file to .cshrc

```
cp /shared/pcluster-cmaq/install/dot.cshrc.pcluster ~/.cshrc
```

logout and log back in to activate default tcsh shell


Check what modules are available on the cluster

`module avail`

Load the openmpi module

`module load openmpi/4.1.5`

Load the Libfabric module

`module load libfabric-aws`

Verify the gcc compiler version is greater than 8.0

`gcc --version`

output:

```
gcc (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0
Copyright (C) 2019 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

```

```{seealso}
<a href="https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/enhanced-networking-ena.html#test-enhanced-networking-ena">Link to the AWS Enhanced Networking Adapter Documentation</a>
```

```{seealso}
<a href="https://docs.aws.amazon.com/parallelcluster/latest/ug/what-is-aws-parallelcluster.html">ParallelCluster User Manual</a>
```

Verify that you have an updated set of run scripts from the pcluster-cmaq repo

`cd /shared/pcluster-cmaq/run_scripts/cmaqv54+/`

`ls -lrt  run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.2x96.ncclassic.csh`

`diff run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.2x96.ncclassic.csh /shared/pcluster-cmaq/run_scripts/cmaqv54+/`


If they don't exist or are not identical, then copy the run scripts from the repo

`cp /shared/pcluster-cmaq/run_scripts/cmaqv54+/run_cctm* /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/`


## Verify that the input data is imported to /fsx from the S3 Bucket

```
cd /fsx/
ls */*
```

Preloading the files

Amazon FSx copies data from your Amazon S3 data repository when a file is first accessed.
CMAQ is sensitive to latencies, so it is best to preload contents of individual files or directories using the following command:

`nohup find /fsx/ -type f -print0 | xargs -0 -n 1 sudo lfs hsm_restore &`

Create a directory that specifies the full path that the run scripts are expecting.

`mkdir -p /fsx/data/CMAQ_Modeling_Platform_2018/`

Link the 2018_12US1 directoy

`cd /fsx/data/CMAQ_Modeling_Platform_2018/`

`ln -s /fsx/CMAQv5.4_2018_12US1_Benchmark_2Day_Input/2018_12US1/ .`

Link the 12LISTOS_Training data

`cd /fsx/data/`

`ln -s /fsx/CMAQv5.4_2018_12LISTOS_Benchmark_3Day_Input/12LISTOS_Training ./12US1_LISTOS`

Link the 2018_12NE3 Benchmark data

`ln -s /fsx/CMAQv5.4_2018_12NE3_Benchmark_2Day_Input/2018_12NE3 .`


netCDF-3 classic input files are used

The *.nc4 compressed netCDF4 files on /fsx input directory were converted to netCDF classic (nc3) files



Create the output directory`

`mkdir -p /fsx/data/output`


## Run the 12US1 Domain on 192 pes

`cd /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/`

`sbatch run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.2x96.ncclassic.csh`

Note, it will take about 3-5 minutes for the compute notes to start up. This is reflected in the Status (ST) of CF (configuring)


Check the status in the queue

`squeue -u ubuntu`

Output:

```
JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 3    queue1     CMAQ   ubuntu  CF                2 queue1-dy-compute-resource-1-[1-2]
```
After 5 minutes the status will change once the compute nodes have been created and the job is running

`squeue -u ubuntu`

Output:

```
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 3    queue1     CMAQ   ubuntu  R       0:58      2 queue1-dy-compute-resource-1-[1-2]
```

If you get the following message, then you likely need to upgrade the Parallel Cluster to using OnDemand Compute Nodes instead of SPOT instances.

```
ubuntu@ip-10-0-1-70:/shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts$ squeue
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 3    queue1     CMAQ   ubuntu PD       0:00      2 (Nodes required for job are DOWN, DRAINED or reserved for jobs in higher priority partitions)
```

If you need to update cluster to use ONDEMAND instead of SPOT instances

Stop Compute Nodes
```
pcluster update-compute-fleet --region us-east-1 --cluster-name cmaq --status STOP_REQUESTED
```

Upgrade compute nodes to ONDEMAND
```
 pcluster update-cluster --region us-east-1 --cluster-name cmaq --cluster-configuration c6a.large-48xlarge.ebs_unencrypted_installed_public_ubuntu2004.fsx_import_ondemand.yaml
```

Restart the compute nodes

`pcluster update-compute-fleet --region us-east-1 --cluster-name cmaq --status START_REQUESTED`

Verify compute nodes have started:

```
pcluster describe-cluster --region=us-east-1 --cluster-name cmaq 
```
Relogin to the cluster

```
pcluster ssh -v -Y -i ~/cmas.pem --region=us-east-1 --cluster-name cmaq
```

Resubmit the job to the queue

The 192 pe job should take 62 minutes to run (31 minutes per day)

Check on the status of the cluster using CloudWatch (optional)

<a href="https://console.aws.amazon.com/cloudwatch/home?region=us-east-1#dashboards:name=cmaq-us-east-1">Cloudwatch Dashboard</a>

<a href="https://aws.amazon.com/blogs/compute/monitoring-dashboard-for-aws-parallelcluster/">Monitoring Dashboard for ParallelCluster</a>

Check the timings while the job is still running using the following command

`cd /fsx/data/output/output_v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_2x96_classic/`

`grep 'Processing completed' CTM_LOG_001*`

Output:

```
            Processing completed...       6.3736 seconds
            Processing completed...       5.0755 seconds
            Processing completed...       5.1098 seconds
```

When the job has completed, use tail to view the timing from the log file.

`cd /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/`

`tail run_cctm5.4+_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.192.16x12pe.2day.20171222start.2x96.log`

Output:

```
==================================
  ***** CMAQ TIMING REPORT *****
==================================
Start Day: 2017-12-22
End Day:   2017-12-23
Number of Simulation Days: 2
Domain Name:               12US1
Number of Grid Cells:      4803435  (ROW x COL x LAY)
Number of Layers:          35
Number of Processes:       192
   All times are in seconds.

Num  Day        Wall Time
01   2017-12-22   1853.4
02   2017-12-23   2035.1
     Total Time = 3888.50
      Avg. Time = 1944.25
```

## Submit a request for a 96 pe job ( 1 x 96 pe) or 1 nodes instead of 2 nodes

`sbatch run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.1x96.ncclassic.csh`

Check on the status in the queue

`squeue -u ubuntu`

Note, it takes about 5 minutes for the compute nodes to be initialized, once the job is running the ST or status will change from CF (configure) to R

Output:

```
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 4    queue1     CMAQ   ubuntu  R       7:20      1 queue1-dy-compute-resource-1-3
```

Check the status of the run

`tail run_cctm5.4+_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.96.12x8pe.2day.20171222start.1x96.log`

The 96 pe job should take 104 minutes to run (52 minutes per day)
Note, this is a different domain (12US1 versus 12US2) than what was used for the HPC6a.48xlarge Benchmark runs, so the timings are not directly comparible.
The 12US1 domain is larger than 12US2.

'12US1'
'LAM_40N97W'  -2556000.   -1728000.   12000.  12000.  459  299    1



Check whether the scheduler thinks there are cpus or vcpus

`sinfo -lN`

Output:

```
Wed Jun 14 00:49:36 2023
NODELIST                         NODES PARTITION       STATE CPUS    S:C:T MEMORY TMP_DISK WEIGHT AVAIL_FE REASON              
queue1-dy-compute-resource-1-1       1   queue1*   allocated 96     96:1:1 373555        0      1 dynamic, none                
queue1-dy-compute-resource-1-2       1   queue1*   allocated 96     96:1:1 373555        0      1 dynamic, none                
queue1-dy-compute-resource-1-3       1   queue1*       idle~ 96     96:1:1 373555        0      1 dynamic, none                
queue1-dy-compute-resource-1-4       1   queue1*       idle~ 96     96:1:1 373555        0      1 dynamic, none                
queue1-dy-compute-resource-1-5       1   queue1*       idle~ 96     96:1:1 373555        0      1 dynamic, none                
queue1-dy-compute-resource-1-6       1   queue1*       idle~ 96     96:1:1 373555        0      1 dynamic, none                
queue1-dy-compute-resource-1-7       1   queue1*       idle~ 96     96:1:1 373555        0      1 dynamic, none                
queue1-dy-compute-resource-1-8       1   queue1*       idle~ 96     96:1:1 373555        0      1 dynamic, none                
queue1-dy-compute-resource-1-9       1   queue1*       idle~ 96     96:1:1 373555        0      1 dynamic, none                
queue1-dy-compute-resource-1-10      1   queue1*       idle~ 96     96:1:1 373555        0      1 dynamic, none      
```

Note: on a c6a.48xlarge, the number of virtual cpus is 192.

If the YAML contains the Compute Resources Setting of DisableSimultaneousMultithreading: false, then all 192 vcpus will be used

If DisableSimultaneousMultithreading: true, then the number of cpus is 96 and there are no virtual cpus.

Verify that the yaml file used DisableSimultaneousMultithreading: true

When the jobs are both submitted to the queue they will be dispatched to different compute nodes.

`squeue`

output

```
Submitted batch job 4
ip-10-0-1-243:/shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts> squeue
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 4    queue1     CMAQ   ubuntu CF       0:01      1 queue1-dy-compute-resource-1-3
                 3    queue1     CMAQ   ubuntu  R      21:28      2 queue1-dy-compute-resource-1-[1-2]
```

When the job has completed, use tail to view the timing from the log file.

`cd /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/`

`tail -n 30 run_cctm5.4+_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.96.12x8pe.2day.20171222start.1x96.log`

Output:

```
==================================
  ***** CMAQ TIMING REPORT *****
==================================
Start Day: 2017-12-22
End Day:   2017-12-23
Number of Simulation Days: 2
Domain Name:               12US1
Number of Grid Cells:      4803435  (ROW x COL x LAY)
Number of Layers:          35
Number of Processes:       96
   All times are in seconds.

Num  Day        Wall Time
01   2017-12-22   3153.2
02   2017-12-23   3485.9
     Total Time = 6639.10
      Avg. Time = 3319.55

```

Based on the Total Time, adding an additional node gave a speed-up of 1.7.
6639.10/3888.50 = 1.7074

## Submit a job to run on 288 pes, 3x96 nodes

`sbatch run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.3x96.ncclassic.csh`

Verify that it is running on 3 nodes

`sbatch`

output:

```
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 5    queue1     CMAQ   ubuntu  R       4:29      3 queue1-dy-compute-resource-1-[1-3]
```

Check the log for how quickly the job is running

`grep 'Processing completed'  run_cctm5.4+_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.288.18x16pe.2day.20171222start.3x96.log`

Output:

```
 Processing completed...       4.0245 seconds
            Processing completed...       4.0263 seconds
            Processing completed...       3.9885 seconds
            Processing completed...       3.9723 seconds
            Processing completed...       3.9934 seconds
            Processing completed...       4.0075 seconds
            Processing completed...       3.9871 seconds
```

When the job has completed, use tail to view the timing from the log file.

`cd /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/`

`tail -n 30 run_cctm5.4+_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.288.18x16pe.2day.20171222start.3x96.log`

Output:

```
==================================
  ***** CMAQ TIMING REPORT *****
==================================
Start Day: 2017-12-22
End Day:   2017-12-23
Number of Simulation Days: 2
Domain Name:               12US1
Number of Grid Cells:      4803435  (ROW x COL x LAY)
Number of Layers:          35
Number of Processes:       288
   All times are in seconds.

Num  Day        Wall Time
01   2017-12-22   1475.9
02   2017-12-23   1580.7
     Total Time = 3056.60
      Avg. Time = 1528.30
```


Once you have submitted a few benchmark runs and they have completed successfully, proceed to the next chapter.
