resource "aws_key_pair" "mykey" {
  key_name   = "ec2_rsa"
  public_key = file("C:\\Users\\abdel\\.ssh\\ec2_rsa.pub")
}

resource "aws_instance" "EC2" {
  ami =  "ami-0ea87431b78a82070"
  instance_type =  "t3.micro"
  key_name = aws_key_pair.mykey.key_name
  tags = {
    Name = "EC2"
  }
  connection {
    user = "ec2-user"
    host = self.public_ip
    private_key = file("C:\\Users\\abdel\\.ssh\\ec2_rsa")
  }
  provisioner "remote-exec" {
    inline = [
      "sudo echo ${self.public_ip} > public_ip.txt"
    ]
  }
}
