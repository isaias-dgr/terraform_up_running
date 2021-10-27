variable "number_example" {
  description = "An example of unmber variable in Terraform"
  type = number
  default = 42
}

variable "list_example" {
  description = "An example of list in Terraform"
  type = list
  default = ["a", "b", "c"]
}

variable "lsit_numeric_example" {
  description = "An example of numeric list in Terraform"
  type = list(number)
  default = [ 1,2,3 ]
}

variable "map_example" {
  description = "An example of map in Terraform"
  type = map(string)
  default = {
    key1="value1"
    key2="value2"
    key3="value3"
  }
}

variable "object_example" {
  description = "An  exmaple of structurak type in Terraform"
  type = object ({
    name = string
    age = number
    tags = list(string)
    enabled = bool
  })
  default = {
    name="value1"
    age = 42
    tags = ["a","b","c"] 
    enabled=true
  }
}

variable "server_port" {
  description = "The port the server will use for HTTP reques"
  type = number
  default = 8080
}

provider "aws" {
  region = "us-west-1"
}

resource "aws_instance" "example" {
  ami                    = "ami-0d382e80be7ffdae5"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
    #!/bin/bash 
      echo "Hola Mundo" > index.html
      nohup busybox httpd -f -p ${var.server_port} &

        tags = {
            Name = "terraform-example"
        }
      }
    EOF

  tags = {
    Name = "terraform-example"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_ip"{
  value = aws_instance.example.public_ip
  description = "The public IP address of the web service"
}