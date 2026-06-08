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

## Neovim cheat sheet

Neovim has modes: you start in **Normal** mode (navigate + commands), press `i` to
type (**Insert**), and `Esc` to go back. The leader key is `Space`.

Open a file: `Space e` for the file tree (Enter opens, `Space e` closes it), or
`Space Space` to fuzzy-find by name. Search inside files with `Space /`.

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

Save and quit — `:w` save, `:q` quit, `:wq` save+quit, `:q!` quit without saving.
Switch between open files with `Shift-h` / `Shift-l`.

If you ever see a `No parser for language "..."` error, run `:TSInstall <lang>`
(e.g. `:TSInstall bash`) once to install that language's syntax highlighting.

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

Installed apt and flatpak packages are snapshotted to `packages/` every day by a
systemd timer, so the list stays current and a fresh install can recreate it.
Take a snapshot by hand any time with `./scripts/snapshot-packages.sh`.

## First launch notes

- Open a new terminal so zsh and the prompt take effect.
- In tmux, press `Ctrl-a` then `I` once to install its plugins.
- Run `nvim` once and let LazyVim download its plugins. After that, commit the
  generated `.config/nvim/lazy-lock.json` to pin the versions.
