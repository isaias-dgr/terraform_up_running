provider "aws" {
    region = "us-west-1"
}

resource "aws_instance" "example" {
  ami = "ami-0d382e80be7ffdae5"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
    #!/bin/bash 
      echo "Hola Mundo" > index.html
      nohup busybox httpd -f -p 8080 &

        tags = {
            Name = "terraform-example-2"
        }
      }
    EOF

  tags = {
      Name = "terraform-example"
  }
}

resource "aws_security_group" "instance"{
  name = "terraform-example-instance"

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}