resource "aws_db_subnet_group" "db" {
  name       = "${var.name_prefix}-db"
  subnet_ids = var.subnet_ids

  tags = merge(
    { Name = "${var.name_prefix}-db" }, var.tags

  )


}

resource "aws_db_instance" "db_ins" {
  identifier = "${var.name_prefix}-db-ins"

  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_encrypted     = var.storage_encrypted

  db_name  = var.db_name
  username = var.db_username
  password = random_password.db.result


  vpc_security_group_ids = var.security_group_ids
  db_subnet_group_name   = aws_db_subnet_group.db.name

  publicly_accessible     = false
  multi_az                = var.multi_az
  backup_retention_period = var.backup_retention

  auto_minor_version_upgrade = true
  skip_final_snapshot        = true

  tags = merge(
    { Name = "${var.name_prefix}-database" },
    var.tags
  )
}

resource "aws_secretsmanager_secret" "db" {
  name        = var.secret_name != "" ? var.secret_name : "${var.name_prefix}-db-credentials"
  description = "Database credentials for ${var.name_prefix}"

  kms_key_id              = var.kms_key_id
  recovery_window_in_days = var.env == "dev" ? 0 : 30

  tags = merge(
    { Name = "${var.name_prefix}-db-secret" },
    var.tags
  )
}


resource "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id
  secret_string = jsonencode({
    DATABASE_URL = "postgres://${var.db_username}:${urlencode(random_password.db.result)}@${aws_db_instance.db_ins.address}:${aws_db_instance.db_ins.port}/${var.db_name}"
    username     = var.db_username
    password     = random_password.db.result
    host         = aws_db_instance.db_ins.address
    port         = aws_db_instance.db_ins.port
    dbname       = var.db_name
    engine       = var.engine
  })
}

resource "random_password" "db" {
  length           = 16
  special          = true
  override_special = "!#$%&()*+,-.:;<=>?[]^_{|}~"
}







