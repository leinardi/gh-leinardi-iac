terraform {
  backend "s3" {
    bucket = "gh-leinardi-iac"
    key    = "github-repos/leinardi.tfstate"
    region = "auto" # required by backend, not AWS here

    endpoints = {
      s3 = "https://96bdc3234fb5c8494694cf9dfccd5eb6.eu.r2.cloudflarestorage.com"
    }

    # === Non-AWS S3 compatibility flags ===
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true

    # === S3-based locking in the same bucket ===
    use_lockfile = true
  }
}
