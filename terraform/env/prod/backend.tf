terraform {
  backend "s3" {
    bucket         = "tfstate-YOURCOMPANY-prod"   # <-- CAMBIA
    key            = "nodejs-app/prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-lock-YOURCOMPANY-prod"   # <-- CAMBIA
    encrypt        = true
  }
}
