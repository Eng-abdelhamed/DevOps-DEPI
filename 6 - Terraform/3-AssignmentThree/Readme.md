# Terraform Assignment Three : AWS Infrastructure Deployment
---
## Objectives
1. Using Terraform, Create an S3 bucket with a unique name of your choice.
2. The access to this bucket is private.
3. Tag the bucket with the tag "terrform_bucket".
4. Create a security group which has an inbound permit rule for the 192.168.120.0/24 subnet on all ports.
5. Ensure that your settings will restrict terraform to only version range v1.5.x.
6. After creating the above resources, update the tag of your bucket to be "terraform_testbd", ensure terraform refreshes only the S3 Bucket resource from the resources in the state file.
7. Destroy the security group resource only and keep the S3 Resource bucket in your deployed infrastructure. This should be reflected in your state file.
8. ![Diagram](graphviz.svg)
---
