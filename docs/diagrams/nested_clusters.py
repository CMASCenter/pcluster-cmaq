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
        
        volume1 = EBS("Software on EBS Volume")

        with Cluster("Head Node"):
            head = [EC2("c5n.xlarge")]

        with Cluster("C5n.18xlarge Nodes"):
            workers = [EC2SpotInstance("node1"),
                       EC2SpotInstance("node2"),
                        EC2SpotInstance("node3"),
                        EC2SpotInstance("node4"),
                        EC2SpotInstance("node5"),
                        EC2SpotInstance("node6"),
                        EC2SpotInstance("node7"),
                        EC2SpotInstance("node8")]
        volume2 = FSx("InputsOutput")


    store = S3("S3 Bucket")

    source >> head >> volume1 >> queue >> workers
    workers >> volume2 >> store
