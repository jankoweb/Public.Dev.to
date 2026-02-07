# Rychlý navigace

## Vytvoření a publikace článku
- stiskni F5 (vytvoří `posts/YYMMDD TITLE/TITLE.md` - titulek se generuje z názvu článku, ale bezpečně; a vloží se do copilota `copilot.txt` pro rychlou editaci)
- pro vkládání obsahu souborů do Markdownu použijte syntaxi (plugin `Markdown Preview Include Files (Markus Stamminger)`):
```
:(path/to/file.ext)
```
- publikuje se automaticky z větve `publish` při změně souborů v `posts/`
- po publikaci se do front-matter automaticky přidá `id`, `date` a `url`

## Automatizace
Workflow automaticky:
- ✅ **Publikuje nové články** na DEV.to
- ✅ **Zpracovává `:(path/file.ext)` syntaxi** - vkládá obsah souborů jako kódové bloky
- ✅ **Aktualizuje články** když je změníte
- ✅ **Zapisuje id, date, url** do front-matter po publikaci
- ✅ **Odstraňuje články z DEV.to** když je smažete z repozitáře

## Ruční psaní
Front-matter:
```yaml
---
title: "Nadpis"
published: true
tags: [tag1, tag2]
---
```
- `title` je identifikátor, neměňte při updatu.
- Max 4 tagy.
- `id`, `date`, `url` se přidávají automaticky po první publikaci.

## DEV.to API klíč

- Získat v DEV.to → Settings → Account → DEV API Keys
- Uložit jako GitHub Secret `DEVTO_API_KEY` (v Actions secret se po uložení nezobrazuje).

## FAQ
- HTTP 422: změněný title, nevalidní front-matter.
- 403: přidejte `permissions: contents: write`.
- Článek se nesmazal z DEV.to: musí mít `id` ve front-matter před smazáním.
