resource "aws_iam_policy" "s3" {
  provider = aws.s3

  name        = "s3-policy"
  description = "Allow RO acces to S3 bukcet ${aws_s3_bucket.s3.bucket}"

  policy = <<EOF
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Sid":"",
         "Effect":"Allow",
         "Action":[
            "s3:ListBucket"
         ],
         "Resource":[
            "arn:aws:s3:::${aws_s3_bucket.s3.bucket}"
         ]
      },
      {
         "Sid":"",
         "Effect":"Allow",
         "Action":[
            "s3:GetObject",
            "s3:ListBucket"
         ],
         "Resource":[
            "arn:aws:s3:::${aws_s3_bucket.s3.bucket}/*"
         ]
      }
   ]
}
EOF
}

resource "aws_iam_role" "s3" {
  provider = aws.s3
  
  name        = "s3-role"
  description = "Allow assume this role with RO access to S3 bucket ${aws_s3_bucket.s3.bucket} for ${data.aws_caller_identity.eks.account_id} - ${var.eks_name}"

  assume_role_policy = <<EOF
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Effect":"Allow",
         "Principal":{
            "AWS":"arn:aws:iam::${data.aws_caller_identity.eks.account_id}:role/${aws_iam_role.eks.name}"
         },
         "Action":"sts:AssumeRole"
      }
   ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "s3" {
  provider = aws.s3

  role       = aws_iam_role.s3.name
  policy_arn = aws_iam_policy.s3.arn
}

