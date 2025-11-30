terraform {
  backend "s3" {
    bucket = "gh-leinardi-iac"
    key    = "github-repos/leinardi.tfstate"
    region = "dummy" # dummy; required, but ignored with skip_region_validation

    endpoints = {
      s3 = "https://s3.tebi.io"
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
