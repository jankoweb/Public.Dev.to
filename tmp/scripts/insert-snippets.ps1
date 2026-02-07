param(
    [string]$PostsDir = "posts",
    [string]$SnippetsDir = "scripts",
    [switch]$Backup
)

$pattern = '<!--\s*include:(?<path>[^\s>]+)(?:\s+lang=(?<lang>[^\s>]+))?\s*-->'

Get-ChildItem -Path $PostsDir -Filter *.md | ForEach-Object {
    $file = $_
    $content = Get-Content -Raw -Encoding UTF8 -Path $file.FullName
    $matches = [regex]::Matches($content, $pattern)
    if ($matches.Count -eq 0) { return }

    foreach ($m in $matches) {
        $rel = $m.Groups['path'].Value
        $lang = $m.Groups['lang'].Value
        $snippetPath = if ([IO.Path]::IsPathRooted($rel)) { $rel } else { Join-Path $SnippetsDir $rel }
        if (-not (Test-Path $snippetPath)) {
            Write-Warning "Snippet not found: $snippetPath (in $($file.Name))"
            continue
        }
        $code = Get-Content -Raw -Encoding UTF8 -Path $snippetPath
        if (-not $lang) {
            switch ([IO.Path]::GetExtension($snippetPath).ToLower()) {
                '.ps1' { $lang = 'powershell' }
                '.sh'  { $lang = 'bash' }
                '.js'  { $lang = 'javascript' }
                '.ts'  { $lang = 'typescript' }
                '.py'  { $lang = 'python' }
                '.json'{ $lang = 'json' }
                '.html'{ $lang = 'html' }
                '.css' { $lang = 'css' }
                default { $lang = 'text' }
            }
        }
        $replacement = "```$lang`r`n$($code.TrimEnd())`r`n```"
        $content = $content.Replace($m.Value, $replacement)
    }

    if ($Backup) { Copy-Item -Path $file.FullName -Destination "$($file.FullName).bak" -Force }
    Set-Content -Path $file.FullName -Value $content -Encoding UTF8
    Write-Host "Updated: $($file.Name)"
}
