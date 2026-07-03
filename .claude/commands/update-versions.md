# Update pinned versions in install scripts

Check all pinned versions in the dotfiles install scripts and update them to the latest stable releases.

## What to check

Read the following files and find all pinned versions:

- `fedora-42-general/scripts/languages.sh` — `NVM_VERSION`, `PYTHON_VERSION`, `JAVA_17`, `JAVA_21`
- `fedora-42-general/scripts/editors.sh` — `TOOLBOX_VERSION`
- `fedora-42-general/scripts/fonts.sh` — `NERD_FONTS_VERSION`

## Process for each version

For each pinned version, look up the latest stable release:

- **nvm**: https://github.com/nvm-sh/nvm/releases — latest tag without "pre" or "rc"
- **Python (pyenv)**: https://github.com/python-releases/python-releases/tree/main or https://www.python.org/downloads/ — latest stable 3.x.y patch release on the currently pinned minor version (e.g. if pinned to 3.12.x, find latest 3.12.y)
- **Java via sdkman**: Run `sdk list java` mentally or check https://api.sdkman.io/2/candidates/java/linuxx64/versions/all — find latest `-tem` (Temurin) releases for the major versions currently pinned (17.x and 21.x)
- **JetBrains Toolbox**: https://www.jetbrains.com/toolbox-app/ or https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release — find the latest version number and build
- **Nerd Fonts**: https://github.com/ryanoasis/nerd-fonts/releases — latest stable tag

## Output

For each version:
1. State the currently pinned version
2. State the latest available version
3. If they differ, update the variable in the file

After all checks, summarize what was updated and what was already up to date.

If a version could not be determined (e.g. network unavailable), say so explicitly — do not silently skip.
