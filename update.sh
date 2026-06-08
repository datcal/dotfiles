#!/bin/bash
set -e

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$DOTFILES_ROOT/scripts/lib.sh"

echo "Re-symlinking dotfiles..."
link_all

command -v systemctl >/dev/null 2>&1 && systemctl --user daemon-reload || true

echo ""
echo "Done. Open a new terminal for changes to take effect."
