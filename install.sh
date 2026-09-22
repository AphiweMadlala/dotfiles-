#!/usr/bin/env bash

set -u
set -o pipefail

echo "======================================"
echo "Setting up Claude Code environment"
echo "======================================"

optional() {
  echo ""
  echo "→ $1"
  shift

  if "$@"; then
    echo "✓ Done"
  else
    echo "⚠ Failed, continuing instead of aborting Codespaces setup"
  fi
}

mkdir -p "$HOME/.claude/skills"
mkdir -p "$HOME/Developer"

# ==================================================
# Claude Code
# ==================================================

echo ""
echo "Installing Claude Code..."

npm install -g @anthropic-ai/claude-code

# ==================================================
# Taste / frontend design skill
# ==================================================

optional \
  "Installing design-taste-frontend" \
  npx -y skills add https://github.com/Leonxlnx/taste-skill \
  --skill design-taste-frontend \
  --agent claude-code \
  --global \
  --yes

# ==================================================
# Impeccable
# ==================================================

optional \
  "Installing Impeccable" \
  npx -y impeccable install \
  --providers=claude \
  --scope=global

# ==================================================
# Agent Reach
# ==================================================

optional \
  "Installing Agent Reach" \
  npx -y skills add https://github.com/Panniantong/agent-reach \
  --agent claude-code \
  --global \
  --yes

# ==================================================
# Playwright CLI
# ==================================================

echo ""
echo "Installing Playwright CLI..."

npm install -g @playwright/cli@latest

optional \
  "Installing Playwright Claude skill globally" \
  playwright-cli install --skills -g

# ==================================================
# design-md
# ==================================================

echo ""
echo "Installing design-md..."

mkdir -p "$HOME/.claude/skills/design-md"

optional \
  "Downloading design-md SKILL.md" \
  curl -fsSL \
  https://raw.githubusercontent.com/arumwu/design-md-skill/main/SKILL.md \
  -o "$HOME/.claude/skills/design-md/SKILL.md"

# ==================================================
# Awesome Design library
# ==================================================

echo ""
echo "Installing Awesome Design library..."

if [ -d "$HOME/Developer/awesome-design-md/.git" ]; then

  optional \
    "Updating Awesome Design library" \
    git -C "$HOME/Developer/awesome-design-md" pull --ff-only

elif [ ! -e "$HOME/Developer/awesome-design-md" ]; then

  optional \
    "Cloning Awesome Design library" \
    git clone --depth 1 \
    https://github.com/VoltAgent/awesome-design-md.git \
    "$HOME/Developer/awesome-design-md"

else
  echo "⚠ $HOME/Developer/awesome-design-md already exists but is not a Git repository."
fi

# ==================================================
# img2threejs
# ==================================================

echo ""
echo "Installing img2threejs..."

if [ -d "$HOME/.claude/skills/img2threejs/.git" ]; then

  optional \
    "Updating img2threejs" \
    git -C "$HOME/.claude/skills/img2threejs" pull --ff-only

elif [ ! -e "$HOME/.claude/skills/img2threejs" ]; then

  optional \
    "Cloning img2threejs" \
    git clone \
    https://github.com/img2threejs/img2threejs.git \
    "$HOME/.claude/skills/img2threejs"

else
  echo "⚠ img2threejs already exists. Leaving it untouched."
fi

# ==================================================
# Firecrawl
# ==================================================

echo ""
echo "Installing Firecrawl..."

npm install -g firecrawl-cli

optional \
  "Installing Firecrawl Claude Code skills" \
  firecrawl init \
  --agent claude-code \
  --skip-auth \
  -y

# ==================================================
# Apify CLI
# ==================================================

echo ""
echo "Installing Apify CLI..."

npm install -g apify-cli

# ==================================================
# Apify Claude plugin
# ==================================================

echo ""
echo "Setting up Apify Claude plugin..."

if claude plugin marketplace list 2>/dev/null | grep -qi "apify"; then

  optional \
    "Updating existing Apify marketplace" \
    claude plugin marketplace update apify

else

  optional \
    "Adding Apify Claude marketplace" \
    claude plugin marketplace add apify/apify-claude-code-plugin

fi

optional \
  "Installing/updating Apify Claude plugin" \
  claude plugin install apify@apify

# ==================================================
# Verification
# ==================================================

echo ""
echo "======================================"
echo "Claude Code environment setup finished"
echo "======================================"

echo ""
echo "Claude version:"
claude --version 2>/dev/null || true

echo ""
echo "Installed global Claude skills:"

if [ -d "$HOME/.claude/skills" ]; then
  ls -1 "$HOME/.claude/skills"
else
  echo "⚠ ~/.claude/skills does not exist"
fi

echo ""
echo "Secret status:"

if [ -n "${APIFY_TOKEN:-}" ]; then
  echo "✓ APIFY_TOKEN is available"
else
  echo "⚠ APIFY_TOKEN is NOT available"
fi

if [ -n "${FIRECRAWL_API_KEY:-}" ]; then
  echo "✓ FIRECRAWL_API_KEY is available"
else
  echo "⚠ FIRECRAWL_API_KEY is NOT available"
fi

echo ""
echo "Claude plugins:"

claude plugin list 2>/dev/null || \
  echo "⚠ Could not list Claude plugins"

echo ""
echo "======================================"
echo "Setup complete"
echo "======================================"
