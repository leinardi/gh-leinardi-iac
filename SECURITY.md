# Security policy

## Supported versions

There are no releases: only the current `main` is maintained, and it is what gets applied to the account.

## Reporting a vulnerability

Report it privately through GitHub's
[private vulnerability reporting](https://github.com/leinardi/gh-leinardi-iac/security/advisories/new), not in a public issue or
pull request. Include the file, what it exposes or weakens, and how to reproduce it.

This is a personal configuration maintained in spare time, so reports are handled on a best-effort basis. You will get an answer
in the advisory, and the fix is credited there unless you prefer otherwise.

## Scope

In scope: anything this configuration applies or leaks, such as a secret or token committed to the repository, a ruleset that
does not protect what it claims to (a default branch that can be force-pushed, a tag that can be moved), a repository setting
weaker than documented, or a workflow that hands a pull request more permissions than it needs.

## Security model

- Nothing in CI can change the account: no workflow runs `tofu plan` or `tofu apply`, and the CI token is read-only except for
  posting review comments. Changes are applied locally by the owner, after reading the plan.
- No credentials are committed. GitHub access comes from the GitHub CLI login; the state backend uses short-lived Cloudflare R2
  credentials minted by `make login` from a Bitwarden item, and the state itself lives in the R2 bucket, not in Git.
- Repository-level Actions variables managed here are public by design; secrets are set outside this repository.
