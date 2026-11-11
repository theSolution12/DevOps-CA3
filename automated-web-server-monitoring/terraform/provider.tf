provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = "Automated-Web-Server-Monitoring"
      ManagedBy = "Terraform"
      Owner     = "Parth Patidar"
      Course    = "INT333"
    }
  }
}

