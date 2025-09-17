variable "region" { default = "ap-southeast-2" }
variable "project" { default = "laravel-fargate" }
variable "desired_count" { type = number; default = 2 }
variable "ecr_repo_name" { default = "laravel-fargate-app" }
variable "image_tag" { default = "latest" } # CI will push with a SHA tag
