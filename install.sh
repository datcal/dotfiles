#!/bin/bash
set -e

if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo "This repo is Linux-only. For macOS, see ~/project/dotfiles-mac."
    exit 1
fi

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$DOTFILES_ROOT/scripts/lib.sh"

if have sudo && have apt-get; then
    sudo -v
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

    echo "Installing packages..."
    sudo apt-get update -q

    # Bootstrap essentials needed to run everything else
    sudo apt-get install -y git git-lfs gpg curl

    # Core terminal stack from apt (tools not in apt are handled below)
    sudo apt-get install -y zsh tmux fzf ripgrep bat fd-find unzip

    # Install the full saved package list if populated
    PACKAGES_FILE="$DOTFILES_ROOT/packages/apt-manual.txt"
    if [[ -s "$PACKAGES_FILE" ]] && grep -qv '^#' "$PACKAGES_FILE"; then
        echo "Installing from packages/apt-manual.txt..."
        grep -v '^#' "$PACKAGES_FILE" | xargs sudo apt-get install -y
    else
        echo "packages/apt-manual.txt not populated yet — installing defaults only."
        sudo apt-get install -y xclip htop build-essential
    fi

    git lfs install
else
    echo "Skipping package installation (sudo/apt-get not available)."
fi

# Install tools that aren't in apt (starship, zoxide, atuin, eza, delta) plus
# zinit / TPM / Nerd Font. Each is idempotent and degrades gracefully offline.
install_terminal_tools

link_all

chmod +x "$DOTFILES_ROOT/scripts/snapshot-packages.sh" "$DOTFILES_ROOT/scripts/doctor.sh"

# Make zsh the default login shell (only when it exists and isn't already default).
if have zsh && [ "$SHELL" != "$(command -v zsh)" ]; then
    zsh_path="$(command -v zsh)"
    if have sudo; then
        grep -qxF "$zsh_path" /etc/shells 2>/dev/null || echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
        # Use sudo (already authenticated above) so chsh never blocks on a
        # hidden password prompt.
        if sudo chsh -s "$zsh_path" "$USER"; then
            echo "Default shell set to zsh (log out/in to apply)."
        else
            echo "Could not change default shell automatically — run: chsh -s $zsh_path"
        fi
    elif chsh -s "$zsh_path"; then
        echo "Default shell set to zsh (log out/in to apply)."
    else
        echo "Could not change default shell automatically — run: chsh -s $zsh_path"
    fi
fi

if have systemctl; then
    echo "Enabling daily package snapshot timer..."
    systemctl --user daemon-reload
    systemctl --user enable --now dotfiles-snapshot.timer
    loginctl enable-linger "$USER"
else
    echo "Skipping systemd timer setup (systemctl not available)."
fi

echo ""
echo "Done. Open a new terminal for changes to take effect."
echo "Run 'scripts/doctor.sh' to verify everything is linked."
echo "First launch: tmux installs plugins via 'prefix + I'; nvim bootstraps LazyVim automatically."
