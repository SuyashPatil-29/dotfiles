#!/bin/bash

# Enable debugging
set -x

# Function to create or switch to a tmux session
create_or_switch_session() {
    local dir_name=$(basename "$1")
    local session_name="${dir_name//[^a-zA-Z0-9]/_}"

    if ! tmux has-session -t="$session_name" 2>/dev/null; then
        tmux new-session -d -s "$session_name" -c "$1"
    else
        echo "Session $session_name already exists"
    fi

    if [ -z "$TMUX" ]; then
        tmux attach-session -t "$session_name"
    else
        tmux switch-client -t "$session_name"
    fi
}

# Use fzf to select a directory, limiting search to ~/Desktop
selected_dir=$(find ~/Desktop/work/ ~/Desktop/web-dev/ ~/Desktop/dotfiles/ ~/Desktop/dotfiles/.config/ -maxdepth 1 -mindepth 1 -type d | fzf --height 40% --reverse --preview 'exa --icons --color=always {}')
if [ -n "$selected_dir" ]; then
    create_or_switch_session "$selected_dir"
else
    echo "No directory selected"
fi

# If we're in Kitty, we need to tell it to close the overlay
if [ -n "$KITTY_WINDOW_ID" ]; then
    kitty @ close-window --self
fi

# Disable debugging
set +x
