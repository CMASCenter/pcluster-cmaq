from diagrams import Cluster, Diagram
from diagrams.aws.compute import EC2, EC2SpotInstance
from diagrams.aws.database import Redshift
from diagrams.aws.integration import SQS
from diagrams.aws.storage import S3, EBS, FSx
from diagrams.aws.devtools import CLI
from diagrams.azure.compute import Disks

graph_attr = {
    "fontsize": "90",
}

with Diagram("Azure Cycle Cloud", graph_attr=graph_attr, show=False):
    source = CLI("Azure")

    with Cluster("Cycle Cloud"):

        queue = SQS("SLURM")
        

        with Cluster("Scheduler Node"):
            head = [EC2("D4ds_v5")]

        with Cluster("Autoscaling Compute Nodes"):
            workers = [EC2("HB120rs_v3"),
                       EC2("HB120rs_v3"),
                        EC2("HB120rs_v3"),
                         EC2("HB120rs_v3"),
                          EC2("HB120rs_v3") ]
        volume1 = Disks("/shared - 1.0TB")
        volume2 = FSx("I/O - 1.2TB Lustre Vol")


    store = S3("S3 Bucket")

    source >> head >> volume1 >> queue >> workers
    workers >> volume2 >> store
