resource "aws_s3_bucket" "capstoneteamuk" {
  bucket = "capstone-team-bucket"
  acl    = "private"

  tags = {
    Name        = "Capstone Team Bucket"
    Environment = "Dev"
  }
}