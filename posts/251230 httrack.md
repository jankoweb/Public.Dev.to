---
title: "HTTrack Website Copier – Troubleshooting gzip Errors"
published: true
tags: httrack, archive, issues
---

**HTTrack** is a free, open-source offline browser utility. Download sites for offline viewing: [httrack.com](https://www.httrack.com/)

**Issue:**
HTTrack sometimes fails to decompress (unzip) downloaded pages on jankoweb, resulting in corrupted binary output instead of HTML.

**Observed error:**
> Error when decompressing
while fetching pages that appear to be gzip-compressed.

**Workaround:**
In HTTrack, go to:
`Set Options → Spider → Force HTTP/1.0`

**Why?**
Forcing HTTP/1.0 disables some server-side compression/transfer behaviors that may trigger decompression failures in HTTrack.

**Status:**
Testing whether HTTP/1.0 prevents broken gzip responses from the server.