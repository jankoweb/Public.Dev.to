````markdown
# Rychlý navigace

## Vytvoření článku
Stiskni F5 (je nastaveno v launch.json a tasks.json).
Vytvoří se soubor `posts/YYMMDD.md`.

---

## Vkládání obsahu souborů do Markdownu (VS Code)

Pokud pracujete ve VS Code, máte dvě elegantní cesty, jak automaticky vkládat obsah souborů do Markdownu. Markdown sám o sobě příkaz ![]() pro vložení kódu nepodporuje, takže se musí použít "preprocesor".

Zde jsou nejlepší řešení pro váš workflow:

1. Řešení přes VS Code: Rozšíření "Markdown Include"
   - Nejjednodušší cesta bez programování vlastních skriptů. Nainstalujte si rozšíření (v Extensions vyhledejte "Markdown Include").

   Syntaxe: Místo `![]()` použijete:

   ```text
   :include path/to/script.ps1
   ```

   Výhoda: VS Code vám při náhledu (Preview) rovnou ukáže obsah souboru. Můžete použít existující Action, například `markdown-include-action`.

   Příklad workflow (.github/workflows/build-markdown.yml):

   ```yaml
   name: Build Markdown
   on: [push]
   jobs:
     build:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v4
         - name: Markdown Include
           uses: lokat/markdown-include-action@v1
           with:
             input_file: 'README.src.md'
             output_file: 'README.md'
         - name: Commit generated README
           run: |
             git config user.name "github-actions[bot]"
             git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
             git add README.md
             git commit -m "Build: update README.md" || echo "No changes to commit"
             git push || echo "Push skipped"
   ```

   Poznámka: Pokud máte v repozitáři jiný workflow, který publikuje (např. na dev.to), upravte ten publikační workflow tak, aby běžel po dokončení tohoto kroku. To lze dosáhnout použitím `on: workflow_run` v publikačním workflow, nebo nastavením závislosti v CI podle vaší potřeby.

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

````