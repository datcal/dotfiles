#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="mac"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


################################### Symlink stuff ############################
################### (Backs up the previous versions if they exist) ###########
# symlinks

DOTFILES_ROOT="$(pwd)"

backup_and_symlink() {
    local file=$1
    local target=$2

    if [[ -e "$target" ]]; then
        cp "$target" "${target}_bak"
    fi

    ln -sf "$DOTFILES_ROOT/$file" "$target"
}

# Install brew on macOS
if [[ "$OS" == "mac" ]]; then
    if ! command_exists brew; then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
    
    # Install via brew
    brew bundle --file=./Brewfile

    backup_and_symlink ".aliases" "$HOME/.aliases"
    backup_and_symlink ".gitconfig" "$HOME/.gitconfig"
    backup_and_symlink ".config/fish/config.fish" "$HOME/.config/fish/config.fish"
    
elif [[ "$OS" == "linux" ]]; then
    echo "Please ensure you have the necessary packages installed via your package manager."
    
    backup_and_symlink ".aliases" "$HOME/.aliases"
    backup_and_symlink ".gitconfig" "$HOME/.gitconfig"
fi



