resource "aws_iam_role" "s3_bucket_role3" {
  name = "${var.project_name}-Role3"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_instance_profile" "s3_bucket_instance_profile3" {
  name = "${var.project_name}-InstanceProfile3"
  role = aws_iam_role.s3_bucket_role3.name
}

resource "aws_iam_policy" "s3_bucket_policy3" {
  name        = "S3BucketPolicy3"
  description = "IAM policy to permit webserver(s) to access S3."
  #name_prefix = "${var.project_name}-"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "s3:Get*",
        "s3:List*",
      ],
      Resource = [
        "arn:aws:s3:::iac-webappbucket",
        "arn:aws:s3:::iac-webappbucket/*",
      ],
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_s3_bucket_policy" {
  policy_arn = aws_iam_policy.s3_bucket_policy3.arn
  role       = aws_iam_role.s3_bucket_role3.name
}


resource "aws_launch_configuration" "webserver_launch_config" {
  name_prefix   = "${var.project_name}-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  security_groups = [var.webserver_sg_id]

  iam_instance_profile = aws_iam_instance_profile.s3_bucket_instance_profile3.name

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