data"aws_iam_policy_document""glue_crawler_s3_access" {
 
 statement {
 actions = ["s3:ListBucket",
"s3:GetObject"]
 effect = "Allow"
 resources = ["${module.moda_raw_journease.bucket.arn}/*",
"${module.moda_raw_magento.bucket.arn}/*",
"${module.moda_raw_spreadsheets.bucket.arn}/*",
"${module.moda_processed.bucket.arn}/*"
 ]
 }
}

