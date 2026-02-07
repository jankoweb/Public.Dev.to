import os, sys, re
files = os.environ.get('FILES','').strip()
if not files:
    sys.exit(0)
for md in files.split():
    if not os.path.exists(md):
        print('Skip missing:', md)
        continue
    with open(md, 'r', encoding='utf-8') as f:
        s = f.read()

    pattern = re.compile(r':\(\s*([^\s\)]+)(?:\s+lang=([^\)\s]+))?\s*\)')

    def repl(m):
        rel = m.group(1)
        lang = m.group(2)
        base = os.path.dirname(md)
        p = rel if os.path.isabs(rel) else os.path.normpath(os.path.join(base, rel))
        if not os.path.exists(p):
            print('Included file not found:', p)
            return m.group(0)
        ext = os.path.splitext(p)[1].lower()
        if not lang:
            lang_map = {'.ps1':'powershell','.sh':'bash','.js':'javascript','.ts':'typescript',
                  '.py':'python','.json':'json','.html':'html','.css':'css'}
            lang = lang_map.get(ext, 'text')
        with open(p,'r',encoding='utf-8') as inc:
            code = inc.read().rstrip()
        return f"```{lang}\n{code}\n```"

    new = pattern.sub(repl, s)
    if new != s:
        with open(md, 'w', encoding='utf-8') as f:
            f.write(new)
        print('Processed includes in', md)