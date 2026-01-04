Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$ErrorActionPreference = 'Stop'
$d = Get-Date -Format 'yyMMdd'

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Vytvoření nového DEV.to článku'
$form.ClientSize = New-Object System.Drawing.Size(560,460)
$form.StartPosition = 'CenterScreen'

$descLabel = New-Object System.Windows.Forms.Label
$descLabel.Text = 'Zadejte název a obsah článku. Klikněte na "Zkopírovat Copilot pokyny" pro zkopírování instrukcí do schránky, pak otevřete Copilot chat a vložte je.'
$descLabel.Location = New-Object System.Drawing.Point(12,8)
$descLabel.Size = New-Object System.Drawing.Size(536,56)
$descLabel.AutoSize = $false
$descLabel.Font = New-Object System.Drawing.Font('Segoe UI',9)
$form.Controls.Add($descLabel)

$nameLabel = New-Object System.Windows.Forms.Label
$nameLabel.Text = 'Název článku:'
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
$textBox.Size = New-Object System.Drawing.Size(536,220)
$textBox.Font = New-Object System.Drawing.Font('Segoe UI',9)
$form.Controls.Add($textBox)

function Validate-Name {
    if ([string]::IsNullOrWhiteSpace($nameTextBox.Text)) {
        [System.Windows.Forms.MessageBox]::Show('Zadejte název článku.','Chyba',[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Warning)
        return $false
    }
    return $true
}

$copyButton = New-Object System.Windows.Forms.Button
$copyButton.Text = 'Vytvořit a zkopírovat do schránky Copilot pokyny'
$copyButton.Size = New-Object System.Drawing.Size(196,36)
$copyButton.BackColor = [System.Drawing.Color]::FromArgb(46,204,113)
$copyButton.ForeColor = [System.Drawing.Color]::White
$copyButton.Font = New-Object System.Drawing.Font('Segoe UI',9,[System.Drawing.FontStyle]::Bold)
$copyButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$copyButton.FlatAppearance.BorderSize = 0
$copyButton.Add_Click({
    if (-not (Validate-Name)) { return }
    $copilotContent = (Get-Content 'copilot.txt' -Raw)
    $copilotContent | Set-Clipboard
    $form.Tag = @{Name=$nameTextBox.Text; Content=$textBox.Text}
    $form.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.Close()
})
$form.Controls.Add($copyButton)

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

# Set default action to the green copy button so Enter triggers copy+create
# Calculate right-aligned button positions and set defaults
$contentRight = 12 + 536
$cancelW = $cancelButton.Size.Width
$okW = $okButton.Size.Width
$copyW = $copyButton.Size.Width
$spacing = 8
$cancelX = $contentRight - $cancelW
$okX = $cancelX - $spacing - $okW
$copyX = $okX - $spacing - $copyW
$btnY = 400
$copyButton.Location = New-Object System.Drawing.Point($copyX,$btnY)
$okButton.Location = New-Object System.Drawing.Point($okX,$btnY)
$cancelButton.Location = New-Object System.Drawing.Point($cancelX,$btnY)

# Set default action to the green copy button so Enter triggers copy+create
$form.AcceptButton = $copyButton
$form.CancelButton = $cancelButton

# Focus the copy button by default
$form.ActiveControl = $copyButton

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
