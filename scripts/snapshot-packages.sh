#!/bin/bash
set -e

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGES_DIR="$DOTFILES_ROOT/packages"

# Manually-installed apt packages (excludes auto-installed dependencies)
if command -v apt-mark >/dev/null 2>&1; then
    apt-mark showmanual | sort > "$PACKAGES_DIR/apt-manual.txt"
fi

# Snap packages (if snap is present)
if command -v snap >/dev/null 2>&1; then
    snap list --unicode=never 2>/dev/null \
        | tail -n +2 \
        | awk '{print $1}' \
        | sort > "$PACKAGES_DIR/snaps.txt"
fi

# Flatpak packages (if flatpak is present)
if command -v flatpak >/dev/null 2>&1; then
    flatpak list --columns=application 2>/dev/null \
        | sort > "$PACKAGES_DIR/flatpaks.txt"
fi

cd "$DOTFILES_ROOT"

# Only commit if something actually changed
if git diff --quiet -- packages/ && git diff --staged --quiet -- packages/; then
    exit 0
fi

git add packages/
# Runs unattended (systemd timer) where no pinentry is available, so don't GPG-sign.
git commit --no-gpg-sign -m "chore: update packages snapshot ($(date +%Y-%m-%d))"
git push || echo "snapshot: push deferred (no credentials?) — commit saved locally"
