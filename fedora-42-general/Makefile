SHELL    := /bin/bash
DOTFILES := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

.PHONY: all packages fonts languages shell terminal wm theming editors shared

all: packages fonts languages shell terminal wm theming editors shared
	@echo ""
	@echo -e "\033[1;32m  ╭────────────────────────────────────────────────\033[0m"
	@echo -e "\033[1;32m  │\033[0m  ✅  \033[1;37mSetup complete!\033[0m"
	@echo -e "\033[1;32m  │\033[0m  🔄  \033[2mLog out and back in, or run: exec zsh\033[0m"
	@echo -e "\033[1;32m  ╰────────────────────────────────────────────────\033[0m"
	@echo ""

packages:
	@bash "$(DOTFILES)/scripts/packages.sh" "$(DOTFILES)"

fonts:
	@bash "$(DOTFILES)/scripts/fonts.sh" "$(DOTFILES)"

languages:
	@bash "$(DOTFILES)/scripts/languages.sh" "$(DOTFILES)"

shell:
	@bash "$(DOTFILES)/scripts/shell.sh" "$(DOTFILES)"

terminal:
	@bash "$(DOTFILES)/scripts/terminal.sh" "$(DOTFILES)"

wm:
	@bash "$(DOTFILES)/scripts/wm.sh" "$(DOTFILES)"

theming:
	@bash "$(DOTFILES)/scripts/theming.sh" "$(DOTFILES)"

editors:
	@bash "$(DOTFILES)/scripts/editors.sh" "$(DOTFILES)"

shared:
	@bash "$(DOTFILES)/scripts/shared.sh" "$(DOTFILES)"
