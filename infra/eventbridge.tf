resource "aws_cloudwatch_event_rule" "daily_api" {
  name        = "${local.name_prefix}capture-api-data"
  description = "daily download of data via api"

  schedule_expression = "cron(0/5 * * * ? *)"
}

resource "aws_cloudwatch_event_target" "download_data_every_day" {
  rule      = "${aws_cloudwatch_event_rule.daily_api.name}"
  target_id = "lambda"
  arn       = "${aws_lambda_function.download_api_lambda.arn}"
}