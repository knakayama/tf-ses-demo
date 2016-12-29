data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "ses_assume_role" {
  statement {
    sid    = "SESAssumeRole"
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals = {
      type = "Service"

      identifiers = [
        "ses.amazonaws.com",
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"

      values = [
        "${data.aws_caller_identity.current.account_id}",
      ]
    }
  }
}

resource "aws_iam_role" "ses" {
  name               = "tf-ses-role"
  assume_role_policy = "${data.aws_iam_policy_document.ses_assume_role.json}"
}

data "aws_iam_policy_document" "ses_policy" {
  statement {
    sid = "GiveSESPermissionToPutFirehose"

    actions = [
      "firehose:PutRecord",
      "firehose:PutRecordBatch",
    ]

    resources = [
      "${aws_kinesis_firehose_delivery_stream.firehose.arn}",
    ]
  }
}

resource "aws_iam_policy" "ses" {
  name   = "tf-ses-policy"
  path   = "/"
  policy = "${data.aws_iam_policy_document.ses_policy.json}"
}

resource "aws_iam_policy_attachment" "ses" {
  name       = "GiveSESPermissionToPutFirehose"
  roles      = ["${aws_iam_role.ses.name}"]
  policy_arn = "${aws_iam_policy.ses.arn}"
}

data "aws_iam_policy_document" "firehose_assume_role" {
  statement {
    sid    = "KinesisAssumeRole"
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals = {
      type = "Service"

      identifiers = [
        "firehose.amazonaws.com",
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"

      values = [
        "${data.aws_caller_identity.current.account_id}",
      ]
    }
  }
}

resource "aws_iam_role" "firehose" {
  name               = "tf-firehose-role"
  assume_role_policy = "${data.aws_iam_policy_document.firehose_assume_role.json}"
}

data "aws_iam_policy_document" "firehose_policy" {
  statement {
    sid    = "GiveFirehosePermissionToPutS3Bucket"
    effect = "Allow"

    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.s3.arn}",
      "${aws_s3_bucket.s3.arn}/*",
    ]
  }

  statement = {
    sid    = "GiveFirehosePermissionToPutLogEvents"
    effect = "Allow"

    actions = [
      "logs:PutLogEvents",
    ]

    resources = [
      "${aws_cloudwatch_log_stream.cloudwatch.arn}",
    ]
  }
}

resource "aws_iam_policy" "firehose" {
  name   = "tf-firehose-policy"
  path   = "/"
  policy = "${data.aws_iam_policy_document.firehose_policy.json}"
}

resource "aws_iam_policy_attachment" "firehose" {
  name       = "GiveFirehosePermissionToS3AndCWLogs"
  roles      = ["${aws_iam_role.firehose.name}"]
  policy_arn = "${aws_iam_policy.firehose.arn}"
}
