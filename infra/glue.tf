resource "aws_glue_classifier" "capstone_classifier" {
  name = "${local.name_prefix}capstone_classifier"

  csv_classifier {
    allow_single_column    = false
    contains_header        = "PRESENT"
    delimiter              = ","
    disable_value_trimming = false
    quote_symbol           = "'"
  }
}

resource "aws_glue_crawler" "crawler_hospital" {
  database_name = aws_athena_database.capstonedb_uk.name
  #"${aws_glue_catalog_database.crawler1.name}"
  name          = "capstone_terraform_crawl_hospital_data"
  role          = aws_iam_role.glue_crawler_role.arn
  classifiers   = ["${local.name_prefix}capstone_classifier"]
  schedule      = "cron(0 1 * * ? *)"
  s3_target {
    path = "s3://${local.name_prefix}data-stage-bucket/${var.hospital_data}"
  }
}

resource "aws_glue_crawler" "crawler_covid" {
  database_name = aws_athena_database.capstonedb_uk.name
  #"${aws_glue_catalog_database.crawler1.name}"
  name          = "capstone_terraform_crawl_covid_data"
  role          = aws_iam_role.glue_crawler_role.arn
  classifiers   = ["${local.name_prefix}capstone_classifier"]
  schedule      = "cron(0/15 * * * ? *)"
  s3_target {
    path = "s3://${local.name_prefix}data-stage-bucket/${var.covid_data}"
  }
}