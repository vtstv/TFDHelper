# TFD Helper - Build Script
# Compiles TFDHelper.ahk to TFDHelper.exe with icon

Write-Host "TFD Helper - Build Script" -ForegroundColor Cyan
Write-Host "=========================" -ForegroundColor Cyan
Write-Host ""

# Check if AutoHotkey v2 compiler exists
$ahkCompiler = "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe"

if (-not (Test-Path $ahkCompiler)) {
    Write-Host "ERROR: AutoHotkey v2 compiler not found at:" -ForegroundColor Red
    Write-Host $ahkCompiler -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install AutoHotkey v2 from: https://www.autohotkey.com/v2/" -ForegroundColor Yellow
    pause
    exit 1
}

# Paths
$scriptDir = $PSScriptRoot
$sourceFile = Join-Path $scriptDir "TFDHelper.ahk"
$iconFile = Join-Path $scriptDir "src\tfdhelper.ico"
$outputFile = Join-Path $scriptDir "TFDHelper.exe"

# Check if source file exists
if (-not (Test-Path $sourceFile)) {
    Write-Host "ERROR: Source file not found:" -ForegroundColor Red
    Write-Host $sourceFile -ForegroundColor Red
    pause
    exit 1
}

# Check if icon file exists
if (-not (Test-Path $iconFile)) {
    Write-Host "WARNING: Icon file not found:" -ForegroundColor Yellow
    Write-Host $iconFile -ForegroundColor Yellow
    Write-Host "Compiling without custom icon..." -ForegroundColor Yellow
    $iconArg = ""
} else {
    Write-Host "Using icon: $iconFile" -ForegroundColor Green
    $iconArg = "/icon `"$iconFile`""
}

# Compile
Write-Host ""
Write-Host "Compiling TFDHelper..." -ForegroundColor Cyan

if ($iconArg) {
    & $ahkCompiler /in "$sourceFile" /out "$outputFile" /icon "$iconFile"
} else {
    & $ahkCompiler /in "$sourceFile" /out "$outputFile"
}

# Wait for compilation to complete
Start-Sleep -Seconds 2

if (Test-Path $outputFile) {
    Write-Host ""
    Write-Host "SUCCESS! Compiled to:" -ForegroundColor Green
    Write-Host $outputFile -ForegroundColor Green
    Write-Host ""
    $fileSize = [math]::Round((Get-Item $outputFile).Length / 1KB, 2)
    Write-Host "File size: $fileSize KB" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "ERROR: Compilation failed!" -ForegroundColor Red
    pause
    exit 1
}

Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
