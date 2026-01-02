---
title: "Automating Git Workflow in VS Code: AI Commit & Sync with One Shortcut"
published: true
tags: "vscode, productivity, AI, commit"
id: 3141639
date: "2026-01-01T20:39:08Z"
---

# Automating Git Workflow in VS Code: AI Commit & Sync with One Shortcut

Manually staging files, waiting for AI to generate a commit message, and then pushing can be tedious. While extensions like GitLens Pro offer this, you can achieve the same "one-click" workflow for free using **GitHub Copilot** and the **Macro Commander** extension.

## Prerequisites

To use this automation, ensure you have the following installed:

- **GitHub Copilot** (for AI message generation)
- **Macro Commander** (`jeff-hykin.macro-commander`)

---

## Step 1: Define the Macro in `settings.json`

Open VS Code **Settings (JSON)**: `Ctrl+Shift+P` → _Preferences: Open User Settings (JSON)_.

Add the following configuration:

```json
"macros": {
  "aiCommitSmart": [
    {
      "javascript": [
        "const sleep = (ms) => new Promise(r => setTimeout(r, ms));",
        "const gitExt = vscode.extensions.getExtension('vscode.git');",
        "if (!gitExt) { await vscode.window.showErrorMessage('Git extension not found'); return; }",
        "const api = gitExt.exports.getAPI(1);",
        "const repo = api.repositories?.[0];",
        "if (!repo) { await vscode.window.showErrorMessage('No Git repository in this window'); return; }",
        "",
        "await vscode.commands.executeCommand('git.stageAll');",
        "await vscode.commands.executeCommand('workbench.view.scm');",
        "await vscode.commands.executeCommand('github.copilot.git.generateCommitMessage');",
        "",
        "let committed = false;",
        "for (let i = 0; i < 300; i++) {",
        "  const msg = repo.inputBox.value;",
        "  if (msg && msg.trim().length > 0) {",
        "    await sleep(300);",
        "    await vscode.commands.executeCommand('scm.acceptInput');",
        "    committed = true;",
        "    break;",
        "  }",
        "  await sleep(100);",
        "}",
        "",
        "if (!committed) {",
        "  await vscode.window.showWarningMessage('AI Commit: timeout waiting for message');",
        "  return;",
        "}",
        "",
        "await sleep(500);",
        "await vscode.commands.executeCommand('git.pullRebase');",
        "await vscode.commands.executeCommand('git.push');"
      ]
    }
  ]
}
```

---

## Step 2: Map the Keyboard Shortcut

Open **Keyboard Shortcuts (JSON)**: `Ctrl+Shift+P` → _Preferences: Open Keyboard Shortcuts (JSON)_.

Add this binding:

```json
{
  "key": "ctrl+alt+g",
  "command": "macros.aiCommitSmart"
}
```

---

## Step 3: Reload VS Code

- `Ctrl+Shift+P` → **Reload Window**

---

## How It Works

Once configured, simply press **`Ctrl + Alt + G`**. VS Code will:

1. **Stage** all your current changes.
2. Open the SCM view.
3. Call **GitHub Copilot** to write a commit message based on your diff.
4. **Wait** (up to 30 seconds) for the AI to fill in the message.
5. **Commit** the changes automatically.

This setup transforms a 5-step manual process into a single, seamless action.

---

## Notes

- Works only if:
  - A Git repository is active
  - You are signed in to GitHub Copilot
- Timeout is about **30 seconds**
- Fully compatible with **Settings Sync**
