resource "aws_s3_bucket" "resources-bucket" {
  bucket = "e329325-resources-bucket"
}

resource "aws_s3_bucket_object" "python_package" {
  bucket = aws_s3_bucket.resources-bucket.bucket
  key    = "python/python.zip"
  source = "../python_scripts/resources/python.zip"
}