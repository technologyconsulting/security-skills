# Changelog

## 0.2.0 (2026-10-12)

Fixes for the four high findings from the first review of the pack.

- **Untrusted content.** Every skill now treats what it reads as evidence, never an instruction, and reports text addressed to the agent as a finding. New glossary terms: untrusted content, redacted shape.
- **`/pre-release` checks the release config.** Check 10 blocks when `release.md` or the deploy script changed since the deployed SHA, until the human confirms the diff in chat. The printed command is copied verbatim from `release.md`, never assembled.
- **`/pre-release` checks security coverage.** Check 11 requires a threat review covering the deployed SHA to HEAD with no open critical or high findings. Check 12 requires a secrets audit that lists every secret the code reads. `/threat-review` reports now write a machine-readable `Scope:` line with full SHAs.
- **`/secrets-audit` no longer reads values whole.** Candidates are read through a redacting reader (name, length, first four characters). Files removed from the tree are now found by name in history.

## 0.1.0 (2026-10-11)

First public scaffold. Five engineering skills: `setup-security-skills`, `threat-model`, `threat-review`, `secrets-audit`, `pre-release`. The `security-team` bucket is listed and empty.
