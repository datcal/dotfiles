# dotfiles

My Linux setup (Pop!_OS / COSMIC, Ghostty terminal). Clone it on a new machine,
run `./install.sh`, and the terminal looks and works the same everywhere.

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
| `.config/ghostty/config` | the terminal |
| `.gitconfig` / `.gitignore` | git |
| `.config/atuin`, `.config/bat` | history search, prettier `cat` |
| `packages/` | list of installed apt/flatpak packages |
| `scripts/` | the install helpers and the daily snapshot |

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

## Packages

Installed apt and flatpak packages are snapshotted to `packages/` every day by a
systemd timer, so the list stays current and a fresh install can recreate it.
Take a snapshot by hand any time with `./scripts/snapshot-packages.sh`.

## First launch notes

- Open a new terminal so zsh and the prompt take effect.
- In tmux, press `Ctrl-a` then `I` once to install its plugins.
- Run `nvim` once and let LazyVim download its plugins. After that, commit the
  generated `.config/nvim/lazy-lock.json` to pin the versions.
