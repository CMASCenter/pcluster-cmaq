# Run CMAQv5.4 on c6a.2xlarge


In the last sections you created and logged into a VM (c6a.2xlarge EC2 instance) based on the public AMI.  Here you will use this VM to run a benchmark case for CMAQ version 5.4.  

1. Obtain the IP address for the VM from AWS Web Console or from using the following AWS CLI command (same steps as the end of section 1.1 and 1.2):

`aws ec2 describe-instances --region=us-east-1 --filters "Name=image-id,Values=ami-051ba52c157e4070c" | grep PublicIpAddress`

2. Use the IP address and your key pair to login to the EC2 instance.

`ssh -v -Y -i ~/downloads/your-pem.pem ubuntu@ip.address`

3. Login to the EC2 instance again, so that you have two windows logged into the machine.

`ssh -Y -i ~/downloads/your-pem.pem ubuntu@your-ip-address` 

4. Load the environment modules

`module avail`

`module load ioapi-3.2/gcc-11.3.0-netcdf  mpi/openmpi-4.1.2  netcdf-4.8.1/gcc-11.3 `

5. Verify that the input data for the benchmark is available.  The benchmark case (12US1_LISTOS) for this example is small with only 25 rows and 25 columns. The GRIDDESC file defines the modeling domain which has 12 km x 12km horizontal grid spacing and is centered over Long Island, New York and Connecticut.

`ls -lrt /shared/data/12US1_LISTOS/*`

```
-rw-rw-r-- 1 ubuntu ubuntu  207 Jun  6 20:05 /shared/data/12US1_LISTOS/GRIDDESC

/shared/data/12US1_LISTOS/emis:
total 28
drwxrwxr-x 2 ubuntu ubuntu 4096 Jun  6 20:19 cmv_c3
drwxrwxr-x 2 ubuntu ubuntu 4096 Jun  6 20:19 pt_oilgas
drwxrwxr-x 2 ubuntu ubuntu 4096 Jun  6 20:19 gridded
drwxrwxr-x 2 ubuntu ubuntu 4096 Jun  6 20:19 ptegu_nopfas
drwxrwxr-x 2 ubuntu ubuntu 4096 Jun  6 20:19 ptnonipm
drwxrwxr-x 2 ubuntu ubuntu 4096 Jun  6 20:19 smk_dates
drwxrwxr-x 2 ubuntu ubuntu 4096 Jun  6 20:19 ptnonipm_nopfas

/shared/data/12US1_LISTOS/met:
total 12
drwxrwxr-x 2 ubuntu ubuntu 4096 Jun  6 20:19 lightning
drwxrwxr-x 2 ubuntu ubuntu 4096 Jun  6 20:19 mcip
drwxrwxr-x 2 ubuntu ubuntu 4096 Jun  6 20:19 wrfout

/shared/data/12US1_LISTOS/icbc:
total 24976
-rw-rw-r-- 1 ubuntu ubuntu 21774044 Jun  6 20:05 ICON_v54_12km_Listos_profile_timeind.nc
-rw-rw-r-- 1 ubuntu ubuntu   109793 Jun  6 20:05 BCON_v54_12km_Listos_profile_timeind.nc.CO.txt
-rw-rw-r-- 1 ubuntu ubuntu  3683924 Jun  6 20:05 BCON_v54_12km_Listos_profile_timeind.nc
drwxrwxr-x 2 ubuntu ubuntu     4096 Jun  6 20:19 cb6r3_ae7_aq

/shared/data/12US1_LISTOS/surface:
total 2668
-rw-rw-r-- 1 ubuntu ubuntu 2199208 Jun  6 20:05 OCEAN_08_L3m_MC_CHL_chlor_a_12US1_Listos.nc3
-rw-rw-r-- 1 ubuntu ubuntu  363296 Jun  6 20:05 OCEAN_08_L3m_MC_CHL_chlor_a_12US1.nc
-rw-rw-r-- 1 ubuntu ubuntu  145796 Jun  6 20:05 GRIDMASK_STATES_12US1_m3clple_12listos.ncf
-rw-rw-r-- 1 ubuntu ubuntu   16452 Jun  6 20:05 12US1_surf_m3clple_12listos.ncf
```

`cat /shared/data/12US1_LISTOS/GRIDDESC`

```
GRIDDESC

'2018_12Listos'
'LamCon_40N_97W'   1812000.000    240000.000     12000.000     12000.000   25   25    1
```

6. Run the CMAQv5.4 12US1_LISTOS benchmark case for 3 days on 4 processors. There is no job scheduler (such as SLURM) installed on the AMI.  Submit the job using the command line: 

```
cd /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts
./run_cctm_2018_12US1_listos.csh | & tee ./run_cctm_2018_12US1_listos.c6a.2xlarge.log
```

7. Use HTOP to view performance. 

`htop`

Output:

![Screenshot of HTOP with hyperthreading off](htop_c6a.2xlarge_hyperthreading_off.png)


8. After the benchmark is complete, use the following command to view the timing results.

`tail -n 20 run_cctm_2018_12US1_listos.c6a.2xlarge.log`

```
==================================
  ***** CMAQ TIMING REPORT *****
==================================
Start Day: 2018-08-05
End Day:   2018-08-07
Number of Simulation Days: 3
Domain Name:               2018_12Listos
Number of Grid Cells:      21875  (ROW x COL x LAY)
Number of Layers:          35
Number of Processes:       4
   All times are in seconds.

Num  Day        Wall Time
01   2018-08-05   165.5
02   2018-08-06   165.8
03   2018-08-07   169.5
     Total Time = 500.80
      Avg. Time = 166.93
```

9. Use lscpu to view number of cores. Confirm that there are 4 cores on the c6a.2xlarge ec2 instance that was created with hyperthreading turned off (1 thread per core).  If the EC2 instance is configured to use 1 thread per core in the advanced setting, then it will have 4 cores. For MPI or parallel applications such as CMAQ it is best to turn off hyperthreading.

`lscpu`

Output:

```
lscpu
Architecture:            x86_64
  CPU op-mode(s):        32-bit, 64-bit
  Address sizes:         48 bits physical, 48 bits virtual
  Byte Order:            Little Endian
CPU(s):                  4
  On-line CPU(s) list:   0-3
Vendor ID:               AuthenticAMD
  Model name:            AMD EPYC 7R13 Processor
    CPU family:          25
    Model:               1
    Thread(s) per core:  1
    Core(s) per socket:  4
    Socket(s):           1
    Stepping:            1
    BogoMIPS:            5299.98
Virtualization features: 
  Hypervisor vendor:     KVM
  Virtualization type:   full
Caches (sum of all):     
  L1d:                   128 KiB (4 instances)
  L1i:                   128 KiB (4 instances)
  L2:                    2 MiB (4 instances)
  L3:                    16 MiB (1 instance)
NUMA:                    
  NUMA node(s):          1
  NUMA node0 CPU(s):     0-3
```

```{note}
If the run time seems to take a while at the beginning of each day, then you may need to resubmit the job. There is an initial latency issue when storage blocks are initially pulled down from Amazon S3 and written to the volume. For the 12US1 or other large benchmarks with larger input file sizes, this latency or delay is longer.

You will need to use a larger EC2 instance to run the larger '12US1' benchmark, and also follow instructions available on how to initialize the volume prior to running:
<a href="https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-initialize.html">Initialize EBS Volume</a>.
```

10. Once you have successfully run the benchmark, terminate the instance. Terminate the c6a.2xlarge either thru the Web Console or using the CLI. Find the InstanceID using the following command on your local machine.

`aws ec2 describe-instances --region=us-east-1 | grep InstanceId`

Output

i-xxxx

`aws ec2 terminate-instances --region=us-east-1 --instance-ids i-xxxx`

11. Verify that the instance is being shut down.

`aws ec2 describe-instances --region=us-east-1`

