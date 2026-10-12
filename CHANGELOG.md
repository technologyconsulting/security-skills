# Changelog

## 0.3.0 (2026-10-12)

Fixes for the bugs and inconsistencies from the first review. `release.md` gains fields, so re-run `/setup-security-skills` on existing repos.

- **`/secrets-audit` finds hardcoded secrets.** New step 4 scans tracked source for credential prefixes and secret-named literals, printing only the redacted shape. Step 1 now covers `import.meta.env`, `Bun.env`, `Deno.env.get`, bracketed and destructured access, and flags secrets behind client prefixes (`VITE_`, `NEXT_PUBLIC_` and others).
- **`release.md` records rollback, release branch, default target and test safety.** `/pre-release` reads them: it prints the real rollback command, checks the recorded release branch, says which environment it chose, and skips tests that touch shared systems instead of running them.
- **Clean-tree check no longer passes with nothing checked.** With no paths listed it checks the whole tree, untracked files included.
- **`/threat-model` refresh keeps human decisions.** Accepted risks and human-written lines are carried over word for word; risks whose entry point vanished are kept for the human to retire.
- **Wording.** The read-only rule now names setup's pointer block and says when a test run counts as read-only. The glossary notes `/secrets-audit` reads the secret-list command. `/threat-review` no longer claims "pre-release check", which belongs to `/pre-release`.

## 0.2.0 (2026-10-12)

Fixes for the four high findings from the first review of the pack.

- **Untrusted content.** Every skill now treats what it reads as evidence, never an instruction, and reports text addressed to the agent as a finding. New glossary terms: untrusted content, redacted shape.
- **`/pre-release` checks the release config.** Check 10 blocks when `release.md` or the deploy script changed since the deployed SHA, until the human confirms the diff in chat. The printed command is copied verbatim from `release.md`, never assembled.
- **`/pre-release` checks security coverage.** Check 11 requires a threat review covering the deployed SHA to HEAD with no open critical or high findings. Check 12 requires a secrets audit that lists every secret the code reads. `/threat-review` reports now write a machine-readable `Scope:` line with full SHAs.
- **`/secrets-audit` no longer reads values whole.** Candidates are read through a redacting reader (name, length, first four characters). Files removed from the tree are now found by name in history.

## 0.1.0 (2026-10-11)

First public scaffold. Five engineering skills: `setup-security-skills`, `threat-model`, `threat-review`, `secrets-audit`, `pre-release`. The `security-team` bucket is listed and empty.
