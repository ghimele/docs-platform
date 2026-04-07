# Threat Model

**Status:** Draft  
**Last updated:** 2026-03-30  
**Owner:** Project Team  

---

## 1. Purpose

This document identifies the trust boundaries, assets, threats, and mitigations
for this system. It is used during code review and when agents generate code
involving authentication, authorization, input handling, or data access.

---

## 2. Scope

### In Scope

- Trust boundaries between components
- Data assets that require protection
- Known threat vectors and mitigations

### Out of Scope

- Infrastructure security (network, OS hardening)
- Physical security

---

## 3. Assets

| Asset | Sensitivity | Notes |
| ----- | ----------- | ----- |
| *(add assets here)* | | |

---

## 4. Trust Boundaries

| Boundary | Description |
| -------- | ----------- |
| *(add boundaries here)* | |

---

## 5. Threats and Mitigations

| ID | Threat | Category | Mitigation | Status |
| -- | ------ | -------- | ---------- | ------ |
| T1 | *(describe threat)* | *(STRIDE category)* | *(mitigation approach)* | Open |

STRIDE categories: Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, Elevation of Privilege

---

## 6. Constraints & Invariants

- **S1** All external input must be validated before use
- **S2** Secrets must never be logged or written to source control
- **S3** Authentication must be verified before any privileged operation

---

## 7. References

- `coding-standards.md` — security rules enforced in code review
