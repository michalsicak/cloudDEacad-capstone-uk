resource "aws_glue_crawler" "crawler1" {
  database_name = aws_athena_database.capstonedb_uk.name
  #"${aws_glue_catalog_database.crawler1.name}"
  name          = "capstone_terraform_crawl_hospitals"
  role          = aws_iam_role.glue_crawler_role.arn
  classifiers   = ["capstone_classifier"]
  s3_target {
    path = "s3://${local.name_prefix}data-dump-bucket/hospitals/"
  }
}

resource "aws_glue_crawler" "crawler2" {
  database_name = aws_athena_database.capstonedb_uk.name
  #"${aws_glue_catalog_database.crawler1.name}"
  name          = "capstone_terraform_crawl_covid_data"
  role          = aws_iam_role.glue_crawler_role.arn
  classifiers   = ["capstone_classifier"]
  s3_target {
    path = "s3://${local.name_prefix}data-dump-bucket/covid-data/"
  }
}