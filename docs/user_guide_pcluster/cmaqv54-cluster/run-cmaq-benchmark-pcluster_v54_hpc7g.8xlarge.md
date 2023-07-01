## Run CMAQ using hpc7g.8xlarge compute nodes

### Verify that you have an updated set of run scripts from the pcluster-cmaq repo


### Run the 12US1 Domain on 32 pes on hpc7g.8xlarge

```
cd /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/

sbatch run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.1x32.ncclassic.c7g.8xlarge.csh`
```


### When the job has completed, use tail to view the timing from the log file.

`cd /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/`

`tail  run_cctm5.4+_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.32.4x8pe.2day.20171222start.1x32.hpc7g.8xlarge.log`

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
Number of Processes:       32
   All times are in seconds.

Num  Day        Wall Time
01   2017-12-22   6266.1
02   2017-12-23   6868.5
     Total Time = 13134.60
      Avg. Time = 6567.30
```

### Submit a request for a 64 pe job ( 2 x 32 pe) using 2 nodes on hpc7g.8xlarge

`sbatch run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.2x32.ncclassic.c7g.8xlarge.csh`

### Check on the status in the queue

`squeue -u ubuntu`

Note, it takes about 5 minutes for the compute nodes to be initialized, once the job is running the ST or status will change from CF (configure) to R

Output:

```
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 4    queue1     CMAQ   ubuntu  R    1:11:48      2 queue1-dy-compute-resource-2-[3-4]

```

### Check the status of the run

`tail run_cctm5.4+_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.64.8x8pe.2day.20171222start.2x32.hpc7g.8xlarge.log`

The 64 pe job should take xx minutes to run (xx minutes per day)


### Check whether the scheduler thinks there are cpus or vcpus

`sinfo -lN`

Output:

```
Fri Jun 30 16:39:48 2023
NODELIST                         NODES PARTITION       STATE CPUS    S:C:T MEMORY TMP_DISK WEIGHT AVAIL_FE REASON              
NODELIST                        NODES PARTITION       STATE CPUS    S:C:T MEMORY TMP_DISK WEIGHT AVAIL_FE REASON              
queue1-dy-compute-resource-1-1      1   queue1*       idle~ 64     64:1:1 124518        0      1 dynamic, none                
queue1-dy-compute-resource-1-2      1   queue1*       idle~ 64     64:1:1 124518        0      1 dynamic, none                
queue1-dy-compute-resource-1-3      1   queue1*       idle~ 64     64:1:1 124518        0      1 dynamic, none                
queue1-dy-compute-resource-1-4      1   queue1*       idle~ 64     64:1:1 124518        0      1 dynamic, none                
queue1-dy-compute-resource-1-5      1   queue1*       idle~ 64     64:1:1 124518        0      1 dynamic, none                
queue1-dy-compute-resource-2-1      1   queue1*       idle~ 32     32:1:1 124518        0      1 dynamic, none                
queue1-dy-compute-resource-2-2      1   queue1*       idle~ 32     32:1:1 124518        0      1 dynamic, none                
queue1-dy-compute-resource-2-3      1   queue1*   allocated 32     32:1:1 124518        0      1 dynamic, none                
queue1-dy-compute-resource-2-4      1   queue1*   allocated 32     32:1:1 124518        0      1 dynamic, none                
queue1-dy-compute-resource-2-5      1   queue1*   allocated 32     32:1:1 124518        0      1 dynamic, none                
queue1-dy-compute-resource-2-6      1   queue1*   allocated 32     32:1:1 124518        0      1 dynamic, none                
queue1-dy-compute-resource-2-7      1   queue1*   allocated 32     32:1:1 124518        0      1 dynamic, none            
```

### When multiple jobs are submitted to the queue they will be dispatched to different compute nodes.

`squeue`

output

```
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 4    queue1     CMAQ   ubuntu  R    1:13:21      2 queue1-dy-compute-resource-2-[3-4]
                 7    queue1     CMAQ   ubuntu  R      57:51      3 queue1-dy-compute-resource-2-[5-7]

```

### When the job has completed, use tail to view the timing from the log file.

`cd /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/`

`tail run_cctm5.4+_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.64.8x8pe.2day.20171222start.2x32.hpc7g.8xlarge.log`

Output:

```

```

Based on the Total Time, adding an additional node gave a speed-up of 2.129
xx/xx = xx

### Submit a job to run on 96 cores, 3x32 nodes on hpc7g.8xlarge

`sbatch run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.3x32.ncclassic.c7g.8xlarge.csh`

### Verify that it is running on 3 nodes

`sbatch`

output:

```
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 7    queue1     CMAQ   ubuntu  R      59:47      3 queue1-dy-compute-resource-2-[5-7]
```

### Check the log for how quickly the job is running

`grep 'Processing completed' `run_cctm5.4+_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.64.12x8pe.2day.20171222start.3x32.hpc7g.8xlarge.log

Output:

```
            Processing completed...       5.6952 seconds
            Processing completed...       8.3384 seconds
            Processing completed...       8.2416 seconds
            Processing completed...       5.7230 seconds
            Processing completed...       5.6911 seconds
```

When the job has completed, use tail to view the timing from the log file.

`cd /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/`

`tail -n 20 run_cctm5.4+_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.64.12x8pe.2day.20171222start.3x32.hpc7g.8xlarge.log`

Output:

```


```

Based on the Total Time, adding 2 additional nodes gave a speed-up of 3.05
xxx/xxx = 3.05



Once you have submitted a few benchmark runs and they have completed successfully, proceed to the next chapter.
