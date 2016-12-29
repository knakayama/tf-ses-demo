resource "random_id" "s3" {
  byte_length = 8

  keepers = {
    name = "tf-configuration-set"
  }
}

resource "aws_s3_bucket" "s3" {
  bucket        = "tf-configuration-set-${random_id.s3.hex}"
  force_destroy = true
}
