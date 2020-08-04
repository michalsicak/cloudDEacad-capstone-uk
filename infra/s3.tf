resource "aws_s3_bucket" "data-dump-bucket" {
  bucket = "${local.name_prefix}data-dump-bucket"
}

resource "aws_s3_bucket" "resources-bucket" {
  bucket = "${local.name_prefix}resources-bucket"
}

resource "aws_s3_bucket" "data-stage-bucket" {
  bucket = "${local.name_prefix}data-stage-bucket"
}

/*not used since hospital data csv errors in glue
resource "aws_s3_bucket_object" "hospital" {
  bucket = aws_s3_bucket.data-dump-bucket.bucket
  key    = "/hospital-data/hospital-data.csv"
  source = "../data/hospital-data.csv"
}
*/
resource "aws_s3_bucket_object" "covid_data" {
  bucket = aws_s3_bucket.data-stage-bucket.bucket
  key    = "/covid-data/covid-data_sample.csv"
  source = "../data/covid-data.csv"
}

resource "aws_s3_bucket_object" "python_package" {
  bucket = aws_s3_bucket.resources-bucket.bucket
  key    = "python/python.zip"
  #remove initial / from key?
  source = "../python_scripts/python.zip"
}

resource "aws_s3_bucket_object" "python_download_script" {
  bucket = aws_s3_bucket.resources-bucket.bucket
  key    = "/python/python_download.zip"
  source = "../python_scripts/script_download.zip"
}

resource "aws_s3_bucket_object" "python_transform_script" {
  bucket = aws_s3_bucket.resources-bucket.bucket
  key    = "/python/python_transform.zip"
  source = "../python_scripts/script_transform.zip"
}