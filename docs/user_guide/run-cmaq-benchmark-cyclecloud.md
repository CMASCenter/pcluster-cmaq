### Copy the run scripts from the parallel_cluster repo
To ensure you have the correct directory specified

`cd /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts`

`cp * /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/`


### Run the CONUS Domain on 180 pes

`cd /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/`

`sbatch run_cctm_2016_12US2.180pe.csh`

Note, it will take about 3-5 minutes for the compute notes to start up This is reflected in the Status (ST) of PD (pending), with the NODELIST reason being that it is configuring the partitions for the cluster

### Check the status in the queue

`squeue `

output:

```
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 1       hpc     CMAQ     chef CF       0:22      1 cmaq-hbv3-hpc-pg0-[1-2]
```
After 5 minutes the status will change once the compute nodes have been created and the job is running

`squeue `

output:

```
JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 2       hpc     CMAQ     chef  R      58:42      2 cmaq-hbv3-hpc-pg0-[1-2]
```

The 180 pe job should take 60 minutes to run (30 minutes per day)


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

### Submit a request for a 270 pe job ( 3 x 90 pe)  

`sbatch scripts/run_cctm_2016_12US2.270pe.3x90.csh`

### Check on the status in the queue

`squeue`


### Check the timing after the run completes

`tail -n 50 run_cctmv5.3.3_Bench_2016_12US2.15x18pe.2day.log`

output

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
Number of Processes:       270
   All times are in seconds.

Num  Day        Wall Time
01   2015-12-22   1703.19
02   2015-12-23   1494.17
     Total Time = 3197.36
      Avg. Time = 1598.68

```


### Check whether the scheduler thinks there are cpus or vcpus

`sinfo -lN`

output:

```
Thu Feb 17 14:53:19 2022
NODELIST             NODES PARTITION       STATE CPUS    S:C:T MEMORY TMP_DISK WEIGHT AVAIL_FE REASON              
cmaq-hbv3-hpc-pg0-1      1      hpc*       idle% 120   120:1:1 435814        0      1    cloud none                
cmaq-hbv3-hpc-pg0-2      1      hpc*       idle% 120   120:1:1 435814        0      1    cloud none                
cmaq-hbv3-hpc-pg0-3      1      hpc*       idle% 120   120:1:1 435814        0      1    cloud none                
cmaq-hbv3-htc-1          1       htc       idle~ 1       1:1:2   3072        0      1    cloud none           
```


### After run has successfully completed

1. [Compare timings and verify that the run completed successfully](parse_timing.md)
2. [Run combine and post processing scripts](post_combine.md)
3. [Run QA scripts](qa_cmaq_run.md)
4. [Copy the output to the S3 Bucket](copy_output_to_S3_Bucket.md)
5. Exit the cluster
6. Delete the Cluster

