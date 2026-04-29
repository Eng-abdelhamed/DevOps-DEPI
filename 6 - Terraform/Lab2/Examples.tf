# Create EIP address
resource "aws_eip" "Web_EIP" {
  # instance = aws_instance.Web.id
  domain   = "vpc"
}

# Create Security Group
resource "aws_security_group" "Web_SG" {
  name        = "Web_SG"
  description = "Allow HTTP and SSH traffic"
  # Allow HTTP access from the EIP address
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${aws_eip.Web_EIP.public_ip}/32"]
  }
  # Allow SSH access from the EIP address
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${aws_eip.Web_EIP.public_ip}/32"]
  }

}
