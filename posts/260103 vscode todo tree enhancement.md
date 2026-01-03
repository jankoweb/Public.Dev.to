---
title: "Enhancing Todo Tree in VS Code"
published: true
tags: vscode, todo-tree, productivity
---

Todo Tree collects inline TODO/FIXME-style comments from your code and shows them in a compact tree view in VS Code. Below is a concise explanation of useful settings and why they help.

- Group items in the tree (`todo-tree.tree.grouped`) to organise by file or tag for faster navigation.
- Enable grouping buttons (`todo-tree.tree.buttons.groupByTag`, `groupBySubTag`) to quickly switch views.
- Define a clear set of tags in `todo-tree.general.tags` (e.g. `TODO`, `FIXME`, `[ ]`, `@urgent`) so filtering is predictable.
- Use `todo-tree.highlights.customHighlight` to colour-code priorities or owners, making high-priority items stand out.
- Adjust the `todo-tree.regex.regex` to match your comment styles across languages (line comments, block comments, markdown lists, etc.).
- Limit scope by excluding large folders or node_modules so the tree stays relevant and responsive.

Example `settings.json` snippets (adapt to your preferences):

```
"todo-tree.tree.grouped": true,
"todo-tree.tree.buttons.groupByTag": true,
"todo-tree.tree.buttons.groupBySubTag": true,
"todo-tree.general.tags": ["[ ]","[/]","@jankoweb","TODO","FIXME","@1","@2","@3","@4"],
"todo-tree.regex.regex": "(?:^\\s*(?:-|\\d+[.)]|;|\\*+)|//|#|<!--|/\\*\\*?)\\s+($TAGS)",
"todo-tree.tree.labelFormat": "${afterOrBefore}",
"todo-tree.highlights.customHighlight": {
  "[ ]": { "foreground": "green" },
  "[/]": { "foreground": "yellow" },
  "[x]": { "foreground": "silver" },
  "@jankoweb": { "foreground": "magenta" },
  "TODO": { "foreground": "green" },
  "FIXME": { "foreground": "lime" },
  "@1": { "foreground": "red"},
  "@2": { "foreground": "orange"},
  "@3": { "foreground": "yellow"},
  "@4": { "foreground": "blue"}
},
"todo-tree.highlights.defaultHighlight": { "type": "whole-line" }
```

Workflow tips: keep tag names short and consistent, include owner prefixes when helpful, and combine Todo Tree with your issue tracker for lifecycle management. The result is faster code navigation and clearer visibility into outstanding work.

![Result](../img/2026-01-03%2023_22_44-Greenshot.png)