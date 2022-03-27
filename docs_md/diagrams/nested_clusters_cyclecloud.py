from diagrams import Cluster, Diagram
from diagrams.aws.compute import EC2, EC2SpotInstance
from diagrams.aws.database import Redshift
from diagrams.aws.integration import SQS
from diagrams.aws.storage import S3, EBS, FSx
from diagrams.aws.devtools import CLI
from diagrams.azure.compute import Disks

with Diagram("Microsoft Azure Minimum Viable Product", show=False):
    source = CLI("Azure")

    with Cluster("Cycle Cloud"):

        queue = SQS("SLURM")
        

        with Cluster("Scheduler Node"):
            head = [EC2("F2sV2")]

        with Cluster("HBv3 - 120CPU/compute node"):
            workers = [EC2("HBv3-120"),
                       EC2("HBv3-120"),
                        EC2("HBv3-120")]
        volume1 = Disks("/shared - 1.0TB")


    store = S3("S3 Bucket")

    source >> head >> queue >> workers
    workers >> volume1 >> store
