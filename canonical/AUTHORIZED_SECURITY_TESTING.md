# SACST Authorized Security Testing

SACST can support defensive security assessment and authorized penetration testing, but only inside an explicit project scope and rules of engagement.

## Allowed When Scoped

- Asset inventory and exposure review.
- Configuration review and hardening.
- Patch and vulnerability verification.
- Authenticated security checks on owned or explicitly authorized systems.
- Non-destructive validation of firewall, routing, service, and access-control posture.
- Reporting and remediation planning.

## Requires Explicit Rules of Engagement

- Exploit validation.
- Password auditing.
- Wireless testing.
- Web application testing.
- Lateral movement simulation.
- Denial-of-service or load testing.
- Social engineering.

## Default Deny

If `control/SECURITY_SCOPE.yaml` does not explicitly authorize a security-testing activity, agents must treat it as out of scope. The template default is defensive inspection and hardening only.

## Evidence Handling

- Store findings in project reports, not SACST.
- Avoid storing sensitive proof material unless the project scope requires it.
- Redact credentials, tokens, private keys, and personal data.
- Prefer reproducible remediation guidance over exploit detail.
