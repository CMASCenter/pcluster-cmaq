## Timing Information using C5n.18xlarge compute node

```{note}
The following jobs were submitted using different configuration options on the Parallel Cluster. The record of these jobs is included for you to review, but it is not required to re-submit all of these benchmarks as part of this tutorial.
```

`sbatch run_cctm_2016_12US2.108pe.3x36.pcluster.csh`

`grep -i 'Processing Completed' CTM_LOG_000.v533_gcc_2016_CONUS_9x12pe_20151222`

Output:

```
            Processing completed...    6.0 seconds
            Processing completed...    6.0 seconds
            Processing completed...    8.3 seconds
            Processing completed...    8.2 seconds
            Processing completed...    6.0 seconds
```

`tail -n 18 run_cctmv5.3.3_Bench_2016_12US2.108.9x12pe.2day.pcluster.log

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
Number of Processes:       108
   All times are in seconds.

Num  Day        Wall Time
01   2015-12-22   2454.11
02   2015-12-23   2142.11
     Total Time = 4596.22
      Avg. Time = 2298.11
```


108 pe run with NPCOL=6, NPROW=18 to compare with the following run:

```
run_cctm_2016_12US2.72pe.2x36.pcluster.csh:   @ NPCOL  =  6; @ NPROW = 12`
```

`sbatch run_cctm_2016_12US2.108pe.3x36.6x18.pcluster.csh`

Compare the answers using m3diff and verify that get matching answers if NPCOL for both runs is identical NPCOL=6.

Note that answers do not match if NPCOL was different, despite the removal of the -march=native compiler flag.

1. Do a make clean and rebuild
2. Rerun two cases with different values for NPCOL
3. Re-check the answers

Also run a case to verify that if NPCOL is identical than answers match.

`sbatch run_cctm_2016_12US2.108pe.3x36.6x18.pcluster.csh`

`tail -n 20 /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/run_cctmv5.3.3_Bench_2016_12US2.108.6x18pe.2day.pcluster.log`

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
Number of Processes:       108
   All times are in seconds.

Num  Day        Wall Time
01   2015-12-22   2415.37
02   2015-12-23   2122.62
     Total Time = 4537.99
      Avg. Time = 2268.99
```

Once that is done, save a snapshot of the volume prior to deleting the cluster, to update the run scripts.


Results from the Parallel Cluster Started with the pre-installed software with the input data copied to /fsx from S3 Bucket

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
Number of Processes:       256
   All times are in seconds.

Num  Day        Wall Time
01   2015-12-22   1305.99
02   2015-12-23   1165.30
     Total Time = 2471.29
      Avg. Time = 1235.64
```


Results from Parallel Cluster Started with the software with data imported from S3 Bucket to Lustre

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
Number of Processes:       256
   All times are in seconds.

Num  Day        Wall Time
01   2015-12-22   1564.90
02   2015-12-23   1381.80
     Total Time = 2946.70
      Avg. Time = 1473.35
```

Timing for a 288 pe run


`tail -n 18 run_cctmv5.3.3_Bench_2016_12US2.16x18pe.2day.log`

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


`tail -n 18 run_cctmv5.3.3_Bench_2016_12US2.10x18pe.2day.log`

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
## Submit a minimum of 2 benchmark runs 
Use two different NPCOLxNPROW configurations, to create output needed for the QA and Post Processing Sections in Chapter 6. 
