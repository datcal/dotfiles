# ~/.zprofile — sourced for login zsh shells. Mirrors ~/.profile's PATH setup.

if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

export PATH
