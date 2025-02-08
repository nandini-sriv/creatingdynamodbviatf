
resource "aws_dynamodb_table" "nandini-bookinventory-using-tf" {
  name           = "Nandini-DynamoDB-Terraform"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "ISBN"
  range_key      = "Genre"

  attribute {
    name = "ISBN"
    type = "S"
  }

  attribute {
    name = "Genre"
    type = "S"
  }



  tags = {
    Name        = "nandini-dynamodb-table-using-tf"
    Environment = "Training"
  }
}

locals {
 name_prefix = "nandini"
}

resource "aws_iam_role" "role_example" {
 name = "${local.name_prefix}-role-example"


 assume_role_policy = jsonencode({
   Version = "2012-10-17"
   Statement = [
     {
       Action = "sts:AssumeRole"
       Effect = "Allow"
       Sid    = ""
       Principal = {
         Service = "ec2.amazonaws.com"
       }
     },
   ]
 })
}
data "aws_iam_policy_document" "policy_example" {
 statement {
   effect    = "Allow"
   actions   = ["ec2:Describe*"]
   resources = ["*"]
 }
 statement {
   effect    = "Allow"
   actions   = ["s3:ListBucket"]
   resources = ["*"]
 }
}


resource "aws_iam_policy" "policy_example" {
 name = "${local.name_prefix}-policy-example"


 ## Option 1: Attach data block policy document
 policy = data.aws_iam_policy_document.policy_example.json


}


resource "aws_iam_role_policy_attachment" "attach_example" {
 role       = aws_iam_role.role_example.name
 policy_arn = aws_iam_policy.policy_example.arn
}


resource "aws_iam_instance_profile" "profile_example" {
 name = "${local.name_prefix}-profile-example"
 role = aws_iam_role.role_example.name
}

resource "aws_instance" "web_app" {
  ami           = "ami-0ac4dfaf1c5c0cce9"
  instance_type = "t2.micro"
associate_public_ip_address = true
  tags = {
    Name = "Nandini_pub_subnet_EC2"
  }
}
