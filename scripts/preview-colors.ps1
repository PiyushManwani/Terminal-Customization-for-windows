<#
.SYNOPSIS
Preview ANSI colors in terminal
#>

Write-Host "================================" -ForegroundColor Cyan
Write-Host "     ANSI Color Preview" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Standard colors
Write-Host "Standard Colors:" -ForegroundColor Cyan
@(
    @("Black", "Black"),
    @("Red", "Red"),
    @("Green", "Green"),
    @("Yellow", "Yellow"),
    @("Blue", "Blue"),
    @("Magenta", "Magenta"),
    @("Cyan", "Cyan"),
    @("White", "White")
) | ForEach-Object {
    Write-Host ("  $($_[0])").PadRight(15) -ForegroundColor $_[1] -NoNewline
    Write-Host " ████████" -ForegroundColor $_[1]
}

Write-Host ""
Write-Host "Bright Colors:" -ForegroundColor Cyan
@(
    @("Bright Black", "Gray"),
    @("Bright Red", "Red"),
    @("Bright Green", "Green"),
    @("Bright Yellow", "Yellow"),
    @("Bright Blue", "Blue"),
    @("Bright Magenta", "Magenta"),
    @("Bright Cyan", "Cyan"),
    @("Bright White", "White")
) | ForEach-Object {
    Write-Host ("  $($_[0])").PadRight(20) -ForegroundColor $_[1] -NoNewline
    Write-Host " ████████" -ForegroundColor $_[1]
}

Write-Host ""
