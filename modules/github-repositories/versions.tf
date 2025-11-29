terraform {
  required_version = ">= 1.11.1"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.6" # latest version 6.9.0
    }
  }
}
