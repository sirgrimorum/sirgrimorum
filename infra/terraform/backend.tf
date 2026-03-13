terraform {
  backend "s3" {
    bucket         = "sirgrimorum-terraform-state"
    key            = "sirgrimorum/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "sirgrimorum-terraform-locks"
    encrypt        = true
    profile        = "sirg-main"
  }
}
