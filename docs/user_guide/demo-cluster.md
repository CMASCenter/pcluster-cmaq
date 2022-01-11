# Use AWS CLI v3.0 to configure and launch a demo cluster 

Requires the user to have a key.pair that was created on an ec2.instance

## Install AWS Parallel Cluster Command Line

### Create a virtual environment on a linux machine to install aws-parallel cluster

```
python3 -m virtualenv ~/apc-ve
source ~/apc-ve/bin/activate
python --version

python3 -m pip install --upgrade aws-parallelcluster
pcluster version
```

### Follow the Parallel Cluster User Guide and install node.js

```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh 
chmod ug+x ~/.nvm/nvm.sh
source ~/.nvm/nvm.sh
nvm install node
node --version
python3 -m pip install --upgrade "aws-parallelcluster"
```

## Configure a demo cluster

### Create a yaml configuration file for the cluster following these instructions
https://docs.aws.amazon.com/parallelcluster/latest/ug/install-v3-configuring.html

```
pcluster configure --config new-hello-world.yaml
```

####  select region: us-east-1
#### select operating system: slurm
#### select Operating system: ubuntu2004
#### select head node instance type: t2.micro
#### select head node instance type: t2.micro

### Examine the yaml file 

```
cat new-hello-world.yaml
```

### The key pair and Subnetid in the yaml file are unique to your account.  Yaml files that are used in this tutorial will need to be edited to use your key pair and your Subnetid. 

## Create a demo cluster

```
pcluster create-cluster --cluster-configuration new-hello-world.yaml --cluster-name hello-pcluster --region us-east-1
```

### Check on the status of the cluster

```
pcluster describe-cluster --region=us-east-1 --cluster-name hello-pcluster
```

### List available clusters

```
pcluster list-clusters --region=us-east-1
```

### Start the compute nodes

```
# AWS ParallelCluster v3 - Slurm fleets
pcluster update-compute-fleet --region us-east-1 --cluster-name hello-pcluster --status START_REQUESTED
```

### SSH into the cluster 
(note, replace the centos.pem key pair with your key pair)

```
pcluster ssh -v -Y -i ~/centos.pem --cluster-name hello-pcluster
```

login prompt should look something like (this will depend on what OS was chosen in the yaml file).

[ip-xx-x-xx-xxx pcluster-cmaq]

### Check what modules are available on the Parallel Cluster

```
module avail
```

### Check what version of the compiler is available

```
gcc --version
```
Need a minimum of gcc 8+ for CMAQ

### Check what version of openmpi is available

```
mpirun --version
```
Need a minimum openmpi version 4.0.1 for CMAQ

### We will not install sofware on this demo cluster, as the t2.micro head node is too small
Save the key pair and SubnetId from this new-hello-world.yaml to use in the yaml for the CMAQ Cluster

### Exit the cluster

```
exit
```

## Delete the demo cluster

```
pcluster delete-cluster --cluster-name hello-pcluster --region us-east-1
```

## To learn more about the pcluster commands

```
pcluster --help
```
