terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}

variable "domain" {}
variable "stage" {}

variable "tags" {
  default = {}
}

locals {
  state_name = "terraform-state-${data.aws_caller_identity.current.account_id}-${var.domain}-${var.stage}"
  aws_partition = data.aws_partition.current.partition
  bucket_policy_deny_http = [
    {
      Sid : "AllowSSLRequestsOnly",
      Action : "s3:*",
      Effect : "Deny",
      Resource : [
        "arn:${local.aws_partition}:s3:::${local.state_name}/*",
        "arn:${local.aws_partition}:s3:::${local.state_name}"
      ],
      Principal : "*",
      Condition : {
        "Bool" : {
          "aws:SecureTransport" : "false"
        }
      }
    }
  ]
}

#################################################
# S3 Bucket
#################################################
resource "aws_s3_bucket" "state_bucket" {
  bucket = local.state_name

  versioning {
    enabled = true
  }

  tags = var.tags

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

#################################################
# S3 Bucket Policy
#################################################

resource "aws_s3_bucket_policy" "data_bucket_policy" {
  bucket = aws_s3_bucket.state_bucket.id
  policy = jsonencode({
    "Id" : "bucket_policy_${local.state_name}",
    "Version" : "2012-10-17",
    "Statement" : local.bucket_policy_deny_http
  })
}

#################################################
# DynamoDB
#################################################
resource "aws_dynamodb_table" "stateLockTable" {
  name         = local.state_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = var.tags
}
