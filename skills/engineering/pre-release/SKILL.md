---
name: pre-release
description: "Read-only GO or NO-GO before a deploy: clean tree, branch sync, typecheck, tests, pending migrations, secrets present, observability on. Prints the single deploy command from docs/security/release.md when GO. Never deploys."
disable-model-invocation: true
---

# Pre-release

Reads `docs/security/release.md` and the repo, and runs the read-only checks it names. Writes nothing but the chat verdict. Never runs a deploy, a migration, a secret write, or anything that changes an environment: when the verdict is GO, it prints the one command for the human to run.

If `docs/security/release.md` is missing, stop and tell the user to run `/setup-security-skills`.

## Checks

Run every one and report each as PASS, FAIL or SKIPPED with the evidence line.

1. **Guards exist**: the deploy command in `release.md` is a script that runs guards (clean tree, typecheck, tests, migrations) before the platform CLI, and a post-deploy health check after. A bare platform CLI as the only deploy path is a finding, not a blocker, and the reply names what class of incident it leaves open: a deploy that ships uncommitted work, or a schema the code does not match.
2. **Clean tree**: `git status --porcelain` on the paths `release.md` lists as bundled from the working tree. Anything listed is NO-GO, because the bundler ships what is on disk, not what is committed.
3. **Branch and sync**: on the release branch, fetched, no unexpected ahead or behind.
4. **Typecheck**: the command in `release.md`.
5. **Tests**: the command in `release.md`, with counts.
6. **Migrations**: the pending-migrations command. Unapplied migrations are NO-GO, and the fix is the apply command in `release.md`, never the bypass it warns about.
7. **Secrets present**: the secret-list command for the target environment, compared with every secret name the code reads (reuse the grep from `/secrets-audit` step 1). A missing secret that makes a gate fail open is NO-GO; any other missing secret is a finding.
8. **Observability**: logs or tracing enabled for the target environment in the platform config. Missing is a finding with the exact lines to add.
9. **Post-deploy path**: the health URL in `release.md` answers now, so a failure after deploy will be visible. Record the current version or SHA it reports.

## Output

```
VERDICT: GO | NO-GO
Repo: <name>  Env: <env>  HEAD: <sha>
| Check | Result | Evidence |
Blocking: <list or none>
Findings: <non-blocking, each with a one-line fix>
Command to run: <the deploy command from release.md>   (printed only on GO)
After it runs: curl <health URL> and confirm the SHA changed; if it did not, or health fails, <the rollback command from release.md>.
```
