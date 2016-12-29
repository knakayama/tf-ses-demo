variable "region" {
  default = "us-east-1"
}

variable "ses_ip_range" {
  default = [
    "199.255.192.0/22",
    "199.127.232.0/22",
    "54.240.0.0/18",
  ]
}
