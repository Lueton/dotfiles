#!/bin/bash
# Shared helpers — source this from other scripts: source "$DOTFILES/scripts/utils.sh"

DOTFILES_DIR="${1:-$(realpath "$(dirname "${BASH_SOURCE[0]}")/..")}"

# Styles
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'

# Bright variants
B_RED='\033[1;31m'
B_GREEN='\033[1;32m'
B_YELLOW='\033[1;33m'
B_CYAN='\033[1;36m'
B_MAGENTA='\033[1;35m'
B_WHITE='\033[1;37m'

section() {
    local title="$1"
    local emoji="${2:-🔧}"
    echo ""
    echo -e "${B_CYAN}  ╭─────────────────────────────────────────────${NC}"
    echo -e "${B_CYAN}  │${NC}  ${emoji}  ${BOLD}${B_WHITE}${title}${NC}"
    echo -e "${B_CYAN}  ╰─────────────────────────────────────────────${NC}"
    echo ""
}

log_info()    { echo -e "  ${B_CYAN}ℹ${NC}  $*"; }
log_success() { echo -e "  ${B_GREEN}✓${NC}  ${GREEN}$*${NC}"; }
log_warn()    { echo -e "  ${B_YELLOW}⚠${NC}  ${YELLOW}$*${NC}"; }
log_error()   { echo -e "  ${B_RED}✗${NC}  ${RED}$*${NC}" >&2; }
log_step()    { echo -e "     ${DIM}·  $*${NC}"; }

is_installed() { command -v "$1" &>/dev/null; }

symlink() {
    local src="$1"
    local dest="$2"
    mkdir -p "$(dirname "$dest")"
    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        mv "$dest" "${dest}.bak"
        log_warn "Backed up $(basename "$dest") → ${dest}.bak"
    fi
    ln -sfn "$src" "$dest"
    log_success "Linked $(basename "$src")"
}
