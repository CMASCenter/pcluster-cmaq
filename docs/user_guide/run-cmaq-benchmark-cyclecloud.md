### Copy the run scripts from the parallel_cluster repo
To ensure you have the correct directory specified

`cd /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts`

`cp * /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/`


### Run the CONUS Domain on 180 pes

`cd /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/`

`sbatch run_cctm_2016_12US2.180pe.csh`

Note, it will take about 3-5 minutes for the compute notes to start up This is reflected in the Status (ST) of PD (pending), with the NODELIST reason being that it is configuring the partitions for the cluster

### Check the status in the queue

`squeue -u lizadams`

output:

```
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 2       hpc     CMAQ lizadams PD       0:00      5 (PartitionConfig)
```
After 5 minutes the status will change once the compute nodes have been created and the job is running

`squeue `

output:

```
JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 2       hpc     CMAQ     chef  R      58:42      2 cmaq-hbv3-hpc-pg0-[1-2]
```

The 180 pe job should take 60 minutes to run (30 minutes per day)

### check on the status of the cluster using CloudWatch

```
<a href="https://console.aws.amazon.com/cloudwatch/home?region=us-east-1#dashboards:name=cmaq-us-east-1">Cloudwatch Dashboard</a>
<a href="https://aws.amazon.com/blogs/compute/monitoring-dashboard-for-aws-parallelcluster/">Monitoring Dashboard for P=arallel Cluster</a>
```

### check the timings while the job is still running using the following command

`grep 'Processing completed' CTM_LOG_001*`

output:

```
   Processing completed...    4.6 seconds
            Processing completed...    4.8 seconds
            Processing completed...    4.8 seconds
            Processing completed...    5.2 seconds
            Processing completed...    4.4 seconds
            Processing completed...    5.0 seconds
            Processing completed...    4.6 seconds
            Processing completed...    4.7 seconds
            Processing completed...    4.7 seconds
            Processing completed...    5.1 seconds

```

### When the job has completed, use tail to view the timing from the log file.

`tail /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/run_cctmv5.3.3_Bench_2016_12US2.10x18pe.2day.log `

output:

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
01   2015-12-22   2481.55
02   2015-12-23   2225.34
     Total Time = 4706.89
      Avg. Time = 2353.44
```

### Submit a request for a 288 pe job ( 8 x 36 pe) or 8 nodes instead of 10 nodes

`sbatch run_cctm_2016_12US2.288pe.csh`

### Check on the status in the queue

`squeue -u ubuntu`

Note, it takes about 5 minutes for the compute nodes to be initialized, once the job is running the ST or status will change from CF (configure) to R

output:

```
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 7    queue1     CMAQ   ubuntu  R      24:57      8 queue1-dy-computeresource1-[1-8]
```

### Check the status of the run

`tail CTM_LOG_025.v533_gcc_2016_CONUS_16x18pe_20151222`

output

```
Number of Grid Cells:      3409560  (ROW x COL x LAY)
Number of Layers:          35
Number of Processes:       180
   All times are in seconds.

Num  Day        Wall Time
01   2015-12-22   2097.37
02   2015-12-23   1809.84
     Total Time = 3907.21
      Avg. Time = 1953.60
```


### Check whether the scheduler thinks there are cpus or vcpus

`sinfo -lN`

output:

```
Wed Jan 05 19:34:05 2022
NODELIST                       NODES PARTITION       STATE CPUS    S:C:T MEMORY TMP_DISK WEIGHT AVAIL_FE REASON
queue1-dy-computeresource1-1       1   queue1*       mixed 72     72:1:1      1        0      1 dynamic, none
queue1-dy-computeresource1-2       1   queue1*       mixed 72     72:1:1      1        0      1 dynamic, none
queue1-dy-computeresource1-3       1   queue1*       mixed 72     72:1:1      1        0      1 dynamic, none
queue1-dy-computeresource1-4       1   queue1*       mixed 72     72:1:1      1        0      1 dynamic, none
queue1-dy-computeresource1-5       1   queue1*       mixed 72     72:1:1      1        0      1 dynamic, none
queue1-dy-computeresource1-6       1   queue1*       mixed 72     72:1:1      1        0      1 dynamic, none
queue1-dy-computeresource1-7       1   queue1*       mixed 72     72:1:1      1        0      1 dynamic, none
queue1-dy-computeresource1-8       1   queue1*       mixed 72     72:1:1      1        0      1 dynamic, none
queue1-dy-computeresource1-9       1   queue1*       idle~ 72     72:1:1      1        0      1 dynamic, Scheduler health che
queue1-dy-computeresource1-10      1   queue1*       idle~ 72     72:1:1      1        0      1 dynamic, Scheduler health che
```

Note: on a c5n.18xlarge, the number of virtual cpus is 72, if the yaml contains the Compute Resources Setting of DisableSimultaneousMultithreading: false
If DisableSimultaneousMultithreading: true, then the number of cpus is 36 and there are no virtual cpus.

### edit run script to use
SBATCH --exclusive

### Confirm that there are only 36 cpus available to the slurm scheduler

`sinfo -lN`

output:

```
Wed Jan 05 20:54:01 2022
NODELIST                       NODES PARTITION       STATE CPUS    S:C:T MEMORY TMP_DISK WEIGHT AVAIL_FE REASON
queue1-dy-computeresource1-1       1   queue1*       idle~ 36     36:1:1      1        0      1 dynamic, none
queue1-dy-computeresource1-2       1   queue1*       idle~ 36     36:1:1      1        0      1 dynamic, none
queue1-dy-computeresource1-3       1   queue1*       idle~ 36     36:1:1      1        0      1 dynamic, none
queue1-dy-computeresource1-4       1   queue1*       idle~ 36     36:1:1      1        0      1 dynamic, none
queue1-dy-computeresource1-5       1   queue1*       idle~ 36     36:1:1      1        0      1 dynamic, none
queue1-dy-computeresource1-6       1   queue1*       idle~ 36     36:1:1      1        0      1 dynamic, none
queue1-dy-computeresource1-7       1   queue1*       idle~ 36     36:1:1      1        0      1 dynamic, none
queue1-dy-computeresource1-8       1   queue1*       idle~ 36     36:1:1      1        0      1 dynamic, none
queue1-dy-computeresource1-9       1   queue1*       idle~ 36     36:1:1      1        0      1 dynamic, none
queue1-dy-computeresource1-10      1   queue1*       idle~ 36     36:1:1      1        0      1 dynamic, none
```

### Re-run the CMAQ CONUS Case

`cd /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/`

`sbatch run_cctm_2016_12US2.288pe.csh`

### Submit a request for a 288 pe job ( 8 x 36 pe) or 8 nodes instead of 10 nodes

`sbatch run_cctm_2016_12US2.288pe.csh`

`squeue -u ubuntu`

output:

```
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 7    queue1     CMAQ   ubuntu CF       3:06      8 queue1-dy-computeresource1-[1-8]
```

Note, it takes about 5 minutes for the compute nodes to be initialized, once the job is running the ST or status will change from CF (configure) to R

`squeue -u ubuntu`

output:

```
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 7    queue1     CMAQ   ubuntu  R      24:57      8 queue1-dy-computeresource1-[1-8]
```

### Check the status of the run

`tail CTM_LOG_025.v533_gcc_2016_CONUS_16x18pe_20151222`

### After run has successfully completed

### After run has successfully completed

1. [Compare timings and verify that the run completed successfully](parse_timing.md)
2. [Run combine and post processing scripts](post_combine.md)
3. [Run QA scripts](qa_cmaq_run.md)
4. [Copy the output to the S3 Bucket](copy_output_to_S3_Bucket.md)
5. Exit the cluster
6. Delete the Cluster

