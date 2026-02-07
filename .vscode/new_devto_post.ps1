Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$ErrorActionPreference = 'Stop'
$d = Get-Date -Format 'yyMMdd'

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Vytvoření nového DEV.to článku'
$form.ClientSize = New-Object System.Drawing.Size(560,480)
$form.StartPosition = 'CenterScreen'
$form.BackColor = [System.Drawing.Color]::FromArgb(245,245,245)
$form.Font = New-Object System.Drawing.Font('Segoe UI',10)

$descLabel = New-Object System.Windows.Forms.Label
$descLabel.Text = 'Zadejte název a obsah článku. Stačí napsat draft – po dokončení se zkopíruje do schránky Copilot prompt, který článek dodělá.'
$descLabel.Location = New-Object System.Drawing.Point(12,8)
$descLabel.Size = New-Object System.Drawing.Size(536,56)
$descLabel.AutoSize = $false
$descLabel.Font = New-Object System.Drawing.Font('Segoe UI',9)
$form.Controls.Add($descLabel)

$nameLabel = New-Object System.Windows.Forms.Label
$nameLabel.Text = 'Název článku:'
$nameLabel.Location = New-Object System.Drawing.Point(12,72)
$nameLabel.Size = New-Object System.Drawing.Size(536,18)
$nameLabel.AutoSize = $false
$nameLabel.Font = New-Object System.Drawing.Font('Segoe UI',9)
$form.Controls.Add($nameLabel)

try { $clipboard = Get-Clipboard -TextFormatType Text -Raw } catch { $clipboard = '' }
$firstLine = ''
if ($clipboard) { $firstLine = ($clipboard -split "`r?`n")[0].Trim() }

$nameTextBox = New-Object System.Windows.Forms.TextBox
$nameTextBox.Location = New-Object System.Drawing.Point(12,94)
$nameTextBox.Size = New-Object System.Drawing.Size(536,26)
$nameTextBox.Font = New-Object System.Drawing.Font('Segoe UI',9)
$nameTextBox.Text = $firstLine
$form.Controls.Add($nameTextBox)

$contentLabel = New-Object System.Windows.Forms.Label
$contentLabel.Text = 'Obsah článku (draft):'
$contentLabel.Location = New-Object System.Drawing.Point(12,130)
$contentLabel.Size = New-Object System.Drawing.Size(536,18)
$contentLabel.AutoSize = $false
$contentLabel.Font = New-Object System.Drawing.Font('Segoe UI',9)
$form.Controls.Add($contentLabel)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Multiline = $true
$textBox.ScrollBars = 'Vertical'
$textBox.Location = New-Object System.Drawing.Point(12,154)
$textBox.Size = New-Object System.Drawing.Size(536,240)
$textBox.Font = New-Object System.Drawing.Font('Segoe UI',9)
$form.Controls.Add($textBox)

function Validate-Name {
    if ([string]::IsNullOrWhiteSpace($nameTextBox.Text)) {
        [System.Windows.Forms.MessageBox]::Show('Zadejte název článku.','Chyba',[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Warning)
        return $false
    }
    return $true
}

function Get-SafeTitle {
    param([string]$title)
    # Odstranit diakritiku
    $safe = $title.Normalize([Text.NormalizationForm]::FormD) -replace '\p{M}', ''
    # Nahradit speciální znaky podtržítky
    $safe = $safe -replace '[^\w\s-]', '_'
    # Nahradit více mezer jednou
    $safe = $safe -replace '\s+', ' '
    $safe = $safe.Trim()
    return $safe
}

$okButton = New-Object System.Windows.Forms.Button
$okButton.Text = 'Vytvořit'
$okButton.Size = New-Object System.Drawing.Size(120,36)
$okButton.Font = New-Object System.Drawing.Font('Segoe UI',9,[System.Drawing.FontStyle]::Bold)
$okButton.Add_Click({
    if (-not (Validate-Name)) { return }
    $form.Tag = @{Name=$nameTextBox.Text; Content=$textBox.Text}
    $form.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.Close()
})
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Text = 'Storno'
$cancelButton.Size = New-Object System.Drawing.Size(120,36)
$cancelButton.Add_Click({ $form.DialogResult = [System.Windows.Forms.DialogResult]::Cancel; $form.Close() })
$form.Controls.Add($cancelButton)

# Calculate right-aligned button positions
$contentRight = 12 + 536
$cancelW = $cancelButton.Size.Width
$okW = $okButton.Size.Width
$spacing = 8
$cancelX = $contentRight - $cancelW
$okX = $cancelX - $spacing - $okW
$btnY = 404
$okButton.Location = New-Object System.Drawing.Point($okX,$btnY)
$cancelButton.Location = New-Object System.Drawing.Point($cancelX,$btnY)

$form.AcceptButton = $okButton
$form.CancelButton = $cancelButton

$form.ActiveControl = $nameTextBox

$result = $form.ShowDialog()
if ($result -ne [System.Windows.Forms.DialogResult]::OK) { exit 0 }

$n = ''
if ($form.Tag) { $n = $form.Tag.Name }
if ([string]::IsNullOrWhiteSpace($n)) { 
    $safeTitle = 'untitled'
    $folderName = ('{0} {1}' -f $d, $safeTitle)
    $fileName = ('{0}.md' -f $safeTitle)
} else { 
    $safeTitle = Get-SafeTitle $n
    $folderName = ('{0} {1}' -f $d, $safeTitle)
    $fileName = ('{0}.md' -f $safeTitle)
}
$dir = Join-Path $PWD 'posts'
$folderPath = Join-Path $dir $folderName
$filePath = Join-Path $folderPath $fileName

if (!(Test-Path $folderPath)) { New-Item -ItemType Directory -Path $folderPath | Out-Null }
if (!(Test-Path $filePath)) { @('---','title: ""','published: false','tags:','---','') | Set-Content -Encoding utf8 $filePath }

$articleContent = $form.Tag.Content
if ($articleContent) {
    $content = Get-Content $filePath -Raw
    $content = $content + "`n" + $articleContent
    Set-Content -Path $filePath -Value $content -Encoding utf8
}

$copilotContent = (Get-Content 'copilot.txt' -Raw) + "`nSoubor je $filePath."
$copilotContent | Set-Clipboard

[System.Windows.Forms.SendKeys]::SendWait("^%i")  # Ctrl+Alt+I pro otevření Copilot Chat
Start-Sleep -Seconds 1
[System.Windows.Forms.SendKeys]::SendWait("^v")  # Ctrl+V pro vložení
# Start-Sleep -Milliseconds 500
# [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")  # Enter pro odeslání - odstraněno, uživatel stiskne ručně

& code --reuse-window -r "$filePath"
