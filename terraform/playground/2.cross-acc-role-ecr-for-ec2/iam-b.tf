resource "aws_iam_policy" "b" {
  name   = "b-policy"
  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [
    {
      "Action" : "sts:AssumeRole",
      "Resource" : "arn:aws:iam::${var.a_id}:role/${var.a_role_name}",
      "Effect" : "Allow",
      "Sid" : ""
    }
  ]  
}
EOF
}

resource "aws_iam_role" "b" {
  name = "role-b"

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

resource "aws_iam_role_policy_attachment" "b" {
  role       = aws_iam_role.b.name
  policy_arn = aws_iam_policy.b.arn
}

resource "aws_iam_instance_profile" "b" {
  name = "ec2-ecr-a-profile"
  role = aws_iam_role.b.name
}
