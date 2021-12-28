data "aws_secretsmanager_secret" "read-db-secrets" {
  name = "${var.ENV_NAME}/db"
}
data "aws_secretsmanager_secret_version" "read-db-secrets-username" {
  secret_id     = data.aws_secretsmanager_secret.read-db-secrets.id
}

resource "aws_db_subnet_group" "database_subnet_group" {
  name       = "${var.ENV_NAME}-db-subnet-group"
  subnet_ids = [[for s in var.PRIVATE_SUBNETS : s.id][0],[for s in var.PRIVATE_SUBNETS : s.id][1]]

  tags = {
    Name = "${var.ENV_NAME}-db-subnet-group"
    Terraform = "true"
    Environment = var.ENV_NAME
  }
}

resource "aws_db_instance" "my_database" {
  name = "my_database_${var.ENV_NAME}"
  identifier = "my-database-${var.ENV_NAME}"
  instance_class = "db.t2.micro"
  engine = "mysql"
  engine_version = "8.0"
  parameter_group_name = "default.mysql8.0"
  username = jsondecode(data.aws_secretsmanager_secret_version.read-db-secrets-username.secret_string)["username"]
  password = jsondecode(data.aws_secretsmanager_secret_version.read-db-secrets-username.secret_string)["password"]
  allocated_storage = 10
  max_allocated_storage = 100
  multi_az = false
  db_subnet_group_name = aws_db_subnet_group.database_subnet_group.name
  vpc_security_group_ids = [var.INTERNAL_SG]
  skip_final_snapshot = var.SKIP_FINAL_SNAPSHOT
  #  apply_immediately = true
  tags = {
    Terraform = "true"
    Environment = var.ENV_NAME
  }
}