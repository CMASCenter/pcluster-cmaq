from diagrams import Diagram
from diagrams.aws.compute import EC2
from diagrams.aws.database import RDS
from diagrams.aws.network import ELB
from diagrams.aws.integration import SQS
from  diagrams.aws.storage import S3
from diagrams.aws.storage import EBS
from diagrams.saas.chat import Slack
attributes = {"pad": "1.0", "fontsize": "25"}
with Diagram("Parallel Cluster", show=True, direction="LR",
             outformat="png",
             graph_attr=attributes):
    head =  EC2("Head Node")
    service1 = EC2('Compute Node 1')
    service2 = EC2('Compute Node 2')
    service3 = EC2('Compute Node 3')
    storage = EBS('Shared Storage')
    
    head >> service1 >> storage 
    head >> service2 >> storage 
    head >> service3 >> storage

    storage >> S3('s3')
