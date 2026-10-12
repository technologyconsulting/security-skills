---
name: upgrade-security-skills
description: "Update the security-skills plugin to the latest marketplace version and do the repo-side steps the changelog asks for (re-run setup, refresh the threat model). Use when the session-start line says a newer version is available, or when asked to update, upgrade or check the version of the security skills."
disable-model-invocation: true
---

# Upgrade security skills

Reads the installed and latest versions, the new `CHANGELOG.md`, and this repo's `docs/security/`. Changes the plugin installation on this machine, which is the user's own tooling, and nothing else by itself. Anything it changes in the repo happens only through `/setup-security-skills` and `/threat-model`, with their usual confirmations. Never deploys, never touches an environment.

## Process

### 1. Where things stand

Run the check script in the plugin root and read its line:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/check-version.sh" --status
```

`update=0` with a known latest: say "security-skills <version> is current" and stop. `latest=unknown`: say the marketplace could not be reached, and stop; do not guess.

### 2. Update the plugin

Two commands, in this order. The first refreshes the marketplace from its source; the second installs the version it now advertises. Run them and show their output.

```bash
claude plugin marketplace update technologyconsulting
```

```bash
claude plugin update security-skills@technologyconsulting
```

If either fails, show the error and stop. Do not retry with different flags, and do not edit the plugin cache by hand.

### 3. Read what changed

The new version's files are under `~/.claude/plugins/cache/technologyconsulting/security-skills/<latest>/`. Read its `CHANGELOG.md` from the top down to the installed version's entry. Each entry may carry an `After upgrading:` line naming the repo-side steps, for example "re-run /setup-security-skills" or "refresh the threat model". Collect those steps, newest first, without duplicates. Everything else in the changelog is for the summary.

### 4. Repo-side steps

Only when the current working directory has a `docs/security/` folder; a repo that has not been set up has nothing to migrate.

Do the collected steps in order, each through its own skill, so its confirmations still happen:

- "re-run /setup-security-skills": invoke that skill. It presents the current release config and asks the one hard question; pre-fill the answer from the existing `docs/security/release.md` and ask only whether it is still right.
- "refresh the threat model": invoke `/threat-model`. Its refresh keeps accepted risks and human-written lines word for word.
- Anything else: say what the changelog asks and let the user decide.

The skill bodies loaded in this session are the old version's, so the steps run with the old text. Say so, and say that re-running the same step in a fresh session is the way to get the new behaviour if the changelog says the step itself changed.

### 5. Finish

Tell the user, in this order:

1. The versions: was, now.
2. The changelog summary, one line per entry between them.
3. Which repo-side steps ran, and which were skipped and why.
4. "Restart Claude Code to load the new version." A running session keeps the skills it loaded at start; the next session's start line confirms the version.

Done when the plugin command reports the new version and the user has seen the four points.
