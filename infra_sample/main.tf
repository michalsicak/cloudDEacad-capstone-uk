resource "random_id" "id" {
	  byte_length = 8
}

resource "aws_s3_bucket" "resources-bucket" {
  bucket = "${random_id.id.hex}-demo-resources-bucket"
  force_destroy = true
}

resource "aws_s3_bucket_object" "python_package" {
  bucket = aws_s3_bucket.resources-bucket.bucket
  key    = "python/python.zip"
  source = "../python_scripts/resources/python.zip"
}