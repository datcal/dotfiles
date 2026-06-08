#!/bin/bash
# scripts/doctor.sh — read-only health check. Verifies every tracked dotfile is
# correctly symlinked and reports which terminal tools are installed.

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
. "$DOTFILES_ROOT/scripts/lib.sh"

status=0

echo "== Symlinks =="
for pair in "${DOTFILES_LINKS[@]}"; do
    src="$DOTFILES_ROOT/${pair%%::*}"
    target="${pair##*::}"
    if [ ! -e "$src" ]; then
        printf "  MISSING SRC  : %s\n" "$src"; status=1
    elif [ ! -L "$target" ]; then
        printf "  NOT LINKED   : %s\n" "$target"; status=1
    elif [ ! -e "$target" ]; then
        printf "  DANGLING     : %s → %s\n" "$target" "$(readlink "$target")"; status=1
    elif [ "$(readlink -f "$target")" != "$(readlink -f "$src")" ]; then
        printf "  WRONG TARGET : %s → %s\n" "$target" "$(readlink "$target")"; status=1
    else
        printf "  OK           : %s\n" "$target"
    fi
done

echo ""
echo "== Tools =="
for t in zsh starship tmux nvim fzf zoxide eza bat batcat fd fdfind rg delta atuin git; do
    if have "$t"; then
        printf "  present : %s\n" "$t"
    else
        printf "  MISSING : %s\n" "$t"
    fi
done

echo ""
echo "== Leftovers =="
if [ -e "$HOME/.bash_aliases" ] && [ ! -L "$HOME/.bash_aliases" ]; then
    echo "  ~/.bash_aliases exists and is not managed (not sourced by tracked .bashrc)."
    echo "    Its aliases live in ~/.aliases already — safe to remove: rm ~/.bash_aliases"
else
    echo "  none"
fi

echo ""
if [ "$status" -eq 0 ]; then
    echo "All tracked dotfiles are correctly linked."
else
    echo "Some links need attention — run ./update.sh to (re)create them."
fi
exit $status
