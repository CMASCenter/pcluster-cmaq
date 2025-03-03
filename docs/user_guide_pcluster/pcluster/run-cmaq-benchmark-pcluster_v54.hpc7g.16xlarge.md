# Run CMAQ on hpc7g.16xlarge

## Login to cluster
```{note}
Replace the your-key.pem with your Key Pair.
```

```
pcluster ssh -v -Y -i ~/your-key.pem --region=us-east-1 --cluster-name cmaq
```

Check to make sure elastic network adapter (ENA) is enabled

```
modinfo ena
lspci
```

Verify the gcc compiler version is greater than 8.0

```
gcc --version
```

output:

gcc (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0
Copyright (C) 2019 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.


Change default shell to .tcsh

```
sudo usermod -s /bin/tcsh ubuntu
```

Copy file to .cshrc

```
cp /shared/pcluster-cmaq/install/dot.cshrc.pcluster ~/.cshrc
```

Note that the .cshrc to add custom module path

```
module use --append /shared/build/Modules/modulefiles
```

Change shell to csh

logout and log back in to switch to the default shell

Use module list and then module load to load the libraries

```
module load netcdf-4.8.1/gcc-9.5  ioapi-3.2/gcc-9.5-netcdf libfabric-aws
```


Description of the hpc7g.16xlarge instance:


Instance Size 	Physical Cores 	Memory (GiB) 	Instance Storage 	EFA Network Bandwidth (Gbps) 	Network Bandwidth (Gbps)*
hpc7g.16xlarge  64              128             EBS-only                200                                 25


Verify that you have an updated set of run scripts from the pcluster-cmaq repo

```
cd /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts
ls -lrt  run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.2x64.ncclassic.csh
```


If they don't exist or are not identical, then copy the run scripts from the repo

```
cd /shared/pcluster-cmaq
git pull
cp /shared/pcluster-cmaq/run_scripts/hpc7g.16xlarge/run_cctm* /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/
```


Verify that the input data is imported to /fsx from the S3 Bucket

```
cd /fsx/
```

## Preloading the files

Amazon FSx copies data from your Amazon S3 data repository when a file is first accessed.
CMAQ is sensitive to latencies, so it is best to preload contents of individual files or directories using the following command:

```
nohup find /fsx/ -type f -print0 | xargs -0 -n 1 sudo lfs hsm_restore &
```

Create a directory that specifies the full path that the run scripts are expecting.

```
mkdir -p /fsx/data/CMAQ_Modeling_Platform_2018/
```

Link the 2018_12US1 directoy

```
cd /fsx/data/CMAQ_Modeling_Platform_2018/
ln -s /fsx/CMAQv5.4_2018_12US1_Benchmark_2Day_Input/2018_12US1/ .
```

Link the 12LISTOS_Training data

```
cd /fsx/data/
ln -s /fsx/CMAQv5.4_2018_12LISTOS_Benchmark_3Day_Input/12LISTOS_Training ./12US1_LISTOS
```

Link the 2018_12NE3 Benchmark data

```
ln -s /fsx/CMAQv5.4_2018_12NE3_Benchmark_2Day_Input/2018_12NE3 .
```


netCDF-3 classic input files are used

The *.nc4 compressed netCDF4 files on /fsx input directory were converted to netCDF classic (nc3) files



Create the output directory`

```
mkdir -p /fsx/data/output
```


Note, that the 12US1 Domain will not run on 64 cores using the hpc7g.16xlarge, as it doesn't have enough memory per node.
It is possible to run on 64 cores using the hpc7g.8xlarge using 2 x 32 cores per node (as there is more memory per core).


## Run the 12US1 Domain on 128 cores

```
cd /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/
sbatch run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.2x64.ncclassic.csh
```

Note, it will take about 3-5 minutes for the compute notes to start up. This is reflected in the Status (ST) of CF (configuring)


Check the status in the queue

```
squeue -u ubuntu`
```

Output:

```
JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 3    queue1     CMAQ   ubuntu  CF                2 queue1-dy-compute-resource-1-[1-2]
```
After 5 minutes the status will change once the compute nodes have been created and the job is running

```
squeue -u ubuntu
```

Output:

```
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 3    queue1     CMAQ   ubuntu  R       0:58      2 queue1-dy-compute-resource-1-[1-2]
```


Check on the status of the cluster using CloudWatch (optional)

<a href="https://console.aws.amazon.com/cloudwatch/home?region=us-east-1#dashboards:name=cmaq-us-east-1">Cloudwatch Dashboard</a>

<a href="https://aws.amazon.com/blogs/compute/monitoring-dashboard-for-aws-parallelcluster/">Monitoring Dashboard for ParallelCluster</a>

Check the timings while the job is still running using the following command

`cd /fsx/data/output/output_v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_2x64_classic/`

`grep 'Processing completed' CTM_LOG_001*`

Output:

```
            Processing completed...       7.4020 seconds
            Processing completed...       5.5893 seconds
            Processing completed...       5.5588 seconds
            Processing completed...       5.5470 seconds
            Processing completed...       5.5449 seconds
            Processing completed...       5.5105 seconds
            Processing completed...       5.5182 seconds
            Processing completed...       5.5343 seconds
            Processing completed...       5.5482 seconds
```

When the job has completed, use tail to view the timing from the log file.

`cd /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/`

`tail run_cctm5.4+_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.128.8x16pe.2day.20171222start.2x64.log`

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
Number of Processes:       128
   All times are in seconds.

Num  Day        Wall Time
01   2017-12-22   2074.2
02   2017-12-23   2298.9
     Total Time = 4373.10
      Avg. Time = 2186.55

```

Check whether the scheduler thinks there are cpus or vcpus

`sinfo -lN`

Output:

```
Thu Jun 29 22:31:30 2023
NODELIST                         NODES PARTITION       STATE CPUS    S:C:T MEMORY TMP_DISK WEIGHT AVAIL_FE REASON              
queue1-dy-compute-resource-1-1       1   queue1*   allocated 64     64:1:1 124518        0      1 dynamic, none                
queue1-dy-compute-resource-1-2       1   queue1*       idle~ 64     64:1:1 124518        0      1 dynamic, Scheduler health che
queue1-dy-compute-resource-1-3       1   queue1*   allocated 64     64:1:1 124518        0      1 dynamic, none                
queue1-dy-compute-resource-1-4       1   queue1*       idle~ 64     64:1:1 124518        0      1 dynamic, none                
queue1-dy-compute-resource-1-5       1   queue1*       idle~ 64     64:1:1 124518        0      1 dynamic, none                
queue1-dy-compute-resource-1-6       1   queue1*       idle~ 64     64:1:1 124518        0      1 dynamic, none                
queue1-dy-compute-resource-1-7       1   queue1*       idle~ 64     64:1:1 124518        0      1 dynamic, none                
queue1-dy-compute-resource-1-8       1   queue1*       idle~ 64     64:1:1 124518        0      1 dynamic, none                
queue1-dy-compute-resource-1-9       1   queue1*       idle~ 64     64:1:1 124518        0      1 dynamic, none                
queue1-dy-compute-resource-1-10      1   queue1*       idle~ 64     64:1:1 124518        0      1 dynamic, none                
queue1-dy-compute-resource-1-11      1   queue1*       idle~ 64     64:1:1 124518        0      1 dynamic, none                
queue1-dy-compute-resource-1-12      1   queue1*       idle~ 64     64:1:1 124518        0      1 dynamic, none      
```


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

Information about the error obtained when running on 1 node using hpc7g.16xlarge

1 pe job is dying, running out of memory, which means that the 12US1 case takes more than 128 GB of memory.

![top showing memory depleted just before job dies](../cmaqv54-cluster/top_just_before_1x64_hpc7g.16xlarge_dies.png )


<a href="https://aws.amazon.com/blogs/hpc/application-deep-dive-into-the-graviton3e-based-amazon-ec2-hpc7g-instance/">2 GB Memory per core for hpc7g.16xlarge</a>

`tail -n 30 run_cctm5.4+_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.64.8x8pe.2day.20171222start.1x64.log`

Output

```
a non-zero exit code. Per user-direction, the job has been aborted.
--------------------------------------------------------------------------
--------------------------------------------------------------------------
mpirun noticed that process rank 12 with PID 6866 on node queue1-dy-compute-resource-1-1 exited on signal 9 (Killed).
--------------------------------------------------------------------------
11.857u 17.117s 1:24.37 34.3%	0+0k 382640+17960io 4860pf+0w

**************************************************************
** Runscript Detected an Error: CGRID file was not written. **
**   This indicates that CMAQ was interrupted or an issue   **
**   exists with writing output. The runscript will now     **
**   abort rather than proceeding to subsequent days.       **
**************************************************************

==================================
  ***** CMAQ TIMING REPORT *****
==================================
Start Day: 2017-12-22
End Day:   2017-12-23
Number of Simulation Days: 1
Domain Name:               12US1
Number of Grid Cells:      4803435  (ROW x COL x LAY)
Number of Layers:          35
Number of Processes:       64
   All times are in seconds.

Num  Day        Wall Time
01   2017-12-22   12
     Total Time = 12.00
      Avg. Time = 12.00
```

`tail -n 30  CTM_LOG_012.v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_1x64_classic_20171222`
```
     File "OMI" opened for input on unit:  92
     /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/BLD_CCTM_v54+_gcc/OMI_1979_to_2019.dat

OMI Ozone column data has Lat by Lon Resolution:      17X     17
     Total column ozone will be interpolated to day 0:00:00   Dec. 22, 2017
     from data available on the OMI input file
```


Switched to running on more than one node c7g.8xlarge, and CMAQv5.4 ran successfully as it had access to more memory.

When the job has completed, use tail to view the timing from the log file.

`cd /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/`

`tail -n 30 run_cctm5.4+_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.256.16x16pe.2day.20171222start.4x64.log`

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
Number of Processes:       256
   All times are in seconds.

Num  Day        Wall Time
01   2017-12-22   1347.3
02   2017-12-23   1501.4
     Total Time = 2848.70
      Avg. Time = 1424.35


```

## Submit a job to run on 192 pes, 3x64 nodes

`sbatch run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.3x64.ncclassic.csh`

Verify that it is running on 3 nodes

`sbatch`

output:

```
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 5    queue1     CMAQ   ubuntu  R       4:29      3 queue1-dy-compute-resource-1-[1-3]
```

Check the log for how quickly the job is running

`grep 'Processing completed'  

Output:

```
```

When the job has completed, use tail to view the timing from the log file.

`cd /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/`

`tail -n 30 run_cctm5.4+_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.192.12x16pe.2day.20171222start.3x64.log`

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
01   2017-12-22   1617.1
02   2017-12-23   1755.3
     Total Time = 3372.40
      Avg. Time = 1686.20

```

## Submit a job to run on 320 pes running on 5 nodes

Output

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
Number of Processes:       320
   All times are in seconds.

Num  Day        Wall Time
01   2017-12-22   1177.0
02   2017-12-23   1266.6
     Total Time = 2443.60
      Avg. Time = 1221.80

```

## Submit a job to run on 128 cores  with 32 cores per node.
Running on  4x32 cores using the hpc7g.8xlarge instances

`sbatch  run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.4x32.ncclassic.csh -w queue1-dy-compute-resource-2[1-4]`


