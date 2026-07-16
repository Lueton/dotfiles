#!/bin/bash
set -euo pipefail
DOTFILES_DIR="${1:-$(realpath "$(dirname "$0")/..")}"
source "$DOTFILES_DIR/scripts/utils.sh" "$DOTFILES_DIR"

section "Language Runtimes" "🛠️"

NVM_VERSION="0.40.5"
PNPM_VERSION="11.13.1"
PYTHON_VERSION="3.12.10"

# nvm — Node.js version manager
if [ ! -d "$HOME/.nvm" ]; then
    log_info "📗  Installing nvm v${NVM_VERSION}..."
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh" | bash
    export NVM_DIR="$HOME/.nvm"
    # shellcheck disable=SC1091
    set +u
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install --lts
    nvm use --lts
    nvm alias default node
    set -u
    log_success "Node.js LTS installed via nvm"
fi

# pnpm — via corepack, bundled with Node
if ! is_installed pnpm; then
    log_info "📦  Installing pnpm v${PNPM_VERSION}..."
    export NVM_DIR="$HOME/.nvm"
    # shellcheck disable=SC1091
    set +u
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    corepack enable
    corepack prepare "pnpm@${PNPM_VERSION}" --activate
    set -u
    log_success "pnpm ${PNPM_VERSION} installed via corepack"
fi

# pyenv — Python version manager
if [ ! -d "$HOME/.pyenv" ]; then
    log_info "🐍  Installing pyenv..."
    curl https://pyenv.run | bash
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    set +u
    eval "$(pyenv init -)"
    set -u
    # Fedora ships Tcl/Tk 9, whose Tcl_Size API change breaks the _tkinter build on
    # this Python version — skip it, this environment has no need for Tkinter GUI support
    export PYTHON_CONFIGURE_OPTS="--without-tcltk"
    pyenv install "$PYTHON_VERSION"
    pyenv global "$PYTHON_VERSION"
    log_success "Python $PYTHON_VERSION installed via pyenv"
fi

# sdkman — Java / JVM toolchain manager
JAVA_17="17.0.19-tem"
JAVA_21="21.0.11-tem"
JAVA_DEFAULT="$JAVA_21"
MAVEN_VERSION="3.9.16"

if [ ! -d "$HOME/.sdkman" ]; then
    log_info "☕  Installing sdkman..."
    curl -s "https://get.sdkman.io" | bash
    # shellcheck disable=SC1091
    set +u
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk install java "$JAVA_17"
    sdk install java "$JAVA_21"
    sdk default java "$JAVA_DEFAULT"
    sdk install maven "$MAVEN_VERSION"
    set -u
    log_success "Java $JAVA_17 and $JAVA_21 installed (default: $JAVA_DEFAULT), Maven $MAVEN_VERSION installed"
fi

log_success "Language runtimes setup complete"
