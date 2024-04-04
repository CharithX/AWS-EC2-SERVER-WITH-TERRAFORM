provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr_block
  tags = {
    Name = "terraform-aws-vpc"
  }
}

resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.subnet_cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "terraform-aws-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "terraform-aws-igw"
  }
}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "terraform-aws-route-table"
  }
}

resource "aws_route_table_association" "nrt1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_security_group" "webSg" {
  name        = "web"
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description = "HTTP from VPC"
    from_port    = 80
    to_port      = 80
    protocol     = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }
    ingress {
    description = "Docker port for application"
    from_port    = 3000
    to_port      = 3000
    protocol     = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from VPC"
    from_port    = 22
    to_port      = 22
    protocol     = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound traffic"
    from_port    = 0
    to_port      = 0
    protocol     = "-1"
    cidr_blocks  = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-aws-sg"
  }
}

resource "aws_instance" "ubun-server" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webSg.id]
  subnet_id              = aws_subnet.sub1.id
  key_name               = var.key_name


connection {
    type     = "ssh"
    user        = "ubuntu"
    private_key = file("Add your private key")
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
     "echo 'Hello from the remote instance'",
     "sudo apt-get update",
     "sudo apt-get install -y docker.io",
     "sudo systemctl start docker",
     "sudo systemctl enable docker",
     "echo 'Succesfully Docker installed'",
    ]
  }
    tags = {
    Name = "terraform-aws-ubuntu"
  }
}
output "instance_public_ip" {
  value = aws_instance.ubun-server.public_ip
}
