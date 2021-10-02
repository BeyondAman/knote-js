# DocumentDB configurations
db_cluster_identifier = "knote-demo"
db_engine_version = "4.0.0"
db_username = "demo"
db_password = "demo"
db_backup_retention_period = 3
db_backup_window = "20:00-23:00"
db_instance_class = "db.t4g.large"

# S3 bucket for minio storage backend
bucket_name = "knote-demo-images"

# Secret Manager
db_creds_secret_name = "demo/db_creds" # Name of secret in which db creds would be stored
external_secrets_namespace = "external-secrets" # namespace in which external secrets controller would be deployed
external_secrets_sa = "kubernetes-external-secrets" # SA to be used to get secrets from AWS Secret Manager

# EKS cluster configurations
cluster_name = "demo-cluster"
environment = "demo-cluster"

region = "us-west-2"

vpc_cidr = "10.97.240.0/20"
vpc_private_subnets =  ["10.97.240.0/22", "10.97.244.0/22"]
vpc_public_subnets = ["10.97.248.0/22", "10.97.252.0/22"]

master_version_prefix = "1.21"

cluster_node_groups = {
  node_pool_a = {
    desired_capacity = 5
    max_capacity     = 10
    min_capacity     = 5

    instance_type = "t3.xlarge"
  }
}
