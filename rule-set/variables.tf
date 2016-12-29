variable "region" {
  default = "us-east-1"
}

variable "ses_config" {
  default = {
    verification_domain        = "example.com"
    verification_email_address = "hoge@example.com"
    object_key_prefix          = "ses"
    invocation_type            = "Event"
  }
}

variable "lambda_config" {
  default = {
    role_name     = "lambda-role"
    filename      = "lambda.zip"
    function_name = "tf-ses-lambda"
    handler       = "handler.hello"
    runtime       = "python2.7"
  }
}

data "aws_caller_identity" "current" {}
