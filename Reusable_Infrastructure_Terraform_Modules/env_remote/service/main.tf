provider "aws" {
  region = "us-west-1"
}

terraform {
  backend "s3" {
    bucket         = "todo-stage-storage"
    key            = "todo-states/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "todo-stage-lock"
    encrypt        = true
  }
}

module "relational_db" {
  source = "github.com/isaias-dgr/terraform_up_running/Reusable_Infrastructure_Terraform_Modules/modules/relational-db"

  project = var.project
  environment = var.environment

  db_name = "${var.project}db"
  db_username = "admin"
  db_password = var.db_password
}

module "webserver_cluster" {
  source = "github.com/isaias-dgr/terraform_up_running/Reusable_Infrastructure_Terraform_Modules/modules/webserver-cluster"

  cluster_name           = "${var.project}-${var.environment}"
  db_remote_state_bucket = var.db_remote_state_bucket
  db_remote_state_key    = var.db_remote_state_key
  db_address = module.relational_db.address
  db_port = module.relational_db.port

  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 2
}

resource "aws_security_group_rule" "allow_testing_inbound" {
  type              = "ingress"
  security_group_id = module.webserver_cluster.alb_security_group_id

  from_port   = 12345
  to_port     = 12345
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

