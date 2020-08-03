resource "aws_cloudwatch_event_rule" "daily_api" {
  name        = "${local.name_prefix}capture-api-data"
  description = "daily download of data via api"

  schedule_expression = "cron(0 * * * ? *)"
}