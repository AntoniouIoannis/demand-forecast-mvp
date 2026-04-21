$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $repoRoot

$py312 = "C:\Users\$env:USERNAME\AppData\Local\Programs\Python\Python312\python.exe"
if (-not (Test-Path $py312)) {
    throw "Python 3.12 not found at $py312. Install Python 3.12 first."
}

if (Test-Path ".venv") {
    Rename-Item -Path ".venv" -NewName (".venv-backup-" + (Get-Date -Format "yyyyMMddHHmmss"))
}

& $py312 -m venv .venv
& .\.venv\Scripts\python.exe -m pip install --upgrade pip
& .\.venv\Scripts\python.exe -m pip install -r requirements.txt
& .\.venv\Scripts\python.exe -V
Write-Host "Local environment ready on Python 3.12."
