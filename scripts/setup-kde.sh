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

# Matching config reader (for idempotent merges of list-valued keys).
KR=""
for c in kreadconfig6 kreadconfig5; do
  command -v "$c" >/dev/null 2>&1 && { KR="$c"; break; }
done

# Super (Meta) tapped alone opens KRunner (Spotlight) instead of the app launcher.
"$KW" --file kwinrc --group ModifierOnlyShortcuts --key Meta \
  "org.kde.krunner,/App,org.kde.krunner.App,toggleDisplay"

# Use the copy-on-select Konsole profile by default (the profile file is symlinked).
"$KW" --file konsolerc --group "Desktop Entry" --key DefaultProfile "Main.profile"

# Dota 2: stop KWin compositing the game window. COSMIC unredirects fullscreen
# games automatically; KWin doesn't, which causes stutter on KDE only. This rule
# (WM_CLASS "dota2") force-blocks compositing whenever Dota is up — even in
# borderless ("Desktop friendly fullscreen"). Idempotent: appended only once.
DOTA_RULE="dota2-nocompositing"
existing=$("${KR:-true}" --file kwinrulesrc --group General --key rules 2>/dev/null || true)
case ",$existing," in
  *",$DOTA_RULE,"*) : ;;
  *)
    if [ -z "$existing" ]; then newrules="$DOTA_RULE"; else newrules="$existing,$DOTA_RULE"; fi
    "$KW" --file kwinrulesrc --group General --key rules "$newrules"
    cnt=$("${KR:-true}" --file kwinrulesrc --group General --key count 2>/dev/null || true)
    "$KW" --file kwinrulesrc --group General --key count "$(( ${cnt:-0} + 1 ))"
    ;;
esac
"$KW" --file kwinrulesrc --group "$DOTA_RULE" --key Description "Dota 2 - block compositing"
"$KW" --file kwinrulesrc --group "$DOTA_RULE" --key wmclass "dota2"
"$KW" --file kwinrulesrc --group "$DOTA_RULE" --key wmclasscomplete "false"
"$KW" --file kwinrulesrc --group "$DOTA_RULE" --key wmclassmatch "1"
"$KW" --file kwinrulesrc --group "$DOTA_RULE" --key blockcompositing "true"
"$KW" --file kwinrulesrc --group "$DOTA_RULE" --key blockcompositingrule "2"

# Apply the kwinrc change live (no logout needed).
if command -v qdbus >/dev/null 2>&1; then
  qdbus org.kde.KWin /KWin reconfigure >/dev/null 2>&1 || true
fi

echo "setup-kde: done."
