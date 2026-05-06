<#
.SYNOPSIS
Backup Windows Terminal settings
.DESCRIPTION
Creates a timestamped backup of current Windows Terminal settings
#>

$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$backupDir = ".\backups"
$backupPath = "$backupDir\settings-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"

# Create backups directory if it doesn't exist
if (-not (Test-Path $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
}

if (Test-Path $settingsPath) {
    try {
        Copy-Item $settingsPath $backupPath -Force
        Write-Host "✅ Backup created: $backupPath" -ForegroundColor Green
        Write-Host "   Size: $((Get-Item $backupPath).Length / 1KB)KB" -ForegroundColor Gray
    } catch {
        Write-Host "❌ Failed to create backup: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "❌ Settings file not found at: $settingsPath" -ForegroundColor Red
}
