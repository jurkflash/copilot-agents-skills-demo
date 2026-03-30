<##
.SYNOPSIS
  Adds a new minimal API endpoint to DemoApi and scaffolds a basic test.

.DESCRIPTION
  This script is intentionally simple. It edits Program.cs by inserting a small
  region between markers and appends a test in the tests project.

.PARAMETER Route
  Example: /version

.PARAMETER Name
  Example: version

.PARAMETER ResponseJson
  Example: {"version": "1.0.0"}

.EXAMPLE
  ./skills/add-endpoint.ps1 -Route /version -Name version -ResponseJson '{"version":"1.0.0"}'
##>

param(
  [Parameter(Mandatory=$true)] [string]$Route,
  [Parameter(Mandatory=$true)] [string]$Name,
  [Parameter(Mandatory=$true)] [string]$ResponseJson
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$solutionRoot = Split-Path -Parent $PSScriptRoot
$apiFile = Join-Path $solutionRoot "src\DemoApi\Program.cs"
$testFile = Join-Path $solutionRoot "tests\DemoApi.Tests\EndpointSmokeTests.cs"

if (-not (Test-Path $apiFile)) { throw "Missing $apiFile" }

# Validate route
if (-not $Route.StartsWith("/")) { throw "Route must start with '/" }

$program = Get-Content $apiFile -Raw

$startMarker = "// <agent:endpoints>"
$endMarker   = "// </agent:endpoints>"

$startIndex = $program.IndexOf($startMarker)
$endIndex = $program.IndexOf($endMarker)

if ($startIndex -lt 0 -or $endIndex -lt 0 -or $endIndex -le $startIndex) {
  throw "Could not find endpoint markers in Program.cs"
}

$insertionPoint = $startIndex + $startMarker.Length

$endpointCode = @"

app.MapGet("$Route", () => Results.Text("$ResponseJson", "application/json"))
   .WithName("$Name");
"@

$updated = $program.Insert($insertionPoint, $endpointCode)
Set-Content -Path $apiFile -Value $updated -Encoding UTF8

# Add/append test file
$testSnippet = @"

    [Fact]
    public async Task GET_$($Name)_returns_200()
    {
        using var app = new DemoApiFactory();
        using var client = app.CreateClient();

        var resp = await client.GetAsync("$Route");
        resp.EnsureSuccessStatusCode();
    }
"@

if (-not (Test-Path $testFile)) {
  Set-Content -Path $testFile -Value @"
using System.Threading.Tasks;
using Xunit;

namespace DemoApi.Tests;

public class EndpointSmokeTests
{
$testSnippet
}
"@ -Encoding UTF8
}
else {
  $existing = Get-Content $testFile -Raw
  if ($existing -notmatch "class EndpointSmokeTests") {
    throw "Unexpected test file contents in $testFile"
  }
  # Insert before last }
  $pos = $existing.LastIndexOf("}")
  $newText = $existing.Insert($pos, $testSnippet)
  Set-Content -Path $testFile -Value $newText -Encoding UTF8
}

Write-Host "Added endpoint $Route and updated tests." -ForegroundColor Green
