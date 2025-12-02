terraform {
  backend "s3" {
    bucket         = "engdata2025"
    key            = "mytfstate.devops/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile   = true
  }
}
