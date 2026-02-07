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

  Moje volba (vložené snippety v náhledu):
  - Pro vkládání snippetů kódu přímo do náhledu ve VS Code používám rozšíření "Markdown Preview Include Files" od Markuse Stammingera. Nainstalujte jej z Extensions (hledejte "Markdown Preview Include Files").
  - Poznámka: toto rozšíření vkládá obsah do VS Code náhledu; pokud potřebujete generovat finální `README.md` v CI (GitHub Actions), použijte stále preprocesor (např. `markdown-include-action`) nebo jiný build krok, protože preview-rozšíření neprovede změny v repozitáři.


# DEV.to publishing via GitHub Actions

Publikace a **aktualizace článků na dev.to** z Markdown souborů v GitHub repozitáři  
pomocí GitHub Actions (`sinedied/publish-devto@v2`).
- GitHub → Settings → Secrets → Actions
- secret: `DEVTO_API_KEY`

# Rychlý návod

- Vytvoření článku: stiskni F5 (vytvoří `posts/YYMMDD.md`).

---

## Vkládání obsahu do Markdownu (stručně)

- VS Code (náhled): nainstalujte "Markdown Preview Include Files" (Markus Stamminger) — umožní vkládat soubory do editorového náhledu.
- CI / generování souborů: použijte preprocesor (např. lokat/markdown-include-action) — generuje konečný `README.md` v CI.

Poznámka: preview-rozšíření upraví pouze náhled ve VS Code; pro trvalé změny v repozitáři generujte soubory přes CI.

---

## Publikace na DEV.to (GitHub Actions)

Používáme akci `sinedied/publish-devto@v2` pro upload/update článků z `posts/**/*.md`.

Příklad (základ):

```yaml
uses: sinedied/publish-devto@v2
with:
  devto_key: ${{ secrets.DEVTO_API_KEY }}
  files: posts/**/*.md
  branch: main
  dry_run: false
```

---

## Front‑matter (požadavky)

```yaml
---
title: "Nadpis"
published: true
tags: [tag1, tag2]
---
```

- `title` slouží jako identifikátor článku — neměňte ho při updatu.
- max 4 tagy, žádné prázdné klíče (např. odstraňte `canonical_url:` pokud je prázdné).

---

## DEV.to API klíč

- Získat v DEV.to → Settings → Account → DEV API Keys
- Uložit jako GitHub Secret `DEVTO_API_KEY` (v Actions secret se po uložení nezobrazuje).

---

## Krátké FAQ

- HTTP 422: obvykle změněný `title`, nevalidní front‑matter nebo smazaný článek na dev.to.
- 403 (github-actions[bot]): přidejte `permissions: contents: write` do workflow.

---

Ověřeno: publish i update fungují s touto konfigurací.
  publish:
