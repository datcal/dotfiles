# dotfiles

My Linux setup (Ghostty terminal, themed Tokyo Night). `install.sh` is
distro-aware — it works on **Arch/CachyOS** (pacman) and **Debian/Pop!_OS**
(apt), under KDE Plasma or COSMIC. Clone it on a new machine, run `./install.sh`,
and the terminal looks and works the same everywhere.

## Install

```sh
git clone git@github.com:datcal/dotfiles.git ~/project/dotfiles
cd ~/project/dotfiles
./install.sh
```

This installs the packages, links all the config files into `$HOME`, installs the
terminal tools, and sets zsh as the default shell. Open a new terminal afterwards.

If you already had real config files (e.g. `~/.bashrc`), they're backed up to
`*_bak` before being replaced with a symlink — nothing is lost.

## Day to day

- **Change a config** — edit the file here in the repo. It's symlinked, so the
  change is live immediately. Commit when you're happy with it.
- **Pull on another machine** — `git pull && ./update.sh` re-links anything new.
- **Check everything is linked** — `./scripts/doctor.sh`. It also tells you which
  tools are installed.

## What's in here

| File | What it's for |
|------|---------------|
| `.zshrc` / `.zshenv` / `.zprofile` | zsh shell (plugins, prompt, tool setup) |
| `.bashrc` / `.profile` | bash (kept as a fallback shell) |
| `.aliases` | git/navigation shortcuts, shared by both shells |
| `.tmux.conf` | tmux — terminal splits and saved sessions |
| `.config/nvim/` | Neovim (LazyVim) |
| `.config/starship.toml` | the prompt |
| `.config/ghostty/config` | Ghostty (main terminal): theme, quick-terminal, copy/paste |
| `.config/terminator/config` | Terminator: copy-on-select, `Ctrl+V` paste |
| `.local/share/konsole/`, `.local/share/kxmlgui5/konsole/` | Konsole/Yakuake profile + `Ctrl+V` / `Ctrl+Shift+V` paste |
| `.gitconfig` / `.gitignore` | git |
| `.config/atuin`, `.config/bat` | history search, prettier `cat` |
| `packages/` | list of installed apt/flatpak packages |
| `scripts/` | install helpers, daily snapshot, and `setup-kde.sh` (KDE settings) |

Everything is themed **Tokyo Night**.

## The tools

| Tool | What you get |
|------|--------------|
| **zsh** | autosuggestions, syntax highlighting, tab completion |
| **starship** | prompt that shows the git branch + status when you're in a repo |
| **tmux** | `Ctrl-a` then `\|` / `-` to split, sessions survive reboots |
| **Neovim** | run `nvim`, LazyVim sets itself up on first launch |
| **fzf** | `Ctrl-R` fuzzy-search history, `Ctrl-T` find files |
| **zoxide** | `z foo` jumps to a folder you visit often |
| **eza** | nicer `ls` (icons, colors) |
| **bat** | `cat` with syntax highlighting |
| **delta** | colored, readable `git diff` |
| **atuin** | better shell history (`Ctrl-R`) |

## Neovim cheat sheet

Neovim has modes: you start in **Normal** mode (navigate + commands), press `i` to
type (**Insert**), and `Esc` to go back. The leader key is `Space`.

Open the **file explorer**: `Ctrl-n` jumps your cursor *into* the file tree
(opening it if needed, but never closing it), while `Space e` toggles the tree
open/closed. In the tree, `Enter` opens a file and `Ctrl-w l` (or just click the
file) jumps back to your code. `Space Space` fuzzy-finds a file by name. Dotfiles
(`.gitignore`, `.env`, …) are always shown in the tree here.

In the file tree (the Snacks explorer):

| Keys | Action |
|------|--------|
| `Enter` / `l` | open file / expand folder |
| `h` | collapse the folder (`Z` collapses everything) |
| `H` / `I` | toggle dotfiles / git-ignored files (both shown by default here) |
| `a` / `r` / `d` | add file / rename / delete |
| `c` / `m` | copy / move the file to a new path |
| `y` / `p` | yank (copy) / paste the file within the tree |
| `P` | preview the file |
| `Space /` | search (grep) inside the tree's folder |

Move around:

| Keys | Moves |
|------|-------|
| `h` `j` `k` `l` | left, down, up, right |
| `w` / `b` / `e` | next word / previous word / end of word |
| `0` / `^` / `$` | start of line / first non-blank / end of line |
| `gg` / `G` | top / bottom of file |
| `42G` or `:42` | go to line 42 |
| `{` / `}` | previous / next blank line (paragraph block) |
| `[{` / `]}` / `%` | start / end / matching brace of the current `{ }` block |
| `Ctrl-d` / `Ctrl-u` | half page down / up |
| `H` `M` `L` | top / middle / bottom of the screen |

Select a block (Visual mode) — `v` char, `V` whole lines, `Ctrl-v` column. Then
text objects (`i` = inside, `a` = around): `vip` paragraph, `vi{` braces block,
`vi(` parens, `vi"` quotes, `viw` word.

Edit — `y` copy, `d` cut, `p`/`P` paste after/before, `u` undo, `Ctrl-r` redo:

| Keys | Action |
|------|--------|
| `yy` / `dd` | copy / cut the line |
| `y` / `d` in Visual | copy / cut the selection |
| `Alt-j` / `Alt-k` | move the line (or selection) down / up |
| `ci"` `da(` `yi{` | change-inside-quotes / delete-around-parens / yank-inside-braces |

Search (the `/` mode) — search inside the file you're editing:

| Keys | Action |
|------|--------|
| `/foo` then `Enter` | search forward for `foo` (highlights as you type) |
| `?foo` then `Enter` | search backward |
| `n` / `N` | jump to next / previous match |
| `*` / `#` | search for the word under the cursor (forward / back) |
| `Esc` | clear the search highlight |
| `Space /` | search *across all files* in the project (live grep) |

Quick terminal — a small terminal at the bottom of the window, for a one-off
command without leaving Neovim or switching tmux windows:

| Keys | Action |
|------|--------|
| `Ctrl-/` | open / close the horizontal terminal (works from inside it too) |
| `Ctrl-\` `Ctrl-n` | leave terminal typing → Normal mode (then `Ctrl-/` to close) |
| `Space f t` | a floating terminal instead |

Bigger / smaller text — the font is the terminal's job, so this is **Ghostty**
(not a Neovim setting), and it affects everything on screen: `Ctrl-+` grows the
text, `Ctrl--` shrinks it, `Ctrl-0` resets to the default size.

Save and quit — `:w` save, `:q` quit, `:wq` save+quit, `:q!` quit without saving.
Switch between open files with `Shift-h` / `Shift-l`.

If you ever see a `No parser for language "..."` error, run `:TSInstall <lang>`
(e.g. `:TSInstall bash`) once to install that language's syntax highlighting.

Languages — **Go** is set up out of the box (LSP `gopls`, autocomplete, jump to
definition with `gd`, hover docs with `K`, and auto-format + organize imports on
save). The first time you open a `.go` file, Neovim downloads the tools in the
background — give it a moment, or watch progress with `:Mason`. Other languages
work the same way; add one with `:LazyExtras` (then pick e.g. `lang.python`).

Git (the leader is `Space`):

| Keys | Action |
|------|--------|
| `Space g g` | open **lazygit** (stage, commit, push, branches) |
| `Space g l` | git log (commits) |
| `Space g s` | git status |
| `Space g b` | blame the current line |
| `]h` / `[h` | jump to next / previous changed hunk |
| `Space g h s` / `Space g h r` | stage / reset the hunk under the cursor |

## tmux cheat sheet

The prefix is `Ctrl-a`. Press it, release, then the key:

| Keys | Action |
|------|--------|
| `Ctrl-a` then `\|` / `-` | split pane vertically / horizontally |
| `Ctrl-a` then `h` `j` `k` `l` | move between panes |
| `Ctrl-a` then `c` | new window (tab) |
| `Ctrl-a` then `I` | install plugins (first launch) |
| `Ctrl-a` then `d` | detach — the session keeps running |
| `tmux attach` | reattach to it later |

Sessions auto-save, so they come back after a reboot.

## Packages

Installed packages are snapshotted to `packages/` every day by a systemd timer,
so the list stays current and a fresh install can recreate it: `apt-manual.txt`
(Debian/Pop), `pacman-explicit.txt` + `pacman-aur.txt` (Arch/CachyOS),
`flatpaks.txt`, `snaps.txt`. Snapshot by hand any time with
`./scripts/snapshot-packages.sh`.

## KDE Plasma settings

Some desktop settings can't be symlinked — Plasma rewrites and atomically replaces
its own `~/.config/*rc` files, which would clobber a repo symlink. So
`scripts/setup-kde.sh` applies them declaratively (and idempotently) instead:

- **Super (Meta) tap → KRunner** (Spotlight), not the application launcher.
- **Default Konsole profile** → the copy-on-select `Main.profile`.

`install.sh` runs it automatically; it's a no-op on non-KDE sessions (e.g. COSMIC).
Re-run any time with `./scripts/setup-kde.sh`, and add new Plasma tweaks there as
more `kwriteconfig` lines.

**Terminal copy/paste** (all terminals): **select to copy** (automatic),
**`Ctrl+Shift+C`** to copy explicitly, **`Ctrl+V`** and **`Ctrl+Shift+V`** to
paste. `Ctrl+C` stays as interrupt. (Terminator allows only one paste key → `Ctrl+V`.)

## Spotlight launcher (TODO — decide once on CachyOS)

Goal: a good-looking, themeable, Mac-style Spotlight opened with the **Super** key.
Options, most → least customizable:

- **Ulauncher** *(current lean)* — most themeable (swap/edit themes: colours, fonts,
  layout) + a big extension marketplace (emoji, translate, clipboard, calculator,
  web search…). Install: `paru -S ulauncher`.
- **Albert** — the truest Spotlight clone, Qt (cleanest on KDE/Wayland), very fast,
  Python plugins. `paru -S albert`. Theming via QML (a touch more technical).
- **KRunner** (built-in) — feature-rich via plugins, looks good with a Global Theme +
  centred position, zero install; but you can't redesign its layout.

Binding it to **Super**: on Wayland a third-party launcher can't grab Super itself, so
use the same KWin modifier-only D-Bus trick `setup-kde.sh` already uses. For Ulauncher:
find its toggle method (`busctl --user introspect io.ulauncher.Ulauncher /io/ulauncher/Ulauncher`)
and point `kwinrc → [ModifierOnlyShortcuts] Meta` at that D-Bus call. (`setup-kde.sh`
currently maps Super → KWin **Overview**; swap that one line for the chosen launcher.)

## First launch notes

- Open a new terminal so zsh and the prompt take effect.
- In tmux, press `Ctrl-a` then `I` once to install its plugins.
- Run `nvim` once and let LazyVim download its plugins. After that, commit the
  generated `.config/nvim/lazy-lock.json` to pin the versions.
