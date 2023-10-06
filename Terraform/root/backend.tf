terraform {
  backend "s3" {
    bucket = "tfstate-matthew-01"
    key    = "backend/iac-research_project.tfstate"
    region = "us-east-1"
    dynamodb_table = "research_project-remote-backend"
  }
}