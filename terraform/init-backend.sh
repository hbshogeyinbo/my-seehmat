#!/bin/bash
# Configuration
AWS_REGION="eu-west-1"
STATE_BUCKET="seehmat-terraform-state-bucket"
LOCK_TABLE="seehmat-terraform-lock-table"
# Create S3 Bucket for Terraform State
echo "Creating S3 bucket: $STATE_BUCKET..."
aws s3api create-bucket --bucket $STATE_BUCKET --region $AWS_REGION --create-bucket-configuration LocationConstraint=$AWS_REGION
# Enable versioning on the bucket
echo "Enabling versioning on the bucket..."
aws s3api put-bucket-versioning --bucket $STATE_BUCKET --versioning-configuration Status=Enabled
# Create DynamoDB Table for Locking
echo "Creating DynamoDB table: $LOCK_TABLE..."
aws dynamodb create-table \
    --table-name $LOCK_TABLE \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region $AWS_REGION
echo "Backend resources created successfully!"