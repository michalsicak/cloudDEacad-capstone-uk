resource "aws_lambda_layer_version" "lambda_layer" {
  #filename      = "../python_scripts/python.zip"
  s3_bucket = aws_s3_bucket.resources-bucket.bucket
  s3_key  = aws_s3_bucket_object.python_package.key
  layer_name = "${local.name_prefix}transformJSONlayer"
compatible_runtimes = ["python3.7"]
}

resource "aws_lambda_function" "download_api_covid_lambda" {
  s3_bucket = aws_s3_bucket.resources-bucket.bucket
  s3_key  = aws_s3_bucket_object.python_download_script.key
  function_name = "${local.name_prefix}lambda_download_data_covid_api"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "script_download_covid.lambda_handler"
  #layers        = [aws_lambda_layer_version.lambda_layer.arn]
  runtime = "python3.7"
  tags = var.lab_tags
}

resource "aws_lambda_function" "download_api_hospital_lambda" {
  s3_bucket = aws_s3_bucket.resources-bucket.bucket
  s3_key  = aws_s3_bucket_object.python_download_hospital_script.key
  function_name = "${local.name_prefix}lambda_download_data_hospital_api"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "script_download_hospital.lambda_handler"
  #layers        = [aws_lambda_layer_version.lambda_layer.arn]
  runtime = "python3.7"
  tags = var.lab_tags
}

resource "aws_lambda_function" "transform_covid_data_lambda" {
#  filename      = "../python_scripts/script_transform.zip"
  s3_bucket = aws_s3_bucket.resources-bucket.bucket
  s3_key  = aws_s3_bucket_object.python_transform_script.key
  function_name = "${local.name_prefix}lambda_transform_covid_data"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "script_transform_covid_v${var.script_version}.lambda_handler"
  #the layer seems to load but does not work
  layers        = [aws_lambda_layer_version.lambda_layer.arn,"arn:aws:lambda:eu-west-1:399891621064:layer:AWSLambda-Python37-SciPy1x:22"]
  runtime = "python3.7"
  tags = var.lab_tags
}

resource "aws_lambda_function" "transform_hospital_data_lambda" {
#  filename      = "../python_scripts/script_transform.zip"
  s3_bucket = aws_s3_bucket.resources-bucket.bucket
  s3_key  = aws_s3_bucket_object.python_transform_hospital_script.key
  function_name = "${local.name_prefix}lambda_transform_hospital_data"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "script_transform_hospital.lambda_handler"
  #the layer seems to load but does not work
  layers        = [aws_lambda_layer_version.lambda_layer.arn,"arn:aws:lambda:eu-west-1:399891621064:layer:AWSLambda-Python37-SciPy1x:22"]
  runtime = "python3.7"
  tags = var.lab_tags
}