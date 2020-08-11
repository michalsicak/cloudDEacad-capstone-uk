#s3 encryption
resource "aws_kms_key" "serverless_data" {
  description             = "This key is used to encrypt serverless-data bucket objects"
  deletion_window_in_days = 10
  tags = merge(var.lab_tags, {
      Key_Name = "capstone_key"
  })
}

resource "aws_kms_alias" "serverless_data" {
  name = "alias/serverless-data"
  target_key_id = aws_kms_key.serverless_data.key_id
}