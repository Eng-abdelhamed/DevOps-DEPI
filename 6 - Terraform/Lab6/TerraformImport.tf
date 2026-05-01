provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "ImportInstance" {
  ami = "ami-0ea87431b78a82070"
  instance_type = "t3.micro"

  tags = {
    Name = "Dragonstone"
  }
}
