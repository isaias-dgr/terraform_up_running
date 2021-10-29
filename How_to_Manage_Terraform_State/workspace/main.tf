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

resource "aws_instance" "example" {
  ami           = "ami-0d382e80be7ffdae5"
  instance_type = "t2.micro"

  tags = {
    Name = "${terraform.workspace}-instance"
  }
}

