#!/bin/bash
set -euo pipefail
DOTFILES_DIR="${1:-$(realpath "$(dirname "$0")/..")}"
source "$DOTFILES_DIR/scripts/utils.sh" "$DOTFILES_DIR"

section "Language Runtimes" "🛠️"

NVM_VERSION="0.39.7"
PYTHON_VERSION="3.12.3"

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

# pyenv — Python version manager
if [ ! -d "$HOME/.pyenv" ]; then
    log_info "🐍  Installing pyenv..."
    curl https://pyenv.run | bash
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    pyenv install "$PYTHON_VERSION"
    pyenv global "$PYTHON_VERSION"
    log_success "Python $PYTHON_VERSION installed via pyenv"
fi

# sdkman — Java / JVM toolchain manager
JAVA_17="17.0.12-tem"
JAVA_21="21.0.4-tem"
JAVA_DEFAULT="$JAVA_21"

if [ ! -d "$HOME/.sdkman" ]; then
    log_info "☕  Installing sdkman..."
    curl -s "https://get.sdkman.io" | bash
    # shellcheck disable=SC1091
    set +u
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk install java "$JAVA_17"
    sdk install java "$JAVA_21"
    sdk default java "$JAVA_DEFAULT"
    set -u
    log_success "Java $JAVA_17 and $JAVA_21 installed (default: $JAVA_DEFAULT)"
fi

log_success "Language runtimes setup complete"
