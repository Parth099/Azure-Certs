data "aws_iam_policy" "ssm_core" {
  name = "AmazonSSMManagedInstanceCore"
}


resource "aws_iam_role" "cloud_ec2_role" {
  name = "dns-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = ["ec2.amazonaws.com"]
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  policy_arn = data.aws_iam_policy.ssm_core.arn
  role       = aws_iam_role.cloud_ec2_role.name
}

resource "aws_iam_instance_profile" "cloud_ec2_profile" {
  name = "dns-ec2-instance-profile"
  role = aws_iam_role.cloud_ec2_role.name
}
