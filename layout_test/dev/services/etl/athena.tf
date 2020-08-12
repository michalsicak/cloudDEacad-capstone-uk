resource "aws_s3_bucket" "athena-query-results-bucket" {
  bucket = "${local.name_prefix}athena-query-results-bucket"
  force_destroy = true
  tags = var.lab_tags
}

#add this to terminal before terraform apply
#terraform import aws_athena_workgroup.primary primary

resource "aws_athena_workgroup" "primary" {
  name = "${local.name_prefix}primary"

  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = true

    result_configuration {
      #remove subfolder - check with other settings
      output_location = "s3://${aws_s3_bucket.athena-query-results-bucket.bucket}"

    }
  }
  tags = var.lab_tags
}
resource "aws_athena_database" "capstonedb_uk" {
  name   = "capstonedb_uk"
  bucket = "${aws_s3_bucket.athena-query-results-bucket.bucket}"
  force_destroy = true
}
/*
resource "aws_athena_named_query" "covid_data_query" {
  name      = "covid_data_query"
  workgroup = aws_athena_workgroup.primary.id
  database  = aws_athena_database.capstonedb_uk.name
  query     = "SELECT * FROM ${aws_athena_database.capstonedb_uk.name} limit 10;"
}
*/