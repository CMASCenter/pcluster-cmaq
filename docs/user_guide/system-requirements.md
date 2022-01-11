## System Requirements

### Software Requirements

* Git
* Compilers (C, C++, and Fortran)
   * GNU compilers version ≥ 8.3
* MPI (Message Passing Interface)
   * OpenMPI ≥ 3.0
* NetCDF (with C, C++, and Fortran support)
* I/O API



### Hardware Requirements

#### Recommended Minimum Requirements

The size of hardware depends on the domain size and resolution for  your CMAQ case, and how quickly your turn-around time is.
Larger hardware and memory is also required for instrumented versions of CMAQ incuding CMAQ-ISAM and CMAQ-DDM3D.


* c4.large instance running RHEL with 3.75 GiB memory, 500 Mbps Network Bandwidth and 2 virtual cpus is used for the CMAQ Training Case 

https://aws.amazon.com/blogs/aws/now-available-new-c4-instances/
The 12km case study has a ColxRowxLayer = 67x59x35 and takes 2 hours to complete.


#### Recommended Parallel Cluster Requirement for CONUS Domain

* c5n.18xlarge running Ubuntu with 192 GiB memory, 14 Gbps EBS Bandwidth, and 100 Gbps Network Bandwitdth

https://aws.amazon.com/blogs/aws/new-c5n-instances-with-100-gbps-networking/

| Instance Name	| vCPUs |  RAM      |  EBS Bandwidth	| Network Bandwidth | Linux On-Demand Price |
| ------------  | ----- | --------  | ---------------   | ---------------   | --------------------  |
| c4.large	| 2	| 3.75 GiB  |   Moderate	|  500 Mbps         | 	$0.116/hour         |
| c4.8xlarge	| 36	| 60 GiB    |	10 Gbps	        |  4,000 Mbps       | 	$1.856/hour         |
| c5n.large	| 2	| 5.25 GiB  |	Up to 3.5 Gbps	| Up to 25 Gbps     |   $0.108/hour         |
| c5n.xlarge	| 4	| 10.5 GiB  |	Up to 3.5 Gbps	| Up to 25 Gbps     |   $0.216/hour         |
| c5n.2xlarge	| 8	| 21 GiB    |	Up to 3.5 Gbps	| Up to 25 Gbps     |   $0.432/hour         |
| c5n.4xlarge	| 16	| 42 GiB    | 	3.5 Gbps	| Up to 25 Gbps     |   $0.864/hour         |
| c5n.9xlarge	| 36	| 96 GiB    |	7 Gbps	        | 50 Gbps           |   $1.944/hour         |
| c5n.18xlarge	| 72	| 192 GiB   |	14 Gbps	        | 100 Gbps          |   $3.888/hour         |


#### Performance of C5n.18xlarge Parallel Cluster for CONUS2 Domain

| Number of PEs | Number of Nodes| NPCOL x NPROW | 1st day Timing (sec) | 2nd day Timing (sec) | Total Time(2days) (sec)    | SBATCH --exclusive | Data Imported or Copied | DisableSimultaneousMultithreading(yaml)| Answers Matched |
|---------------| -----------    | ----------- | ----------     | --------------- | -------------------  | ------------------ | ----------  | --------- |   -------- |
| 180           |  5x36          | 10x18       | 2481.55        | 2225.34         |    4706.89           |  no                 | copied      |  false        |        |
| 180           |  5x36          | 10x18       | 2378.73        | 2378.73         |    4588.92           |  no                 | copied      |  true        | 10x18 did not match 16x18|
| 180           |  5x36          | 10x18       | 1585.67        | 1394.52         |    2980.19           |  yes                | imported    |  true        |            |
| 256           |  8x36          | 16x16       |  1289.59       | 1164.53         |    2454.12           |  no                 |  copied           |  true    |            |
| 256           |  8x36          | 16x16       |  1305.99       | 1165.30         |    2471.29           |  no                |   copied    |   true    |            |
| 256           |  8x36          | 16x16       |  1564.90       | 1381.80         |    2946.70           |  no                |   imported  | true   |            |
| 288           |  8x36          | 16x18       | 1873.00        | 1699.24         |     3572.2           |  no                |  copied     |    false       |            |
| 288           |  8x36          |  16x18      |  1976.35       | 1871.61         |     3847.96          |  no                |  Copied     |  true         |            |
| 288           |  8x36          | 16x18       |  1197.19       | 1090.45         |     2287.64          |  yes               |  Copied     |  true         |             16x18 matched 16x16 |
| 288           |  8x36          | 18x16       | 1206.01        | 1095.76         |     2301.77          |  yes               |  imported   |  true        |             |



