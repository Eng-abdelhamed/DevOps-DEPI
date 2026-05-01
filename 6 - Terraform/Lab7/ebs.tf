# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform
resource "aws_ebs_volume" "ImportVolume" {
  availability_zone          = "us-east-1f"
  encrypted                  = false
  final_snapshot             = null
  iops                       = 3000
  multi_attach_enabled       = false
  outpost_arn                = null
  region                     = "us-east-1"
  size                       = 8
  snapshot_id                = "snap-02d946866914ba929"
  tags                       = {}
  tags_all                   = {}
  throughput                 = 125
  type                       = "gp2"
}
