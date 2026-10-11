# Security Skills

Security skills for coding agents: threat model a service, review every change against that model, audit the secrets, and gate the release. Built by [Blankitt](https://blankitt.com), a founder-led UK company that sells email security and runs its own engineering with these skills.

They follow the shape of [Matt Pocock's skills](https://github.com/mattpocock/skills): small, composable, editable, model-agnostic. His pack has no security step. This one is the security step.

**Read-only by design.** Every skill reads and reports. The only files a skill writes are its own reports under `docs/security/`. Fixes, deploys, secret rotation and configuration changes stay with the human.

## Installation

Pick one install per agent, because installing both gives you every skill twice.

<details>
<summary><strong>Claude Code</strong></summary>

```bash
claude plugin marketplace add technologyconsulting/security-skills
claude plugin install security-skills@technologyconsulting
```

Updates itself by default.

</details>

<details>
<summary><strong>Any other agent, or editable files</strong></summary>

```bash
npx skills@latest add technologyconsulting/security-skills -a <agent>  # cursor, codex, opencode, copilot, amp; omit -a to choose
```

Include `setup-security-skills` when the installer asks which skills to take. Update with `npx skills@latest update`.

</details>

Then run `/setup-security-skills` once per repo. It finds your deploy command, secret store and health endpoint, confirms them with you, and writes `docs/security/release.md` so the other skills know how this repo ships.

## The skills

| Skill | When | Writes |
|---|---|---|
| [`/threat-model`](./skills/engineering/threat-model/SKILL.md) | Before the first review of a service, and again when a new entry point is added. | `docs/security/THREAT-MODEL.md` |
| [`/threat-review`](./skills/engineering/threat-review/SKILL.md) | Before merging or deploying a change. Reviews the diff against the threat model, not against a generic checklist. | `docs/security/reviews/<date>-<ref>.md` |
| [`/secrets-audit`](./skills/engineering/secrets-audit/SKILL.md) | Before a release, after onboarding a new secret, or when a rotation is due. | `docs/security/reviews/<date>-secrets.md` |
| [`/pre-release`](./skills/engineering/pre-release/SKILL.md) | When you are about to deploy. Read-only GO or NO-GO, and the single command to run if GO. | chat only |
| [`/setup-security-skills`](./skills/engineering/setup-security-skills/SKILL.md) | Once per repo. | `docs/security/release.md` and a block in `CLAUDE.md` or `AGENTS.md` |

A second bucket, [`skills/security-team/`](./skills/security-team/README.md), is for people who run systems rather than write them: Linux hosts, containers, Microsoft 365. It is planned, listed, and empty until each skill has been tested on a real system.

## Why a threat model and not a checklist

In October 2026 a generic diff review of Blankitt's DMARC service passed clean. A review that started from the threat model found that the service's inbound report address, which every customer publishes in public DNS, would accept a report for any domain and create that domain in the customer's account. Anyone who could read DNS could fill a paying customer's account with junk, push them past their plan cap, and inject HTML into alert emails the service sent. The code was tidy. The entry point was the hole.

A checklist asks "is the input validated". A threat model asks "who can reach this, and what can they make it do". The second question found it. [`/threat-model`](./skills/engineering/threat-model/SKILL.md) writes the entry points down once; [`/threat-review`](./skills/engineering/threat-review/SKILL.md) reads them on every change.

## Conventions

- One `SKILL.md` per skill under `skills/<bucket>/<name>/`.
- Each skill opens with what it reads and ends with what it writes.
- Findings cite `path:line` and quote the code. A finding the agent cannot point at is not reported.
- Severity is critical, high, medium or low, with the impact stated as who can do what to whom.
- UK English, no em-dashes.

## Contributing

Read [`SCOPE.md`](./SCOPE.md) first. Issues that describe an observed failure in a real session are welcome. New skills in `engineering/` are closed; the `security-team/` bucket takes proposals that come with a system the skill was tested on.

## Licence

MIT. See [`LICENSE`](./LICENSE).
