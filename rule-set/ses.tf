resource "aws_ses_receipt_rule_set" "ses" {
  rule_set_name = "tf-rule-set"
}

resource "aws_ses_receipt_rule" "ses" {
  name          = "tf-rule"
  rule_set_name = "${aws_ses_receipt_rule_set.ses.rule_set_name}"
  recipients    = ["${var.ses_config["verification_domain"]}"]
  enabled       = true
  scan_enabled  = true

  add_header_action {
    header_name  = "TestHeader"
    header_value = "Test"
    position     = 1
  }

  bounce_action {
    message         = "Mailbox does not exist"
    sender          = "bounce@${var.ses_config["verification_domain"]}"
    smtp_reply_code = 550
    topic_arn       = "${module.tf_sns_email.arn}"
    status_code     = "5.1.1"
    position        = 2
  }

  lambda_action {
    function_arn    = "${aws_lambda_function.lambda.arn}"
    invocation_type = "${var.ses_config["invocation_type"]}"
    position        = 3
  }

  s3_action {
    bucket_name       = "${aws_s3_bucket.s3.id}"
    object_key_prefix = "${var.ses_config["object_key_prefix"]}"
    position          = 4
  }

  sns_action {
    topic_arn = "${module.tf_sns_email.arn}"
    position  = 5
  }
}

resource "aws_ses_active_receipt_rule_set" "ses" {
  rule_set_name = "${aws_ses_receipt_rule_set.ses.rule_set_name}"
}
