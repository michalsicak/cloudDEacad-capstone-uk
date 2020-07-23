resource "aws_s3_bucket" "bucket" {
  acl    = var.s3_bucket_acl
  bucket = "${var.s3_bucket_name}-${var.environment}"
  policy = var.s3_bucket_policy
  force_destroy = var.s3_bucket_force_destroy
  versioning {
    enabled    = var.enable_versioning
    mfa_delete = var.mfa_delete
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = var.sse_algorithm
      }
    }
  }
  tags = var.common_tags
}
output bucket {
  value       = aws_s3_bucket.bucket
  description = "The  bucket name"
}

variable "common_tags" {
  description = "This is a map type for applying tags on resources"
  type        = map
}
variable "s3_bucket_name" {
  description = "capstoneteamuk"
  type        = string
}
variable "s3_bucket_policy" {
  description = "s3 bucket policy"
  type        = string
}
variable "environment" {
  description = "The environment we are using"
  type        = string
}
variable "s3_bucket_acl" {
    description = "ACL for the bucket"
    type = string
    default = "private"
}
variable "s3_bucket_force_destroy" {
    description = "Require items in the bucket to first be removed before it can be destroyed"
    type = string
    default = true
}
variable "enable_versioning" {
  description = "Enable versioning on s3 bucket"
  type        = bool
  default     = true
}
variable "sse_algorithm" {
  description = "The type of encryption algorithm to use"
  type        = string
  default     = "AES256"
}
variable "mfa_delete" {
  type        = bool
  description = "To enable/disable MFA delete"
  default     = false
}

#diff file
module "moda_athena_results" {
 source = "../modules/s3/"
 environment = var.environment
 common_tags = var.common_tags
 s3_bucket_force_destroy = var.s3_bucket_force_destroy
 s3_bucket_name = "moda-athena-results"
 s3_bucket_policy = "${data.aws_iam_policy_document.moda_athena_results.json}"
 mfa_delete = var.mfa_delete
}