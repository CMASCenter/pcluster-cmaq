# Upgrade to run CMAQ on larger EC2 Instance 

## Save the AMI and create a new VM using a larger c6a.8xlarge (with 32 processors)

Requires access to the AWS Web Interface
(I will look for insructions on how to do this from the aws command line, but I don't currently have a method for this.)

### Use the AWS Console to Stop the Image

add screenshot

### Use the AWS Console to Create a new AMI

add screenshot

Check to see that the AMI has been created by examining the status. Wait for the status to change from Pending to Available.

### Use the newly created AMI to launch a new Single VM using a larger EC2 instance.
Launch a new instance using the AMI with the software loaded and request a spot instance for the c6a.8xlarge EC2 instance

### Load the modules

### Test running the listos domain on 32 processors

Output

```
     Processing Day/Time [YYYYDDD:HHMMSS]: 2017357:235600
       Which is Equivalent to (UTC): 23:56:00 Saturday,  Dec. 23, 2017
       Time-Step Length (HHMMSS): 000400
                 VDIFF completed...       3.6949 seconds
                COUPLE completed...       0.3336 seconds
                  HADV completed...       1.8413 seconds
                  ZADV completed...       0.5154 seconds
                 HDIFF completed...       0.4116 seconds
              DECOUPLE completed...       0.0696 seconds
                  PHOT completed...       0.7443 seconds
               CLDPROC completed...       2.4009 seconds
                  CHEM completed...       1.3362 seconds
                  AERO completed...       1.3210 seconds
            Master Time Step
            Processing completed...      12.6698 seconds

      =--> Data Output completed...       0.9872 seconds


     ==============================================
     |>---   PROGRAM COMPLETED SUCCESSFULLY   ---<|
     ==============================================
     Date and time 0:00:00   Dec. 24, 2017  (2017358:000000)

     The elapsed time for this simulation was    3389.0 seconds.

315644.552u 1481.008s 56:29.98 9354.7%	0+0k 33221248+26871200io 9891pf+0w

CMAQ Processing of Day 20171223 Finished at Wed Jun  7 02:25:47 UTC 2023

\\\\\=====\\\\\=====\\\\\=====\\\\\=====/////=====/////=====/////=====/////


==================================
  ***** CMAQ TIMING REPORT *****
==================================
Start Day: 2018-08-05
End Day:   2018-08-07
Number of Simulation Days: 3
Domain Name:               2018_12Listos
Number of Grid Cells:      21875  (ROW x COL x LAY)
Number of Layers:          35
Number of Processes:       32
   All times are in seconds.

Num  Day        Wall Time
01   2018-08-05   80.6
02   2018-08-06   72.7
03   2018-08-07   76.3
     Total Time = 229.60
      Avg. Time = 76.53

```

## Run CMAQv5.4 for the full 12US1 Domain on c6a.48xlarge

Download the full 12US1 Domain that is netCDF4 compressed and convert it to classic netCDF-3 compression.

Note: I first tried running this domain on the c6a.8xlarge on 32 processors.
The model failed, with a signal 9 - likely not enough memory available to run the model.

I re-saved the AMI and launched a c6a.48xlarge with 192 vcpus, running as spot instance.

Spot Pricing cost for Linux in US East Region


c6a.48xlarge	$6.4733 per Hour


### Run utility to uncompress hdf5 *.nc4 files and save as classic *.nc files


May need to look at disabling hyperthreading at runtime.

<a href="https://aws.amazon.com/blogs/compute/disabling-intel-hyper-threading-technology-on-amazon-linux/">Disable Hyperthreading</a>


### Increased disk space on /shared to 500 GB 

Ran out of disk space when trying to run the full 12US1 domain, so it is necessary to increase the size.
You can do this in the AWS Web Interface without stopping the instance. 

Expanded the root volume to 500 GB, and increased the throughput to 1000 MB/s and then expanded it using these instructions, and then resized it.

<a href="https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/recognize-expanded-volume-linux.html">Recognize Expanded Volume</a>

Rerunning the 12US1 case on 8x12 processors - for total of 96 processors.

It takes about 13 minutes of initial I/O prior to the model starting.


Successful run output:

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
Number of Processes:       96
   All times are in seconds.

Num  Day        Wall Time
01   2017-12-22   3395.1
02   2017-12-23   3389.0
     Total Time = 6784.10
      Avg. Time = 3392.05
```

Note, this run time is slower than a single node of the Parallel Cluster using the HPC6a.48xlarge (total time = 5000 seconds). Note the 12US1 domain is larger than the 12US2 domain that was used for the HPC6a.48xlarge benchmarks. 
It would be good to do another benchmark for 12US1 using HPC6a.48xlarge a compute node that is configured for HPC by AWS.   AWS turns off hyperthreading by default for HPC6a.48xlarge, and there may be other optimizations for HPC applications (disk/networking/cpu).
