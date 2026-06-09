#!/usr/bin/env bash

SESSION="$1"
DIR="$2"

tmux new-session -d -s "$SESSION" -c "$DIR" -n editor
tmux send-keys -t "$SESSION:editor" 'nvim' C-m

tmux new-window -t "$SESSION" -c "$DIR" -n server
tmux new-window -t "$SESSION" -c "$DIR" -n logs

tmux select-window -t "$SESSION:editor"
