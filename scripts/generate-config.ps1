<#
.SYNOPSIS
Generate a custom Windows Terminal configuration
.DESCRIPTION
Interactive script to generate custom terminal config
#>

Write-Host "================================" -ForegroundColor Cyan
Write-Host "  Terminal Config Generator" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Helper function to get choice
function Get-UserChoice {
    param(
        [string]$Prompt,
        [array]$Options,
        [string]$Default = $null
    )
    
    Write-Host "$Prompt" -ForegroundColor Cyan
    for ($i = 0; $i -lt $Options.Count; $i++) {
        Write-Host "  $($i + 1). $($Options[$i])"
    }
    
    $choice = Read-Host "Enter choice (1-$($Options.Count))"
    
    if ([int]::TryParse($choice, [ref]$choice)) {
        return $Options[$choice - 1]
    }
    return $Default
}

# Get user preferences
$colorScheme = Get-UserChoice "Select color scheme:" @(
    "Catppuccin Neon",
    "Dracula",
    "Nord",
    "One Dark",
    "Tokyo Night",
    "Gruvbox",
    "Cyberpunk",
    "Solarized Dark",
    "Monokai"
) "One Dark"

$fontSize = Read-Host "Font size (default 12)"
if (-not $fontSize) { $fontSize = 12 }

$opacity = Read-Host "Opacity 0-100 (default 85)"
if (-not $opacity) { $opacity = 85 }

$padding = Read-Host "Padding in pixels (default 14)"
if (-not $padding) { $padding = 14 }

# Create config
$config = @{
    "`$schema" = "https://aka.ms/terminal-profiles-schema"
    "defaultProfile" = "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}"
    "profiles" = @{
        "defaults" = @{
            "font" = @{
                "face" = "JetBrainsMono Nerd Font Propo"
                "size" = [int]$fontSize
            }
            "cursorShape" = "bar"
            "padding" = "$padding, $padding, $padding, $padding"
            "opacity" = [int]$opacity
            "useAcrylic" = $true
            "colorScheme" = $colorScheme
        }
        "list" = @(
            @{
                "commandline" = "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
                "guid" = "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}"
                "name" = "Windows PowerShell"
                "tabTitle" = "PowerShell"
            }
        )
    }
    "keybindings" = @(
        @{ "command" = "copy"; "keys" = "ctrl+c" },
        @{ "command" = "paste"; "keys" = "ctrl+v" },
        @{ "command" = "newTab"; "keys" = "ctrl+shift+t" },
        @{ "command" = "splitPane"; "keys" = "alt+shift+d" }
    )
}

# Save config
$filename = "custom-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
$filepath = ".\configs\$filename"

$config | ConvertTo-Json -Depth 100 | Set-Content $filepath

Write-Host ""
Write-Host "✅ Configuration saved to: $filepath" -ForegroundColor Green
Write-Host ""
Write-Host "To apply this config:" -ForegroundColor Yellow
Write-Host "  .\scripts\apply-config.ps1 -Theme `"$(Get-Item $filepath | Select-Object -ExpandProperty BaseName)`"" -ForegroundColor Cyan
