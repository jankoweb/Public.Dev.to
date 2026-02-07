# YAML Validation Script for GitHub Copilot
# Use this script to validate YAML files before editing or committing.
# Run: python .vscode/validate_yaml.py <path_to_yaml_file>
# This ensures YAML syntax is correct.

import yaml, traceback, sys

if len(sys.argv) != 2:
    print("Usage: python validate_yaml.py <yaml_file_path>")
    sys.exit(1)

p = sys.argv[1]
try:
    with open(p, 'r', encoding='utf-8') as f:
        text = f.read()
    yaml.safe_load(text)
    print('YAML parsed OK')
except Exception as e:
    print('YAML parse error:')
    traceback.print_exc()
    sys.exit(1)
