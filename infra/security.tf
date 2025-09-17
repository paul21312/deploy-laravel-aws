resource "aws_security_group" "alb_sg" {
  name        = "${var.project}-alb-sg"
  vpc_id      = aws_vpc.this.id
  description = "Allow inbound HTTP from internet to ALB"

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

resource "aws_security_group" "ecs_sg" {
  name        = "${var.project}-ecs-sg"
  vpc_id      = aws_vpc.this.id
  description = "Allow ALB to ECS tasks"

  ingress {
    from_port       = 80 
    to_port         = 80 
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
