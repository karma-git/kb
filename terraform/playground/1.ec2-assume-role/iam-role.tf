resource "aws_iam_role" "this" {
    name = "ecr-role"

    assume_role_policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [
    {
      "Action" : "sts:AssumeRole",
      "Principal" : {
        "Service" : "ec2.amazonaws.com"
      },
      "Effect" : "Allow",
      "Sid" : ""
    }
  ]  
}
EOF
}

resource "aws_iam_policy" "this" {
    name = "ecr-policy"

    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:Get*",
        "ecr:List*",
        "ecr:Describe*",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "this" {
    role = aws_iam_role.this.name
    policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_instance_profile" "this" {
    name = "ecr-ec2-iam-profile"
    role = aws_iam_role.this.name
}
