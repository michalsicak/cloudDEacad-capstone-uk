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

resource "aws_lambda_layer_version" "lambda_layer" {
  s3_bucket = aws_s3_bucket.data-dump-bucket.bucket
  s3_key  = aws_s3_bucket_object.python_package.key
  layer_name = "transformJSONlayer"
compatible_runtimes = ["python3.7"]
}
*/