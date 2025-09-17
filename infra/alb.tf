resource "aws_lb" "alb" {
  name = "${var.project}-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb_sg.id]
  subnets = [for s in aws_subnet.public : s.id]
  tags = { Name = "${var.project}-alb" }
}

resource "aws_lb_target_group" "app_tg" {
  name = "${var.project}-tg"
  port = 80
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = aws_vpc.this.id

  health_check {
    path = "/healthz"
    protocol = "HTTP"
    matcher = "200-399"
    interval = 30
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 5
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port = 80
  protocol = "HTTP"
  default_action { type = "forward"; target_group_arn = aws_lb_target_group.app_tg.arn }
}
