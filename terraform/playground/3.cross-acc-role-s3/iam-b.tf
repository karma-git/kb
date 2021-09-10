resource "aws_iam_policy" "b" {
  name   = "b-policy"
  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [
    {
      "Action" : "sts:AssumeRole",
      "Resource" : "arn:aws:iam::${var.a_id}:role/${aws_iam_role.a.name}",
      "Effect" : "Allow",
      "Sid" : ""
    }
  ]  
}
EOF
}

resource "aws_iam_policy_attachment" "b" {
  name = "attach"
  users = ["Administrator"]
  policy_arn = aws_iam_policy.b.arn
}
