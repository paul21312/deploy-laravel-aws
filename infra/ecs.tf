resource "aws_ecs_cluster" "cluster" {
  name = "${var.project}-cluster"
}

resource "aws_cloudwatch_log_group" "app" {
  name = "/ecs/${var.project}"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "app_td" {
  family = "${var.project}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  cpu = "256"      # 0.25 vCPU
  memory = "512"   # 0.5GB
  execution_role_arn = aws_iam_role.ecs_exec_role.arn

  container_definitions = jsonencode([{
    name = "app"
    image = "${aws_ecr_repository.app.repository_url}:${var.image_tag}"
    essential = true
    portMappings = [{ containerPort = 80, protocol = "tcp" }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group = aws_cloudwatch_log_group.app.name
        awslogs-region = var.region
        awslogs-stream-prefix = "app"
      }
    }
  }])
}

resource "aws_ecs_service" "app_svc" {
  name = "${var.project}-service"
  cluster = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.app_td.arn
  desired_count = var.desired_count
  launch_type = "FARGATE"

  network_configuration {
    subnets = [for s in aws_subnet.public : s.id]   # public subnets (assign public IP)
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name = "app"
    container_port = 80
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent = 200

  depends_on = [aws_lb_listener.http]
}
