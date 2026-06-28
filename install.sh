#!/bin/bash

# Solana Launch Skill - Standard Installer
# Installs with recommended defaults. For custom options, use ./install-custom.sh

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

# Standard defaults
SKILLS_DIR="$HOME/.claude/skills"
LAUNCH_SKILL_PATH="$SKILLS_DIR/solana-launch"
CORE_SKILL_PATH="$SKILLS_DIR/solana-dev"
CLAUDE_MD_PATH="$HOME/.claude/CLAUDE.md"

CORE_SKILL_REPO="https://github.com/solana-foundation/solana-dev-skill.git"

print_banner() {
    echo ""
    echo -e "${MAGENTA}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║${NC}                                                               ${MAGENTA}║${NC}"
    echo -e "${MAGENTA}║${NC}   ${WHITE}Solana Launch Skill${NC}  ${CYAN}— safe token launch & tokenomics${NC}        ${MAGENTA}║${NC}"
    echo -e "${MAGENTA}║${NC}                                                               ${MAGENTA}║${NC}"
    echo -e "${MAGENTA}║${NC}   ${GREEN}design ▸ mint ▸ distribute ▸ liquidity ▸ GATE ▸ operate${NC}      ${MAGENTA}║${NC}"
    echo -e "${MAGENTA}║${NC}                                                               ${MAGENTA}║${NC}"
    echo -e "${MAGENTA}║${NC}   ${YELLOW}for the Solana AI Kit${NC}                                       ${MAGENTA}║${NC}"
    echo -e "${MAGENTA}║${NC}                                                               ${MAGENTA}║${NC}"
    echo -e "${MAGENTA}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_help() {
    echo "Solana Launch Skill - Standard Installer"
    echo ""
    echo "Usage: ./install.sh [OPTIONS]"
    echo ""
    echo "Installs with recommended defaults:"
    echo "  - Location: ~/.claude/skills/"
    echo "  - Installs both solana-dev and solana-launch skills"
    echo "  - Copies CLAUDE.md to ~/.claude/"
    echo ""
    echo "Options:"
    echo "  -y, --yes      Skip confirmation prompt"
    echo "  -h, --help     Show this help"
    echo ""
    echo "For custom installation options, use: ./install-custom.sh"
    echo ""
}

# Parse arguments
SKIP_CONFIRM=false
while [[ $# -gt 0 ]]; do
    case $1 in
        -y|--yes) SKIP_CONFIRM=true; shift ;;
        -h|--help) print_help; exit 0 ;;
        *) echo "Unknown option: $1"; echo "Use --help for usage information"; exit 1 ;;
    esac
done

print_banner

echo -e "${WHITE}Standard Installation${NC}"
echo ""
echo -e "This will install:"
echo -e "  ${BLUE}•${NC} solana-launch-skill → ${CYAN}$LAUNCH_SKILL_PATH${NC}"
echo -e "  ${BLUE}•${NC} solana-dev-skill    → ${CYAN}$CORE_SKILL_PATH${NC}"
echo -e "  ${BLUE}•${NC} CLAUDE.md           → ${CYAN}$CLAUDE_MD_PATH${NC}"
echo ""

if [ "$SKIP_CONFIRM" = false ]; then
    read -p "Proceed with installation? [Y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        echo -e "${YELLOW}Installation cancelled${NC}"
        echo -e "For custom options, run: ${CYAN}./install-custom.sh${NC}"
        exit 0
    fi
fi

echo ""
mkdir -p "$SKILLS_DIR"
mkdir -p "$HOME/.claude"

# Install core skill (solana-dev)
echo -e "${CYAN}[1/3]${NC} Installing solana-dev-skill..."
if [ -d "$CORE_SKILL_PATH" ]; then
    echo -e "  ${YELLOW}→${NC} Removing existing installation"
    rm -rf "$CORE_SKILL_PATH"
fi
temp_dir=$(mktemp -d)
if git clone --depth 1 --quiet "$CORE_SKILL_REPO" "$temp_dir" 2>/dev/null; then
    if [ -d "$temp_dir/skill" ]; then
        cp -r "$temp_dir/skill" "$CORE_SKILL_PATH"
    else
        cp -r "$temp_dir" "$CORE_SKILL_PATH"
    fi
    rm -rf "$temp_dir"
    echo -e "  ${GREEN}✓${NC} Installed to $CORE_SKILL_PATH"
else
    rm -rf "$temp_dir"
    echo -e "  ${RED}✗${NC} Failed to clone solana-dev-skill"
    echo -e "  ${YELLOW}→${NC} Install manually: https://github.com/solana-foundation/solana-dev-skill"
fi

# Install launch skill
echo -e "${CYAN}[2/3]${NC} Installing solana-launch-skill..."
if [ -d "$LAUNCH_SKILL_PATH" ]; then
    echo -e "  ${YELLOW}→${NC} Removing existing installation"
    rm -rf "$LAUNCH_SKILL_PATH"
fi
mkdir -p "$LAUNCH_SKILL_PATH"
cp -r "$SOURCE_DIR"/* "$LAUNCH_SKILL_PATH/"
echo -e "  ${GREEN}✓${NC} Installed to $LAUNCH_SKILL_PATH"

# Install CLAUDE.md
echo -e "${CYAN}[3/3]${NC} Installing CLAUDE.md..."
if [ -f "$CLAUDE_MD_PATH" ]; then
    echo -e "  ${YELLOW}→${NC} Backing up existing CLAUDE.md"
    cp "$CLAUDE_MD_PATH" "$CLAUDE_MD_PATH.backup"
fi
cp "$SCRIPT_DIR/CLAUDE.md" "$CLAUDE_MD_PATH"
echo -e "  ${GREEN}✓${NC} Installed to $CLAUDE_MD_PATH"

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC}  ${WHITE}Installation Complete!${NC}                                       ${GREEN}║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${WHITE}Installed:${NC}"
echo -e "  ${GREEN}✓${NC} solana-dev-skill    ${CYAN}$CORE_SKILL_PATH${NC}"
echo -e "  ${GREEN}✓${NC} solana-launch-skill ${CYAN}$LAUNCH_SKILL_PATH${NC}"
echo -e "  ${GREEN}✓${NC} CLAUDE.md           ${CYAN}$CLAUDE_MD_PATH${NC}"
echo ""
echo -e "${CYAN}Try asking Claude:${NC}"
echo -e "  ${BLUE}•${NC} \"Design tokenomics for my 1B-supply project token\""
echo -e "  ${BLUE}•${NC} \"Which launchpad for a fair-launch token with no treasury?\""
echo -e "  ${BLUE}•${NC} \"Am I ready to launch?\"  /  \"Is this token a honeypot? <mint>\""
echo ""
