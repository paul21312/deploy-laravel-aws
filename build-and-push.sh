#!/bin/bash
set -e

# --- Config ---
ECR_URI="372836560826.dkr.ecr.ap-southeast-2.amazonaws.com/laravel-fargate-app"
REGION="ap-southeast-2"
IMAGE_NAME="laravel-fargate-app"
DOCKERFILE_PATH="docker/Dockerfile"

# --- Ensure required directories exist ---
echo "Checking required directories..."
mkdir -p app/storage app/bootstrap/cache

# --- Set permissions locally (optional, for dev) ---
chmod -R 775 app/storage app/bootstrap/cache

# --- Log in to AWS ECR ---
echo "Logging in to AWS ECR..."
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_URI

# --- Build Docker image ---
echo "Building Docker image..."
docker build -f $DOCKERFILE_PATH -t $IMAGE_NAME .

# --- Tag the image for ECR ---
echo "Tagging image for ECR..."
docker tag $IMAGE_NAME:latest $ECR_URI:latest

# --- Push to ECR ---
echo "Pushing image to ECR..."
docker push $ECR_URI:latest

echo "Done! Docker image successfully built and pushed."
