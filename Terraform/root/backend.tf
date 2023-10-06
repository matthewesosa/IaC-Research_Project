terraform {
  backend "s3" {
    bucket = "tfstate-matthew-101"
    key    = "backend/research_project-iac.tfstate"
    region = "us-east-1"
    dynamodb_table = "research_project-remote-backend"
  }
}