variable "cidr_block" {
  description = "CIDR block for the VPC"
}

variable "subnet_cidr_block" {
  description = "CIDR block for the subnet"
}

variable "availability_zone" {
  description = "Availability Zone for the subnet"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
}

variable "key_name" {
  description = "SSH key pair name"
}

