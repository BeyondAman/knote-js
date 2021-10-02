# DocumentDB configurations
variable "db_cluster_identifier" {
  type        = string
  description = "reates a unique cluster identifier beginning with the specified prefix"
}

variable "db_engine_version" {
  type        = string
  description = "The database engine version. Updating this argument results in an outage."
}

variable "db_username" {
  type        = string
  description = "Username for the master DB user"
}

variable "db_password" {
  type        = string
  description = "Password for the master DB user"
}

variable "db_backup_retention_period" {
  type        = string
  description = "The days to retain backups for. Default 1"
}

variable "db_backup_window" {
  type        = string
  description = "The daily time range during which automated backups are created"
}

variable "db_instance_class" {
  type        = string
  description = "The instance class to use"
}

# S3 bucket for minio storage backend
variable "bucket_name" {
  type        = string
  description = "Bucket name - to be used for minio"
}

# EKS cluster configurations
variable "cluster_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "vpc_private_subnets" {
  type = list(string)
}

variable "vpc_public_subnets" {
  type = list(string)
}


variable "master_version_prefix" {
  type = string
}

variable "cluster_node_groups" {
  default = {
    node_pool_a = {
      desired_capacity = 1
      max_capacity     = 5
      min_capacity     = 1

      instance_type = "t2.small"
    }
  }
}
