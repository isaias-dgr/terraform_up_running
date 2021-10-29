provider "aws" {
  region = "us-west-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-bck-state"
    key    = "states/terraform.tfstate"

    dynamodb_table = "terraform-locks-db"
    encrypt        = true
    region         = "us-west-1"
  }
}

resource "aws_db_instance" "example" {
  identifier_prefix   = "terraform-up-and-running"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  name                = "example_database"
  username            = "admin"
  password            = data.aws_secretsmanager_secret_version.db_password.secret_string
  skip_final_snapshot = true
}

data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = "mysql-master-password-stage"
}

output "address" {
  value       = aws_db_instance.example.address
  description = "Connect to the database at this endpoint"
}

output "port" {
  value       = aws_db_instance.example.port
  description = "The port the database is listening on"
}

