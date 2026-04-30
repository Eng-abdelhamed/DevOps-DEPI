resource "aws_key_pair" "mykey" {
  key_name   = "ec2_rsa"
  public_key = file("C:/Users/abdel/.ssh/ec2-inst.pub")
}

resource "aws_instance" "ec2" {
  ami           = "ami-0ea87431b78a82070"
  instance_type = "t3.micro"
  key_name = aws_key_pair.mykey.key_name

  tags = {
    Name = "ExampleInstance"
  }

  connection {
    user = "ec2-user"
    type = "ssh"
    host = self.public_ip
    private_key = file("C:/Users/abdel/.ssh/ec2-inst")
  }
  provisioner "local-exec" {
    command = "echo ${aws_instance.ec2.public_ip} > public_ip.txt"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum install nginx -y" ,
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]
  }

}
