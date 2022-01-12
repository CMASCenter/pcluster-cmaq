# Use Lustre File System and Import S3 Bucket that contains input data 

1. Saves storage cost
2. Removes need to copy data from S3 bucket to Lustre file system
     a. FSx for Lustre integrates natively with Amazon S3, making it easy for you to process HPC data sets stored in Amazon S3
3. simplifies running HPC workloads on AWS
4. Amazon FSx for Lustre uses parallel data transfer techniques to transfer data to and from S3 at up to hundreds of GBs/s.


<a href="https://www.amazonaws.cn/en/fsx/lustre/faqs/">Lustre FAQs</a>

<a href="https://docs.amazonaws.cn/en_us/fsx/latest/LustreGuide/performance.html">Lustre Performance Documentation</a>

To find the default settings for Lustre see:
<a href="https://docs.aws.amazon.com/parallelcluster/latest/ug/SharedStorage-v3.html#SharedStorage-v3-FsxLustreSettings>Lustre Settings for Parallel Cluster</a>

