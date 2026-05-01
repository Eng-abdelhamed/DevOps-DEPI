# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "sg-07c5855c7ba7b314b"
resource "aws_security_group" "SGq" {
  description = "BackEndSecurityGroup"
  egress      = []
  ingress = [{
    cidr_blocks      = []
    description      = ""
    from_port        = 22
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = ["sg-04aaeab0f1abc4fe3"]
    self             = false
    to_port          = 80
  }]
  name                   = "BackEndSg"
  region                 = "us-east-1"
  revoke_rules_on_delete = null
  tags                   = {}
  tags_all               = {}
  vpc_id                 = "vpc-0d78a8d1ec032e36d"
}

# __generated__ by Terraform
resource "aws_instance" "ImportInstance" {
  ami                                  = "ami-0ea87431b78a82070"
  associate_public_ip_address          = true
  availability_zone                    = "us-east-1f"
  disable_api_stop                     = false
  disable_api_termination              = false
  ebs_optimized                        = true
  force_destroy                        = false
  get_password_data                    = false
  hibernation                          = false
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "t3.micro"
  # ipv6_address_count                   = 0
  # ipv6_addresses                       = []
  key_name                             = "NorthVirginia"
  monitoring                           = false
  placement_partition_number           = 0
  private_ip                           = "172.31.67.191"
  region                               = "us-east-1"
  secondary_private_ips                = []
  security_groups                      = ["default"]
  source_dest_check                    = true
  subnet_id                            = "subnet-0547049f320f1ea4a"
  tags = {
    Name = "Dragonstone2"
  }
  tenancy                     = "default"
  user_data                   = null
  user_data_replace_on_change = null
  volume_tags                 = null
  vpc_security_group_ids      = ["sg-0dd4a470ef40cf664"]
  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }
  cpu_options {
    core_count       = 1
    threads_per_core = 2
  }
  credit_specification {
    cpu_credits = "unlimited"
  }
  enclave_options {
    enabled = false
  }
  maintenance_options {
    auto_recovery = "default"
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = 2
    http_tokens                 = "required"
    instance_metadata_tags      = "disabled"
  }
  private_dns_name_options {
    enable_resource_name_dns_a_record    = false
    enable_resource_name_dns_aaaa_record = false
    hostname_type                        = "ip-name"
  }
  root_block_device {
    delete_on_termination = true
    encrypted             = false
    iops                  = 3000
    tags                  = {}
    tags_all              = {}
    throughput            = 125
    volume_size           = 8
    volume_type           = "gp3"
  }
}
