---
title: "Automating Git Workflow in VS Code: AI Commit & Sync with One Shortcut"
published: true
tags: vscode, productivity, AI, commit
---

# Automating Git Workflow in VS Code: AI Commit & Sync with One Shortcut

Manually staging files, waiting for AI to generate a commit message, and then pushing can be tedious. While extensions like GitLens Pro offer this, you can achieve the same "one-click" workflow for free using **GitHub Copilot** and the **Multi-command** extension.

## Prerequisites

To use this automation, ensure you have the following installed:
* **GitHub Copilot** (for AI message generation)
* **Multi-command** (by ryuta46)

---

## Step 1: Define the Command Sequence

We need to chain the commands with a specific delay to allow the AI enough time to generate the message before the commit command fires.

1. Open VS Code **Settings (JSON)**: `Ctrl+Shift+P` -> *Preferences: Open User Settings (JSON)*.
2. Add the following configuration to your settings:

```json
"multiCommand.commands": [
    {
        "command": "multiCommand.aiCommitFlow",
        "sequence": [
            "git.stageAll",
            "github.copilot.git.generateCommitMessage",
            {
                "command": "extension.multiCommand.execute",
                "args": { "interval": 5000 } 
            },
            "git.commitStaged"
        ]
    }
]

```

> **Note:** The `interval: 5000` (5 seconds) is a safety buffer for the AI. You can decrease it to `3000` if your Copilot responds faster.

---

## Step 2: Map the Keyboard Shortcut

Now, bind this sequence to a single hotkey.

1. Open **Keyboard Shortcuts (JSON)**: `Ctrl+Shift+P` -> *Preferences: Open Keyboard Shortcuts (JSON)*.
2. Add this binding:

```json
{
    "key": "ctrl+alt+g",
    "command": "multiCommand.aiCommitFlow",
    "when": "config.git.enabled"
}

```

---

## Step 3: Streamline the UI (Optional but Recommended)

To ensure the process runs without interruptions (pop-up dialogs), adjust these settings in VS Code (`Ctrl+,`):

* **Git: Confirm No Stage Confirmation**: Disable (uncheck) to skip the "Do you want to stage all files?" prompt.
* **Git: Confirm Sync**: Disable (uncheck) to skip the confirmation when pushing to the remote.

---

## How It Works

Once configured, simply press **`Ctrl + Alt + G`**. VS Code will:

1. **Stage** all your current changes.
2. Call **GitHub Copilot** to write a commit message based on your diff.
3. **Wait** for 5 seconds to ensure the text is populated.
4. **Commit** the changes.

This setup transforms a 5-step manual process into a single, seamless action.