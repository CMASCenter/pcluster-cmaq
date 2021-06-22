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
#### Note, the compute nodes can be modified, but the head node is unchangable.
#### Note, the settings in the cluster configuration file determine what compute nodes are available
#### how many compute nodes can be requested using slurm
#### What network is used, and whether the compute nodes are on the same network
#### Whether hyperthreading is used or not
#### What disk is used, ie ebs or fsx

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

### Once you are on the cluster check what modules are available

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

### Buiild I/O API library

```
./gcc9_ioapi.csh
```

### Build CMAQ

```
./gcc9_cmaq.csh
```


## Copy a preinstall script to the S3 bucket

```
aws s3 cp --acl public-read parallel-cluster-pre-install.sh s3://cmaqv5.3.2-benchmark-2day-2016-12se1-input/
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





