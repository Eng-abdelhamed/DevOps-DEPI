# Configure The Aws Vpc
resource "aws_vpc" "main_Vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Main_Vpc_Terraform"
  }
}


# Create Public Subnet
resource "aws_subnet" "pub_sub" {
  vpc_id     = aws_vpc.main_Vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "Public_Subnet"
  }
}

# Create Ec2 Instance inside the public subnet and The VPC
resource "aws_instance" "EC2" {
  ami           = var.AMI
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.pub_sub.id
  tags = {
    Name = "EC2_Instance"
  }
}
variable "AMI" {
  type=string
}
