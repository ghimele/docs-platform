# Security Coding Standards

**Status:** Draft  
**Last updated:** 2026-03-30  
**Owner:** Project Team  

---

## 1. Purpose

This document defines security-specific coding rules for both C++ and .NET components.
These rules are enforced during code review and are used by agents when generating code.

---

## 2. C++ Rules

| Rule | Description |
| ---- | ----------- |
| **SC-CPP-01** | No raw owning pointers — use `std::unique_ptr` or `std::shared_ptr` |
| **SC-CPP-02** | All array accesses must be bounds-checked |
| **SC-CPP-03** | No `strcpy`, `sprintf`, or other unbounded C string functions |
| **SC-CPP-04** | All external input must be validated before use in any buffer or container |
| **SC-CPP-05** | No `system()` calls — use structured process APIs |

---

## 3. .NET Rules

| Rule | Description |
| ---- | ----------- |
| **SC-NET-01** | Nullable reference types must be enabled per project |
| **SC-NET-02** | All SQL or query strings must use parameterised queries — no string concatenation |
| **SC-NET-03** | Secrets must be loaded from environment or secret store — never hardcoded |
| **SC-NET-04** | All public API endpoints must validate input with model validation |
| **SC-NET-05** | No `dynamic` type usage in security-sensitive code paths |

---

## 4. General Rules (All Languages)

| Rule | Description |
| ---- | ----------- |
| **SC-GEN-01** | Secrets must never appear in logs, exceptions, or error messages |
| **SC-GEN-02** | Dependencies must be pinned to specific versions and reviewed on upgrade |
| **SC-GEN-03** | Third-party libraries must be evaluated before use |

---

## 5. References

- `threat-model.md` — threats these rules are designed to mitigate
