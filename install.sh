#!/bin/bash
set -e

echo "Installing Claude Code skills..."

npx skills add https://github.com/Leonxlnx/taste-skill \
  --skill "design-taste-frontend" \
  --agent claude-code \
  --global \
  --yes

echo "Done."
