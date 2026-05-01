provider "aws" {
  region  = "us-east-1"
  profile = "Terraform2"
  alias = "defaultd"
}

provider "aws" {
  alias = "non_default"
  region = "us-east-2"
  profile = "Terraform1"
}

resource "aws_instance" "myInstanc2e" {
  ami = "ami-0a1b6a02658659c2a"
  provider = aws.non_default
  instance_type = "t3.micro"
  tags = {
    Name = "MyFirstInstance"
  }
}
resource "aws_instance" "myInstance" {
  ami = "ami-098e39bafa7e7303d"
  provider = aws.defaultd
  instance_type = "t3.micro"
  tags = {
    Name = "MyFirstInstance"
  }
}

