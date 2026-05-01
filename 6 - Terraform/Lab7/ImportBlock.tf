provider "aws" {
  region = "us-east-1"
}

import {
  to = aws_instance.ImportInstance
  id = "i-085ff748dd03e739e"
}

import {
  to = aws_security_group.SGq
  id = "sg-07c5855c7ba7b314b"
}

import {
  to = aws_s3_bucket.example
  identity = {
    bucket = "703930550709"
  }
}

import {
  to = aws_ebs_volume.ImportVolume
  id = "vol-011a3c0cbf945e767"
}

