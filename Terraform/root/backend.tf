terraform {
  backend "s3" {
    bucket = "iac-webappBucket"
    key    = "backend/iac-researchproject.tfstate"
    region = "eu-central-1"
    dynamodb_table = "iac-researchproject-remote-backend"
  }
}