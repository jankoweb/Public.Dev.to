---
title: "Creating a Reliable VS Code Task for New DEV.to Posts (Windows + PowerShell)"
published: true
tags: 'vscode, productivity, shortcut, dev.to'
---
 
This article documents a **verified, working setup** for creating a new DEV.to Markdown post using **VS Code Tasks** on **Windows** with **PowerShell (pwsh)**.

The solution avoids all common pitfalls with quoting, spaces, and input handling.

---

## Problem Summary

When using `tasks.json` with:

- `type: "shell"`
- inline PowerShell via `-Command`
- `${input:...}` directly embedded in the script

VS Code expands inputs **without shell escaping**.  
If the input contains spaces, the PowerShell parser breaks, producing errors such as:

- `Missing statement block after if`
- `Unexpected token`
- broken array literals like `@(---,title:,...)`

---

## Key Principles (from VS Code documentation)

1. **Do not interpolate `${input:...}` directly into PowerShell code**
2. **Use `type: "process"`**, not `shell`
3. **Pass user input via environment variables**
4. Let PowerShell read input from `$env:VAR_NAME`

This is the only robust and documented-safe approach on Windows.

---

## Final Working `tasks.json`

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "New DEV.to post (today)",
      "type": "process",
      "command": "pwsh",
      "args": [
        "-NoProfile",
        "-Command",
        "$ErrorActionPreference='Stop'; $d=Get-Date -Format 'yyMMdd'; $n=$env:POST_NAME; if ([string]::IsNullOrWhiteSpace($n)) { $fname=('{0}.md' -f $d) } else { $fname=('{0} {1}.md' -f $d, $n) }; $dir=Join-Path $PWD 'posts'; if (!(Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }; $f=Join-Path $dir $fname; if (!(Test-Path $f)) { @('---','title: ""','published: false','tags:','---','') | Set-Content -Encoding utf8 $f }; code -r $f"
      ],
      "options": {
        "cwd": "${workspaceFolder}",
        "env": {
          "POST_NAME": "${input:postName}"
        }
      },
      "group": "build",
      "problemMatcher": []
    }
  ],
  "inputs": [
    {
      "id": "postName",
      "type": "promptString",
      "description": "Enter post name (optional):",
      "default": ""
    }
  ]
}
```

---

## What This Task Does

- Prompts for an optional post name
- Creates a file:
  - `yyMMdd.md` (no name)
  - `yyMMdd Post Name.md` (with name)
- Ensures the `posts/` directory exists
- Writes DEV.to front‑matter if the file does not exist
- Opens the file in VS Code

---

## Why This Works

- `type: "process"` bypasses shell re-parsing
- Environment variables preserve spaces safely
- PowerShell receives clean, valid syntax every time

This pattern is **stable, reproducible, and production‑safe**.

---

## Recommended Extensions

- Slugify file names
- Auto-fill `title:` from file name
- Auto-set `published: true` for drafts vs posts

---

## Conclusion

If you are using **VS Code + PowerShell on Windows**, this is the **correct and verified** way to handle user input in `tasks.json`.

Anything else will eventually break.
