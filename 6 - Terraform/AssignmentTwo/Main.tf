resource "aws_iam_user" "User" {
  provider = aws
  name = "AWs_IAM_User"
  path = "/"
}

resource "aws_eip" "eip" {
  provider = aws
  domain = "vpc"
}

resource "aws_nat_gateway" "natgw" {
  provider = aws
  allocation_id = aws_eip.eip.id
  subnet_id = "subnet-0547049f320f1ea4a"
}

