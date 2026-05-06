<#
.SYNOPSIS
Convert hex color to RGB
.PARAMETER HexColor
Hex color code (e.g., #FF5555)
#>

param(
    [string]$HexColor
)

if (-not $HexColor) {
    $HexColor = Read-Host "Enter hex color (e.g., #FF5555)"
}

# Remove # if present
$HexColor = $HexColor.TrimStart('#')

# Validate format
if ($HexColor -notmatch '^[0-9A-Fa-f]{6}$') {
    Write-Host "Invalid hex color format" -ForegroundColor Red
    exit
}

# Convert to RGB
$r = [Convert]::ToInt32($HexColor.Substring(0, 2), 16)
$g = [Convert]::ToInt32($HexColor.Substring(2, 2), 16)
$b = [Convert]::ToInt32($HexColor.Substring(4, 2), 16)

Write-Host "Hex Color: #$HexColor" -ForegroundColor Cyan
Write-Host "RGB Color: rgb($r, $g, $b)" -ForegroundColor Cyan
Write-Host ""
Write-Host "Display:" -ForegroundColor Cyan

# Create color preview (Windows only)
$colorCode = [int32]([System.Drawing.Color]::FromArgb($r, $g, $b).ToArgb())
Write-Host "████████" -ForegroundColor White -BackgroundColor $colorCode
