resource "random_id" "id" {
	  byte_length = 8
}

resource "aws_s3_bucket" "resources-bucket" {
  bucket = "${local.name_prefix}${random_id.id.hex}-demo-resources-bucket"
  force_destroy = true
  tags = var.lab_tags
}

resource "aws_s3_bucket_object" "python_package" {
  bucket = aws_s3_bucket.resources-bucket.bucket
  key    = "python/python.zip"
  source = "../python_scripts/resources/python.zip"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "${local.name_prefix}${random_id.id.hex}tf-state"
  # Enable versioning so we can see the full revision history of our
  # state files
  versioning {
    enabled = true
  }
  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = var.lab_tags
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "${local.name_prefix}tf-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = var.lab_tags
}