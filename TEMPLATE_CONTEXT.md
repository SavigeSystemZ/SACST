# SACST Template Context

## Identity

This repository is the canonical SACST template and meta-system.

It defines how AI agents should operate on computers, servers, firewalls, switches, and related infrastructure. It also defines how SACST itself is safely improved over time.

SACST must remain adaptable across vendors and operating systems. It may define live-research workflows for unfamiliar command syntax, Windows/Linux/vendor appliance behavior, generic vendor planning, and authorized security assessment patterns, but project-specific findings and target details belong only in scaffolded project repos.

## Boundary

- SACST is not a live instance repository.
- SACST must not store project-specific runtime state, raw audits, logs, checkpoints, or host-specific truth.
- SACST must not store real credentials, target secrets, private configs, or project-specific security findings.
- Project-specific repos are scaffolded outside SACST and are self-contained.

## Mutation Rule

Changes in SACST are template/meta-system changes. They must keep canonical docs, schemas, templates, adapters, validation, and migration surfaces aligned.

## Sync Rule

Project repos never write back into SACST directly. Template improvements flow outward through explicit sync from SACST into project repos.
