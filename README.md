# Rychlý navigace

## Vytvoření a publikace článku
- stiskni F5 (vytvoří `posts/YYMMDD TITLE/TITLE.md` - titulek se generuje z názvu článku, ale bezpečně; a vloží se do copilota `copilot.txt` pro rychlou editaci)
- pro vkládání obsahu souborů do Markdownu použijte syntaxi (plugin `Markdown Preview Include Files (Markus Stamminger)`):
```
:(path/to/file.ext)
```
- publikuje se automaticky z větve `publish` při změně souborů v `posts/`

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

## DEV.to API klíč

- Získat v DEV.to → Settings → Account → DEV API Keys
- Uložit jako GitHub Secret `DEVTO_API_KEY` (v Actions secret se po uložení nezobrazuje).

## FAQ
- HTTP 422: změněný title, nevalidní front-matter.
- 403: přidejte `permissions: contents: write`.

**Important: Web edits vs repository (DŮLEŽITÉ)**
- **Neprovádějte trvalé úpravy pouze v editaci na dev.to.** Pokud upravíte text přímo na webu (dev.to), tahle změna může být přepsána dalším spuštěním GitHub Actions, které nahraje obsah z repozitáře.
- V repozitáři udržujeme kód odděleně pomocí include syntaxe jako `:(path/to/code.js)` — workflow rozbalí ten kód jen v dočasné kopii pro publikaci, ale v repozitáři zůstane původní `:(...)` zápis. To znamená, že úpravy těla článku provedené přímo na webu budou ztraceny při dalším publish, pokud nejsou promítnuty do repozitáře.
- Doporučení: pokud potřebujete upravit překlepy nebo obsah trvale, upravte soubor v repozitáři (`posts/...`) a pusheujte změnu. Pokud chcete, aby úpravy na webu přežily, nejdřív syncněte repozitář s těmito změnami.
