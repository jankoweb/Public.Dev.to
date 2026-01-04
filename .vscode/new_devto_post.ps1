Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$ErrorActionPreference = 'Stop'
$d = Get-Date -Format 'yyMMdd'

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Vytvoření nového DEV.to článku'
$form.ClientSize = New-Object System.Drawing.Size(560,520)
$form.StartPosition = 'CenterScreen'

$descLabel = New-Object System.Windows.Forms.Label
$descLabel.Text = 'Zadejte název a obsah článku. Klikněte na "Zkopírovat Copilot pokyny" pro zkopírování instrukcí do schránky, pak otevřete Copilot chat a vložte je.'
$descLabel.Location = New-Object System.Drawing.Point(12,8)
$descLabel.Size = New-Object System.Drawing.Size(536,70)
$descLabel.AutoSize = $false
$descLabel.Font = New-Object System.Drawing.Font('Segoe UI',9)
$form.Controls.Add($descLabel)

$nameLabel = New-Object System.Windows.Forms.Label
$nameLabel.Text = 'Název článku (volitelné):'
$nameLabel.Location = New-Object System.Drawing.Point(12,88)
$nameLabel.Size = New-Object System.Drawing.Size(536,18)
$nameLabel.AutoSize = $false
$nameLabel.Font = New-Object System.Drawing.Font('Segoe UI',9)
$form.Controls.Add($nameLabel)

try { $clipboard = Get-Clipboard -TextFormatType Text -Raw } catch { $clipboard = '' }
$firstLine = ''
if ($clipboard) { $firstLine = ($clipboard -split "`r?`n")[0].Trim() }

$nameTextBox = New-Object System.Windows.Forms.TextBox
$nameTextBox.Location = New-Object System.Drawing.Point(12,110)
$nameTextBox.Size = New-Object System.Drawing.Size(536,26)
$nameTextBox.Font = New-Object System.Drawing.Font('Segoe UI',9)
$nameTextBox.Text = $firstLine
$form.Controls.Add($nameTextBox)

$contentLabel = New-Object System.Windows.Forms.Label
$contentLabel.Text = 'Obsah článku:'
$contentLabel.Location = New-Object System.Drawing.Point(12,146)
$contentLabel.Size = New-Object System.Drawing.Size(536,18)
$contentLabel.AutoSize = $false
$contentLabel.Font = New-Object System.Drawing.Font('Segoe UI',9)
$form.Controls.Add($contentLabel)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Multiline = $true
$textBox.ScrollBars = 'Vertical'
$textBox.Location = New-Object System.Drawing.Point(12,170)
$textBox.Size = New-Object System.Drawing.Size(536,260)
$textBox.Font = New-Object System.Drawing.Font('Segoe UI',9)
$form.Controls.Add($textBox)

$button = New-Object System.Windows.Forms.Button
$button.Text = 'Zkopírovat Copilot pokyny'
$button.Location = New-Object System.Drawing.Point(12,440)
$button.Size = New-Object System.Drawing.Size(240,30)
$button.Add_Click({
    $copilotContent = (Get-Content 'copilot.txt' -Raw)
    $copilotContent | Set-Clipboard
    $button.BackColor = [System.Drawing.Color]::LightGray
})
$form.Controls.Add($button)

$okButton = New-Object System.Windows.Forms.Button
$okButton.Text = 'Vytvořit'
$okButton.Location = New-Object System.Drawing.Point(264,440)
$okButton.Size = New-Object System.Drawing.Size(120,30)
$okButton.Add_Click({ $form.Tag = @{Name=$nameTextBox.Text; Content=$textBox.Text}; $form.DialogResult = [System.Windows.Forms.DialogResult]::OK; $form.Close() })
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Text = 'Storno'
$cancelButton.Location = New-Object System.Drawing.Point(392,440)
$cancelButton.Size = New-Object System.Drawing.Size(156,30)
$cancelButton.Add_Click({ $form.DialogResult = [System.Windows.Forms.DialogResult]::Cancel; $form.Close() })
$form.Controls.Add($cancelButton)

$form.AcceptButton = $okButton
$form.CancelButton = $cancelButton

$result = $form.ShowDialog()
if ($result -ne [System.Windows.Forms.DialogResult]::OK) { exit 0 }

$n = ''
if ($form.Tag) { $n = $form.Tag.Name }
if ([string]::IsNullOrWhiteSpace($n)) { $fname=('{0}.md' -f $d) } else { $fname=('{0} {1}.md' -f $d, $n) }
$dir = Join-Path $PWD 'posts'
$f = Join-Path $dir $fname

if (!(Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
if (!(Test-Path $f)) { @('---','title: ""','published: false','tags:','---','') | Set-Content -Encoding utf8 $f }

$articleContent = $form.Tag.Content
if ($articleContent) {
    $content = Get-Content $f -Raw
    $content = $content + "`n" + $articleContent
    Set-Content -Path $f -Value $content -Encoding utf8
}

& code --reuse-window -r "$f"
