output "availability_zones" {
  value = data.aws_availability_zones.available.names
}

output "Regions" {
  value = data.aws_region.current.name

}

output "ami_id" {
  value = data.aws_ami.myamis.id
}
