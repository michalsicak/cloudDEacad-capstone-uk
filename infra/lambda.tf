resource "aws_lambda_layer_version" "lambda_layer" {
#  filename      = "../python.zip"
  s3_bucket = aws_s3_bucket.resources-bucket.bucket
  s3_key  = "python/python.zip"
  layer_name = "${local.name_prefix}transformJSONlayer"
compatible_runtimes = ["python3.7"]
}

resource "aws_lambda_function" "download_api_lambda" {
  #filename      = "../python_scripts/script_download.zip"
  s3_bucket = aws_s3_bucket.resources-bucket.bucket
  s3_key  = "python/python_download.zip"
  function_name = "${local.name_prefix}lambda_download_data_api"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "script_download.lambda_handler"
  #layers        = [aws_lambda_layer_version.lambda_layer.arn]
  runtime = "python3.7"
}

resource "aws_lambda_function" "transform_data_lambda" {
#  filename      = "../python_scripts/script_transform.zip"
  s3_bucket = aws_s3_bucket.resources-bucket.bucket
  s3_key  = "python/python_transform.zip"
  function_name = "${local.name_prefix}lambda_transform_data"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "script_transform.lambda_handler"
  #the layer seems to load but does not work
  layers        = [aws_lambda_layer_version.lambda_layer.arn,"arn:aws:lambda:us-west-2:420165488524:layer:AWSLambda-Python37-SciPy1x:20"]
  runtime = "python3.7"
}
