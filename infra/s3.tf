resource "aws_s3_bucket" "data-dump-bucket" {
  bucket = "${local.name_prefix}data-dump-bucket"
}

resource "aws_s3_bucket_object" "hospital" {
  bucket = aws_s3_bucket.data-dump-bucket.bucket
  key    = "/hospital-data/hospital-data.csv"
  source = "../data/hospital-data.csv"
}

resource "aws_s3_bucket_object" "covid_data" {
  bucket = aws_s3_bucket.data-dump-bucket.bucket
  key    = "/covid-data/covid-data.csv"
  source = "../data/covid-data.csv"
}

resource "aws_s3_bucket_object" "python_package" {
  bucket = aws_s3_bucket.data-dump-bucket.bucket
  key    = "/python/python.zip"
  source = "../python.zip"
}