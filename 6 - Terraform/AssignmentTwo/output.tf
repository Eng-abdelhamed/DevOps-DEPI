output "Elastic-IP" {
  value = aws_eip.eip.public_ip
}

output "UUser-Arn"{
  value = aws_iam_user.User.arn
}

output "Nat-Gateway-Id" {
  value = aws_nat_gateway.natgw.id
}
