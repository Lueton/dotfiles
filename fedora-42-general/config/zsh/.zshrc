# Path
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-z)
source "$ZSH/oh-my-zsh.sh"

# Pywal — apply terminal colors from last run
(cat ~/.cache/wal/sequences 2>/dev/null &)
source ~/.cache/wal/colors-tty.sh 2>/dev/null || true

# Starship prompt
eval "$(starship init zsh)"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)" 2>/dev/null || true

# sdkman
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ls
alias ls='ls --color=auto'
alias ll='ls -lah'
alias la='ls -A'

# Prefer modern CLI tools when available
command -v bat  &>/dev/null && alias cat='bat --style=plain'
command -v fd   &>/dev/null && alias find='fd'
command -v btop &>/dev/null && alias top='btop'

# Git
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias glog='git log --oneline --graph --decorate'

# Theming
alias wallpaper='$HOME/.local/bin/wallpaper'
