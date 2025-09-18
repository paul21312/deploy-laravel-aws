
---

## Requirements

- AWS Account
- Terraform v1.7+
- GitHub repository with secrets:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
  - `EXEC_ROLE_ARN` (for ECS task execution)

---

## Features

### Infrastructure
- VPC with 2 public subnets (for ALB) and 2 private subnets.
- Application Load Balancer with `/healthz` health check.
- ECS Fargate Service:
  - Desired count: 2 tasks
  - Rolling deployments
  - Healthy targets in multiple AZs
- ECR repository for the Laravel container image.
- IAM Roles with least privilege for ECS tasks.

### Application
- Minimal Laravel app with `/healthz` route.
- Containerized with Docker (Nginx + PHP-FPM).

### CI/CD
- GitHub Actions workflow:
  - Builds and pushes Docker image to ECR.
  - Updates ECS service with new task definition.
- Optional Terraform workflow:
  - `apply` or `destroy` infrastructure.
  - Can run manually or trigger on changes in `infra/`.

---

## Deployment

### 1. Terraform (Optional)
```bash
cd infra/
terraform init
terraform plan
terraform apply -auto-approve

Output will look like:

alb_dns      = "laravel-fargate-alb-xxxxxxxx.ap-southeast-2.elb.amazonaws.com"
ecr_repo_url = "372836560826.dkr.ecr.ap-southeast-2.amazonaws.com/laravel-fargate-app"


### 2. CI/CD
Push to main branch to trigger deployment:
Builds Docker image
Pushes to ECR
Updates ECS service and forces new deployment

You can also run workflows manually from GitHub Actions.

Access App

ALB URL from Terraform outputs:
http://laravel-fargate-alb-1382219124.ap-southeast-2.elb.amazonaws.com/

Health check:
curl http://laravel-fargate-alb-1382219124.ap-southeast-2.elb.amazonaws.com/healthz
# Should return 200 OK

Notes

Terraform may fail if resources already exist. This is normal when testing multiple times.

The Docker image tag is automatically generated from GitHub commit SHA.

Ensure the ECS task execution role has proper permissions.

Cleanup

To destroy all infrastructure:
cd infra/
terraform destroy -auto-approve
This will remove VPC, subnets, ALB, ECS service, ECR repo, and IAM roles.

