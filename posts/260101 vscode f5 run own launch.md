---
title: Creating a Reliable VS Code Task for New DEV.to Posts (Windows + PowerShell)
published: true
tags: 'vscode, productivity, shortcut, devto'
id: 3146726
date: '2026-01-03T23:09:03Z'
---
 
This article provides a **verified setup** for creating new DEV.to posts using **VS Code Tasks** on **Windows** with **PowerShell**.

It avoids common issues with input handling and quoting.

---

## Problem

Using `tasks.json` with `type: "shell"`, inline PowerShell, and `${input:...}` directly in scripts causes VS Code to expand inputs without escaping. Spaces in input break PowerShell parsing, leading to errors like "Missing statement block" or broken arrays.

## Launch Configuration

To run the task with F5 without debug UI:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Run Task",
      "type": "node",
      "request": "launch",
      "program": "echo",
      "args": ["Task completed"],
      "preLaunchTask": "New DEV.to post (today)",
      "noDebug": true,
      "console": "internalConsole",
      "internalConsoleOptions": "neverOpen"
    }
  ]
}
```

## Key Principles

1. Avoid interpolating `${input:...}` directly into PowerShell.
2. Use `type: "process"`, not `shell`.
3. Pass input via environment variables (`$env:VAR_NAME`).

This is the robust approach for Windows.

---
 
## Working `tasks.json`
 
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

## Task Behavior

- Prompts for optional post name.
- Creates file: `yyMMdd.md` or `yyMMdd Name.md`.
- Ensures `posts/` directory exists.
- Adds DEV.to front-matter if new.
- Opens file in VS Code.

---

## Why It Works

- `type: "process"` avoids shell re-parsing.
- Environment variables handle spaces safely.
- PowerShell gets valid syntax.

Stable and safe for production.

---

## Recommendations

- Use extensions for slugifying filenames.
- Auto-fill title from filename.
- Set `published: true` for posts.

---

## Conclusion

For **VS Code + PowerShell on Windows**, this is the correct way to handle inputs in `tasks.json`. Other methods will break.
