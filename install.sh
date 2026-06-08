#!/bin/bash
set -e

if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo "This repo is Linux-only. For macOS, see ~/project/dotfiles-mac."
    exit 1
fi

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "Installing packages..."
sudo apt-get update -q
sudo apt-get install -y \
    git \
    git-lfs \
    gpg \
    xclip \
    htop \
    curl \
    build-essential

git lfs install

backup_and_symlink() {
    local src="$DOTFILES_ROOT/$1"
    local target="$2"

    mkdir -p "$(dirname "$target")"

    if [[ -e "$target" && ! -L "$target" ]]; then
        echo "  Backing up $target → ${target}_bak"
        cp -r "$target" "${target}_bak"
    fi

    ln -sf "$src" "$target"
    echo "  Linked $target → $src"
}

echo "Symlinking dotfiles..."
backup_and_symlink ".aliases"                          "$HOME/.aliases"
backup_and_symlink ".bashrc"                           "$HOME/.bashrc"
backup_and_symlink ".profile"                          "$HOME/.profile"
backup_and_symlink ".pam_environment"                  "$HOME/.pam_environment"
backup_and_symlink ".gitconfig"                        "$HOME/.gitconfig"
backup_and_symlink ".gitignore"                        "$HOME/.gitignore"
backup_and_symlink ".config/ghostty/config"            "$HOME/.config/ghostty/config"
backup_and_symlink ".config/autostart/cosmic-quake-terminal.desktop" \
                                                       "$HOME/.config/autostart/cosmic-quake-terminal.desktop"
backup_and_symlink ".config/autostart/indicator-multiload.desktop" \
                                                       "$HOME/.config/autostart/indicator-multiload.desktop"

echo ""
echo "Done. Open a new terminal for changes to take effect."
