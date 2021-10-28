variable "server_port" {
  description = "The port the server will use for HTTP reques"
  type        = number
  default     = 8080
}

provider "aws" {
  region = "us-west-1"
}

# 1. Create the config of instances 
resource "aws_launch_configuration" "example" {
  image_id        = "ami-0d382e80be7ffdae5"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.instance.id]

  user_data = <<-EOF
      #!/bin/bash
      echo "Hola Mundo" > index.html &
      nohup busybox httpd -f -p ${var.server_port} &
    EOF

  lifecycle {
    create_before_destroy = true
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


# 2.- Create autoscaling group
resource "aws_autoscaling_group" "example" {
  # Type of images Setup step 1
  launch_configuration = aws_launch_configuration.example.name 
  vpc_zone_identifier  = data.aws_subnet_ids.default.ids

  # this instance are called by Load Balancer
  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"

  min_size = 2
  max_size = 10

  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}


data "aws_vpc" default {
  default = true
}

# 3. Use the defaul VPC
data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

# 4 Create Load balancer ALB
resource "aws_lb" "example" {
  name               = "terraform-asg-example"
  load_balancer_type = "application"
  # Subnet with the instances of cluster
  subnets            = data.aws_subnet_ids.default.ids
  # add security group to load balancer
  security_groups    = [aws_security_group.alb.id]
}

# ALB Listener To listen all call to urn name on the port 80
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

# to allowd access from out to in bypass
resource "aws_security_group" "alb" {
  name = "terraform-example-alb"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# relatioin ship between lb ans cluster instances
resource "aws_lb_target_group" "asg" {
  name     = "terraform-asg-example"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# security to only allow calls url with a pattern
resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}

output "alb_dns_name" {
  value       = aws_lb.example.dns_name
  description = "The domain name of the load balancer"
}