# Create Cyclecloud CMAQ Cluster
Documentation for Azure
<a href="https://docs.microsoft.com/en-us/azure/cyclecloud/?view=cyclecloud-8">CycleCloud Documentation</a>

## Configure the Cycle Cloud Cluster using the Azure Web Interface

Create a virtual Machine

![Azure Create a Virtual Machine Console](../azure_web_interface_images/Create_Virtual_Machine.png)

Select a VM Size of D4s_v3

![Azure Select a VM Size of D4s_v3](../azure_web_interface_images/Select-a-VM-Size-D4s_v3.png)

Screenshot of the setting selected
![Azure Setting for VM Size of D4s_v3](../azure_web_interface_images/Create_Virtual_Machine_with_Size_F4s_v2.png)

Selects Disks for the Azure Virtual Machine
![Select Disks for the Azure Virutal Machine](../azure_web_interface_images/Create_VM_Select_DIsks.png)

Selects Network Interface for the Azure Virtual Machine
![Select Network Interface for the Azure Virutal Machine](../azure_web_interface_images/Create_VM_Select_Network_Interface.png)

Create Virtual Machine Management Identity
![Select Network Interface for the Azure Virutal Machine](../azure_web_interface_images/Create_VM_Management_Identity.png)

Create Virtual Machine Management Identity - Screenshot 2
![Select Network Interface for the Azure Virutal Machine](../azure_web_interface_images/Create_VM_Management_Identity_2.png)

Create Virtual Machine Management Identity - Screenshot 3
![Select Network Interface for the Azure Virutal Machine](../azure_web_interface_images/Create_VM_Management_Identity3.png)

Create a Virtual Machine
![Create the Virtual Machine](../azure_web_interface_images/Create_VM.png)

Add Contributor Role to Virtual Machine
![Add Contributor Role to Virtual Machine](../azure_web_interface_images/VM_Add_Role_Assignment_Contributor.png)

Add Role Assignment - Management Identity
![Add Contributor Role to Virtual Machine](../azure_web_interface_images/VM_Add_Role_Assignment_Members_Managed_Identity.png)

Add Role Assignment
![Add Role Assignment](../azure_web_interface_images/VM_Add_Role_Assignment.png)

Add Reader Role to Virtual Machine
![Add Reader Role to Virtual Machine](../azure_web_interface_images/VM_Add_Role_Assignment_Reader.png)

Review REader Role on Virtual Machine
![Review Reader Role to Virtual Machine](../azure_web_interface_images/VM_Add_Role_Assignment_Reader_Review.png)

Azure Create Storage Account
![Create Storage Account on Azure](../azure_web_interface_images/Azure_Create_Storage_Account.png)

Azure Create Storage Account Details
![Details of Storage Account on Azure](../azure_web_interface_images/Azure_Create_A_Storage_Account_details.png)

Azure Review Storate Account Details
![Review Details of Storage Account on Azure](../azure_web_interface_images/Azure_Create_A_Storage_Account_Review+create.png)

Web Interface to CycleCloud
![Web Interface to CycleCloud](../azure_web_interface_images/Cyclecloud-ea_Virtual_Machine.png)

Azure CycleCloud Web Login
![Azure CycleCloud Web Login](../azure_web_interface_images/Azure_CycleCloud_Web_Login.png)

Azure CycleCloud Add Subscription
![Azure CycleCloud Add Subscription](../azure_web_interface_images/Azure_CycleCloud_Add_Subscription.png)

Azure CycleCloud Add Subscription and Validate Credentials
![Azure CycleCloud Add Subscription and Validate Credentials](../azure_web_interface_images/Azure_CycleCloud_Add_Subscription_Validate_Credentials.png)

Azure CycleCloud HPC Queue Select Machine
![Azure CycleCloud HPC Queue Select Machine](../azure_web_interface_images/Azure_CycleCloud_Select_A_Machine_Type_HC44rs.png)

Azure CycleCloud HPC VM Type Confirmed
![Azure CycleCloud HPC VM Type Confirmed](../azure_web_interface_images/Azure_CycleCloud_HPC_VM_TYPE_HC44rs.png)

Azure CycleCloud Network Attached Storage
![Azure CycleCloud Network Attached Storage](../azure_web_interface_images/Azure_CycleCloud_Network_Attached_Storage.png)

Azure CycleCloud Select OS and Uncheck Name as HostName
![Azure CycleCloud Select OS](../azure_web_interface_images/Azure_CycleCloud_Advanced_Settings_Choose_OS.png)

Login to Azure Cycle Cloud and verify that the following command works.

'srun -t 1:30:00  -n --pty /bin/bash'

## Instructions to upgrade the number of processors available to the Cycle Cloud Cluster

Edit the HPC config in the cyclecloud web interface to set the CPUs to 480 
Run the following on the scheduler node the changes should get picked up:

`cd /opt/cycle/slurm`

`sudo ./cyclecloud_slurm.sh scale`
