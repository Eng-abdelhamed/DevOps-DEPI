# Ensure that your settings will restrict terraform to only version range v1.5.x.
terraform {
  required_version = ">= 1.14.0, < 1.15.0"
}

# Terraform configuration for creating an S3 bucket with specific ownership controls and ACL settings.
resource "aws_s3_bucket" "S3" {
  bucket = "apoloza-buck"
  tags = {
    Name = "Terraform_testbd"
  }
}

resource "aws_s3_bucket_ownership_controls" "BUCK-ACL" {
  bucket = aws_s3_bucket.S3.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
# Acess to this bucket is private and only the bucket owner has access to it.
resource "aws_s3_bucket_acl" "bucket-acl" {
  depends_on = [aws_s3_bucket_ownership_controls.BUCK-ACL]
  bucket     = aws_s3_bucket.S3.id
  acl        = "private"
}

# 4.Create a security group which has an inbound permit rule for the 192.168.120.0/24 subnet on all ports.
resource "aws_security_group" "SsG" {
  name        = "Allow-Rule"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["192.168.120.0/24"]
  }
}


