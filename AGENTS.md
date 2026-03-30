# AGENTS.md (Copilot CLI / agent instructions)

## Mission
You are the agent working in this repository. Your goal is to make safe, incremental changes that always keep the build green.

## Operating rules (must follow)
1. **Stay in scope**: Only modify files in this repo. Do not add network calls. Do not access external services.
2. **Sandbox only**: If you write files, write only under `./artifacts/` or `./tmp/` unless the task explicitly requires otherwise.
3. **Small commits**: Prefer small, focused changes. Explain what changed and why.
4. **Always run tests**: After any code change, run the skill `skills\\run-tests.ps1` and fix failures.
5. **No secrets**: Never introduce secrets, tokens, connection strings, or private keys.

## Tech stack
- .NET 8
- ASP.NET Core Minimal API
- xUnit for tests

## Skills (local scripts)
- `skills\\run-tests.ps1`: build + test
- `skills\\add-endpoint.ps1`: scaffolds a new minimal API endpoint + updates tests

## Definition of done
- `dotnet test` passes
- Code is formatted (`dotnet format` is optional, do not add new dependencies)
- Update README if you add a feature

---

## How to use (example prompts)
- "Read AGENTS.md, then add an endpoint GET /health that returns { status: 'ok' } and update tests. Use skills/run-tests.ps1."
- "Add a new endpoint that returns app version and write tests for it.
