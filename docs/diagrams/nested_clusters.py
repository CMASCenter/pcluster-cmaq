from diagrams import Cluster, Diagram
from diagrams.aws.compute import EC2, EC2SpotInstance
from diagrams.aws.database import Redshift
from diagrams.aws.integration import SQS
from diagrams.aws.storage import S3, EBS, FSx
from diagrams.aws.devtools import CLI

with Diagram("AWS Minimum Viable Product", show=False):
    source = CLI("AWS CLI v3.0")

    with Cluster("Parallel Cluster"):

        queue = SQS("SLURM")
        
        volume1 = EBS("Software/EBS Vol")

        with Cluster("Head Node"):
            head = [EC2("c5n.xlarge")]

        with Cluster("C5n.18xlarge - 36CPU/compute node"):
            workers = [EC2SpotInstance("node1-spot"),
                       EC2SpotInstance("node2-spot"),
                        EC2SpotInstance("node3-spot"),
                        EC2SpotInstance("node4-spot"),
                        EC2SpotInstance("node5-spot")]
        volume2 = FSx("I/O - 1.2TB Lustre Vol")


    store = S3("S3 Bucket")

    source >> head >> volume1 >> queue >> workers
    workers >> volume2 >> store
