resource "aws_instance" "Web" {
  ami           = "ami-0ea87431b78a82070"
  instance_type = "t3.micro"

  tags = {
    Name = "Web"
  }
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "defds-bucketami-oddff1c"
}

