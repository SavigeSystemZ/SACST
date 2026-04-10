# SACST Authorized Security Testing

SACST supports full-spectrum red-team, blue-team, and purple-team security operations when the operator's current tasking authorizes that work.

The template is operator-gated: the human operator is the approval gateway, and project repos carry the active scope posture in `control/SECURITY_SCOPE.yaml`.

## Default Project Posture

- Asset inventory and exposure review.
- Configuration review and hardening.
- Patch and vulnerability verification.
- Authenticated security checks on owned or explicitly authorized systems.
- Non-destructive validation of firewall, routing, service, and access-control posture.
- Exploit validation, credential auditing, wireless testing, web-application testing, lateral-movement simulation, controlled load testing, detection engineering, threat hunting, incident response, and red/blue/purple-team validation when the current operator task authorizes it.
- Reporting and remediation planning.

## Operator-Gated Actions

- Exploit validation.
- Password auditing.
- Wireless testing.
- Web application testing.
- Lateral movement simulation.
- Controlled load testing.
- Social engineering.

## Still Prohibited By Default

- Unauthorized third-party targets.
- Actions outside the operator's current tasking.
- Uncontrolled denial-of-service.
- Destructive testing without explicit confirmation.
- Credential exfiltration or secret disclosure.

If `control/SECURITY_SCOPE.yaml` narrows a project scope, agents must obey the narrower project scope. If the operator's current tasking is ambiguous, agents must ask before proceeding.

## Evidence Handling

- Store findings in project reports, not SACST.
- Avoid storing sensitive proof material unless the project scope requires it.
- Redact credentials, tokens, private keys, and personal data.
- Prefer reproducible remediation guidance over exploit detail.
