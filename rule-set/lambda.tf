data "aws_iam_policy_document" "lambda" {
  statement {
    sid    = "LambdaAssumeRole"
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals = {
      type = "Service"

      identifiers = [
        "lambda.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "lambda" {
  name               = "${var.lambda_config["role_name"]}"
  assume_role_policy = "${data.aws_iam_policy_document.lambda.json}"
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role       = "${aws_iam_role.lambda.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "lambda" {
  filename         = "${path.module}/source/${var.lambda_config["filename"]}"
  function_name    = "${var.lambda_config["function_name"]}"
  role             = "${aws_iam_role.lambda.arn}"
  handler          = "${var.lambda_config["handler"]}"
  runtime          = "${var.lambda_config["runtime"]}"
  source_code_hash = "${base64sha256(file("${path.module}/source/${var.lambda_config["filename"]}"))}"
}

resource "aws_lambda_permission" "lambda" {
  statement_id   = "AllowSesInvoke"
  action         = "lambda:InvokeFunction"
  function_name  = "${aws_lambda_function.lambda.arn}"
  principal      = "ses.amazonaws.com"
  source_account = "${data.aws_caller_identity.current.account_id}"
}
