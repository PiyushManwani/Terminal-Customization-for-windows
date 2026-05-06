<#
.SYNOPSIS
Merge multiple terminal configurations
.DESCRIPTION
Combines profiles, schemes, and keybindings from multiple configs
#>

param(
    [string[]]$ConfigPaths
)

if ($ConfigPaths.Count -lt 2) {
    Write-Host "Usage: .\merge-configs.ps1 -ConfigPaths config1.json, config2.json" -ForegroundColor Yellow
    exit
}

Write-Host "Merging configurations..." -ForegroundColor Cyan

$mergedConfig = @{
    "`$schema" = "https://aka.ms/terminal-profiles-schema"
    "defaultProfile" = "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}"
    "profiles" = @{
        "defaults" = @{}
        "list" = @()
    }
    "schemes" = @()
    "keybindings" = @()
}

foreach ($path in $ConfigPaths) {
    if (Test-Path $path) {
        $config = Get-Content $path | ConvertFrom-Json
        
        # Merge profiles
        if ($config.profiles.list) {
            $mergedConfig.profiles.list += $config.profiles.list
        }
        
        # Merge schemes
        if ($config.schemes) {
            $mergedConfig.schemes += $config.schemes
        }
        
        # Merge keybindings
        if ($config.keybindings) {
            $mergedConfig.keybindings += $config.keybindings
        }
        
        Write-Host "✅ Merged: $path" -ForegroundColor Green
    } else {
        Write-Host "❌ Not found: $path" -ForegroundColor Red
    }
}

# Save merged config
$outputPath = "merged-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
$mergedConfig | ConvertTo-Json -Depth 100 | Set-Content $outputPath

Write-Host ""
Write-Host "✅ Merged config saved to: $outputPath" -ForegroundColor Green
