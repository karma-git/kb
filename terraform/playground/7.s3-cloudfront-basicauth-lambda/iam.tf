// s3 & cdn

resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "Acces to ${aws_s3_bucket.this.bucket} via CDN"
}

resource "aws_s3_bucket_policy" "cdn" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.cdn.json
}

// lambda

resource "aws_iam_role" "lambda" {
  name        = "${local.resource_name}-lambda-role"
  description = "For proper work with lambda edge"

  assume_role_policy = <<EOF
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Effect":"Allow",
         "Principal":{
            "Service":[
               "lambda.amazonaws.com",
               "edgelambda.amazonaws.com",
               "ssm.amazonaws.com"
            ]
         },
         "Action":"sts:AssumeRole"
      }
   ]
}
EOF
  tags               = local.tags
}

resource "aws_iam_policy" "lambda" {
  name        = "${local.resource_name}-lambda-policy"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Action":[
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
         ],
         "Resource":"*",
         "Effect":"Allow"
      },
      {
        "Action":[
          "ssm:GetParameter",
          "ssm:GetParameters"
        ],
        "Resource":"arn:aws:ssm:${local.region}:${data.aws_caller_identity.current.account_id}:parameter/${aws_ssm_parameter.password.name}",
        "Effect":"Allow"
      }
   ]
}
EOF
  // FIXME: "Resource":"*" just lambda arn here?
  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.lambda.arn
}
