<#
.SYNOPSIS
Apply a Windows Terminal configuration theme
.DESCRIPTION
Applies a theme from the configs folder to Windows Terminal settings
.PARAMETER Theme
The theme name (without .json extension)
.EXAMPLE
.\apply-config.ps1 -Theme "catppuccin-neon"
#>

param(
    [string]$Theme = "catppuccin-neon"
)

# Settings path
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$configPath = ".\configs\$Theme.json"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Change to script directory
if ($scriptDir) {
    Push-Location $scriptDir
}

# Clear errors
$Error.Clear()

Write-Host "================================" -ForegroundColor Cyan
Write-Host "  Windows Terminal Theme Applier" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Verify files exist
if (-not (Test-Path $configPath)) {
    Write-Host "Theme '$Theme' not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Available themes:" -ForegroundColor Yellow
    Get-Item ".\configs\*.json" -ErrorAction SilentlyContinue | ForEach-Object {
        Write-Host "  • $($_.BaseName)" -ForegroundColor Gray
    }
    exit 1
}

if (-not (Test-Path $settingsPath)) {
    Write-Host "Windows Terminal settings not found!" -ForegroundColor Red
    Write-Host "Make sure Windows Terminal is installed from Microsoft Store." -ForegroundColor Yellow
    exit 1
}

# Backup current settings
$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$backupPath = "$env:USERPROFILE\Desktop\settings-backup-$timestamp.json"

try {
    Write-Host "Backing up current settings..." -ForegroundColor Cyan
    Copy-Item $settingsPath $backupPath -Force
    Write-Host "Backup saved to: $backupPath" -ForegroundColor Green
} catch {
    Write-Host "Could not backup settings: $($_.Exception.Message)" -ForegroundColor Yellow
}

# Load and validate new config
try {
    Write-Host "Validating theme configuration..." -ForegroundColor Cyan
    $newConfig = Get-Content $configPath -Raw | ConvertFrom-Json
    Write-Host "Theme validation passed" -ForegroundColor Green
} catch {
    Write-Host "Invalid JSON in theme: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Apply config
try {
    Write-Host "Applying theme: $Theme" -ForegroundColor Cyan
    $newConfig | ConvertTo-Json -Depth 100 | Set-Content $settingsPath
    Write-Host "Theme applied successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Please restart Windows Terminal to see the changes." -ForegroundColor Yellow
} catch {
    Write-Host "Failed to apply theme: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
