#!/bin/bash

# Function to create or switch to a tmux session
create_or_switch_session() {
    local dir_name=$(basename "$1")
    local session_name="${dir_name//[^a-zA-Z0-9]/_}"
    if ! /opt/homebrew/bin/tmux has-session -t="$session_name" 2>/dev/null; then
        /opt/homebrew/bin/tmux new-session -d -s "$session_name" -c "$1"
    else
        echo "Session $session_name already exists"
    fi
    if [ -z "$TMUX" ]; then
        /opt/homebrew/bin/tmux attach-session -t "$session_name"
    else
        /opt/homebrew/bin/tmux switch-client -t "$session_name"
    fi
}

# Use fzf to select a directory, limiting search to specific directories
echo "Select a directory to open in a new tmux session"
echo "Or press Ctrl+C or Esc to cancel"
selected_dir=$(find ~/Desktop/work ~/Desktop/dotfiles -maxdepth 1 -mindepth 1 -type d | /opt/homebrew/bin/fzf --height 40% --reverse --preview 'exa --icons --color=always {}')

if [ -n "$selected_dir" ]; then
    create_or_switch_session "$selected_dir"
else
    echo "No directory selected"
fi

# If we're in Kitty, we need to tell it to close the overlay
if [ -n "$KITTY_WINDOW_ID" ]; then
    kitty @ close-window --self
fi
