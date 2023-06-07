# Save the AMI and create a new VM using a larger c6a.8xlarge (with 32 processors)

### Use the AWS Console to Stop the Image

### Use the AWS Console to Create a new AMI

Check to see that the AMI has been created by examining the status. Wait for the status to change from Pending to Available.

### Use the newly created AMI to launch a new Single VM using a larger EC2 instance.
Launch a new instance using the AMI with the software loaded and request a spot instance for the c6a.8xlarge EC2 instance

### Load the modules

### Test running the listos domain on 32 processors

Output

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
Number of Processes:       32
   All times are in seconds.

Num  Day        Wall Time
01   2018-08-05   80.6
02   2018-08-06   72.7
03   2018-08-07   76.3
     Total Time = 229.60
      Avg. Time = 76.53

```



Download the full 12US1 Domain that is netCDF4 compressed and convert it to classic netCDF-3 compression.
Then run for the full domain on 32 processors.

The model failed, with a signal 9 - likely not enough memory available to run the model.

Saved the AMI and used a c6a.48xlarge with 192 vcpus, running as spot instance.

Spot Pricing cost for Linux in US East Region


c6a.48xlarge	$6.4733 per Hour


### Run model again using the hdf5 compressed nc4 files


May need to look at disabling hyperthreading at runtime.

https://aws.amazon.com/blogs/compute/disabling-intel-hyper-threading-technology-on-amazon-linux/


### Expanded the root volume to 500 GB, and increased the throughput to 1000 MB/s and then expanded it using these instructions

https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/recognize-expanded-volume-linux.html

Rerunning the 12US1 case on 8x12 processors - for total of 96 processors.

It takes about 13 minutes of initial I/O prior to the model starting.


