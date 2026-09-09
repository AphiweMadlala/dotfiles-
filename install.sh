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

echo "Installing Agent Reach..."
npx skills add https://github.com/Panniantong/agent-reach \
  --agent claude-code \
  --global \
  --yes

echo "Installing Playwright CLI..."
npm install -g @playwright/cli@latest

echo "Installing Playwright Claude skill..."
playwright-cli install --skills

echo "Installing design-md skill..."
mkdir -p ~/.claude/skills/design-md
curl -fsSL https://raw.githubusercontent.com/arumwu/design-md-skill/main/SKILL.md \
  -o ~/.claude/skills/design-md/SKILL.md

echo "Installing Awesome Design library..."
mkdir -p ~/Developer

if [ ! -d ~/Developer/awesome-design-md/.git ]; then
  git clone --depth 1 https://github.com/VoltAgent/awesome-design-md.git \
    ~/Developer/awesome-design-md
else
  git -C ~/Developer/awesome-design-md pull --ff-only
fi

echo "Claude Code setup complete."