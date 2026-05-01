data "aws_ami" "myamis" {
  owners = [ "amazon"]
  most_recent = true

  filter {
    name ="name"
    values = ["amzn2-ami-hvm*"]
  }

}
data "aws_availability_zones" "available" {
  state = "available"
}
data "aws_region" "current" {}




resource "local_file" "ami_id"{
  filename = "ami_id.txt"
  content = "${data.aws_ami.myamis.id} is the latest Amazon Linux 2 AMI ID in the ${data.aws_region.current.name} region. The available availability zones in this region are: ${join(", ", data.aws_availability_zones.available.names)}."
}


