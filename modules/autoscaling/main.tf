data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_launch_template" "app_lt" {
  name_prefix   = "${var.project_name}-lt"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  network_interfaces {
    security_groups = [var.app_sg]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum install -y httpd
	      systemctl enable httpd
              systemctl start httpd
              echo "Hello from App Server" > /var/www/html/index.html
              EOF
  )
}

resource "aws_autoscaling_group" "app_asg" {
  desired_capacity = 2
  max_size         = 3
  min_size         = 1

  vpc_zone_identifier = var.subnets

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = aws_launch_template.app_lt.latest_version
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-app-instance"
    propagate_at_launch = true
  }
}
