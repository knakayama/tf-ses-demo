resource "aws_ses_configuration_set" "ses" {
  name = "tf-configuration-set"
}

resource "aws_ses_event_destination" "firehose" {
  name                   = "tf-firehose-destination"
  configuration_set_name = "${aws_ses_configuration_set.ses.name}"
  enabled                = true

  matching_types = [
    "send",
  ]

  kinesis_destination = {
    stream_arn = "${aws_kinesis_firehose_delivery_stream.firehose.arn}"
    role_arn   = "${aws_iam_role.ses.arn}"
  }
}

resource "aws_ses_event_destination" "cloudwatch" {
  name                   = "tf-cloudwatch-destination"
  configuration_set_name = "${aws_ses_configuration_set.ses.name}"
  enabled                = true

  matching_types = [
    "send",
  ]

  cloudwatch_destination = {
    default_value  = "unknown"
    dimension_name = "campaign"
    value_source   = "messageTag"
  }
}
