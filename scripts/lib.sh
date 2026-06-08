#!/bin/bash
# scripts/lib.sh — shared helpers for install.sh / update.sh / doctor.sh.
# This file is SOURCED, never executed directly. Callers own `set -e`.

# Repo root, resolved relative to THIS file regardless of the caller's CWD.
DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# ---------------------------------------------------------------------------
# Declarative symlink map — the SINGLE source of truth for what gets linked.
# Format: "REPO_RELATIVE_SRC::ABSOLUTE_TARGET". Add one line per new dotfile;
# install.sh, update.sh and doctor.sh all read this array, so they can't drift.
# ---------------------------------------------------------------------------
DOTFILES_LINKS=(
    ".aliases::$HOME/.aliases"
    ".bashrc::$HOME/.bashrc"
    ".profile::$HOME/.profile"
    ".pam_environment::$HOME/.pam_environment"
    ".zshenv::$HOME/.zshenv"
    ".zprofile::$HOME/.zprofile"
    ".zshrc::$HOME/.zshrc"
    ".tmux.conf::$HOME/.tmux.conf"
    ".gitconfig::$HOME/.gitconfig"
    ".gitignore::$HOME/.gitignore"
    ".config/ghostty/config::$HOME/.config/ghostty/config"
    ".config/starship.toml::$HOME/.config/starship.toml"
    ".config/atuin/config.toml::$HOME/.config/atuin/config.toml"
    ".config/bat/config::$HOME/.config/bat/config"
    ".config/nvim::$HOME/.config/nvim"
    ".config/autostart/cosmic-quake-terminal.desktop::$HOME/.config/autostart/cosmic-quake-terminal.desktop"
    ".config/autostart/indicator-multiload.desktop::$HOME/.config/autostart/indicator-multiload.desktop"
    ".config/systemd/user/dotfiles-snapshot.service::$HOME/.config/systemd/user/dotfiles-snapshot.service"
    ".config/systemd/user/dotfiles-snapshot.timer::$HOME/.config/systemd/user/dotfiles-snapshot.timer"
)

# Back up a pre-existing real file/dir, then symlink src -> target.
# Uses `ln -sfn` so re-linking a DIRECTORY (e.g. .config/nvim) replaces the
# link in place instead of nesting a new link inside it — keeps re-runs idempotent.
backup_and_symlink() {
    local src="$DOTFILES_ROOT/$1"
    local target="$2"

    mkdir -p "$(dirname "$target")"

    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "  Backing up $target → ${target}_bak"
        cp -r "$target" "${target}_bak"
    fi

    ln -sfn "$src" "$target"
    echo "  Linked $target → $src"
}

# Link everything in DOTFILES_LINKS.
link_all() {
    echo "Symlinking dotfiles..."
    local pair src target
    for pair in "${DOTFILES_LINKS[@]}"; do
        src="${pair%%::*}"
        target="${pair##*::}"
        backup_and_symlink "$src" "$target"
    done
}

# True if a command exists on PATH.
have() { command -v "$1" >/dev/null 2>&1; }

# ---------------------------------------------------------------------------
# Idempotent tool installers. Each is a no-op when the tool is already present,
# and each tolerates a missing network/curl so install.sh never aborts on them.
# ---------------------------------------------------------------------------
install_starship() {
    have starship && return 0
    have curl || { echo "  starship: curl missing, skipping"; return 0; }
    curl -sS https://starship.rs/install.sh | sh -s -- -y -b "$HOME/.local/bin"
}

install_zoxide() {
    have zoxide && return 0
    have curl || { echo "  zoxide: curl missing, skipping"; return 0; }
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
}

install_atuin() {
    have atuin && return 0
    have curl || { echo "  atuin: curl missing, skipping"; return 0; }
    curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh | sh
}

install_eza() {
    have eza && return 0
    have cargo || { echo "  eza: cargo missing, skipping"; return 0; }
    cargo install eza
}

install_delta() {
    have delta && return 0
    have curl || { echo "  delta: curl missing, skipping"; return 0; }
    have dpkg || { echo "  delta: dpkg missing, skipping"; return 0; }
    local ver="0.18.2" arch deb tmp
    arch="$(dpkg --print-architecture)"
    deb="git-delta_${ver}_${arch}.deb"
    tmp="$(mktemp -d)"
    if curl -sSfL "https://github.com/dandavison/delta/releases/download/${ver}/${deb}" -o "$tmp/$deb"; then
        sudo dpkg -i "$tmp/$deb" || echo "  delta: dpkg install failed"
    else
        echo "  delta: download failed (arch=$arch), skipping"
    fi
    rm -rf "$tmp"
}

install_zinit() {
    local d="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
    [ -d "$d" ] && return 0
    have git || { echo "  zinit: git missing, skipping"; return 0; }
    git clone https://github.com/zdharma-continuum/zinit "$d"
}

install_tpm() {
    local d="$HOME/.tmux/plugins/tpm"
    [ -d "$d" ] && return 0
    have git || { echo "  tpm: git missing, skipping"; return 0; }
    git clone https://github.com/tmux-plugins/tpm "$d"
}

setup_bat_theme() {
    # bat has no built-in Tokyo Night theme; fetch the tmTheme and build cache.
    local bat_bin theme_dir
    if have bat; then bat_bin=bat; elif have batcat; then bat_bin=batcat; else
        echo "  bat-theme: bat not installed, skipping"; return 0
    fi
    theme_dir="$("$bat_bin" --config-dir 2>/dev/null)/themes"
    mkdir -p "$theme_dir"
    if [ ! -f "$theme_dir/tokyonight_night.tmTheme" ]; then
        have curl || { echo "  bat-theme: curl missing, skipping"; return 0; }
        curl -sSfL "https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/sublime/tokyonight_night.tmTheme" \
            -o "$theme_dir/tokyonight_night.tmTheme" || { echo "  bat-theme: download failed"; return 0; }
    fi
    "$bat_bin" cache --build >/dev/null 2>&1 || true
}

install_nerd_font() {
    fc-list 2>/dev/null | grep -qi "JetBrainsMono Nerd" && return 0
    have curl || { echo "  nerd-font: curl missing, skipping"; return 0; }
    local ver="v3.2.1" tmp dir="$HOME/.local/share/fonts"
    mkdir -p "$dir"
    tmp="$(mktemp -d)"
    if curl -sSfL "https://github.com/ryanoasis/nerd-fonts/releases/download/${ver}/JetBrainsMono.zip" -o "$tmp/jbm.zip"; then
        if have unzip; then
            unzip -oq "$tmp/jbm.zip" -d "$dir"
            fc-cache -f >/dev/null 2>&1 || true
        else
            echo "  nerd-font: unzip missing, skipping"
        fi
    else
        echo "  nerd-font: download failed, skipping"
    fi
    rm -rf "$tmp"
}

# Run every optional installer. Each call is wrapped so one failure never
# aborts the caller (which runs under `set -e`) — the symlink phase must stay
# reachable.
install_terminal_tools() {
    echo "Installing terminal tools (idempotent)..."
    install_starship  || echo "  warn: starship skipped"
    install_zoxide    || echo "  warn: zoxide skipped"
    install_atuin     || echo "  warn: atuin skipped"
    install_eza       || echo "  warn: eza skipped"
    install_delta     || echo "  warn: delta skipped"
    install_zinit     || echo "  warn: zinit skipped"
    install_tpm       || echo "  warn: tpm skipped"
    install_nerd_font || echo "  warn: nerd-font skipped"
    setup_bat_theme   || echo "  warn: bat-theme skipped"
}
