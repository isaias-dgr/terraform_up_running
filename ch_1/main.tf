provider "aws" {
    region = "us-west-1"
}

resource "aws_instance" "example" {
  ami = "ami-03ab7423a204da002"
  instance_type = "t2.micro"

  tags = {
      Name = "terraform-example"
  }
}
