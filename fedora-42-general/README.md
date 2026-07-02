# Fedora KDE Setup

Automatisiertes Setup für eine vollständige Fedora Entwicklungsumgebung mit Sway (Wayland) als primärer Session, KDE Plasma als Fallback, Kitty Terminal und dynamischem pywal-Theming.

---

## Stack

| Kategorie | Tool |
|-----------|------|
| Window Manager | [Sway](https://swaywm.org/) (Wayland) |
| Fallback Desktop | [KDE Plasma](https://kde.org/plasma-desktop/) |
| Status Bar | [Waybar](https://github.com/Alexays/Waybar) |
| Terminal | [Kitty](https://sw.kovidgoyal.net/kitty/) |
| Shell | [Zsh](https://www.zsh.org/) + [Oh My Zsh](https://ohmyz.sh/) |
| Prompt | [Starship](https://starship.rs/) |
| App Launcher | [Wofi](https://hg.sr.ht/~scoopta/wofi) |
| Notifications | [Mako](https://github.com/emersion/mako) |
| Theming | [pywal](https://github.com/dylanaraps/pywal) |
| Editoren | VS Code, Zed, JetBrains Toolbox |
| Node.js | [nvm](https://github.com/nvm-sh/nvm) |
| Python | [pyenv](https://github.com/pyenv/pyenv) |
| Java | [sdkman](https://sdkman.io/) |

Reine Wayland-Session — kein X11 (kein Xorg, kein XWayland-Tooling in den Scripts).

---

## Voraussetzungen

- Fedora (frische Installation empfohlen)
- Internetverbindung
- Ein normaler Benutzeraccount (kein Root)

---

## Schnellstart

Einzeiliger Bootstrap direkt nach der frischen Fedora-Installation:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/lueton/dotfiles/master/fedora-42-general/install.sh)
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
cd fedora-42-general
make all        # Alles auf einmal
```

Oder einzelne Komponenten:

```bash
make packages   # System-Pakete via dnf, RPM Fusion, Flathub, Intel VA-API
make fonts      # Nerd Fonts
make languages  # Node.js, Python, Java
make shell      # Zsh, Oh My Zsh, Starship
make terminal   # Kitty
make wm         # Sway, Waybar, Wofi, Mako, KDE Plasma (Fallback), SDDM
make theming    # pywal
make editors    # VS Code, Zed, JetBrains Toolbox
make shared     # Shared Configs (Git)
```

Die Targets sind idempotent — bereits installierte Komponenten werden übersprungen, und jedes Target kann gefahrlos mehrfach laufen.

---

## Was wird installiert

### `make packages` — System-Pakete

- **RPM Fusion** (Free + Nonfree) und **Flathub** werden aktiviert — dienen nur als Fallback für Pakete, die nicht offiziell über `dnf` verfügbar sind
- **Build-Tools:** `gcc`, `gcc-c++`, `make`, `cmake`, `pkgconf-pkg-config`
- **Utilities:** `curl`, `wget`, `git`, `unzip`, `tar`, `gnupg2`
- **Shell:** `zsh`
- **Terminal:** `kitty` (Fallback; wird auch via offiziellem Installer installiert)
- **System Tools:** `htop`, `btop`, `fastfetch`, `tmux`, `brightnessctl`
- **Modernes CLI:** `ripgrep`, `fd-find`, `bat`
- **Python:** `python3`, `python3-pip` + alle pyenv Build-Dependencies
- **Audio:** PipeWire-Stack (`pipewire`, `pipewire-pulseaudio`, `wireplumber`, `pavucontrol`)
- **Netzwerk:** `NetworkManager`, `network-manager-applet`
- **GTK Theming:** `lxappearance`, `papirus-icon-theme`
- **Media:** `mpv` (via RPM Fusion)
- **GPU:** `intel-media-driver-freeworld` für VA-API-Hardwarebeschleunigung (Intel-Onboard-Grafik)

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

- **Sway** — Wayland-natives Tiling
- **Waybar** — Status Bar
- **Wofi** — Application Launcher
- **Mako** — Notification Daemon
- **grim + slurp** — Screenshots
- **wl-clipboard** — Clipboard
- **KDE Plasma** (`kde-desktop-environment` Gruppe) — Fallback-Session, an SDDM wählbar
- **SDDM** — Display Manager, Sway als Default-Session (nur beim allerersten Login gesetzt)

Symlinks:

```
config/sway/  → ~/.config/sway/
config/waybar/config.jsonc, style.css → ~/.config/waybar/
config/wofi/config, style.css         → ~/.config/wofi/
```

> **Mako** wird **nicht** symlinkt — pywal generiert `~/.config/mako/config` bei jedem Wallpaper-Wechsel neu. Beim ersten Start wird eine statische Fallback-Config kopiert.

---

### `make theming` — pywal

- Installiert **pywal** via pipx
- Symlinkt pywal-Templates: `config/pywal/templates/ → ~/.config/wal/templates/`
- Erstellt `~/wallpapers/` Verzeichnis
- Installiert das `wallpaper`-Hilfsskript nach `~/.local/bin/wallpaper`

KDE Plasma bekommt **kein** Theming durch dieses Setup — die Fallback-Session behält, was du dort manuell einstellst.

> pywal hat kein Wayland-Wallpaper-Backend. `wal -i` läuft daher mit `-n`; das Wallpaper wird explizit über `swaybg` gesetzt (siehe Theming-System unten).

---

### `make editors` — Editoren

- **VS Code** via Microsoft RPM-Repository
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

Das pywal-Theming generiert ein Farbschema aus dem Wallpaper und überträgt es auf Sway, Kitty, Waybar und Mako:

```bash
# Aus einem eigenen Bild
wallpaper ~/wallpapers/mein-bild.jpg

# Mit einem vordefinierten pywal-Theme
wal --theme catppuccin-mocha -n
```

### 3. Sway starten

Über SDDM als Session auswählen (Sway ist nach `make wm` beim ersten Login vorausgewählt), oder KDE Plasma als Fallback-Session wählen.

---

## Theming-System

Das Theming basiert auf **pywal** und ist vollständig dynamisch — für die Sway-Session:

```
Wallpaper
    └─▶ pywal generiert Farbpalette (-n)
            ├─▶ Sway (swaymsg reload)
            ├─▶ Kitty (SIGUSR1)
            ├─▶ Waybar (SIGUSR2 — Live-Reload, kein Neustart)
            ├─▶ Mako (Config kopieren + makoctl reload)
            └─▶ swaybg (kill + relaunch mit neuem Bild)
```

KDE Plasma wird von diesem Setup **gar nicht** angefasst — Theme, Farben, Panels bleiben, wie du sie dort selbst konfigurierst.

Das `wallpaper`-Kommando orchestriert den gesamten Prozess:

```bash
wallpaper /pfad/zum/bild.jpg
```

---

## Verzeichnisstruktur

```
fedora-42-general/
├── install.sh              # Bootstrap (git clone + make all)
├── Makefile                # Orchestrierung aller Setup-Scripts
├── scripts/
│   ├── utils.sh            # Farben, Logging-Funktionen, Hilfsfunktionen
│   ├── packages.sh         # dnf + RPM Fusion + Flathub + intel-media-driver-freeworld
│   ├── fonts.sh             # Nerd Fonts
│   ├── languages.sh         # nvm, pyenv, sdkman
│   ├── shell.sh              # Zsh, Oh My Zsh, Starship
│   ├── terminal.sh           # Kitty
│   ├── wm.sh                 # Sway, Waybar, Wofi, Mako, KDE Plasma, SDDM
│   ├── theming.sh             # pywal
│   ├── editors.sh              # VS Code, Zed, JetBrains
│   ├── shared.sh                # Shared Configs
│   └── wallpaper.sh              # Wallpaper + pywal Reload-Kette
└── config/
    ├── sway/                # Sway Konfiguration
    ├── waybar/               # Waybar Konfiguration + Style
    ├── wofi/                  # Wofi Konfiguration + Style
    ├── kitty/                   # Kitty Konfiguration
    ├── mako/                     # Mako Fallback-Config
    ├── zsh/                        # .zshrc, .zprofile
    ├── starship/                    # starship.toml
    └── pywal/
        └── templates/                # pywal Templates (colors.sway, colors-waybar.css, colors-wofi.css, mako)
```

---

## Symlink-Verhalten

Das `symlink`-Hilfsskript in `utils.sh` sichert bestehende Dateien automatisch:

- Existiert die Zieldatei bereits als reguläre Datei → wird als `.bak` gespeichert
- Existiert sie bereits als Symlink → wird direkt überschrieben

Waybar und Wofi bekommen zusätzlich einen separaten Symlink `colors-*.css → ~/.cache/wal/colors-*.css` innerhalb ihres Config-Verzeichnisses, da GTK-CSS `~`/`$HOME` in `@import` nicht auflösen kann.

---

## Troubleshooting

**`wallpaper`-Befehl nicht gefunden nach Installation**

```bash
export PATH="$HOME/.local/bin:$PATH"
# Dauerhaft: steht in ~/.zprofile / ~/.zshrc
```

**Waybar startet nicht / falsche Farben**

```bash
waybar -l debug
```

**pywal Farben werden nicht übernommen**

Sicherstellen, dass `wallpaper <bild>` mindestens einmal ausgeführt wurde, bevor Sway gestartet wird. Die Konfiguration von Sway, Waybar und Mako enthält pywal-Variablen, die erst nach dem ersten Lauf existieren.

**JetBrains Toolbox: Setup abschließen**

Die Toolbox startet sich nach der Installation selbst. Den Einrichtungsdialog im UI abschließen.
