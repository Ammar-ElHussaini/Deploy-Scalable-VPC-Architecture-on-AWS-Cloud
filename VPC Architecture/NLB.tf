# Security Group for NLB
resource "aws_security_group" "nlb_sg" {
  vpc_id = aws_vpc.main.id
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
  tags = {
    Name = "nlb-sg"
  }
}

# Network Load Balancer
resource "aws_lb" "main" {
  name               = "main-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.public[1].id]
  tags = {
    Name = "main-nlb"
  }
}

# NLB Target Group
resource "aws_lb_target_group" "main" {
  name     = "main-tg"
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.main.id
  health_check {
    protocol            = "HTTP"
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 30
  }
}

# NLB Listener
resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}