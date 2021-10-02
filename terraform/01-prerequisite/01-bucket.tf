# Colearn-V2 bucket
resource "aws_s3_bucket" "demo--terraform-remote-state" {
  bucket = var.tf_state_bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  force_destroy = "true"
}