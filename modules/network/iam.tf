###### Optional requirement ##### 
# creating iam role so to allow SSM entry into public server without opening port 22 on SG.

####### Instance profile role ########
resource "aws_iam_instance_profile" "iam_profile" {
  name = "iam_profile"
  role = aws_iam_role.role.name
}

##### Assume role trust policy #####
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "role" {
  name               = "cfire_role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# ##### Custom policy statement #####
# data "aws_iam_policy_document" "policy" {
#   statement {
#     effect    = "Allow"
#     actions   = ["s3:GetObject*"]
#     resources = ["*"]
#   }
# }

# resource "aws_iam_policy" "policy" {
#   name        = "cf-policy"
#   description = "Policy for cf server"
#   policy      = data.aws_iam_policy_document.policy.json
# }

# resource "aws_iam_role_policy_attachment" "cf_policy_attach" {
#   role       = aws_iam_role.role.name
#   policy_arn = aws_iam_policy.policy.arn
# }

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}