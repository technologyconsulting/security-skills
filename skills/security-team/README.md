# Security team

Skills for people who run systems rather than write them. Listed here before they exist so the shape is public and feedback can start. None is shipped in the plugin until it has been run against a real system and the result written up.

Same rule as the engineering bucket: each skill reads and reports. A hardening review names what to change and why; the operator changes it.

## Planned

- **linux-hardening-review**: Read a host's configuration (SSH, sudoers, services, listening ports, package state, logging) against a baseline, and report drift with the file and line. First target: an Ubuntu 24.04 host.
- **container-review**: Read a Dockerfile, compose file or image and report the user it runs as, the capabilities it keeps, the secrets it bakes, the base image age, and the ports it opens.
- **m365-posture-review**: Read an exported Microsoft 365 configuration (Conditional Access, mail flow rules, DKIM and DMARC state, admin role holders, legacy auth) and report against a baseline. Tested on a real tenant with sign-off, anonymised in the write-up.
- **incident-retro**: Turn a timeline and the artefacts of an incident into a retro with a cause chain, the detection gap, and the controls that would have shortened each.
- **evidence-pack**: Collect the read-only evidence a control review asks for (who has access, what is logged, what is patched) into a dated folder, so an audit question is answered from files rather than memory.

## Proposing one

Open an issue that names the system the skill was tested on and what it found there. See [`SCOPE.md`](../../SCOPE.md).
