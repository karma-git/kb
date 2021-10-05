resource "aws_iam_user" "this" {
  name = "s3-manager"

  tags = var.tags
}

/*
resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}
*/

resource "aws_iam_policy" "this" {
  name   = "s3-manager"
  policy = <<EOF
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Sid":"",
         "Effect":"Allow",
         "Action": "s3:*",
         "Resource":[
            "arn:aws:s3:::${aws_s3_bucket.this.bucket}",
            "arn:aws:s3:::${aws_s3_bucket.this.bucket}/*"
         ]
      }
   ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "this" {
  user       = aws_iam_user.this.name
  policy_arn = aws_iam_policy.this.arn
}
