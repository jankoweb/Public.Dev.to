import yaml, traceback, sys
p = r'c:/Users/kohoutj/git/_Weby/Dev.to/.github/workflows/devto.yml'
text = open(p, 'r', encoding='utf-8').read()
try:
    yaml.safe_load(text)
    print('YAML parsed OK')
except Exception:
    print('YAML parse error:')
    traceback.print_exc()
    sys.exit(1)
