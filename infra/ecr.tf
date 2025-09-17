resource "aws_ecr_repository" "app" {
  name = var.ecr_repo_name
  image_scanning_configuration { scan_on_push = true }
  tags = { Name = "${var.project}-ecr" }
}
