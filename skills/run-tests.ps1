param(
  [switch]$NoBuild
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host "==> Running build + tests" -ForegroundColor Cyan

$solutionRoot = Split-Path -Parent $PSScriptRoot
Push-Location $solutionRoot
try {
  if (-not $NoBuild) {
    dotnet build .\src\DemoApi\DemoApi.csproj -c Release
  }
  dotnet test .\tests\DemoApi.Tests\DemoApi.Tests.csproj -c Release --nologo

  Write-Host "==> OK" -ForegroundColor Green
}
finally {
  Pop-Location
}