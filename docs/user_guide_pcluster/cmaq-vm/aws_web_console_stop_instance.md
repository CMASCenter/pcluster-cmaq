## Stop Instance 


### Go to the EC2 Dashboard 

<a href="https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#Home:">EC2 Resources on AWS Web Console</a>


### Click on Instances Running

Select the checkbox next to the c6a.2xlarge instance name

![Select Instance on EC2 Dashboard](../web-vm/ec2_select_instance_checkbox.png)

### Select Instance State Pulldown menu and select stop instance

This will stop charges from being incurred by the ec2 instance, but you will still be charged for the gp3 volume until the ec2 instance is terminated.
Typically, you would choose to stop, and then restart the instance if you plan to do additional work on it within a few hours.
Otherwise, to avoid incurring costs, it is better to terminate the instance, and then recreate later from either the public AMI or your newly saved AMI.

### Select Instance State Pulldown menu and select terminate instance.

![Terminate Instance on EC2 Dashboard](../web-vm/ec2_instance_state_pulldown_select_terminate_instance.png)

### When the pop-up menu asks if you are sure you want to terminate the instance, click on the orange Terminate button.

![Confirm Terminate Instance on EC2 Dashboard](../web-vm/ec2-dashboard-confirm-terminate-instance.png)



