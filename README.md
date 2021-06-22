# pcluster-cmaq

## Scripts and code to configure an AWS pcluster for CMAQ

## To obtain this code use the following command:

```
git clone -b main https://github.com/lizadams/pcluster-cmaq.git pcluster-cmaq
```

## To configure the cluster start a virtual environment on your local linux machine and install aws-parallelcluster

```
python3 -m virtualenv ~/apc-ve
source ~/apc-ve/bin/activate
python --version

python3 -m pip install --upgrade aws-parallelcluster
pcluster version
```

### Edit the configuration file for the cluster

```
vi ~/.parallelcluster/config
```

### Configure the cluster
      Note, the compute nodes can be updated/changed, but the head node cannot be updated.
      The settings in the cluster configuration file determine 
              1) what compute nodes are available
              2) the maximum number of compute nodes that can be requested using slurm
              3) What network is used (elastic fabric adapter (efa))
              4) Whether the compute nodes are on the same network
              5) Whether hyperthreading is used or not
              6) What disk is used, ie ebs or fsx and the size of /shared disk thatis available  (can't be updated) 
              7) Note the /shared disks are persistent as you can't turn them off, they will acrue charges until the cluster is deleted so you need to determine the size requirements carefully.
              8) You can turn off the head node after stopping the cluster, as long as you restart it before restaring the cluster
              9) The pcluster slurm queue system will create and destroy the compute nodes, so that helps reduce manual cleanup for the cluster.
              10) If intel compiler is available - need separate config settings to get access to intel compiler
              11) Note: you can use intelmpi with the gcc compiler, it isn't a requirement to use ifort as the base compiler.
              12) It is best to copy/backup the outputs and logs to an s3 bucket for follow-up analysis\
              13) It is possible to add an ebs volume as a shared directory - this can then be saved and available even after the pcluster is deleted. (?)

```
pcluster configure pcluster -c /Users/lizadams/.parallelcluster/config
```

### Create the cluster

```
pcluster create cmaq
```

### Check status of cluster

```
pcluster status cmaq
```

### Stop cluster

```
pcluster stop cmaq
```

### Start cluster

```
pcluster start cmaq
```

### Update the cluster

```
pcluster update -c /Users/lizadams/.parallelcluster/config cmaq
```

### To learn more about the pcluster commands

```
pcluster --help
```

### Pcluster User Manual
https://docs.aws.amazon.com/parallelcluster/latest/ug/what-is-aws-parallelcluster.html

### Configuring Pcluster for HPC
https://jimmielin.me/2019/wrf-gc-aws/

### Login to cluster using the permissions file

```
pcluster ssh cmaq -i ~/downloads/centos.pem
```

### Once you are on the cluster change from default bash shell to csh
csh

### Check what modules are available

```
module avail
```

### Load the openmpi module

```
module load openmpi/4.1.0
```

### Change directories to Install and build the libraries and CMAQ

```
cd /shared/pcluster-cmaq
```

### Build netcdf C and netcdf F libraries

```
./gcc9_install.csh
```

### A .cshrc script with LD_LIBRARY_PATH was copied to your home directory, enter the shell again and check environment variables that were set using

```
csh
env
```

### Buiild I/O API library

```
./gcc9_ioapi.csh
```

### Build CMAQ

```
./gcc9_cmaq.csh
```

## Copy the input data from a S3 bucket (this bucket is not public and needs credentials)
## set the aws credentials

```
aws credentials
```

## Use the script to copy the CONUS input data to the cluster

```
./s3_copy_need_credentials_conus.csh
```

### For the 12km SE Domain, copy the input data and then untar it, or use the pre-install script in the pcluster configuration file.
### Note: it is faster to copy all of the data to an S3 bucket without using tar.gz

```
cd /shared/
aws s3 cp --recursive s3://cmaqv5.3.2-benchmark-2day-2016-12se1-input .
tar -xzvf CMAQv5.3.2_Benchmark_2Day_Input.tar.gz
'''

## Link the CONUS and 12km SE Domain input benchmark directory to your run script area

```
cd /shared/build/openmpi_4.1.0_gcc_8.3.1/CMAQ_v532/data
ln -s /shared/CONUS .
ln -s /shared/CMAQv5.3.2_Benchmark_2Day_Input .
```


## Copy a preinstall script to the S3 bucket (may be able to install all software and input data on spinup)
## This example is for the 12km SE domain (not implemented for CONUS domain yet).

```
aws s3 cp --acl public-read parallel-cluster-pre-install.sh s3://cmaqv5.3.2-benchmark-2day-2016-12se1-input/
```

### Copy the run scripts to the run directory

```
cd /shared/pcluster-cmaq
cp run*  /shared/build/openmpi_4.1.0_gcc_8.3.1/CMAQ_v532/CCTM/scripts
cd  /shared/build/openmpi_4.1.0_gcc_8.3.1/CMAQ_v532/CCTM/scripts
```


#### Once you have logged into the queue you can submit multiple jobs to the slurm job scheduler.

 ```
sbatch run_cctm_2016_12US2.64pe.csh
sbatch run_cctm_2016_12US2.256pe.csh
```

```
squeue -u centos
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON) 
                27   compute     CMAQ   centos  R      47:41      2 compute-dy-c59xlarge-[1-2] 
                28   compute     CMAQ   centos  R      10:58      8 compute-dy-c59xlarge-[3-10] 
                ```

## Note, there are times when the second day run fails, looking for the input file that was output from the first day.
## may need to put in a sleep command between the two days.
## Temporary fix is to restart the second day.

### Note this may help with networking on the parallel cluster
If the head node must be in the placement group, use the same instance type and subnet for both the head as well as all of the compute nodes. By doing this, the compute_instance_type parameter has the same value as the master_instance_type parameter, the placement parameter is set to cluster, and the compute_subnet_id parameter isn't specified. With this configuration, the value of the master_subnet_id parameter is used for the compute nodes. 
https://docs.aws.amazon.com/parallelcluster/latest/ug/troubleshooting.html



