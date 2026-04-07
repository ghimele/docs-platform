# Test Strategy

**Status:** Draft  
**Last updated:** 2026-03-30  
**Owner:** Project Team  

---

## 1. Purpose

This document defines the overall testing approach for the project,
covering test categories, coverage targets, tooling, and conventions
for both C++ and .NET components.

---

## 2. Scope

### In Scope

- Unit, integration, and end-to-end test strategy
- Tooling and framework choices per language
- Naming and organisation conventions
- Coverage targets

### Out of Scope

- Performance and load testing strategy (document separately when needed)
- CI/CD pipeline configuration (see `.github/workflows/`)

---

## 3. Test Categories

| Category | Scope | Isolation | Speed |
| -------- | ----- | --------- | ----- |
| Unit | Single function or class | Full mock of dependencies | Fast (< 1s per test) |
| Integration | Multiple components together | Real dependencies within a boundary | Medium |
| End-to-end | Full system path | No mocks | Slow |

---

## 4. C++ Testing

**Framework:** Google Test (GTest) + Google Mock  
**Location:** `tests/` mirroring the `src/` structure  

### Naming conventions

- Test files: `<ClassName>Test.cpp`
- Test suites: `class <ClassName>Test : public ::testing::Test`
- Test names: `MethodName_StateUnderTest_ExpectedBehaviour`

### Example

```cpp
TEST_F(AtomStoreTest, Append_NewAtom_ReturnsValidAtomId) { ... }
TEST_F(AtomStoreTest, Append_DuplicateAtom_ReusesExistingId) { ... }
```

---

## 5. .NET Testing

**Framework:** xUnit  
**Mocking:** Moq  
**Location:** `<ProjectName>.Tests/` alongside each project  

### Naming conventions

- Test classes: `<ClassName>Tests`
- Test methods: `MethodName_StateUnderTest_ExpectedBehaviour`

### Example

```csharp
public class OrderServiceTests
{
    [Fact]
    public void PlaceOrder_ValidInput_ReturnsOrderId() { ... }

    [Fact]
    public void PlaceOrder_NullInput_ThrowsArgumentException() { ... }
}
```

---

## 6. Coverage Targets

| Layer | Target |
| ----- | ------ |
| Core business logic (C++ / .NET) | ≥ 80% line coverage |
| Infrastructure / adapters | ≥ 60% |
| Generated or boilerplate code | Excluded |

---

## 7. Constraints & Invariants

- **T1** Tests must not depend on execution order
- **T2** Tests must not share mutable state between test cases
- **T3** Unit tests must not perform I/O (file, network, database)
- **T4** Every public API must have at least one unit test for the happy path and one for each documented error case

---

## 8. References

- `../architecture/` — system structure relevant for integration test boundaries
- `../api/` — interface contracts that tests must validate
