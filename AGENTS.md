Skills live in bucket folders under `skills/`:

- `engineering/`: for people who write and ship code. Shipped in the plugin.
- `security-team/`: for people who run systems (hosts, containers, identity). Public on purpose, not shipped in the plugin until each skill has been tested on a real system.

Every skill in `engineering/` has a reference in the top-level `README.md` table and an entry in `.claude-plugin/plugin.json`'s `skills` array. Skills in `security-team/` appear in neither until promoted. Run `claude plugin validate . --strict` after touching either manifest.

Every `SKILL.md` states, in its first paragraph, what it reads and what it writes. The only files a skill writes are its own reports under `docs/security/` in the target repo. If a skill needs to run a command, the command is one that changes nothing: `git status`, `git diff`, a typecheck, a test run, a `secret list`, a read-only query.

Findings carry `path:line` and quote the code. Severity is critical, high, medium or low. Impact is written as who can do what to whom.

Per-company facts (deploy command, secret store, auth model, tenant model) live in the target repo's `docs/security/release.md` and `docs/security/THREAT-MODEL.md`, never in a skill.

UK English. No em-dashes anywhere in this repo's prose; where a sentence reaches for one, rewrite it with a comma, colon, full stop, parentheses or a conjunction.

Shared language is in [`GLOSSARY.md`](./GLOSSARY.md). Use its terms in skills and docs.
