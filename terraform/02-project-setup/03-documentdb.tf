# TODO: update to use global documentdb
resource "aws_docdb_subnet_group" "subnetgroup" {
  name       = "docdb-subnet-group"
  subnet_ids = ["${module.vpc.private_subnets}"]
}

resource "aws_docdb_cluster" "cluster" {
  skip_final_snapshot     = true
  db_subnet_group_name    = aws_docdb_subnet_group.subnetgroup.name
  cluster_identifier      = var.db_cluster_identifier
  engine                  = "docdb"
  engine_version          = var.db_engine_version
  master_username         = var.db_username
  master_password         = var.db_password
  backup_retention_period = var.db_backup_retention_period
  preferred_backup_window = var.db_backup_window
  vpc_security_group_ids  = ["${aws_security_group.service.id}"]
}

resource "aws_docdb_cluster_instance" "cluster_instance" {
  count              = 1
  identifier         = "${var.db_cluster_identifier}-cluster-instance"
  cluster_identifier = aws_docdb_cluster.cluster.id
  instance_class     = var.db_instance_class
}
