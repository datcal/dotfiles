# ~/.zshrc — interactive zsh configuration.

# --- History -----------------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt append_history share_history hist_ignore_all_dups hist_ignore_space \
       hist_reduce_blanks inc_append_history
setopt auto_cd interactive_comments

# --- zinit plugin manager (self-bootstraps if missing) -----------------------
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ] && command -v git >/dev/null 2>&1; then
    git clone https://github.com/zdharma-continuum/zinit "$ZINIT_HOME"
fi
if [ -f "$ZINIT_HOME/zinit.zsh" ]; then
    source "$ZINIT_HOME/zinit.zsh"

    zinit light zsh-users/zsh-autosuggestions
    zinit light zsh-users/zsh-completions
    zinit light zsh-users/zsh-syntax-highlighting   # must load last
fi

# --- Completion --------------------------------------------------------------
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# --- Prompt: starship --------------------------------------------------------
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# --- Tools -------------------------------------------------------------------
command -v zoxide   >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v atuin    >/dev/null 2>&1 && eval "$(atuin init zsh)"

# fzf key bindings + completion (Debian/Ubuntu ships these paths)
if command -v fzf >/dev/null 2>&1; then
    if fzf --zsh >/dev/null 2>&1; then
        source <(fzf --zsh)
    else
        [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
        [ -f /usr/share/doc/fzf/examples/completion.zsh ]   && source /usr/share/doc/fzf/examples/completion.zsh
    fi
fi

# --- Tool aliases (handle Debian's renamed binaries) -------------------------
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --group-directories-first --icons=auto'
    alias ll='eza -lah --group-directories-first --icons=auto'
    alias la='eza -a --group-directories-first --icons=auto'
    alias lt='eza --tree --level=2 --icons=auto'
else
    alias ls='ls --color=auto'
    alias ll='ls -alF'
    alias la='ls -A'
fi

# bat: real `bat` if present, else Debian's `batcat`
if command -v bat >/dev/null 2>&1; then
    alias cat='bat --paging=never'
elif command -v batcat >/dev/null 2>&1; then
    alias bat='batcat'
    alias cat='batcat --paging=never'
fi

# fd: real `fd` if present, else Debian's `fdfind`
if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
    alias fd='fdfind'
fi

alias grep='grep --color=auto'

# --- Shared aliases (git/nav/etc.) — same file bash uses ---------------------
[ -f "$HOME/.aliases" ] && . "$HOME/.aliases"

. "$HOME/.atuin/bin/env"
