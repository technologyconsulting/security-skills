# Scope

This repo is the set of security skills Blankitt uses on its own services. It is curated. Issues are for tracking changes to the skills; questions go to [GitHub Discussions](https://github.com/technologyconsulting/security-skills/discussions).

## The bar

An issue stays open only if it clears both parts:

1. **Observed failure.** It describes something that went wrong in a real session: what you ran, what the skill did, what you expected. A hypothetical improvement does not clear this part.
2. **Fits the rule.** Every skill reads and reports. A proposal that has a skill change a system (apply a fix, rotate a secret, run a deploy, edit a firewall) does not fit, however useful. Those actions stay with the human.

## By bucket

- **`engineering/`**: the bar above. New skills are closed. If the behaviour composes from the existing five, it does not get a new one.
- **`security-team/`**: proposals are open, with one condition: the proposal names the real system the skill was tested on and what it found there. A skill that has only been run against an imagined system is not ready.

## Already decided

- **No automatic fixes.** A skill that found a hole and fixed it would be the most useful skill in the pack, and the most dangerous. The human applies the fix, with the finding in front of them.
- **No harness-name collisions.** Claude Code ships a built-in `/security-review`, so the review skill here is `/threat-review`. Skills in this pack avoid names a harness already uses.
- **No per-company specifics in a skill.** Deploy commands, secret stores, health URLs and internal auth models belong in `docs/security/release.md` and `docs/security/THREAT-MODEL.md` in your repo, written by `/setup-security-skills` and `/threat-model`. The skills read those files; they never carry one company's facts.

## Unclear issues

An issue that cannot be judged against the bar gets one round of questions and the `needs-info` label. With no reply in 14 days, it is closed.
