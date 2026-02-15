# Testing the DEV.to Publishing Workflow

This document describes how to test all features of the workflow.

## Prerequisites
- Repository pushed to GitHub with `publish` branch
- `DEVTO_API_KEY` secret configured in GitHub repository settings
- At least one test article in `posts/` directory

## Test Scenarios

### 1. Publish a New Article
**Steps:**
1. Create a new markdown file in `posts/YYMMDD title/title.md`
2. Add front-matter with `title`, `published: true`, and `tags`
3. Commit and push to `publish` branch
4. Check GitHub Actions workflow run

**Expected:**
- Workflow detects the new file
- Article is published to DEV.to
- Original file is updated with `id`, `date`, and `url` in front-matter
- Bot commits the update back to the repository

### 2. Include Code Files with :(PATH.EXT) Syntax
**Steps:**
1. Create a code file (e.g., `example.js`) in the same directory as your article
2. In your markdown, add: `:(example.js)`
3. Commit and push to `publish` branch

**Expected:**
- Workflow processes the :(PATH.EXT) syntax
- Published article contains code block with content from `example.js`
- Original markdown preserves :(PATH.EXT) syntax
- Front-matter is updated with DEV.to metadata

### 3. Update an Existing Article
**Steps:**
1. Modify an article that already has an `id` in its front-matter
2. Commit and push to `publish` branch

**Expected:**
- Workflow detects the change
- Article is updated on DEV.to (not republished)
- If `date` changes, it's updated in front-matter

### 4. Delete an Article
**Steps:**
1. Note the `id` of an article you want to delete
2. Delete the markdown file from `posts/`
3. Commit and push to `publish` branch

**Expected:**
- Workflow detects the deletion
- Article is unpublished on DEV.to using the `id` from git history
- Article still exists on DEV.to but is marked as unpublished

### 5. Test with File Paths Containing Spaces
**Steps:**
1. Create an article in a directory with spaces (e.g., `posts/260207 test article/test.md`)
2. Follow steps from scenario 1 or 2

**Expected:**
- Workflow handles the spaces correctly
- Article is published without issues

### 6. Test Front-matter with Hyphenated Keys
**Steps:**
1. Add front-matter keys like `cover-image`, `canonical-url`
2. Publish the article

**Expected:**
- Workflow preserves all hyphenated keys
- DEV.to metadata (id, date, url) is added correctly
- No loss of existing front-matter data

### 7. Verify Bot Commit Loop Prevention
**Steps:**
1. Publish an article and wait for the bot to commit front-matter updates
2. Check that the workflow doesn't trigger again on the bot's commit

**Expected:**
- Workflow runs once for your commit
- Bot commits front-matter update
- Workflow does NOT run again for the bot's commit (prevents infinite loop)

## Debugging

### Check Workflow Logs
1. Go to GitHub repository → Actions tab
2. Click on the latest workflow run
3. Expand each step to see detailed logs

### Common Issues
- **No files detected**: Check that you're on the `publish` branch and modified files in `posts/` directory
- **Article not updating**: Verify the `id` in front-matter matches the DEV.to article
- **Include syntax not working**: Ensure the file path is correct relative to the markdown file
- **Deletion not working**: The article must have an `id` in its last committed version

### Manual Testing
To test the Python scripts locally without running the full workflow:
```bash
# Test include processor
export FILES="posts/your-article/article.md"
python -c "$(sed -n '/Run include-processor/,/PY$/p' .github/workflows/devto.yml | tail -n +7 | head -n -1)"

# Test front-matter synchronization
python -c "$(sed -n '/Copy front-matter updates/,/PY$/p' .github/workflows/devto.yml | tail -n +7 | head -n -1)"
```

## Success Criteria
- ✅ New articles are published to DEV.to
- ✅ Code includes with :(PATH.EXT) are processed correctly
- ✅ Front-matter is updated with id, date, url after publishing
- ✅ Updates to existing articles work
- ✅ Deleted articles are unpublished on DEV.to
- ✅ No infinite commit loops
- ✅ Spaces in paths are handled correctly
- ✅ Hyphenated front-matter keys are preserved
