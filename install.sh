#!/bin/bash
set -e

if [[ "$OSTYPE" != "linux-gnu"* ]]; then
  echo "This repo is Linux-only. For macOS, see ~/project/dotfiles-mac."
  exit 1
fi

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$DOTFILES_ROOT/scripts/lib.sh"

if have sudo; then
  sudo -v
  # Keep sudo warm for the rest of the run.
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done 2>/dev/null &

  # Pick the package installer for this distro (both defined in lib.sh).
  if have pacman; then
    install_packages_arch       # CachyOS / Arch
  elif have apt-get; then
    install_packages_debian     # Pop!_OS / Ubuntu / Debian
  else
    echo "No supported package manager (pacman/apt-get) found — skipping packages."
  fi
else
  echo "Skipping package installation (sudo not available)."
fi

# Install tools that aren't in apt (starship, zoxide, atuin, eza, delta) plus
# zinit / TPM / Nerd Font. Each is idempotent and degrades gracefully offline.
install_terminal_tools

link_all

chmod +x "$DOTFILES_ROOT/scripts/snapshot-packages.sh" "$DOTFILES_ROOT/scripts/doctor.sh" "$DOTFILES_ROOT/scripts/setup-kde.sh"

# Apply KDE Plasma settings (Meta->KRunner, default Konsole profile). No-op off KDE.
"$DOTFILES_ROOT/scripts/setup-kde.sh" || echo "  warn: setup-kde skipped"

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
