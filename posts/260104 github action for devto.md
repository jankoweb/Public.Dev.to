---
title: "Automating DEV.to Publishing with GitHub Actions"
published: true
tags: github,actions,devto,automation
---

GitHub Actions can automate publishing your markdown articles to DEV.to whenever you push changes to your repository.

## What You Need

1. A GitHub repository with your articles in a `posts/` folder (markdown files with front matter).
2. DEV.to API key stored as a GitHub secret named `DEVTO_API_KEY`.
3. The workflow file (`.github/workflows/publish.yml`) with the following configuration:

```yaml
name: Publish to dev.to

on:
  push:
    branches:
      - main
    paths:
      - "posts/**/*.md"

permissions:
  contents: write

jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Get changed posts
        id: changed
        run: |
          FILES=$(git diff --name-only ${{ github.event.before }} ${{ github.sha }} -- 'posts/**/*.md' | tr '\n' ' ')
          echo "FILES=$FILES" >> $GITHUB_OUTPUT

      - name: Publish articles to dev.to
        if: steps.changed.outputs.FILES != ''
        uses: sinedied/publish-devto@v2
        with:
          devto_key: ${{ secrets.DEVTO_API_KEY }}
          github_token: ${{ secrets.GITHUB_TOKEN }}
          files: ${{ steps.changed.outputs.FILES }}
          conventional_commits: true

```

This setup automatically publishes your articles to DEV.to when you commit changes to markdown files in the posts directory.
