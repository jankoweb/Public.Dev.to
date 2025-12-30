---
title: VS Code Terminal Shell Integration (Windows)
published: true
tags: 'vscode, windows, AI'
id: 3134583
date: '2025-12-30T00:19:11Z'
---

To avoid “The terminal is awaiting input” and similar prompts, VS Code needs Terminal Shell Integration enabled and a supported shell.


**Problem:**
If you see “The terminal is awaiting input” or similar prompts, VS Code needs Terminal Shell Integration enabled and a supported shell.

**Required VS Code settings (`settings.json`):**

```json
{
	"terminal.integrated.shellIntegration.enabled": true,
	"terminal.integrated.defaultProfile.windows": "PowerShell 7",
	"terminal.integrated.profiles.windows": {
		"PowerShell 7": {
			"path": "C:\\Program Files\\PowerShell\\7\\pwsh.exe"
		}
	}
}
```

**After changing settings:**
- Close all terminals
- Reload VS Code window

**Still seeing the message?**
You are likely using **Windows PowerShell 5.1**, which has unreliable shell integration.

**Fix (one-time per machine):**
- Install PowerShell 7:
	- [Microsoft Docs](https://learn.microsoft.com/powershell)
	- Or run:
		```powershell
		winget install Microsoft.PowerShell
		```

**PowerShell 7** fully supports VS Code terminal integration and resolves command/input detection issues.
