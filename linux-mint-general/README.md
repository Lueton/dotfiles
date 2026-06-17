# Linux Mint Setup

Automatisiertes Setup für eine vollständige Linux Mint Entwicklungsumgebung mit i3 Window Manager, Kitty Terminal und dynamischem pywal-Theming.

---

## Stack

| Kategorie | Tool |
|-----------|------|
| Window Manager | [i3](https://i3wm.org/) |
| Status Bar | [Polybar](https://github.com/polybar/polybar) |
| Terminal | [Kitty](https://sw.kovidgoyal.net/kitty/) |
| Shell | [Zsh](https://www.zsh.org/) + [Oh My Zsh](https://ohmyz.sh/) |
| Prompt | [Starship](https://starship.rs/) |
| App Launcher | [Rofi](https://github.com/davatorium/rofi) |
| Compositor | [Picom](https://github.com/yshui/picom) |
| Notifications | [Dunst](https://dunst-project.org/) |
| Theming | [pywal](https://github.com/dylanaraps/pywal) |
| Editoren | VS Code, Zed, JetBrains Toolbox |
| Node.js | [nvm](https://github.com/nvm-sh/nvm) |
| Python | [pyenv](https://github.com/pyenv/pyenv) |
| Java | [sdkman](https://sdkman.io/) |

---

## Voraussetzungen

- Linux Mint (frische Installation empfohlen)
- Internetverbindung
- Ein normaler Benutzeraccount (kein Root)

---

## Schnellstart

Einzeiliger Bootstrap direkt nach der frischen Linux Mint Installation:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/lueton/dotfiles/master/linux-mint-general/install.sh)
```

Das Script:
1. Installiert `git` und `make` falls noch nicht vorhanden
2. Klont das Repo nach `~/.dotfiles`
3. Führt `make all` aus

> **Nicht mit `sudo` ausführen.** Die Scripts rufen `sudo` intern auf, wo es benötigt wird. Ein Root-Start würde alle Pfade nach `/root` auflösen.

---

## Manuelle Installation

Wenn das Repo bereits geklont ist:

```bash
cd linux-mint-general
make all        # Alles auf einmal
```

Oder einzelne Komponenten:

```bash
make packages   # System-Pakete via apt
make fonts      # Nerd Fonts
make languages  # Node.js, Python, Java
make shell      # Zsh, Oh My Zsh, Starship
make terminal   # Kitty
make wm         # i3, Polybar, Rofi, Picom, Dunst
make theming    # pywal
make editors    # VS Code, Zed, JetBrains Toolbox
make shared     # Shared Configs (Git)
```

Die Targets sind idempotent — bereits installierte Komponenten werden übersprungen.

---

## Was wird installiert

### `make packages` — System-Pakete

Installiert via `apt`:

- **Build-Tools:** `build-essential`, `cmake`, `pkg-config`
- **Utilities:** `curl`, `wget`, `git`, `unzip`, `tar`, `gnupg`
- **Shell:** `zsh`
- **X11 / Display:** `xorg`, `xinit`, `xclip`, `xdotool`, `dex`, `xss-lock`
- **WM Stack:** `i3`, `polybar`, `rofi`, `dunst`, `feh`, `picom`
- **Terminal:** `kitty` (Fallback; wird auch via offiziellem Installer installiert)
- **System Tools:** `htop`, `btop`, `neofetch`, `tmux`, `scrot`, `brightnessctl`
- **Modernes CLI:** `ripgrep`, `fd-find`, `bat`
- **Python:** `python3`, `python3-pip`, `python3-venv` + alle pyenv Build-Dependencies
- **Audio:** `pulseaudio`, `pavucontrol`
- **Netzwerk:** `network-manager`, `network-manager-gnome`
- **GTK Theming:** `lxappearance`, `papirus-icon-theme`
- **Media:** `mpv`

---

### `make fonts` — Nerd Fonts

Installiert nach `~/.local/share/fonts/NerdFonts/`:

- **JetBrains Mono** Nerd Font
- **FiraCode** Nerd Font

Version: `3.2.1` von [ryanoasis/nerd-fonts](https://github.com/ryanoasis/nerd-fonts)

---

### `make languages` — Language Runtimes

| Runtime | Version | Manager |
|---------|---------|---------|
| Node.js | LTS | nvm v0.39.7 |
| Python | 3.12.3 | pyenv |
| Java | 17.0.12-tem (alt) | sdkman |
| Java | 21.0.4-tem **(default)** | sdkman |

---

### `make shell` — Shell Setup

- **Zsh** als Default-Shell (`chsh`)
- **Oh My Zsh** Framework
- Plugins: `zsh-autosuggestions`, `zsh-syntax-highlighting`, `zsh-z`
- **Starship** Prompt

Symlinks:

```
config/zsh/.zshrc           → ~/.zshrc
config/zsh/.zprofile        → ~/.zprofile
config/starship/starship.toml → ~/.config/starship/starship.toml
```

---

### `make terminal` — Kitty

Installiert via offiziellem Installer (`sw.kovidgoyal.net`).

Symlink:

```
config/kitty/ → ~/.config/kitty/
```

---

### `make wm` — Window Manager Stack

Installiert und konfiguriert:

- **i3** — Tiling Window Manager
- **Polybar** — Status Bar
- **Rofi** — Application Launcher
- **Picom** — Compositor (Transparenz, Blur, Schatten)
- **Dunst** — Notification Daemon
- **i3-workspace-names-daemon** — Dynamische Workspace-Icons via pip

Symlinks:

```
config/i3/     → ~/.config/i3/
config/polybar/ → ~/.config/polybar/
config/rofi/   → ~/.config/rofi/
config/picom/  → ~/.config/picom/
```

> **Dunst** wird **nicht** symlinkt — pywal generiert `~/.config/dunst/dunstrc` bei jedem Wallpaper-Wechsel neu. Beim ersten Start wird eine statische Fallback-Config kopiert.

---

### `make theming` — pywal

- Installiert **pywal** via pip
- Symlinkt pywal-Templates: `config/pywal/templates/ → ~/.config/wal/templates/`
- Erstellt `~/wallpapers/` Verzeichnis
- Installiert das `wallpaper`-Hilfsskript nach `~/.local/bin/wallpaper`

---

### `make editors` — Editoren

- **VS Code** via Microsoft apt-Repository
- **Zed** via offiziellem Installer
- **JetBrains Toolbox** v2.3.2 (startet sich automatisch, UI-Installation erforderlich)

---

### `make shared` — Shared Configs

Symlinkt plattformübergreifende Konfigurationen:

```
shared/git/.gitconfig → ~/.gitconfig
```

---

## Nach der Installation

### 1. Neu anmelden

```bash
exec zsh   # Sofort Zsh starten, oder ausloggen und wieder einloggen
```

### 2. Wallpaper setzen und Farbschema generieren

Das pywal-Theming generiert ein Farbschema aus dem Wallpaper und überträgt es auf i3, Kitty, Polybar und Dunst:

```bash
# Aus einem eigenen Bild
wallpaper ~/wallpapers/mein-bild.jpg

# Mit einem vordefinierten pywal-Theme
wal --theme catppuccin-mocha
```

### 3. i3 starten

```bash
startx
```

---

## Theming-System

Das Theming basiert auf **pywal** und ist vollständig dynamisch:

```
Wallpaper
    └─▶ pywal generiert Farbpalette
            ├─▶ i3 (i3-msg reload)
            ├─▶ Kitty (SIGUSR1)
            ├─▶ Polybar (launch.sh neu starten)
            └─▶ Dunst (dunstrc aus pywal-Cache → SIGUSR2)
```

Das `wallpaper`-Kommando orchestriert den gesamten Prozess:

```bash
wallpaper /pfad/zum/bild.jpg
```

---

## Verzeichnisstruktur

```
linux-mint-general/
├── install.sh              # Bootstrap (git clone + make all)
├── Makefile                # Orchestrierung aller Setup-Scripts
├── scripts/
│   ├── utils.sh            # Farben, Logging-Funktionen, Hilfsfunktionen
│   ├── packages.sh         # apt Pakete
│   ├── fonts.sh            # Nerd Fonts
│   ├── languages.sh        # nvm, pyenv, sdkman
│   ├── shell.sh            # Zsh, Oh My Zsh, Starship
│   ├── terminal.sh         # Kitty
│   ├── wm.sh               # i3, Polybar, Rofi, Picom, Dunst
│   ├── theming.sh          # pywal
│   ├── editors.sh          # VS Code, Zed, JetBrains
│   ├── shared.sh           # Shared Configs
│   └── wallpaper.sh        # Wallpaper + pywal Reload
└── config/
    ├── i3/                 # i3 Konfiguration
    ├── polybar/            # Polybar Konfiguration + launch.sh
    ├── rofi/               # Rofi Theme
    ├── kitty/              # Kitty Konfiguration
    ├── picom/              # Picom Konfiguration
    ├── dunst/              # Dunst Fallback-Config
    ├── zsh/                # .zshrc, .zprofile
    ├── starship/           # starship.toml
    └── pywal/
        └── templates/      # pywal Templates (dunstrc, ggf. weitere)
```

---

## Symlink-Verhalten

Das `symlink`-Hilfsskript in `utils.sh` sichert bestehende Dateien automatisch:

- Existiert die Zieldatei bereits als reguläre Datei → wird als `.bak` gespeichert
- Existiert sie bereits als Symlink → wird direkt überschrieben

---

## Troubleshooting

**`wallpaper`-Befehl nicht gefunden nach Installation**

```bash
export PATH="$HOME/.local/bin:$PATH"
# Dauerhaft: steht in ~/.zprofile / ~/.zshrc
```

**Polybar startet nicht**

```bash
cat /tmp/polybar.log
```

**pywal Farben werden nicht übernommen**

Sicherstellen, dass pywal mindestens einmal ausgeführt wurde, bevor i3 gestartet wird. Die Konfiguration von i3, Polybar und Dunst enthält pywal-Variablen, die erst nach dem ersten `wal`-Lauf existieren.

**JetBrains Toolbox: Setup abschließen**

Die Toolbox startet sich nach der Installation selbst. Den Einrichtungsdialog im UI abschließen.
