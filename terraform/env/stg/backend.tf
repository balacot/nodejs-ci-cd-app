terraform {
  backend "s3" {
    bucket         = "tfstate-YOURCOMPANY-stg"   # <-- CAMBIA
    key            = "nodejs-app/stg/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-lock-YOURCOMPANY-stg"   # <-- CAMBIA
    encrypt        = true
  }
}
