# IAM Roles/Policies
resource "aws_iam_role" "s3_bucket_role7" {
  name = "${var.project_name}-Role7"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# An IAM instance profile
resource "aws_iam_instance_profile" "s3_bucket_instance_profile7" {
  name = "S3BucketInstanceProfile7"
  role = aws_iam_role.s3_bucket_role7.name
}

# This IAM policy permits the webServer(s)(EC2 instance(s)) to list items in S3
resource "aws_iam_policy" "s3_bucket_policy7" {
  name        = "S3BucketPolicy7"
  description = "Allows EC2 instances to access S3"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:Get*",
        "s3:List*"
      ],
      "Resource": [
        "arn:aws:s3:::iac-webappbucket",
        "arn:aws:s3:::iac-webappbucket/*"
      ]
    }
  ]
}
EOF
}

# Attach the IAM role to the instance profile
resource "aws_iam_role_policy_attachment" "s3_bucket_role_policy_attachment7" {
  role       = aws_iam_role.s3_bucket_role7.name
  policy_arn = aws_iam_policy.s3_bucket_policy7.arn
}



resource "aws_launch_configuration" "webserver_launch_config" {
  name_prefix   = "${var.project_name}-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  security_groups = [var.webserver_sg_id]

  iam_instance_profile = aws_iam_instance_profile.s3_bucket_instance_profile7.name

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras enable php7.2
    yum clean metadata
    yum install -y httpd php php-mysqlnd
    service httpd start
    chkconfig httpd on
    sudo aws s3 cp s3://iac-webappbucket --region eu-central-1 /var/www/html/ --recursive
    EOF
}

resource "aws_autoscaling_group" "webserver_group" {
  name_prefix                   = "${var.project_name}-"
  vpc_zone_identifier           = [var.priv_sub_3a_id, var.priv_sub_4b_id]
  launch_configuration          = aws_launch_configuration.webserver_launch_config.name
  min_size                      = var.min_size
  max_size                      = var.max_size
  target_group_arns             = [var.targetgroup_arn]
  health_check_type             = "ELB"
  health_check_grace_period     = 300
  force_delete                  = true

  tag {
    key                 = "Name"
    value               = "${var.project_name}-webserver-group"
    propagate_at_launch = true
  }
}