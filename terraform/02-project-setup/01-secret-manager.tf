# add secret to store postgres db creds 
resource "aws_secretsmanager_secret" "db_creds" {
  name = var.db_creds_secret_name
}

variable "db_secret" {
  default = {
    MONGO_URL = "mongodb://${aws_docdb_cluster.cluster.master_username}:${aws_docdb_cluster.cluster.master_password}@${aws_docdb_cluster.cluster.endpoint}:${aws_docdb_cluster.cluster.port}"
  }

  type = map(string)
}

resource "aws_secretsmanager_secret_version" "db_creds" {
  secret_id     = aws_secretsmanager_secret.db_creds.id
  secret_string = jsonencode(var.db_secret)
}
