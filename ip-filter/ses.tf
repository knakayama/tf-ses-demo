resource "aws_ses_receipt_filter" "block" {
  name   = "block-all"
  cidr   = "0.0.0.0/0"
  policy = "Block"
}

resource "aws_ses_receipt_filter" "allow" {
  count  = "${length(var.ses_ip_range)}"
  name   = "allow-ses-ip-range-${count.index + 1}"
  cidr   = "${var.ses_ip_range[count.index]}"
  policy = "Allow"
}
