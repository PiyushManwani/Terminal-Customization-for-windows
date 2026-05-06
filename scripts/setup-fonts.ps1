<#
.SYNOPSIS
Download and install Nerd Fonts
#>

Write-Host "================================" -ForegroundColor Cyan
Write-Host "  Nerd Fonts Setup" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

$fonts = @(
    @{
        "name" = "JetBrains Mono"
        "url" = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.0/JetBrainsMono.zip"
    },
    @{
        "name" = "Fira Code"
        "url" = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.0/FiraCode.zip"
    },
    @{
        "name" = "Cascadia Code"
        "url" = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.0/CascadiaCode.zip"
    }
)

Write-Host "Available Fonts:" -ForegroundColor Cyan
for ($i = 0; $i -lt $fonts.Count; $i++) {
    Write-Host "  $($i + 1). $($fonts[$i].name)"
}

$choice = Read-Host "Select font to install (1-$($fonts.Count)) or 0 to skip"

if ($choice -eq "0") {
    Write-Host "Skipped font installation" -ForegroundColor Yellow
    exit
}

if ([int]::TryParse($choice, [ref]$choice) -and $choice -ge 1 -and $choice -le $fonts.Count) {
    $selectedFont = $fonts[$choice - 1]
    
    Write-Host ""
    Write-Host "Downloading $($selectedFont.name)..." -ForegroundColor Cyan
    
    $tempDir = Join-Path $env:TEMP "nerd-fonts"
    if (-not (Test-Path $tempDir)) {
        New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
    }
    
    $zipPath = Join-Path $tempDir "$($selectedFont.name).zip"
    
    try {
        Invoke-WebRequest -Uri $selectedFont.url -OutFile $zipPath -UseBasicParsing
        Write-Host "✅ Downloaded" -ForegroundColor Green
        
        Write-Host "Extracting..." -ForegroundColor Cyan
        Expand-Archive -Path $zipPath -DestinationPath $tempDir -Force
        
        Write-Host "Installing fonts..." -ForegroundColor Cyan
        $fontFiles = Get-ChildItem "$tempDir\*.ttf"
        
        foreach ($font in $fontFiles) {
            Copy-Item $font $env:WINDIR\Fonts -Force
        }
        
        Write-Host "✅ Fonts installed successfully!" -ForegroundColor Green
        Write-Host "Please restart Windows Terminal" -ForegroundColor Yellow
    } catch {
        Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "Invalid choice" -ForegroundColor Red
}
