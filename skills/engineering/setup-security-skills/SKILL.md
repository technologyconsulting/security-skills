---
name: setup-security-skills
description: "Configure this repo for the security skills: record how it ships (deploy command, environments, secret store, health URL, test and migration commands) so /pre-release and /threat-review know the facts. Run once per repo."
disable-model-invocation: true
---

# Setup Security Skills

Reads the repo. Writes `docs/security/release.md` and a `## Security skills` block in `CLAUDE.md` or `AGENTS.md`. Changes nothing else.

Prompt-driven, not a script: explore, present what you found, confirm, then write.

## Process

### 1. Explore

Read what exists. Assume nothing.

- `package.json` scripts, `Makefile`, `justfile`, `Cargo.toml`, `pyproject.toml`: which commands build, typecheck, test, deploy. Note any `predeploy` or `postdeploy` hook and what it guards.
- Platform config: `wrangler.toml`, `vercel.json`, `fly.toml`, `serverless.yml`, `Dockerfile`, `k8s/`, `.github/workflows/`. Which environments exist, and the command that lists secrets for each (for example `wrangler secret list --env production`, `flyctl secrets list`, `vercel env ls`).
- Migrations: a `migrations/` directory and the tool that applies it. Note whether a command can apply SQL without recording it in the tracker; that is a gotcha worth caching.
- Health: a route under `/health`, `/healthz`, `/.well-known` or similar, and the production hostname it answers on.
- `CLAUDE.md` and `AGENTS.md` at the root: which exists, and whether a `## Security skills` block is already there.
- `docs/security/`: a prior `release.md` or `THREAT-MODEL.md`.
- Tracked files that look like secrets: `.env`, `.env.*`, `*.pem`, `*.p12`, `*.key`. List them; `/secrets-audit` judges them.

Done when every bullet has an answer or an explicit "not found".

### 2. Present and confirm

Summarise in one screen: the deploy command per environment, the guard hooks present, the secret-list command, the health URL, the test and typecheck commands, the migration tool and any gotcha. Lead with the recommended answer for each so the user can accept in a word. Ask only where exploration left a genuine branch (two deploy paths, no health route, no tests).

One hard question, always asked:

> Which command is the only one that should ever deploy to production? (Recommended: the npm or make script that runs the guards, never the bare platform CLI.)

Record the answer verbatim. `/pre-release` prints exactly this command on GO.

### 3. Write

`docs/security/release.md` from this template, filled with what you confirmed:

```markdown
# Release config

Written by /setup-security-skills on <date>. Edit by hand when something changes.

## Environments
| Env | Deploy command (the only one) | Secret list command | Health URL |
|---|---|---|---|
| production | `<cmd>` | `<cmd>` | `<url>` |
| staging | `<cmd>` | `<cmd>` | `<url>` |

## Checks
- Typecheck: `<cmd>`
- Tests: `<cmd>`
- Migrations pending: `<cmd>`  (apply with `<cmd>`; never with `<the bypass>`)
- Clean-tree paths that the bundler ships from the working tree: `<paths>`

## Gotchas
- <one per line: the unwritten convention, the flag that silently targets the wrong environment, the cache that needs a key bump>
```

Then the block in whichever of `CLAUDE.md` or `AGENTS.md` exists (edit the existing one; create neither without asking; update an existing block in place):

```markdown
## Security skills

Release config in `docs/security/release.md`. Threat model in `docs/security/THREAT-MODEL.md` (run /threat-model if missing). Reviews under `docs/security/reviews/`.
```

Done when both files exist and the user has seen the release config.

### 4. Finish

Tell the user: run `/threat-model` next if `docs/security/THREAT-MODEL.md` is missing, then `/threat-review` on their next change.
