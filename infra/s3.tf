resource "aws_s3_bucket" "bucket" {
  bucket = "${local.name_prefix}bucket"
  }