## Run CMAQ

### Verify that you have an updated set of run scripts from the pcluster-cmaq repo

`cd /shared/pcluster-cmaq/run_scripts/cmaqv54+/`

`ls -lrt  run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.2x96.ncclassic.csh`

`diff run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.2x96.ncclassic.csh /shared/pcluster-cmaq/run_scripts/cmaqv54+/`


If they don't exist or are not identical, then copy the run scripts from the repo

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
                 3    queue1     CMAQ   ubuntu  R       0:58      2 queue1-dy-compute-resource-1-[1-2]
```

The 192 pe job should take 60 minutes to run (30 minutes per day)

### check on the status of the cluster using CloudWatch

(optional)

```
<a href="https://console.aws.amazon.com/cloudwatch/home?region=us-east-1#dashboards:name=cmaq-us-east-1">Cloudwatch Dashboard</a>
<a href="https://aws.amazon.com/blogs/compute/monitoring-dashboard-for-aws-parallelcluster/">Monitoring Dashboard for ParallelCluster</a>
```

### check the timings while the job is still running using the following command

`cd /fsx/data/output/output_v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_2x96_classic/`

`grep 'Processing completed' CTM_LOG_001*`

Output:

```
            Processing completed...       6.3736 seconds
            Processing completed...       5.0755 seconds
            Processing completed...       5.1098 seconds
```

### When the job has completed, use tail to view the timing from the log file.

`cd /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/`

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

Note: on a c6a.24xlarge, the number of virtual cpus is 192.

If the YAML contains the Compute Resources Setting of DisableSimultaneousMultithreading: false, then all 192 vcpus will be used

If DisableSimultaneousMultithreading: true, then the number of cpus is 96 and there are no virtual cpus.

### edit run script to use

SBATCH --exclusive

### Verify that the yaml file used DisableSimultaneousMultithreading: true

Once you have submitted a few benchmark runs and they have completed successfully, proceed to the next chapter.
