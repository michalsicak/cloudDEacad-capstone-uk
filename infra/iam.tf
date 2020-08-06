resource "aws_iam_role" "glue_crawler_role" {
  name = "${local.name_prefix}GlueCrawlerRole"

#  tags = var.resource_tags

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "glue.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

resource "aws_iam_policy" "glue_crawler_policy" {
  name        = "${local.name_prefix}GlueCrawlerPolicy"
  description = "Policy for Glue role"
  path        = "/"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::${local.name_prefix}*/*"
            ]
        }
    ]
}
EOF
}

#attaches the custom crawler policy to the role
resource "aws_iam_role_policy_attachment" "glue_crawler_policy_attachment" {
  role       = aws_iam_role.glue_crawler_role.name
  policy_arn = aws_iam_policy.glue_crawler_policy.arn
}

#assigns the AWSGlueServiceRole policy to the role created at the beginning of this script
resource "aws_iam_role_policy_attachment" "glue_service_role_attachment" {
  role       = aws_iam_role.glue_crawler_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "${local.name_prefix}iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "${local.name_prefix}lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_iam_role_policy_attachment" "lambda_s3_role_attachment" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

#rule to allow eventbridge to trigger lambda to download data via API
resource "aws_lambda_permission" "allow_cloudwatch_to_call_daily_api" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.download_api_covid_lambda.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.daily_api.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_daily_hospitals_api" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.download_api_hospitals_lambda.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.daily_api.arn}"
}

#rule to allow S3 invoke Lambda
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.transform_covid_data_lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.data-dump-bucket.arn
}

resource "aws_lambda_permission" "allow_bucket_hospitals" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.transform_hospitals_data_lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.data-dump-bucket.arn
}