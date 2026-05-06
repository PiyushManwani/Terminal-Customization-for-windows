<#
.SYNOPSIS
List all available themes
#>

Write-Host "Available Themes:" -ForegroundColor Cyan
Write-Host ""

$themes = Get-ChildItem ".\configs\*.json" -ErrorAction SilentlyContinue

if ($themes.Count -eq 0) {
    Write-Host "No themes found in configs folder" -ForegroundColor Yellow
    exit
}

$themes | ForEach-Object {
    $themeName = $_.BaseName
    $themeSize = "{0:N2}" -f ($_.Length / 1KB)
    
    Write-Host "  • $themeName" -ForegroundColor Green -NoNewline
    Write-Host " ($themeSize KB)" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Usage: .\scripts\apply-config.ps1 -Theme `"theme-name`"" -ForegroundColor Yellow
