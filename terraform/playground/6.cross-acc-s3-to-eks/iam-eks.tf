resource "aws_iam_policy" "eks" {
  provider = aws.eks

  name        = "eks-ploicy"
  description = "Allow to assume role ${aws_iam_role.s3.name} from ${data.aws_caller_identity.s3.account_id}"

  policy = <<EOF
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Action":"sts:AssumeRole",
         "Resource":"arn:aws:iam::${data.aws_caller_identity.s3.account_id}:role/${aws_iam_role.s3.name}",
         "Effect":"Allow",
         "Sid":""
      }
   ]
}
EOF
}

resource "aws_iam_role" "eks" {
  provider = aws.eks

  name     = "eks-role"
  description = "Grant permissions to Pods in ${var.eks_name} to communicate with S3 ${aws_s3_bucket.s3.bucket}"

  assume_role_policy = <<EOF
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Effect":"Allow",
         "Principal":{
            "Federated":"arn:aws:iam::${data.aws_caller_identity.eks.account_id}:oidc-provider/${local.oidc}"
         },
         "Action":"sts:AssumeRoleWithWebIdentity",
         "Condition":{
            "StringEquals":{
               "${local.oidc}:sub":"system:serviceaccount:${var.sa_namespace}:${var.sa}"
            }
         }
      }
   ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "eks" {
  provider = aws.eks

  role       = aws_iam_role.eks.name
  policy_arn = aws_iam_policy.eks.arn
}
