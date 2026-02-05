---
title: "How to Fix GitHub Copilot Terminal Integration in VS Code"
published: true
tags: vscode,copilot,terminal,integration
---


If your GitHub Copilot Chat is failing to send commands to the terminal or constantly asking for permission, follow these steps to fix your `settings.json`. 

## 1. Enable Shell Integration
Copilot cannot interact with the terminal without this.

**Change in settings.json:**
"terminal.integrated.shellIntegration.enabled": true

## 2. Relocate Chat for Stability
Running Chat in the terminal panel often causes focus issues. Use the Sidebar instead.

**Change in settings.json:**
"github.copilot.chat.terminalChatLocation": "chatView"

## Summary for settings.json
{
  "terminal.integrated.shellIntegration.enabled": true,
  "github.copilot.chat.terminalChatLocation": "chatView",
}
