resource "aws_s3_bucket" "knote_demo_bucket" {
  bucket = var.bucket_name
  acl    = "public-read"
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  policy = data.aws_iam_policy_document.knote_demo_bucket_policy_document.json

  website {
    index_document = "index.html"
  }
}

data "aws_iam_policy_document" "knote_demo_bucket_policy_document" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.bucket_name}/*"]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}
