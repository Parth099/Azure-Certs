data "aws_iam_policy" "cloudwatch_logs_full_access" {
  name = "CloudWatchLogsFullAccess"
}

resource "aws_iam_role" "flow_logs_role" {
  name = "flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = ["vpc-flow-logs.amazonaws.com"]
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "flow_logs_full_access" {
  policy_arn = data.aws_iam_policy.cloudwatch_logs_full_access.arn
  role       = aws_iam_role.flow_logs_role.name
}

resource "aws_cloudwatch_log_group" "flow_logs" {
  name = "ec2-example-fl"
}

resource "aws_flow_log" "flow_log" {
  iam_role_arn    = aws_iam_role.flow_logs_role.arn
  log_destination = aws_cloudwatch_log_group.flow_logs.arn

  traffic_type             = "ALL"
  vpc_id                   = aws_vpc.vpc.id
  max_aggregation_interval = 60 # sec
}

