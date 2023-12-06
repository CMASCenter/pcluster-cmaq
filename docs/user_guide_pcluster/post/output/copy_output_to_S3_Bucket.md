## Copy Output Data and Run script logs to S3 Bucket

```{note}
You need permissions to copy to a S3 Bucket.
```

```{seealso}
<a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-access-control.html">S3 Access Control</a>
```

Be sure you enter your access credentials on the parallel cluster by running:

`aws configure`

Currently, the bucket listed below has ACL turned off

```{seealso}
<a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/about-object-ownership.html">S3 disable ACL</a>
```

See example of sharing bucket across accounts.

```{seealso}
<a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/example-walkthroughs-managing-access-example2.html">Bucket owner granting cross-account permissions</a>
```

## Copy scripts and logs to /fsx

The CTM_LOG files don't contain any information about the compute nodes that the jobs were run on.
Note, it is important to keep a record of the NPCOL, NPROW setting and the number of nodes and tasks used as specified in the run script: #SBATCH --nodes=16 #SBATCH --ntasks-per-node=8
It is also important to know what volume was used to read and write the input and output data, so it is recommended to save a copy of the standard out and error logs, and a copy of the run scripts to the OUTPUT directory for each benchmark.

```
cd /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts
mkdir -p /fsx/data/output/logs/
mkdir -p /fsx/data/output/scripts/
cp run*.log /fsx/data/output/logs/
cp run*.csh /fsx/data/output/scripts/
```
## Examine the output files

```{note}
The following commands will vary depending on what APPL or domain decomposition was run
```

```
cd /fsx/data/output/output_v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x64_classic
ls -lht
```

output:

```
total 26G
drwxrwxr-x 2 ubuntu ubuntu 153K Jul 12 20:59 LOGS
-rw-rw-r-- 1 ubuntu ubuntu 2.3M Jul 12 20:59 CCTM_BUDGET_v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x64_classic_20171223.txt
-rw-rw-r-- 1 ubuntu ubuntu 4.1G Jul 12 20:59 CCTM_CGRID_v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x64_classic_20171223.nc
-rw-rw-r-- 1 ubuntu ubuntu 1.9G Jul 12 20:58 CCTM_AELMO_v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x64_classic_20171223.nc
-rw-rw-r-- 1 ubuntu ubuntu 2.8G Jul 12 20:58 CCTM_ACONC_v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x64_classic_20171223.nc
-rw-rw-r-- 1 ubuntu ubuntu 171M Jul 12 20:58 CCTM_CONC_v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x64_classic_20171223.nc
-rw-rw-r-- 1 ubuntu ubuntu 1.8G Jul 12 20:58 CCTM_WETDEP1_v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x64_classic_20171223.nc
-rw-rw-r-- 1 ubuntu ubuntu 2.1G Jul 12 20:58 CCTM_DRYDEP_v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x64_classic_20171223.nc
-rw-rw-r-- 1 ubuntu ubuntu  51M Jul 12 20:58 CCTM_MEDIA_CONC_v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x64_classic_20171223.nc
-rw-rw-r-- 1 ubuntu ubuntu  15M Jul 12 20:58 CCTM_BSOILOUT_v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x64_classic_20171223.nc
-rw-rw-r-- 1 ubuntu ubuntu 3.7K Jul 12 20:30 CCTM_v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x64_classic_20171223.cfg
-rw-rw-r-- 1 ubuntu ubuntu 2.3M Jul 12 20:30 CCTM_BUDGET_v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x64_classic_20171222.txt
-rw-rw-r-- 1 ubuntu ubuntu 4.1G Jul 12 20:30 CCTM_CGRID_v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x64_classic_20171222.nc
-rw-rw-r-- 1 ubuntu ubuntu 2.8G Jul 12 20:29 CCTM_ACONC_v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x64_classic_20171222.nc
-rw-rw-r-- 1 ubuntu ubuntu 1.9G Jul 12 20:29 CCTM_AELMO_v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x64_classic_20171222.nc
-rw-rw-r-- 1 ubuntu ubuntu 171M Jul 12 20:29 CCTM_CONC_v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x64_classic_20171222.nc
-rw-rw-r-- 1 ubuntu ubuntu 1.8G Jul 12 20:29 CCTM_WETDEP1_v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x64_classic_20171222.nc
-rw-rw-r-- 1 ubuntu ubuntu  51M Jul 12 20:29 CCTM_MEDIA_CONC_v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x64_classic_20171222.nc
-rw-rw-r-- 1 ubuntu ubuntu  15M Jul 12 20:29 CCTM_BSOILOUT_v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x64_classic_20171222.nc
-rw-rw-r-- 1 ubuntu ubuntu 2.1G Jul 12 20:29 CCTM_DRYDEP_v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x64_classic_20171222.nc
-rw-rw-r-- 1 ubuntu ubuntu 3.7K Jul 12 20:00 CCTM_v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x64_classic_20171222.cfg
```

Check disk space

```
 du -sh
26G    .
```

## Copy the output to an S3 Bucket

Examine the example script

```
cd /shared/pcluster-cmaq/s3_scripts
cat s3_upload.c7g.16xlarge.csh 

```

output:

```
#!/bin/csh -f
# Script to upload output data to S3 bucket
# NOTE: a new bucket needs to be created to store each set of cluster runs

#cd /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts
#cp run*.log /fsx/data/output
#cp run*.csh /fsx/data/output

aws s3 mb s3://c7g-head-hpc7g.16xlarge-cmaqv5.4plus.12us1-output
aws s3 cp --recursive /fsx/data/output/ s3://c7g-head-hpc7g.16xlarge-cmaqv5.4plus.12us1-output/jul-14-2023/fsx/data/output/
```

If you do not have permissions to write to the s3 bucket, you may need to ask the administrator of your account to add S3 Bucket writing permissions.

Run the script to copy all of the CMAQ output and logs to the S3 bucket.

```
./s3_upload.c7g.16xlarge.csh
```
