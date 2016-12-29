resource "random_id" "s3" {
  byte_length = 8

  keepers = {
    name = "tf-rule-set"
  }
}

data "aws_iam_policy_document" "s3" {
  statement {
    sid    = "AllowSESPuts"
    effect = "Allow"

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${random_id.s3.hex}/*",
    ]

    principals = {
      type = "Service"

      identifiers = [
        "ses.amazonaws.com",
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:Referer"

      values = [
        "${data.aws_caller_identity.current.account_id}",
      ]
    }
  }
}

resource "aws_s3_bucket" "s3" {
  bucket        = "tf-rule-set-${random_id.s3.hex}"
  policy        = "${data.aws_iam_policy_document.s3.json}"
  force_destroy = true
}
