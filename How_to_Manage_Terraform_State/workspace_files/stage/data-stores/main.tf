
provider "aws" {
  region = "us-west-1"
}

terraform {
  backend "s3" {
    bucket         = "states-storage"
    key            = "project/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "states-lock"
    encrypt        = true
  }
}

resource "aws_db_instance" "example" {
  identifier_prefix   = "terraform-up-and-running-${var.environment}"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  username            = "admin"
  name                = var.db_name
  skip_final_snapshot = true
  password            = var.db_password
}
