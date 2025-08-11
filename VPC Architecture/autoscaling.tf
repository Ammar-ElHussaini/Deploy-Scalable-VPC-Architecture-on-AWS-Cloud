# Security Group for EC2 Instances
resource "aws_security_group" "instance_sg" {
  vpc_id = aws_vpc.main.id
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.nlb_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "instance-sg"
  }
}

# Launch Template for Auto Scaling
resource "aws_launch_template" "main" {
  name_prefix   = "main-launch-template-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  user_data     = filebase64("${path.module}/userdata.sh")
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.instance_sg.id]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "asg-instance"
    }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "main" {
  desired_capacity = 2
  min_size         = 2
  max_size         = 4
  vpc_zone_identifier = [aws_subnet.private[0].id, aws_subnet.private[1].id]
  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }
  health_check_type         = "ELB"
  health_check_grace_period = 300
  target_group_arns         = [aws_lb_target_group.main.arn]
  tags = [
    {
      key                 = "Name"
      value               = "asg-instance"
      propagate_at_launch = true
    }
  ]
}