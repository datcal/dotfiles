# ~/.zshenv — sourced for every zsh (login, interactive, scripts). Keep it minimal.

export PATH="$HOME/.local/bin:$PATH"

# Rust toolchain, only if installed.
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
