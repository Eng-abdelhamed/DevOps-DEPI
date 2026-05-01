resource "aws_instance" "myec2" {
  ami =  "ami-0ea87431b78a82070"
  instance_type =  "t3.micro"
  tags = {
    Name = "MyEC2"
  }
  provisioner "local-exec" {
    command = "echo ${aws_instance.myec2.public_ip} > public_ip.txt"
  }
}
