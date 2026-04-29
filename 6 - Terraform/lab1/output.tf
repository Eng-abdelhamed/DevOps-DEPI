output "S3-ARN" {
  value = aws_s3_bucket.my_bucket.arn

}
output "S3-Endpoint" {
  value = aws_s3_bucket.my_bucket.bucket_domain_name
}
output "S3-Region" {
  value = aws_s3_bucket.my_bucket.region
}
output "ec2-Public-IP" {
  value = aws_instance.Web.public_ip
}
