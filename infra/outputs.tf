output data-dump-bucket {
  value       = aws_s3_bucket.data-dump-bucket
  description = "The  bucket name"
}

output python_bucket {
  value       = aws_s3_bucket_object.python_package
  #value       = aws_s3_bucket_object.python_package.key
}

output lambda_role_arn {
  value       = aws_iam_role.iam_for_lambda.arn
}

output "lambda_layer" {
  value       = aws_lambda_layer_version.lambda_layer
}

output athena_connection {
  value       = "athena.${local.aws_region}.amazonaws.com"
  description = "The Athena DB"
}

output athena_db {
  value       = "s3://${aws_athena_database.capstonedb_uk.bucket}/"
  description = "The Athena DB"
}
