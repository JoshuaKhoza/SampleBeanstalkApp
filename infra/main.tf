provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "app_bucket" {
  bucket = var.s3_bucket_name
  force_destroy = true
}

resource "aws_elastic_beanstalk_application" "dotnet_app" {
  name        = var.eb_app_name
  description = "Sample .NET App for blue-green Deployment"
}

# IAM roles required by Elastic Beanstalk
resource "aws_iam_role" "beanstalk_ec2_role" {
  name = "beanstalk-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.eb_ec2_assume.json
}

resource "aws_iam_role_policy_attachment" "ec2_attach" {
  role       = aws_iam_role.beanstalk_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

data "aws_iam_policy_document" "eb_ec2_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_instance_profile" "beanstalk_profile" {
  name = "beanstalk-instance-profile"
  role = aws_iam_role.beanstalk_ec2_role.name
}

resource "aws_elastic_beanstalk_environment" "blue_env" {
  name                = "${var.eb_app_name}-blue"
  application         = aws_elastic_beanstalk_application.dotnet_app.name
  solution_stack_name = var.solution_stack

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.beanstalk_profile.name

  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t3.small"
  }
}

resource "aws_elastic_beanstalk_environment" "green_env" {
  name                = "${var.eb_app_name}-green"
  application         = aws_elastic_beanstalk_application.dotnet_app.name
  solution_stack_name = var.solution_stack

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.beanstalk_profile.name
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t3.small"
  }
}
