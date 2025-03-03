from diagrams import Cluster, Diagram
from diagrams.aws.compute import EC2, EC2SpotInstance
from diagrams.aws.database import Redshift
from diagrams.aws.integration import SQS
from diagrams.aws.storage import S3, EBS, FSx
from diagrams.aws.devtools import CLI
from diagrams.azure.storage import StorageSyncServices

with Diagram("AWS Parallel Cluster", show=False):
    source = CLI("AWS CLI v3.0")

    with Cluster("Parallel Cluster"):

        queue = SQS("SLURM")
        
        with Cluster("Head Node"):
            head = [EC2("c6a.xlarge")]

        with Cluster("hpc6a.48xlarge - 96 cores/node, Scalable by SLURM request"):
            workers = [EC2("hpc6a.48xlarge"),
                        EC2("hpc6a.48xlarge"),
                        EC2("hpc6a.48xlarge")]
        with Cluster("lustre"):
            volume2 = [FSx("I/O - 1.2TB Lustre Vol")]

        with Cluster("Shared"):
            sched = [
                     EC2("c6a.xlarge"),
                     EBS("Software/EBS Vol")]
        mnt = StorageSyncServices("Mount Point")

    store = S3("S3 Bucket")

    source >> head >> queue >> workers
    workers >> mnt
    mnt >> volume2 >> store
    mnt >> sched >> store


