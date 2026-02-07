$ErrorActionPreference = 'Stop'
Set-Location -Path "$PSScriptRoot\.."

$posts = Get-ChildItem -Path .\posts -Filter *.md -File
foreach ($p in $posts) {
    $name = [IO.Path]::GetFileNameWithoutExtension($p.Name)
    $dir = Join-Path -Path .\posts -ChildPath $name
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
    $content = Get-Content -Raw -Path $p.FullName
    $matches = [regex]::Matches($content, '!\[[^\]]*\]\(([^)]+)\)')
    foreach ($m in $matches) {
        $link = $m.Groups[1].Value
        $file = Split-Path $link -Leaf
        $src = Join-Path -Path .\img -ChildPath $file
        if (Test-Path $src) { Move-Item -Path $src -Destination $dir -Force }
    }
    Move-Item -Path $p.FullName -Destination (Join-Path $dir $p.Name) -Force
}

$remaining = Get-ChildItem -Path .\img -File -ErrorAction SilentlyContinue
if ($remaining) {
    $dest = Join-Path -Path .\posts -ChildPath '_unassigned_images'
    if (-not (Test-Path $dest)) { New-Item -ItemType Directory -Path $dest | Out-Null }
    Move-Item -Path (Join-Path .\img '*') -Destination $dest -Force
}

if (Test-Path .\img) {
    try { Remove-Item -Path .\img -Recurse -Force -ErrorAction Stop } catch { }
}

Write-Host "Reorganization complete."
