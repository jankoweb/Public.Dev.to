---
title: 'Peacock: Visual Studio Code workspace color with a keybinding'
published: true
tags: vscode,peacock,keybindings,productivity
---

Peacock lets you change the color of your Visual Studio Code workspace so you can visually distinguish projects or contexts.

This short snippet binds a keyboard shortcut to open Peacock's color picker. Requirements: install the Peacock extension.

Add the following entry to your Keyboard Shortcuts JSON (`Preferences: Open Keyboard Shortcuts (JSON)`) to bind `Ctrl+Shift+F1` to Peacock's color picker:

```json
{
  "key": "ctrl+shift+f1",
  "command": "peacock.enterColor"
}
```

That's it — press `Ctrl+Shift+F1` to quickly pick a workspace color.
