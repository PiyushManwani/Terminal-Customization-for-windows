<#
.SYNOPSIS
Validate JSON configuration files
.DESCRIPTION
Validates all JSON files in configs directory
.PARAMETER Path
Optional path to specific JSON file to validate
#>

param(
    [string]$Path
)

function Validate-JsonFile {
    param([string]$FilePath)
    
    try {
        $content = Get-Content $FilePath -Raw
        $json = $content | ConvertFrom-Json
        Write-Host "✅ $FilePath" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "❌ $FilePath" -ForegroundColor Red
        Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

Write-Host "================================" -ForegroundColor Cyan
Write-Host "   JSON Validator" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

$passCount = 0
$failCount = 0

if ($Path) {
    if (Test-Path $Path) {
        if ((Validate-JsonFile $Path)) {
            $passCount++
        } else {
            $failCount++
        }
    } else {
        Write-Host "❌ File not found: $Path" -ForegroundColor Red
    }
} else {
    # Validate all configs
    $files = @(
        Get-ChildItem ".\configs\*.json" -ErrorAction SilentlyContinue
        Get-ChildItem ".\presets\*\*.json" -ErrorAction SilentlyContinue
        Get-ChildItem ".\keybindings\*.json" -ErrorAction SilentlyContinue
    )
    
    if ($files.Count -eq 0) {
        Write-Host "No JSON files found" -ForegroundColor Yellow
        exit
    }
    
    $files | ForEach-Object {
        if ((Validate-JsonFile $_.FullName)) {
            $passCount++
        } else {
            $failCount++
        }
    }
}

Write-Host ""
Write-Host "Results:" -ForegroundColor Cyan
Write-Host "  ✅ Passed: $passCount" -ForegroundColor Green
Write-Host "  ❌ Failed: $failCount" -ForegroundColor Red
