# Engineering

Security skills for people who write and ship code. All five are shipped in the plugin.

## User-invoked

Reachable only when you type them (`disable-model-invocation: true`).

- **[setup-security-skills](./setup-security-skills/SKILL.md)**: Record how this repo ships (deploy command, secret store, health URL, checks) in `docs/security/release.md`. Run once per repo.
- **[pre-release](./pre-release/SKILL.md)**: Read-only GO or NO-GO before a deploy, and the single command to run if GO. Never deploys.

## Model-invoked

Model- or user-reachable.

- **[threat-model](./threat-model/SKILL.md)**: Write or refresh `docs/security/THREAT-MODEL.md`: every entry point, trust boundary and actor, and what each actor can make each entry point do.
- **[threat-review](./threat-review/SKILL.md)**: Review a diff, path or repo against the threat model. Findings carry `path:line`, the actor, the impact and the smallest fix.
- **[secrets-audit](./secrets-audit/SKILL.md)**: Where every secret is read, set and could leak; which gates fail open; what breaks on rotation.
