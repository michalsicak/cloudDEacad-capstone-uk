output data-dump-bucket {
  value       = aws_s3_bucket.data-dump-bucket
  description = "The  bucket name"
}

output capstonedb_uk {
  value       = aws_athena_database.capstonedb_uk
  description = "The Athena DB"
}

output python_bucket {
  value       = aws_s3_bucket_object.python_package.key
}

output lambda_role_arn {
  value       = aws_iam_role.iam_for_lambda.arn
}