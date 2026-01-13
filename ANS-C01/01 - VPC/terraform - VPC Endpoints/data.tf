data "aws_iam_policy" "s3_full_access" {
  name = "AmazonS3FullAccess"
}

data "aws_caller_identity" "current" {}
