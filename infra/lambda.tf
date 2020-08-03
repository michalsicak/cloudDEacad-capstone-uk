/*resource "aws_lambda_function" "test_lambda" {
  filename      = "lambda_function_payload.zip"
  function_name = "downloadAPI"
  role          = "${aws_iam_role.iam_for_lambda.arn}"
  handler       = "exports.test"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${filebase64sha256("lambda_function_payload.zip")}"

  runtime = "python3.7"

  environment {
    variables = {
      foo = "bar"
    }
  }
}
*/
resource "aws_lambda_layer_version" "lambda_layer" {
  s3_bucket = aws_s3_bucket.data-dump-bucket.bucket
  s3_key  = "python/python.zip"
  layer_name = "${local.name_prefix}transformJSONlayer"
compatible_runtimes = ["python3.7"]
}

resource "aws_lambda_function" "download_api_lambda" {
  filename      = "../python_scripts/script_download.zip"
  function_name = "${local.name_prefix}lambda_download_data_api"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "script_download.lambda_handler"
  #layers        = [aws_lambda_layer_version.lambda_layer.arn]
  runtime = "python3.7"
}

resource "aws_lambda_function" "transform_data_lambda" {
  filename      = "../python_scripts/script_transform.zip"
  function_name = "${local.name_prefix}lambda_transform_data"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "script_transform.lambda_handler"
  #the layer seems to load but does not work
  layers        = [aws_lambda_layer_version.lambda_layer.arn]
  runtime = "python3.7"
}
