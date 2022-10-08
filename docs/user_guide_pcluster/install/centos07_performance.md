### Submit a 180 pe job

`sbatch run_cctm_2016_12US2.180pe.5x36.pcluster.csh`

`tail -n 50 run_cctmv5.3.3_Bench_2016_12US2.10x18pe.2day.pcluster.log`

Output:

```
CMAQ Processing of Day 20151223 Finished at Tue Feb 22 22:54:32 UTC 2022

\\\\\=====\\\\\=====\\\\\=====\\\\\=====/////=====/////=====/////=====/////


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
01   2015-12-22   2241.14
02   2015-12-23   1963.18
     Total Time = 4204.32
      Avg. Time = 2102.16

```
Question - is this performance poor due to using Centos7 and the older gcc compiler?

`gcc --version`

Output:

```
gcc (GCC) 4.8.5 20150623 (Red Hat 4.8.5-44)
Copyright (C) 2015 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```
Only reason that I switched to centos7 over ubuntu2004 is that when I tried to create a ParallelCluster with ubuntu2004 on Feb. 22, 2022, I could not find slurm or sbatch, so I could notsubmit jobs to the queue. (I had not run into this previously, when I saved the EBS Snapshot as encrypted.


### Submit a 288 pe job

`sbatch run_cctm_2016_12US2.288pe.8x36.pcluster.csh`


`tail -n 50 run_cctmv5.3.3_Bench_2016_12US2.16x18pe.2day.pcluster.log`

```
==============================
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
01   2015-12-22   1524.55
02   2015-12-23   1362.90
     Total Time = 2887.45
      Avg. Time = 1443.72

```

