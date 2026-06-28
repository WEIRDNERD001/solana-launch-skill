#!/bin/bash

# Solana Launch Skill - Custom Installer
# Full control: personal vs project location, skip core skill if present, CLAUDE.md placement.

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/skill"
LAUNCH_SKILL_NAME="solana-launch"
CORE_SKILL_NAME="solana-dev"
CORE_SKILL_REPO="https://github.com/solana-foundation/solana-dev-skill.git"

PERSONAL_SKILLS_DIR="$HOME/.claude/skills"
PROJECT_SKILLS_DIR=".claude/skills"

print_banner() {
    echo ""
    echo -e "${MAGENTA}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║${NC}   ${WHITE}Solana Launch Skill${NC}  ${CYAN}— custom installer${NC}                     ${MAGENTA}║${NC}"
    echo -e "${MAGENTA}║${NC}   ${GREEN}safe token launch & tokenomics for the Solana AI Kit${NC}        ${MAGENTA}║${NC}"
    echo -e "${MAGENTA}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_help() {
    echo "Solana Launch Skill - Custom Installer"
    echo ""
    echo "Usage: ./install-custom.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --project          Install into ./.claude/skills (project-local)"
    echo "  --personal         Install into ~/.claude/skills (default)"
    echo "  --path <dir>       Install skills into a custom directory"
    echo "  --skip-core        Do not install solana-dev-skill"
    echo "  --no-claude-md     Do not copy CLAUDE.md"
    echo "  -y, --yes          Use defaults, no prompts"
    echo "  -h, --help         Show this help"
    echo ""
}

# Defaults
INSTALL_BASE="$PERSONAL_SKILLS_DIR"
CLAUDE_MD_BASE="$HOME/.claude"
SKIP_CORE=false
COPY_CLAUDE_MD=true
SKIP_CONFIRM=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --project) INSTALL_BASE="$PROJECT_SKILLS_DIR"; CLAUDE_MD_BASE="."; shift ;;
        --personal) INSTALL_BASE="$PERSONAL_SKILLS_DIR"; CLAUDE_MD_BASE="$HOME/.claude"; shift ;;
        --path) INSTALL_BASE="$2"; shift 2 ;;
        --skip-core) SKIP_CORE=true; shift ;;
        --no-claude-md) COPY_CLAUDE_MD=false; shift ;;
        -y|--yes) SKIP_CONFIRM=true; shift ;;
        -h|--help) print_help; exit 0 ;;
        *) echo "Unknown option: $1"; echo "Use --help for usage"; exit 1 ;;
    esac
done

print_banner

# Interactive prompts (unless -y)
if [ "$SKIP_CONFIRM" = false ]; then
    echo -e "${WHITE}Where should the skills be installed?${NC}"
    echo -e "  ${CYAN}1${NC}) Personal  (${PERSONAL_SKILLS_DIR})  [default]"
    echo -e "  ${CYAN}2${NC}) Project   (${PROJECT_SKILLS_DIR})"
    echo -e "  ${CYAN}3${NC}) Custom path"
    read -p "Choice [1]: " -r CHOICE
    case "$CHOICE" in
        2) INSTALL_BASE="$PROJECT_SKILLS_DIR"; CLAUDE_MD_BASE="." ;;
        3) read -p "Enter path: " -r INSTALL_BASE; CLAUDE_MD_BASE="$(dirname "$INSTALL_BASE")" ;;
        *) INSTALL_BASE="$PERSONAL_SKILLS_DIR"; CLAUDE_MD_BASE="$HOME/.claude" ;;
    esac

    if [ -d "$INSTALL_BASE/$CORE_SKILL_NAME" ]; then
        echo -e "${YELLOW}Found existing $CORE_SKILL_NAME — skipping core install.${NC}"
        SKIP_CORE=true
    else
        read -p "Also install core solana-dev-skill? [Y/n] " -n 1 -r; echo
        [[ $REPLY =~ ^[Nn]$ ]] && SKIP_CORE=true
    fi

    read -p "Copy CLAUDE.md to ${CLAUDE_MD_BASE}/CLAUDE.md? [Y/n] " -n 1 -r; echo
    [[ $REPLY =~ ^[Nn]$ ]] && COPY_CLAUDE_MD=false
fi

LAUNCH_SKILL_PATH="$INSTALL_BASE/$LAUNCH_SKILL_NAME"
CORE_SKILL_PATH="$INSTALL_BASE/$CORE_SKILL_NAME"
CLAUDE_MD_PATH="$CLAUDE_MD_BASE/CLAUDE.md"

echo ""
echo -e "${WHITE}Plan:${NC}"
echo -e "  ${BLUE}•${NC} solana-launch → ${CYAN}$LAUNCH_SKILL_PATH${NC}"
[ "$SKIP_CORE" = false ] && echo -e "  ${BLUE}•${NC} solana-dev    → ${CYAN}$CORE_SKILL_PATH${NC}"
[ "$COPY_CLAUDE_MD" = true ] && echo -e "  ${BLUE}•${NC} CLAUDE.md     → ${CYAN}$CLAUDE_MD_PATH${NC}"
echo ""

mkdir -p "$INSTALL_BASE"

if [ "$SKIP_CORE" = false ]; then
    echo -e "${CYAN}[*]${NC} Installing solana-dev-skill..."
    [ -d "$CORE_SKILL_PATH" ] && rm -rf "$CORE_SKILL_PATH"
    temp_dir=$(mktemp -d)
    if git clone --depth 1 --quiet "$CORE_SKILL_REPO" "$temp_dir" 2>/dev/null; then
        if [ -d "$temp_dir/skill" ]; then cp -r "$temp_dir/skill" "$CORE_SKILL_PATH"; else cp -r "$temp_dir" "$CORE_SKILL_PATH"; fi
        rm -rf "$temp_dir"
        echo -e "  ${GREEN}✓${NC} $CORE_SKILL_PATH"
    else
        rm -rf "$temp_dir"
        echo -e "  ${RED}✗${NC} Failed to clone — install manually: $CORE_SKILL_REPO"
    fi
fi

echo -e "${CYAN}[*]${NC} Installing solana-launch-skill..."
[ -d "$LAUNCH_SKILL_PATH" ] && rm -rf "$LAUNCH_SKILL_PATH"
mkdir -p "$LAUNCH_SKILL_PATH"
cp -r "$SOURCE_DIR"/* "$LAUNCH_SKILL_PATH/"
echo -e "  ${GREEN}✓${NC} $LAUNCH_SKILL_PATH"

if [ "$COPY_CLAUDE_MD" = true ]; then
    echo -e "${CYAN}[*]${NC} Installing CLAUDE.md..."
    mkdir -p "$CLAUDE_MD_BASE"
    [ -f "$CLAUDE_MD_PATH" ] && cp "$CLAUDE_MD_PATH" "$CLAUDE_MD_PATH.backup"
    cp "$SCRIPT_DIR/CLAUDE.md" "$CLAUDE_MD_PATH"
    echo -e "  ${GREEN}✓${NC} $CLAUDE_MD_PATH"
fi

echo ""
echo -e "${GREEN}Done.${NC} Ask Claude: \"Design tokenomics for my token\" or \"Is this token a honeypot? <mint>\""
echo ""
