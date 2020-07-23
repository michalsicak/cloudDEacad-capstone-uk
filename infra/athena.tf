resource "aws_s3_bucket" "athena-query-results-bucket" {
  bucket = "${local.name_prefix}athena-query-results-bucket"
}

resource "aws_athena_database" "capstonedb_uk" {
  name   = "capstonedb_uk"
  bucket = "${aws_s3_bucket.athena-query-results-bucket.bucket}/results/"
}