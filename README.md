# Publikování článků na dev.to z GitHubu

Tento repozitář slouží k **automatickému publikování článků na dev.to přímo z GitHubu** pomocí Markdown souborů.

---

## Jak to funguje
- Každý článek je **Markdown soubor**
- Soubor **musí začínat dev.to front-matter**
- Po `git push`:
  - první commit → vytvoří nový článek
  - další commity → aktualizují existující
- **Smazání souboru článek nemaže** (lze jen přes UI na dev.to)

---

## Povinný front-matter
```md
---
title: Název článku
published: true
tags: vscode, windows, powershell
canonical_url:
---
```

---

## Jak psát nové články

### 1️⃣ GitHub Markdown template
V repozitáři je template:

```
.github/ISSUE_TEMPLATE/devto-post.md
```

Postup:
1. **Add file → Create new file**
2. Vyber template
3. Doplň `title`, `tags`
4. Napiš obsah
5. Commit

---

### 2️⃣ VS Code snippet
Ve VS Code napiš `devto` a rozbal snippet  
(front-matter se vloží automaticky)

Snippet je uložen v:
```
.vscode/devto.code-snippets
```

---

## Propojení repozitáře s dev.to
1. dev.to → **Settings → Extensions**
2. Propoj GitHub účet
3. Povol tento repozitář

Dokumentace:  
https://dev.to/publishing-from-github

---

## Poznámky
- Repo může být **public i private**
- Úprava Markdown souboru = aktualizace článku
- Publikování je **jednosměrné (GitHub → dev.to)**

Autor:  
https://dev.to/jankoweb
