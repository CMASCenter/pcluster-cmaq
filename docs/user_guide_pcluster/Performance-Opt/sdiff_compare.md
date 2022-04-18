## Side by Side Comparison of the information in the log files for 12x9 pe run compared to 9x12 pe run.

`cd /shared/pcluster-cmaq/c5n.18xlarge_scripts_logs`

`sdiff run_cctmv5.3.3_Bench_2016_12US2.108.12x9pe.2day.pcluster.log run_cctmv5.3.3_Bench_2016_12US2.108.9x12pe.2day.pcluster.log | more`

Output:

```
Start Model Run At  Fri Feb 25 20:48:42 UTC 2022	      |	Start Model Run At  Thu Feb 24 01:04:42 UTC 2022
information about processor including whether using hyperthre	information about processor including whether using hyperthre
Architecture:                    x86_64				Architecture:                    x86_64
CPU op-mode(s):                  32-bit, 64-bit			CPU op-mode(s):                  32-bit, 64-bit
Byte Order:                      Little Endian			Byte Order:                      Little Endian
Address sizes:                   46 bits physical, 48 bits vi	Address sizes:                   46 bits physical, 48 bits vi
CPU(s):                          36				CPU(s):                          36
On-line CPU(s) list:             0-35				On-line CPU(s) list:             0-35
Thread(s) per core:              1				Thread(s) per core:              1
Core(s) per socket:              18				Core(s) per socket:              18
Socket(s):                       2				Socket(s):                       2
NUMA node(s):                    2				NUMA node(s):                    2
Vendor ID:                       GenuineIntel			Vendor ID:                       GenuineIntel
CPU family:                      6				CPU family:                      6
Model:                           85				Model:                           85
Model name:                      Intel(R) Xeon(R) Platinum 81	Model name:                      Intel(R) Xeon(R) Platinum 81
Stepping:                        4				Stepping:                        4
CPU MHz:                         2887.020		      |	CPU MHz:                         2999.996
BogoMIPS:                        5999.98		      |	BogoMIPS:                        5999.99
Hypervisor vendor:               KVM				Hypervisor vendor:               KVM
Virtualization type:             full				Virtualization type:             full
L1d cache:                       1.1 MiB			L1d cache:                       1.1 MiB
L1i cache:                       1.1 MiB			L1i cache:                       1.1 MiB
L2 cache:                        36 MiB				L2 cache:                        36 MiB
L3 cache:                        49.5 MiB			L3 cache:                        49.5 MiB
NUMA node0 CPU(s):               0-17				NUMA node0 CPU(s):               0-17
NUMA node1 CPU(s):               18-35				NUMA node1 CPU(s):               18-35

     ===========================================		     ===========================================
     |>---   ENVIRONMENT VARIABLE REPORT   ---<|		     |>---   ENVIRONMENT VARIABLE REPORT   ---<|
     ===========================================		     ===========================================

     |> Grid and High-Level Model Parameters:			     |> Grid and High-Level Model Parameters:
     +=========================================			     +=========================================
      --Env Variable-- | --Value--				      --Env Variable-- | --Value--
      -------------------------------------------------------	      -------------------------------------------------------
             BLD  |             (default)			             BLD  |             (default)
          OUTDIR  |  /fsx/data/output/output_CCTM_v533_gcc_20 |	          OUTDIR  |  /fsx/data/output/output_CCTM_v533_gcc_20
       NEW_START  |          T					       NEW_START  |          T
  ISAM_NEW_START  |  Y (default)				  ISAM_NEW_START  |  Y (default)
       GRID_NAME  |  12US2					       GRID_NAME  |  12US2
       CTM_TSTEP  |       10000					       CTM_TSTEP  |       10000
      CTM_RUNLEN  |      240000					      CTM_RUNLEN  |      240000
    CTM_PROGNAME  |  DRIVER (default)				    CTM_PROGNAME  |  DRIVER (default)
      CTM_STDATE  |     2015356					      CTM_STDATE  |     2015356
      CTM_STTIME  |           0					      CTM_STTIME  |           0
     NPCOL_NPROW  |  12 9				      |	     NPCOL_NPROW  |  9 12
     CTM_MAXSYNC  |         300					     CTM_MAXSYNC  |         300



==================================				==================================
  ***** CMAQ TIMING REPORT *****				  ***** CMAQ TIMING REPORT *****
==================================				==================================
Start Day: 2015-12-22						Start Day: 2015-12-22
End Day:   2015-12-23						End Day:   2015-12-23
Number of Simulation Days: 2					Number of Simulation Days: 2
Domain Name:               12US2				Domain Name:               12US2
Number of Grid Cells:      3409560  (ROW x COL x LAY)		Number of Grid Cells:      3409560  (ROW x COL x LAY)
Number of Layers:          35					Number of Layers:          35
Number of Processes:       108					Number of Processes:       108
   All times are in seconds.					   All times are in seconds.

Num  Day        Wall Time					Num  Day        Wall Time
01   2015-12-22   2758.01				      |	01   2015-12-22   2454.11
02   2015-12-23   2370.92				      |	02   2015-12-23   2142.11
     Total Time = 5128.93				      |	     Total Time = 4596.22
      Avg. Time = 2564.46				      |	      Avg. Time = 2298.11


```
