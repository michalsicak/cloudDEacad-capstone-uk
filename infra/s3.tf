resource "aws_s3_bucket" "data-dump-bucket" {
  bucket = "${local.name_prefix}data-dump-bucket"
}

resource "aws_s3_bucket_object" "hospital" {
  bucket = aws_s3_bucket.data-dump-bucket.bucket
  key    = "/hospitals/latest_hospital_data.json"
  source = "../data/hospital_beds.json"
}

resource "aws_s3_bucket_object" "covid_data" {
  bucket = aws_s3_bucket.data-dump-bucket.bucket
  key    = "/covid-data/latest_file_colorado.json"
  source = "../data/sample_covid_json.json"
}