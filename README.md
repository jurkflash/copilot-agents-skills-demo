# Copilot Agents + Skills Demo (PowerShell + .NET 8)

This repo is a tiny demo you can use with **GitHub Copilot in the CLI**.

## What this demonstrates
- **AGENTS.md**: a single place to put agent instructions / project rules.
- **Skills**: simple PowerShell scripts under `./skills` that the agent can run.
- A minimal **.NET 8** API + **xUnit** tests.

## Quick start

### Prereqs
- .NET SDK 8.x
- PowerShell 7+ recommended (Windows PowerShell also works)

### Build + test (skill)

```powershell
./skills/run-tests.ps1
```

### Run the API

```powershell
cd src/DemoApi
$env:ASPNETCORE_URLS = "http://localhost:5100"
dotnet run
```

Then open:
- `http://localhost:5100/health`
- `http://localhost:5100/weather?c=72`

## Copilot CLI prompts to try

In the repo root:

- "Read AGENTS.md and explain the repo rules."
- "Add GET /version returning a JSON object with version from the assembly, add tests, and run ./skills/run-tests.ps1."
- "Add input validation to /weather so c must be between -100 and 140, update tests.
