# Publikování článků na dev.to z GitHubu

Tento repozitář slouží k **automatickému publikování článků na dev.to** pomocí **GitHub Actions** a **DEV Community API (beta)**.

Repo používá **oddělenou větev `publish`**, aby bylo možné v `main` psát a upravovat obsah bez rizika publikace.

---

## Základní princip

- `main` → psaní, drafty, experimenty
- `publish` → **jediná větev, ze které se publikuje**
- Publikace proběhne **jen při pushi do `publish`**

---

## Jak to funguje

- Každý článek je **Markdown soubor**
- Soubor **musí začínat dev.to front-matter**
- Po `git push` do větve `publish`:
  - první push → vytvoří nový článek
  - další push → aktualizuje existující
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

Minimum:
- `title`
- `published: true | false`

---

## Jak psát nové články

### 1️⃣ GitHub Markdown template
V repozitáři je připraven template:

```
.github/ISSUE_TEMPLATE/devto-post.md
```

Postup:
1. **Add file → Create new file**
2. Vyber template
3. Doplň `title`, `tags`
4. Napiš obsah
5. Commitni do `main`

---

### 2️⃣ VS Code snippet
Ve VS Code napiš `devto` a rozbal snippet  
(front-matter se vloží automaticky)

Snippet je uložen v:
```
.vscode/devto.code-snippets
```

---

## Publikace článků

```bash
git checkout publish
git merge main
git push
```

Tím se spustí GitHub Action a články se publikují / aktualizují na dev.to.

---

## GitHub Action

Workflow je uložen v:
```
.github/workflows/devto.yml
```

Publikuje pouze:
- větev `publish`
- soubory `posts/**/*.md`

---

## Požadavky

### DEV.to
- vygenerovaný **DEV Community API Key (beta)**  
  https://developers.forem.com/api

### GitHub
- secret `DEVTO_API_KEY` uložený v repo settings

---

## Poznámky

- Repo může být **public i private**
- Publikování je **jednosměrné (GitHub → dev.to)**
- DEV API je **beta**

---

Autor:  
https://dev.to/jankoweb
