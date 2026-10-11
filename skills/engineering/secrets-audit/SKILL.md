---
name: secrets-audit
description: "Audit how a repo handles secrets: tracked files that hold them, config that exposes them, code that logs them, checks that fail open when one is missing, and rotation paths that would break. Use before a release, after adding a secret, when a rotation is due, or when the user asks \"are our secrets safe\"."
---

# Secrets audit

Reads the repo and runs read-only list commands from `docs/security/release.md`. Writes `docs/security/reviews/<date>-secrets.md`. Changes nothing else; rotations are the human's.

## Process

### 1. What the code reads

Grep for environment and binding access (`process.env.X`, `env.X`, `os.environ`, `getenv`, `secrets.`) and list every name. Done when the list is complete and each name is marked as secret or plain config, by what it unlocks rather than by its name.

### 2. Where each is set

For each secret name, find where production gets it: the platform's secret store (list it with the command in `release.md`), a tracked config file, a CI variable, a `.env` file. Done when every secret name has a source, or the explicit word "unset", which is a finding on its own.

### 3. Tracked files

`git ls-files` filtered for `.env*`, `*.pem`, `*.p12`, `*.key`, `*.jks`, `credentials*`, `*secret*`, seed and fixture scripts. Open each. A value that unlocks something is a finding, including in test fixtures, unless the file marks it as a deliberate fake. Check `git log --all --diff-filter=A -- <file>` for anything that was once tracked and later removed; removal from the tree does not remove it from history.

### 4. Config that exposes

Platform config `[vars]` or `env:` blocks, committed JSON, Dockerfiles with `ENV`, client bundles that bake a server secret. Public keys and site keys are fine; anything that lets the holder act is not.

### 5. Code that leaks

Log statements and error responses that include a token, header, request body or secret. Health endpoints that return config. Error messages that echo the comparison value.

### 6. Fail open

For every check that depends on a secret (an admin gate, an internal-service gate, a signing or encryption key, an upstream API key), read what the code does when the secret is unset or empty: refuse, skip the check, or derive a key from an empty string. Each fail-open is a finding with its impact.

### 7. Rotation

For each secret: can it be rotated without downtime? Signing keys need a next-key slot; encryption keys need a re-encrypt path for stored rows; API keys need both old and new accepted for a window. Note which secrets are shared between services and would need a coordinated rotation. Note any secret whose name no longer describes what it does.

### 8. Write

`docs/security/reviews/<YYYYMMDD>-secrets.md`:

```markdown
# Secrets audit, <date>
Repo: <name> at <sha>

## Inventory
| Name | Secret or config | Set in production? | Source | Read at |

## Findings
### [severity] <title>
- Where: path:line
- What
- Impact: who can do what to whom
- Fix

## Rotation table
| Secret | Rotatable without downtime? | Shared with | Procedure exists? |

## Verified OK
```

Reply in chat with: anything tracked that unlocks something, every unset secret, and every fail-open gate. Never print a secret value in chat or in the report; cite the file and line instead.
