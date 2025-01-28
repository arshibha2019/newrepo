provider "aws" {
    region = "eu-central-1"
    shared_credentials_files = ["/home/rahul/.aws/credentials"]
}

resource "aws_iam_role" "lambda_role"{
  name = "terraform_aws_lambda_role"
  assume_role_policy = <<EOF
{
    "Version" : "2012-10-17",
    "Statement" : [
       { 
         "Action" : "sts:AssumeRole",
         "Principal" : {
           "Service" : "lambda.amazonaws.com"
         },
         "Effect" : "Allow",
         "sid" : ""
        }
    ]
}  
EOF
}

resource "aws_iam_policy" "iam_policy_for_lambda"{
    name = "aws_iam_policy_for_terraform_aws_lambda_role"
    path = "/"
    description = "AWS IAM POLICY for managing aws lambda role"
    policy = <<EOF
{
    "Version" : "2013-10-17",
    "Statement" : [
        { 
            "Action" : [
               "logs:CreateLogGroup",
               "logs:CreateLogStream",
               "logs:PutLogEvents"
            ] ,
            "Resource" : "arn:aws:logs:*:*:*",
            "Effect" : "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role"{
    role = aws_iam_role.lambda_role.name
    policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
}


data "archive_file" "zip_the_python_code"{
    type = "zip"
    source_dir =  "${path.module}/python"
    output_path = "${path.module}/python/hello-pyhton.zip"
}

resource "aws_lambda_function" "terraform_lambda_func"{
    filename   = "${path.module}/python/hello-python.zip"
    function_name  = "Jhooq-lambda-function"
    role           = aws_iam_role.lambda_role.arn
    handler       = "hello-python.lambda_handler"
    runtime        = "python3.8"
    depends_on     = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
}

output "terraform_aws_role_output"{
  value = aws_iam_role.lambda_role.name
} 

output "terraform_aws_role_arn_output"{
  value = aws_iam_role.lambda_role.arn
}

output "terraform_logging_arn_output"{
  value = aws_iam_policy.iam_policy_for_lambda.arn
}
