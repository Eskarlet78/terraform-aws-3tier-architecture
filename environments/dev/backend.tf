terraform {
  backend "s3" {
    bucket         = "terraform-landing-zone-state-ard"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
