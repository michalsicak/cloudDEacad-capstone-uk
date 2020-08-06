resource "aws_lambda_layer_version" "lambda_layer" {
  filename      = "../python_scripts/python.zip"
  #s3_bucket = aws_s3_bucket.resources-bucket.bucket
  #s3_key  = "python/python.zip"
  layer_name = "${local.name_prefix}transformJSONlayer"
compatible_runtimes = ["python3.7"]
}

resource "aws_lambda_function" "download_api_covid_lambda" {
  s3_bucket = aws_s3_bucket.resources-bucket.bucket
  s3_key  = "python/script_download_covid.zip"
  function_name = "${local.name_prefix}lambda_download_data_covid_api"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "script_download_covid.lambda_handler"
  #layers        = [aws_lambda_layer_version.lambda_layer.arn]
  runtime = "python3.7"
}

resource "aws_lambda_function" "download_api_hospitals_lambda" {
  s3_bucket = aws_s3_bucket.resources-bucket.bucket
  s3_key  = "python/script_download_hospitals.zip"
  function_name = "${local.name_prefix}lambda_download_data_hospitals_api"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "script_download_hospitals.lambda_handler"
  #layers        = [aws_lambda_layer_version.lambda_layer.arn]
  runtime = "python3.7"
}

resource "aws_lambda_function" "transform_covid_data_lambda" {
#  filename      = "../python_scripts/script_transform.zip"
  s3_bucket = aws_s3_bucket.resources-bucket.bucket
  s3_key  = "python/script_transform_covid_v${var.script_version}.zip"
  function_name = "${local.name_prefix}lambda_transform_covid_data"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "script_transform_covid_v${var.script_version}.lambda_handler"
  #the layer seems to load but does not work
  layers        = [aws_lambda_layer_version.lambda_layer.arn,"arn:aws:lambda:us-west-2:420165488524:layer:AWSLambda-Python37-SciPy1x:20"]
  runtime = "python3.7"
}

resource "aws_lambda_function" "transform_hospitals_data_lambda" {
#  filename      = "../python_scripts/script_transform.zip"
  s3_bucket = aws_s3_bucket.resources-bucket.bucket
  s3_key  = "python/script_transform_hospitals.zip"
  function_name = "${local.name_prefix}lambda_transform_hospitals_data"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "script_transform_hospitals.lambda_handler"
  #the layer seems to load but does not work
  layers        = [aws_lambda_layer_version.lambda_layer.arn,"arn:aws:lambda:us-west-2:420165488524:layer:AWSLambda-Python37-SciPy1x:20"]
  runtime = "python3.7"
}