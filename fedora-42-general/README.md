# Fedora KDE Setup

Automatisiertes Setup für eine vollständige Fedora Entwicklungsumgebung mit Sway (Wayland) als primärer Session, KDE Plasma als Fallback, Kitty Terminal und pywal-Theming mit einem statischen, semantischen Farbschema (unabhängig vom Wallpaper).

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
| Container Runtime | [Podman](https://podman.io/) (rootless) + `podman-compose` + `podman-docker` (docker-CLI-Kompatibilität) + `podman-tui` |
| Node.js | [nvm](https://github.com/nvm-sh/nvm) |
| Python | [pyenv](https://github.com/pyenv/pyenv) |
| Java | [sdkman](https://sdkman.io/) |
| Build Tool | Maven (via sdkman) |
| SSH Access | OpenSSH (key-only) |

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
make languages  # Node.js, Python, Java, Maven
make shell      # Zsh, Oh My Zsh, Starship
make terminal   # Kitty
make wm         # Sway, Waybar, Wofi, Mako, KDE Plasma (Fallback), SDDM
make theming    # pywal
make editors    # VS Code, Zed, JetBrains Toolbox
make containers # Podman, podman-compose, podman-docker, podman-tui
make ssh        # OpenSSH Server, key-only auth
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
- **Modernes CLI:** `ripgrep`, `fd-find`, `bat`, `fzf`
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
| Maven | 3.9.16 | sdkman |

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
config/wofi/    → ~/.config/wofi/
```

> **Mako** wird **nicht** symlinkt — pywal generiert `~/.config/mako/config` bei jeder Theme-Anwendung (`apply-theme`) neu.
>
> **Wofi** löst relative `@import`-Pfade in `style.css` gegen `$HOME` auf, nicht gegen das Verzeichnis der CSS-Datei selbst (gefunden via `WAYLAND_DEBUG=1 wofi --show drun`, bestätigt durch eine GTK-Fehlermeldung). `style.css` importiert deshalb bewusst `.cache/wal/colors-wofi.css` (ohne führenden Slash, ohne `~`) — landet nach der `$HOME`-Auflösung direkt beim echten pywal-Cache. Kein Symlink-Trick, kein hartcodierter Username nötig.

---

### `make theming` — pywal

- Installiert **pywal** via pipx
- Symlinkt pywal-Templates: `config/pywal/templates/ → ~/.config/wal/templates/`
- Symlinkt das statische Farbschema: `config/pywal/colorschemes/tailwind-dark.json → ~/.config/wal/colorschemes/dark/tailwind-dark.json`
- Erstellt `~/wallpapers/` Verzeichnis
- Installiert die Hilfsskripte `wallpaper` und `apply-theme` nach `~/.local/bin/`
- Wendet das `tailwind-dark`-Farbschema sofort an (`apply-theme tailwind-dark`) — unabhängig davon, ob bereits ein Wallpaper-Bild gesetzt ist
- Setzt das Standard-Wallpaper-Bild (`lunar-tides.jpg`), falls vorhanden
- Installiert **sunwait** und richtet automatisches Hell/Dunkel-Umschalten für Firefox/GTK-Apps ein (siehe [Automatisches Hell/Dunkel-Umschalten](#automatisches-helldunkel-umschalten) unten)

KDE Plasma bekommt **kein** Theming durch dieses Setup — die Fallback-Session behält, was du dort manuell einstellst.

> pywal hat kein Wayland-Wallpaper-Backend. `wal --theme ... -n` läuft daher immer mit `-n`; das Wallpaper wird komplett unabhängig davon über `swaybg` gesetzt (siehe Theming-System unten).

---

### `make editors` — Editoren

- **VS Code** via Microsoft RPM-Repository
- **Zed** via offiziellem Installer
- **JetBrains Toolbox** v2.3.2 (startet sich automatisch, UI-Installation erforderlich)

---

### `make containers` — Container Runtime

- **Podman** — rootless, daemonless Container-Runtime (Fedoras Standard, kein Docker-Repo nötig)
- **podman-compose** — Compose-Datei-Support
- **podman-docker** — stellt `/usr/bin/docker` als echten Wrapper auf `podman` bereit, `docker`-Befehle funktionieren dadurch unverändert (auch in Scripts, nicht nur interaktiv)
- **podman-tui** — TUI zur Container-/Image-/Volume-Verwaltung, spricht nativ mit Podmans API

Aktiviert zusätzlich den rootless Podman-API-Socket (`systemctl --user enable --now podman.socket`) für Tools, die einen echten Docker-kompatiblen Socket erwarten (z. B. IDE-Erweiterungen), nicht nur die CLI.

---

### `make ssh` — SSH Server

- Installiert `openssh-server` (idempotent, falls noch nicht vorhanden)
- Generiert ein eigenes ed25519-Keypair unter `~/.ssh/id_ed25519_workstation` — ein bereits vorhandener Key wird **nie** überschrieben oder neu generiert
- Trägt den Public Key in `~/.ssh/authorized_keys` ein
- Härtet `sshd` über eine Drop-in-Datei (`/etc/ssh/sshd_config.d/99-key-only.conf`): **Passwort-Login ist deaktiviert**, nur Key-basierte Authentifizierung ist erlaubt
- Aktiviert und startet den `sshd`-Service, öffnet den `ssh`-Service in `firewalld` (dort meist schon standardmäßig erlaubt)

> Der generierte Private Key verlässt die Maschine **nicht automatisch** und ist nicht Teil des Repos. Um dich von einem anderen Rechner aus einzuloggen, den Private Key manuell dorthin kopieren, z. B.:
> ```bash
> scp ~/.ssh/id_ed25519_workstation <client>:~/.ssh/
> ssh -i ~/.ssh/id_ed25519_workstation <user>@<ip>
> ```

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

### 2. Wallpaper setzen (optional)

Das Farbschema (`tailwind-dark`) ist bereits durch `make theming` aktiv und **unabhängig vom Wallpaper-Bild**. `wallpaper` ändert nur das Hintergrundbild, nicht die Farben:

```bash
wallpaper ~/wallpapers/mein-bild.jpg
```

Um ein anderes (oder ein eigenes) Farbschema anzuwenden:

```bash
apply-theme tailwind-dark   # Standard-Theme dieses Setups
apply-theme catppuccin-mocha   # oder ein beliebiges pywal-Theme / eigene JSON-Datei
```

### 3. Sway starten

Über SDDM als Session auswählen (Sway ist nach `make wm` beim ersten Login vorausgewählt), oder KDE Plasma als Fallback-Session wählen.

---

## Theming-System

Das Theming basiert auf **pywal**, verwendet aber ein **statisches, fest entworfenes Farbschema** (`tailwind-dark`) statt einer aus dem Wallpaper extrahierten Palette — ein einfarbiges (schwarz/grau/weißes) Wallpaper würde sonst eine praktisch einfarbige Palette erzeugen und z. B. Waybar-Module, Mako-Dringlichkeitsstufen oder Git-Diff-Farben im Terminal ununterscheidbar machen. Wallpaper-Bild und Farbschema sind dadurch **vollständig entkoppelt**:

```
apply-theme <name>                    wallpaper <bild>
    └─▶ wal --theme <name> -n              └─▶ swaybg (kill + relaunch mit neuem Bild)
            ├─▶ Sway (swaymsg reload)
            ├─▶ Kitty (SIGUSR1)
            ├─▶ Waybar (SIGUSR2 — Live-Reload, kein Neustart)
            ├─▶ Mako (Config kopieren + makoctl reload)
            └─▶ Wofi (liest ~/.cache/wal live beim nächsten Start, kein Reload nötig)
```

`apply-theme` ändert nie das Wallpaper-Bild, `wallpaper` ändert nie die Farben. `wal --theme` parst ausschließlich die JSON-Datei des gewählten Schemas — keine Bildanalyse, keine Farbextraktion (siehe `pywal/theme.py`).

KDE Plasma wird von diesem Setup **gar nicht** angefasst — Theme, Farben, Panels bleiben, wie du sie dort selbst konfigurierst.

### Semantische Farbrollen (`tailwind-dark`)

Jede der 16 pywal-Farbslots hat eine feste Bedeutung, angelehnt an Tailwind-CSS-Farbfamilien:

| Rolle | Slot | Tailwind | Hex |
|---|---|---|---|
| `surface` (Hintergrund) | `background` | slate-950 | `#020617` |
| `text-primary` | `foreground` | slate-200 | `#e2e8f0` |
| `cursor` / `primary` | `cursor`, `color4` | indigo-500 | `#6366f1` |
| `surface-alt` | `color0` | slate-900 | `#0f172a` |
| `error` | `color1` | rose-500 | `#f43f5e` |
| `success` | `color2` | emerald-500 | `#10b981` |
| `warning` | `color3` | amber-500 | `#f59e0b` |
| `neutral-dim` | `color5` | slate-500 | `#64748b` |
| `info` | `color6` | cyan-500 | `#06b6d4` |
| `text-muted` | `color7` | slate-400 | `#94a3b8` |
| `color8`-`color14` | *_bright-Varianten von oben (Hover/Emphasis)* | — | siehe `config/pywal/colorschemes/tailwind-dark.json` |
| bright white / emphasis | `color15` | slate-50 | `#f8fafc` |

`primary` (indigo) markiert überall "fokussiert/aktiv" (fokussiertes Sway-Fenster, aktiver Waybar-Workspace, ausgewählter Wofi-Eintrag) — bewusst getrennt von `success` (grün), das zuvor beide Bedeutungen trug. Waybar-Module (`cpu`/`memory`/`network`/`pulseaudio`) dürfen die Akzentfarben frei zur Kategorisierung wiederverwenden, ohne dass das einen Status (Fehler/Erfolg) impliziert — die Bedeutung ist kontextabhängig pro Fläche, nicht global.

Für Text auf farbigem Grund (z. B. eine Mako-Notification oder ein Waybar-Pill) gilt: heller Text (`color15`) auf `primary`, dunkler Text (`background`) auf `success`/`warning`/`error`/`info` — kontrastgeprüft nach WCAG-Luminanz.

Ein eigenes Farbschema erstellen: JSON-Datei nach dem Schema in `config/pywal/colorschemes/tailwind-dark.json` anlegen (`special.background/foreground/cursor` + `colors.color0`–`color15`), unter `config/pywal/colorschemes/<name>.json` ablegen, in `theming.sh` einen zusätzlichen `symlink`-Aufruf nach `~/.config/wal/colorschemes/dark/<name>.json` ergänzen, danach `apply-theme <name>`.

---

## Automatisches Hell/Dunkel-Umschalten

Sway ist (anders als GNOME/KDE) kein volles Desktop-Environment und hat daher keine eingebaute Zeitplan-Funktion für Hell/Dunkel — Firefox' "Automatisch ans System anpassen" folgt aber trotzdem `org.gnome.desktop.interface color-scheme`, sofern `xdg-desktop-portal-gtk` läuft (bereits über die KDE-Plasma-Fallback-Session als Abhängigkeit vorhanden). `make theming` richtet dafür `sunwait` + einen systemd-User-Timer ein, der alle 15 Minuten prüft, ob gerade Tag oder Nacht ist, und `color-scheme` nur bei tatsächlicher Änderung umschaltet (`gsettings`):

```
sunset-theme.timer (alle 15 Min, + 1 Min nach Boot)
    └─▶ sunset-theme
            ├─▶ sunwait -p <lat> <lon>                 # Text-Report mit Sonnenauf-/-untergang
            ├─▶ "Sun rises HHMM, sets HHMM" extrahieren, mit aktueller Uhrzeit vergleichen
            └─▶ gsettings set org.gnome.desktop.interface color-scheme prefer-light|prefer-dark
```

Das Fedora-Paket `sunwait` ist die alte Version von 2004 (nicht der neuere, community-geforkte `poll`-Modus) — es liefert keinen fertigen Tag/Nacht-Exit-Code, sondern nur einen Text-Report per `-p`, aus dem `sunset-theme.sh` die Uhrzeiten für Sonnenauf- und -untergang herauspars't und selbst mit der aktuellen Uhrzeit vergleicht. Außerdem kennt diese Version für Längengrade nur den Suffix `W` — östliche Längen (wie Berlin) müssen deshalb als *negativer* W-Wert angegeben werden (`-13.4132W` statt `13.4132E`).

Betroffen sind nur Firefox und andere GTK/Portal-Apps mit "Automatisch" — Sway, Waybar, Mako, Kitty und das pywal-Farbschema bleiben unverändert, da es noch kein helles pywal-Schema gibt. `sunset-theme.sh` enthält dazu einen Kommentar mit der Idee, das später per `apply-theme` zu ergänzen.

> **Koordinaten:** Da dieses Repo öffentlich auf GitHub liegt, sind in `sunset-theme.sh` bewusst grobe Koordinaten (Berlin Alexanderplatz) statt der exakten Heimadresse hinterlegt — für Sonnenauf-/-untergang genau genug, ohne den eigenen Standort preiszugeben. Bei Bedarf einfach `LAT`/`LON` im Skript anpassen (Achtung Vorzeichen-Eigenheit oben).

`sunset-theme` manuell ausführen oder Timer-Status prüfen:

```bash
sunset-theme
systemctl --user list-timers sunset-theme.timer
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
│   ├── languages.sh         # nvm, pyenv, sdkman (Java, Maven)
│   ├── shell.sh              # Zsh, Oh My Zsh, Starship
│   ├── terminal.sh           # Kitty
│   ├── wm.sh                 # Sway, Waybar, Wofi, Mako, KDE Plasma, SDDM
│   ├── theming.sh             # pywal
│   ├── editors.sh              # VS Code, Zed, JetBrains
│   ├── containers.sh            # Podman, podman-compose, podman-docker, podman-tui
│   ├── ssh.sh                     # OpenSSH Server, key-only auth
│   ├── shared.sh                # Shared Configs
│   ├── wallpaper.sh              # Setzt nur das Wallpaper-Bild (swaybg)
│   ├── apply-theme.sh             # Wendet ein pywal-Farbschema an + Reload-Kette
│   └── sunset-theme.sh             # Schaltet GTK color-scheme nach Sonnenstand um (sunwait)
└── config/
    ├── sway/                # Sway Konfiguration
    ├── waybar/               # Waybar Konfiguration + Style
    ├── wofi/                  # Wofi Konfiguration + Style
    ├── kitty/                   # Kitty Konfiguration
    ├── mako/                     # Mako Fallback-Config
    ├── zsh/                        # .zshrc, .zprofile
    ├── starship/                    # starship.toml
    ├── systemd/
    │   └── user/                      # sunset-theme.service + .timer
    └── pywal/
        ├── templates/                # pywal Templates (colors.sway, colors-waybar.css, colors-wofi.css, mako)
        └── colorschemes/               # Statische Farbschemata (tailwind-dark.json)
```

---

## Symlink-Verhalten

Das `symlink`-Hilfsskript in `utils.sh` sichert bestehende Dateien automatisch:

- Existiert die Zieldatei bereits als reguläre Datei → wird als `.bak` gespeichert
- Existiert sie bereits als Symlink → wird direkt überschrieben

Waybar bekommt zusätzlich einen separaten Symlink `colors-waybar.css → ~/.cache/wal/colors-waybar.css` innerhalb seines Config-Verzeichnisses, da GTK-CSS `~` in `@import` nicht auflöst und Waybar relative Pfade gegen das Verzeichnis der CSS-Datei auflöst. Wofi braucht diesen Trick nicht — es löst relative `@import`-Pfade ohnehin gegen `$HOME` auf (siehe oben), `style.css` importiert daher direkt `.cache/wal/colors-wofi.css`.

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

`make theming` ruft `apply-theme tailwind-dark` bereits automatisch auf. Falls die Konfiguration von Sway, Waybar oder Mako trotzdem noch pywal-Variablen ohne Werte zeigt, einmal manuell nachholen:

```bash
apply-theme tailwind-dark
```

**JetBrains Toolbox: Setup abschließen**

Die Toolbox startet sich nach der Installation selbst. Den Einrichtungsdialog im UI abschließen.
