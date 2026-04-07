terraform {
  backend "s3" {
    bucket = "notepad-tfstate2"
    key    = "dev/terraform.tfstate"
    region = "eu-west-2"
  }
}