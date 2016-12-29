module "tf_sns_email" {
  source = "github.com/deanwilson/tf_sns_email"

  display_name  = "tf-test"
  email_address = "${var.ses_config["verification_email_address"]}"
  owner         = "Owner"
  stack_name    = "tf-sns-email"
}
