resource "aws_cloudwatch_log_group" "cloudwatch" {
  name = "/aws/kinesisfirehose/tf-firehose-log-group"
}

resource "aws_cloudwatch_log_stream" "cloudwatch" {
  name           = "tf-firehose-log-stream"
  log_group_name = "${aws_cloudwatch_log_group.cloudwatch.name}"
}

resource "aws_kinesis_firehose_delivery_stream" "firehose" {
  name        = "tf-delivery-stream"
  destination = "s3"

  s3_configuration {
    role_arn        = "${aws_iam_role.firehose.arn}"
    bucket_arn      = "${aws_s3_bucket.s3.arn}"
    prefix          = "ses"
    buffer_interval = 60

    cloudwatch_logging_options = {
      enabled         = true
      log_group_name  = "${aws_cloudwatch_log_group.cloudwatch.name}"
      log_stream_name = "${aws_cloudwatch_log_stream.cloudwatch.name}"
    }
  }
}
