variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "tf_state_bucket_name" {
  type        = string
  description = "Name of the s3 bucket to be created."
}
