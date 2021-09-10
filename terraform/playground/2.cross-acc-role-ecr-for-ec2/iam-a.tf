resource "aws_iam_role" "a" {
  name = "role-a"
  provider = aws.a

  assume_role_policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [
    {
      "Action" : "sts:AssumeRole",
      "Principal" : {
        "AWS" : "arn:aws:iam::${var.b_id}:root"
      },
      "Effect" : "Allow",
      "Sid" : ""
    }
  ]  
}
EOF
}

resource "aws_iam_policy" "a" {
  name = "policy-a"
  provider = aws.a

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ecr:GetAuthorizationToken",
      "Resource": "*"
    },
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

resource "aws_iam_role_policy_attachment" "a" {
  role       = aws_iam_role.a.name
  policy_arn = aws_iam_policy.a.arn
  provider = aws.a
}
