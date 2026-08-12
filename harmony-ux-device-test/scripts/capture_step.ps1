#Requires -Version 5.1
<#
.SYNOPSIS
  Capture uitest dumpLayout + screenCap for one UX test step (Windows + hdc).

.PARAMETER ArtifactDir
  Local directory for layout_*.json and cap_*.png

.PARAMETER Step
  Step id used in filenames (e.g. 01_home)

.PARAMETER Target
  Optional hdc serial (-t). Empty = default device.

.PARAMETER BundleName
  Optional: dumpLayout -b <bundleName>
#>
param(
  [Parameter(Mandatory = $true)][string]$ArtifactDir,
  [Parameter(Mandatory = $true)][string]$Step,
  [string]$Target = "",
  [string]$BundleName = ""
)

$ErrorActionPreference = "Stop"

function Invoke-Hdc {
  param([string[]]$HdcArgs)
  if ($Target) {
    & hdc -t $Target @HdcArgs
  } else {
    & hdc @HdcArgs
  }
  if ($LASTEXITCODE -ne 0) {
    throw "hdc failed ($LASTEXITCODE): hdc $($HdcArgs -join ' ')"
  }
}

$safeStep = ($Step -replace '[^\w\-.]+', '_').Trim('_')
if (-not $safeStep) { throw "Step name is empty after sanitizing" }

New-Item -ItemType Directory -Force -Path $ArtifactDir | Out-Null
$remoteLayout = "/data/local/tmp/ux_layout_$safeStep.json"
$remoteCap = "/data/local/tmp/ux_cap_$safeStep.png"
$localLayout = Join-Path $ArtifactDir "layout_$safeStep.json"
$localCap = Join-Path $ArtifactDir "cap_$safeStep.png"

$dumpArgs = @("shell", "uitest", "dumpLayout", "-p", $remoteLayout, "-a")
if ($BundleName) {
  $dumpArgs += @("-b", $BundleName)
}
Invoke-Hdc $dumpArgs
Invoke-Hdc @("file", "recv", $remoteLayout, $localLayout)

Invoke-Hdc @("shell", "uitest", "screenCap", "-p", $remoteCap)
Invoke-Hdc @("file", "recv", $remoteCap, $localCap)

$clickables = @()
if (Test-Path $localLayout) {
  try {
    $jsonText = Get-Content -Raw -Encoding UTF8 $localLayout
    # Collect quoted text/id-like fields without full DOM walk dependency
    $textMatches = [regex]::Matches($jsonText, '"(?:text|content|description|accessibilityText|id|resourceId)"\s*:\s*"([^"\\]*(?:\\.[^"\\]*)*)"')
    $seen = @{}
    foreach ($m in $textMatches) {
      $v = $m.Groups[1].Value
      if ($v.Length -lt 1 -or $v.Length -gt 80) { continue }
      if ($seen.ContainsKey($v)) { continue }
      $seen[$v] = $true
      $clickables += $v
      if ($clickables.Count -ge 60) { break }
    }
  } catch {
    Write-Warning "Could not summarize layout texts: $_"
  }
}

$summary = [ordered]@{
  step        = $safeStep
  artifactDir = (Resolve-Path $ArtifactDir).Path
  layout      = $localLayout
  screenshot  = $localCap
  textsSample = $clickables
  timeUtc     = (Get-Date).ToUniversalTime().ToString("o")
}

$summaryPath = Join-Path $ArtifactDir "summary_$safeStep.json"
$summary | ConvertTo-Json -Depth 4 | Set-Content -Encoding UTF8 $summaryPath

Write-Host "OK layout=$localLayout"
Write-Host "OK screenshot=$localCap"
Write-Host "OK summary=$summaryPath"
if ($clickables.Count -gt 0) {
  Write-Host "Texts (sample):"
  $clickables | ForEach-Object { Write-Host "  - $_" }
}
