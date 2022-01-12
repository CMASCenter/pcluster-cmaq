# Parse timings from the log file 

## Compare to CONUS Parallel Cluster Runs for other PE configurations

1. For other PE configurations

   a. 10x18
   b. 16x16
   b. 16x18

2. For different compute nodes   

   a. c5n.18xlarge
   b. c5n.9xlarge

3. For with and without sbatch --exclusive

4. For with and without Elastic Fabric and Elastic Netaork Adapter 

5. For with and without network placement 

6. For lustre

   a. imported from S3 bucket to lustre
   b. copied from S3 bucket to lustre

7. For different yaml settings for slurm  

   a. DisableSimultaneousMultithreading= true
   b. DisableSimultaneousMultithreading= false

8. Others?
