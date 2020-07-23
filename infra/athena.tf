resource "aws_s3_bucket" "athena-query-results-bucket" {
  bucket = "${local.name_prefix}athena-query-results-bucket"
}

resource "aws_athena_workgroup" "primary" {
  name = "primary-capstone"

  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = true

    result_configuration {
      output_location = "s3://${aws_s3_bucket.athena-query-results-bucket.bucket}/query-results/"

    }
  }
}
resource "aws_athena_database" "capstonedb_uk" {
  name   = "capstonedb_uk"
  bucket = "${aws_s3_bucket.athena-query-results-bucket.bucket}/query-results/"
}