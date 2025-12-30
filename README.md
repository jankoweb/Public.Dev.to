# Rychlý navigace

## Vytvoření článku
1. Otevři projekt ve VS Code  
2. `Ctrl+Shift+P`
3. **Run Task
4. New DEV.to post (today)
Vytvoří se soubor `posts/YYMMDD.md`.

---

# DEV.to publishing via GitHub Actions

Publikace a **aktualizace článků na dev.to** z Markdown souborů v GitHub repozitáři  
pomocí GitHub Actions (`sinedied/publish-devto@v2`).

Cíl:
- psát články lokálně v Markdownu
- verzovat je v GitHubu
- **automaticky publikovat a aktualizovat** na dev.to

---

## 1️⃣ Struktura repozitáře

```
.
├─ posts/
│  └─ test.md
└─ .github/
   └─ workflows/
      └─ publish-devto.yml
```

Každý `.md` soubor = **1 článek**.

---

## 2️⃣ Front-matter článku (POVINNÉ)

```md
---
title: "Test"
published: true
tags: test
---

Obsah článku…
```

### Pravidla
- `title` = identifikátor článku → **neměnit**, pokud chceš update
- max **4 tagy**
- žádné prázdné hodnoty

❌ ŠPATNĚ
```yaml
canonical_url:
```

✅ SPRÁVNĚ
- klíč vůbec neuvádět

---

## 3️⃣ GitHub Actions workflow

`.github/workflows/publish-devto.yml`

```yaml
name: Publish to dev.to

on:
  push:
    branches: [ main ]

permissions:
  contents: write

jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: sinedied/publish-devto@v2
        with:
          devto_key: ${{ secrets.DEVTO_API_KEY }}
          files: posts/**/*.md
          branch: main
          dry_run: false
```

---

## 4️⃣ DEV.to API key

- DEV.to → Settings → Account → DEV API Keys
- GitHub → Settings → Secrets → Actions
- secret: `DEVTO_API_KEY`

Pole je po uložení při editaci **vždy prázdné** – je to normální.

---

## 5️⃣ Aktualizace článků

- mapování podle `title`
- shoda → UPDATE
- neshoda → CREATE

Neměnit:
- `title`
- nemaž článek ručně na dev.to

---

## FAQ

### Warning: Can't add secret mask for empty string
Příčina: prázdný `canonical_url`.  
Řešení: klíč **odstranit celý**.

### HTTP 422
- změněný `title`
- smazaný článek na dev.to
- nevalidní front-matter

### 403 github-actions[bot]
Chybí write permissions:
```yaml
permissions:
  contents: write
```

---

Ověřeno v praxi: update i publish funguje.
