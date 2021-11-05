resource "aws_db_instance" "db_instance" {
  identifier_prefix   = "${var.project}-${var.environment}-"
  allocated_storage   = 10
  engine              = "mysql"
  engine_version      = "5.7"
  instance_class      = "db.t2.micro"
  name                = var.db_name
  username            = var.db_username
  password            = var.db_password
  skip_final_snapshot = true
}