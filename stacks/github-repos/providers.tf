provider "github" {
  owner = var.github_owner
  # token comes from either:
  # - gh CLI (locally)
  # - GitHub App token (CI)
}
