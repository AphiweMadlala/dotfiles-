#!/bin/bash
set -e

echo "Installing Claude Code..."
npm install -g @anthropic-ai/claude-code

echo "Installing Taste Skill..."
npx skills add https://github.com/Leonxlnx/taste-skill \
  --skill "design-taste-frontend" \
  --agent claude-code \
  --global \
  --yes

echo "Adding Impeccable marketplace..."
claude plugin marketplace add pbakaus/impeccable

echo "Installing Impeccable..."
claude plugin install impeccable@impeccable

echo "Claude Code setup complete."
