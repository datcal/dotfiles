#!/bin/bash
# scripts/setup-kde.sh — apply KDE Plasma settings that must NOT be symlinked.
# Plasma rewrites (and atomically replaces) its rc files, which would clobber a
# symlink into the repo — so these settings are applied declaratively instead.
# Idempotent: safe to re-run. No-op on non-KDE systems (e.g. a COSMIC session).

set -e

# Prefer the Plasma 6 tool, fall back to Plasma 5 (Pop!_OS 24.04 ships kwriteconfig5).
KW=""
for c in kwriteconfig6 kwriteconfig5; do
  command -v "$c" >/dev/null 2>&1 && { KW="$c"; break; }
done
if [ -z "$KW" ]; then
  echo "setup-kde: no kwriteconfig found — not a KDE Plasma system, skipping."
  exit 0
fi
echo "setup-kde: using $KW"

# Super (Meta) tapped alone opens KRunner (Spotlight) instead of the app launcher.
"$KW" --file kwinrc --group ModifierOnlyShortcuts --key Meta \
  "org.kde.krunner,/App,org.kde.krunner.App,toggleDisplay"

# Use the copy-on-select Konsole profile by default (the profile file is symlinked).
"$KW" --file konsolerc --group "Desktop Entry" --key DefaultProfile "Main.profile"

# Apply the kwinrc change live (no logout needed).
if command -v qdbus >/dev/null 2>&1; then
  qdbus org.kde.KWin /KWin reconfigure >/dev/null 2>&1 || true
fi

echo "setup-kde: done."
