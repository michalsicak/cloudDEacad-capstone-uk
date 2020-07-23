output data-dump-bucket {
  value       = aws_s3_bucket.data-dump-bucket
  description = "The  bucket name"
}

output capstonedb_uk {
  value       = aws_athena_database.capstonedb_uk
  description = "The Athena DB"
}