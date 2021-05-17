locals {
  role_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
  ]
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${local.name}-EC2-Profile"
  role = aws_iam_role.ec2_role.name

  depends_on = [
    aws_iam_role.ec2_role
  ]
}

resource "aws_iam_role_policy_attachment" "iam_policies" {
  count = length(local.role_policy_arns)

  role       = aws_iam_role.ec2_role.name
  policy_arn = element(local.role_policy_arns, count.index)
  depends_on = [
    aws_iam_role.ec2_role
  ]
}

resource "aws_iam_role_policy" "ec2_iam_polcy" {
  name = "${local.name}-EC2-Inline-Policy"
  role = aws_iam_role.ec2_role.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "ssm:GetParameter"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
  depends_on = [
    aws_iam_role.ec2_role
  ]
}

resource "aws_iam_role" "ec2_role" {
  name = "${local.name}-EC2-Role"
  path = "/"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : [
              "ec2.amazonaws.com",
              "ssm.amazonaws.com"
            ]
          },
          "Effect" : "Allow"
        }
      ]
    }
  )
}