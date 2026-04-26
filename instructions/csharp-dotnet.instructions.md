---
description: "C# and .NET conventions: nullable reference types, async/await with CancellationToken propagation, constructor-based DI (with Unity Container variation), EF Core data access (with custom SQL variation), xUnit testing (with MSTest variation), CSharpier formatting, structured logging with ILogger<T>, NuGet central package management, P/Invoke interop. Covers both .NET 6+ and .NET Framework 4.8 legacy codebases."
applyTo: "**/*.cs"
---

# C# / .NET Coding Conventions

**Status:** Active
**Last updated:** 2026-04-17
**Owner:** Project Team
**Applies to:** All `.cs` files across .NET 6+ and .NET Framework 4.8 codebases

---

## Target Framework

- New projects: **.NET 6+** (prefer latest LTS)
- Legacy codebases: **.NET Framework 4.8** — do not introduce .NET 6+ APIs unless the project is actively migrating
- Do not mix `net6.0+` and `net48` target frameworks in the same project unless it is a multi-targeting library with appropriate `#if` guards

---

## Nullable Reference Types

- All new projects must enable `<Nullable>enable</Nullable>`
- Do not suppress warnings with `!` (null-forgiving operator) without a documented justification
- Use `string?`, `object?` etc. to declare nullable intent explicitly
- Check for `null` at public API boundaries; rely on flow analysis internally

---

## Naming Conventions

- Async methods: suffix with `Async` — `SaveAsync()`
- Private fields: `_camelCase` — `_connectionString`
- Some codebases use `m_camelCase` for instance fields and `s_camelCase` for static fields — check existing files in the project before choosing

---

## Async / Await

- Propagate `CancellationToken` through every async call chain — never ignore a `CancellationToken` parameter
- Never use `.Result` or `.Wait()` on a `Task` — causes deadlocks
- Default to `Task<T>`; use `ValueTask<T>` only when benchmarking proves benefit
- Use `ConfigureAwait(false)` in library code; omit in ASP.NET controller code
- Return `Task` rather than `async void` — `async void` is only for event handlers

---

## Dependency Injection

- Use **constructor injection** exclusively — no service-locator or property injection
- Some codebases use **Unity Container** instead of the built-in .NET DI container — match the existing DI framework in the project
- Service lifetimes:
  - `Singleton` — stateless or thread-safe shared services
  - `Scoped` — per-request services (EF `DbContext`, unit-of-work)
  - `Transient` — lightweight, stateless, disposable-safe services
- Never inject `IServiceProvider` directly except in factory patterns

---

## NuGet Packages

- Pin package versions explicitly in `Directory.Packages.props` (Central Package Management)
- Do not add a NuGet dependency if the functionality exists in the BCL or an internal shared package

---

## Entity Framework / Data Access

- Use **EF Core** with code-first migrations in new projects
- Some codebases use custom SQL abstractions or stored procedures — match the existing data access pattern in the project
- Legacy projects using EF6 or ADO.NET: follow the existing pattern — do not migrate without explicit instruction
- Always use `AsNoTracking()` for read-only queries
- Never call `SaveChanges` / `SaveChangesAsync` inside a loop — batch operations
- Use `IQueryable<T>` in repository methods; materialize with `ToListAsync()` at the service layer

---

## Error Handling

- Catch the most specific exception type — never catch bare `Exception` unless at a top-level boundary (middleware, background worker entry point)
- Include inner exceptions: `throw new DomainException("msg", ex)`
- Use the **Result pattern** (`Result<T>` / `OneOf`) for expected failure paths in domain logic rather than exceptions for flow control

---

## Platform SDK Interop (P/Invoke)

- Use `[DllImport]` or `[LibraryImport]` (.NET 7+) for native interop
- Define interop structs with explicit `[StructLayout(LayoutKind.Sequential)]`
- Minimise `unsafe` code — isolate it behind safe public API surfaces
- Pin managed objects (`GCHandle`, `fixed`) only for the minimum required scope
- Never expose raw `IntPtr` in public APIs — wrap in a `SafeHandle` or custom wrapper

---

## Logging

- Use `ILogger<T>` from `Microsoft.Extensions.Logging`
- Use structured logging with message templates: `_logger.LogInformation("Processing {OrderId}", orderId)`
- Never use string interpolation in log messages — it defeats structured logging

---

## Testing

- Default framework: **xUnit** with `FluentAssertions`
- Some codebases use **MSTest** with **Moq** — check `*.csproj` for test SDK references and match the existing framework
- Test class naming: `{ClassName}Tests` in a matching namespace under the test project
- Use `[Fact]` for single cases, `[Theory]` with `[InlineData]` for parameterised tests
- Keep tests independent — no shared mutable state between test methods
- Integration tests use `WebApplicationFactory<T>` for ASP.NET endpoints

---

## Formatting

- Check for `.csharpierrc` or `.csharpierrc.yaml` — if present, **CSharpier** is the formatter; otherwise use `dotnet format`
- Do not reformat files unrelated to the current task

---

## Never-Do List

| Forbidden | Reason |
|-----------|--------|
| `.Result` / `.Wait()` on tasks | Deadlocks |
| `async void` (except event handlers) | Unhandled exceptions crash the process |
| Service locator / `IServiceProvider` for general use | Hides dependencies |
| Suppressing nullable warnings with `!` without justification | Masks null bugs |
| Exposing `IntPtr` in public APIs | Unsafe memory contract |
| `Thread.Sleep` in async code | Use `Task.Delay` |
| String interpolation in log messages | Defeats structured logging |
| `var` for non-obvious types | Reduces readability |

---

## Ask Before Doing

- Changing target framework or multi-targeting configuration
- Changing EF Core migration strategy or database schema
- Introducing a new NuGet dependency
- Introducing a new pattern not already present in the codebase
