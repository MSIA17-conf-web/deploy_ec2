provider "aws" {
  version = "<= 1.60.0"
  access_key = "${var.aws_secret_id}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

variable "aws_secret_id" {
  type = "string"
}

variable "aws_secret_key" {
  type = "string"
}

variable "aws_region" {
  type = "string"
  default = "us-east-2"
}
