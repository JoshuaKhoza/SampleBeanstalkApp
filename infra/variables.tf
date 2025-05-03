variable "region" {
  type = string
  default = "us-east-1"
}

variable "eb_app_name" {
  type = string
  default = "sample-eb-dotnet-app"
}

variable "s3_bucket_name" {
  default = "sample-dotnet-app-deploy-bucket"
}

variable "solution_stack" {
  description = "Elastic Beanstalk Solution Stack"
  default = "64bit Amazon Linux 2023 v3.4.1 running .NET 9"
}

