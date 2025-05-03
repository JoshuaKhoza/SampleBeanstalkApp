output "app_name" {
  value = aws_elastic_beanstalk_application.dotnet_app.name
}

output "blue_environment" {
  value = aws_elastic_beanstalk_environment.blue_env.name
}

output "green_environment" {
  value = aws_elastic_beanstalk_environment.green_env.name
}

output "s3_bucket" {
  value = aws_s3_bucket.app_bucket.bucket
}
