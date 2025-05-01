# 🖥️ AWS EC2 Server with Terraform

This project sets up an **AWS EC2 instance** using **Terraform**. It creates a **VPC**, **subnet**, **security group**, and provisions an EC2 instance with Docker installed, allowing HTTP and SSH access. Terraform is used to automate the entire setup process, enabling Infrastructure-as-Code (IaC).

## 🚀 Prerequisites

Before you begin, ensure you have the following installed:

- [Terraform](https://www.terraform.io/downloads.html) (v0.12+)
- [AWS CLI](https://aws.amazon.com/cli/) (configured with your AWS credentials)
- An AWS account with the necessary permissions to create resources like VPC, EC2, security groups, etc.

## 🛠️ Tech Stack

- **Terraform** (Infrastructure-as-Code)
- **AWS** (Cloud provider)
- **Ubuntu** (Operating System for EC2 instance)
- **Docker** (Installed on EC2 instance)

## 🔧 Setup and Configuration

### 1. Clone the Repository

Clone this repository to your local machine.

```bash
git clone https://github.com/your-username/AWS-EC2-SERVER-WITH-TERRAFORM.git
cd AWS-EC2-SERVER-WITH-TERRAFORM
```

2. Configure AWS Credentials
Make sure your AWS CLI is configured with the proper credentials:


aws configure
Alternatively, you can use environment variables:

bash
Copy
Edit
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
3. Define Your Variables
Create a terraform.tfvars file to specify values for your variables:

bash
Copy
Edit
touch terraform.tfvars
In the terraform.tfvars file, provide values for the variables like cidr_block, subnet_cidr_block, ami_id, etc. Example:

hcl
Copy
Edit
cidr_block           = "10.0.0.0/16"
subnet_cidr_block    = "10.0.1.0/24"
availability_zone    = "us-east-1a"
ami_id               = "ami-xxxxxxxxxxxxxxxxx"
key_name             = "your-ssh-key-name"
4. Initialize Terraform
Initialize the Terraform project to download the necessary provider plugins:

bash
Copy
Edit
terraform init
5. Apply Terraform Configuration
Run the following command to apply the configuration and create the resources on AWS:

bash
Copy
Edit
terraform apply
Terraform will prompt you to confirm the action. Type yes to proceed.

6. Access the EC2 Instance
Once the EC2 instance is created, Terraform will output the public IP address of the instance:

bash
Copy
Edit
terraform output instance_public_ip
Use this public IP to access your EC2 instance via SSH:

bash
Copy
Edit
ssh -i /path/to/your/private-key.pem ubuntu@<instance_public_ip>
7. Docker Installation on EC2
The Terraform configuration ensures Docker is installed and running on your EC2 instance. The following commands are executed during the provisioning process on the EC2 instance:

bash
Copy
Edit
sudo apt-get update
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
8. Clean Up
When you're done with the resources, destroy the infrastructure created by Terraform:

terraform destroy
# This will remove all resources (VPC, EC2 instance, security group, etc.) from AWS.
