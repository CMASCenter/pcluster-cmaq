## Run CMAQ

### Verify that you have an updated set of run scripts from the pcluster-cmaq repo
To ensure you have the correct directory specified

`cd /shared/pcluster-cmaq/run_scripts/cmaqv54+/`

`ls -lrt  run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.2x96.ncclassic.csh 


If they are not identical, then copy the set from the repo

`cp /shared/pcluster-cmaq/run_scripts/cmaqv54+/run_cctm* /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/`


### Verify that the input data is imported to /fsx from the S3 Bucket

`cd /fsx/data/CMAQ_Modeling_Platform_2018/2018_12US1`


### Create the output directory

`mkdir -p /fsx/data/output`


### Run the 12US1 Domain on 192 pes

`cd /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/`

`sbatch run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.2x96.ncclassic.csh`

Note, it will take about 3-5 minutes for the compute notes to start up. This is reflected in the Status (ST) of CF (configuring)

### Check the status in the queue

`squeue -u ubuntu`

Output:

```
JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 2    queue1     CMAQ   ubuntu CF       3:00      5 queue1-dy-computeresource1-[1-5]
```
After 5 minutes the status will change once the compute nodes have been created and the job is running

`squeue -u ubuntu`

Output:

```

             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 2   compute     CMAQ   ubuntu  R      16:50      5 compute-dy-c5n18xlarge-[1-5]
```

The 180 pe job should take 60 minutes to run (30 minutes per day)

### check on the status of the cluster using CloudWatch

(optional)

```
<a href="https://console.aws.amazon.com/cloudwatch/home?region=us-east-1#dashboards:name=cmaq-us-east-1">Cloudwatch Dashboard</a>
<a href="https://aws.amazon.com/blogs/compute/monitoring-dashboard-for-aws-parallelcluster/">Monitoring Dashboard for ParallelCluster</a>
```

### check the timings while the job is still running using the following command

`cd /fsx/data/output/output_v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_2x96_classic/LOGS`

`grep 'Processing completed' CTM_LOG_001*`

Output:

```
            Processing completed...    8.8 seconds
            Processing completed...    7.4 seconds
```

### When the job has completed, use tail to view the timing from the log file.

`tail run_cctm5.4+_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.192.16x12pe.2day.20171222start.2x96.log

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
01   2015-12-22   2481.55
02   2015-12-23   2225.34
     Total Time = 4706.89
      Avg. Time = 2353.44
```

### Submit a request for a 96 pe job ( 1 x 96 pe) or 1 nodes instead of 2 nodes

`sbatch run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.1x96.ncclassic.csh`

### Check on the status in the queue

`squeue -u ubuntu`

Note, it takes about 5 minutes for the compute nodes to be initialized, once the job is running the ST or status will change from CF (configure) to R

Output:

```
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 6    queue1     CMAQ   ubuntu  R      24:57      8 queue1-dy-computeresource1-[1-8]
```

### Check the status of the run

`tail CTM_LOG_025.v533_gcc_2016_CONUS_16x18pe_20151222`

### Check whether the scheduler thinks there are cpus or vcpus

`sinfo -lN`

Output:

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

Note: on a c5n.18xlarge, the number of virtual cpus is 72.

If the YAML contains the Compute Resources Setting of DisableSimultaneousMultithreading: false, then all 72 vcpus will be used

If DisableSimultaneousMultithreading: true, then the number of cpus is 36 and there are no virtual cpus.

### edit run script to use

SBATCH --exclusive

### Edit the yaml file to use DisableSimultaneousMultithreading: true

### Confirm that there are only 36 cpus available to the slurm scheduler

`sinfo -lN`

Output:

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


### Submit a request for a 288 pe job ( 8 x 36 pe) or 8 nodes instead of 10 nodes with full output

`sbatch run_cctm_2016_12US2.288pe.full.pcluster.csh`

`squeue -u ubuntu`

Output:

```
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 7    queue1     CMAQ   ubuntu CF       3:06      8 queue1-dy-computeresource1-[1-8]
```

Note, it takes about 5 minutes for the compute nodes to be initialized, once the job is running the ST or status will change from CF (configure) to R

`squeue -u ubuntu`

Output:

```
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 7    queue1     CMAQ   ubuntu  R      24:57      8 queue1-dy-computeresource1-[1-8]
```

### Check the status of the run

`tail CTM_LOG_025.v533_gcc_2016_CONUS_16x18pe_full_20151222`

Once you have submitted a few benchmark runs and they have completed successfully, proceed to the next chapter.
