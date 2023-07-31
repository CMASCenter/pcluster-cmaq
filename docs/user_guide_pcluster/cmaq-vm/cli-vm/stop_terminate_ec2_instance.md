## Stop or Terminate EC2 instance using the AWS CLI 

### Stop the instance (skip this as it doesn't work for spot instances)

`aws ec2 stop-instances --region=us-east-1 --instance-ids i-xxxx`


Get the following error message.

aws ec2 stop-instances --region=us-east-1 --instance-ids i-041a702cc9f7f7b5d

An error occurred (UnsupportedOperation) when calling the StopInstances operation: You can't stop the Spot Instance 'i-041a702cc9f7f7b5d' because it is associated with a one-time Spot Instance request. You can only stop Spot Instances associated with persistent Spot Instance requests.


Note sure how to do a persistent spot instance request .
### Terminate Instance

`aws ec2 terminate-instances --region=us-east-1 --instance-ids i-xxxx`

### Verify that the instance is being shut down.

`aws ec2 describe-instances --region=us-east-1`
