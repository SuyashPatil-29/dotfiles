#!/bin/bash

# Define the config files and their paths in the specified order
declare -A configs
configs=(
  ["1. neovim"]="$HOME/.config/nvim/"
  ["2. .zshrc"]="$HOME/.zshrc"
  ["3. kitty"]="$HOME/.config/kitty/kitty.conf"
  ["4. tmux"]="$HOME/.tmux.conf"
  ["5. i3"]="$HOME/.config/i3/config"
  ["6. polybar"]="$HOME/.config/polybar/config"
)

# Create the menu options
menu=""
for key in "${!configs[@]}"; do
  menu+="$key\n"
done
menu+="7. Exit"

# Show Rofi menu and get user selection
chosen=$(echo -e "$menu" | rofi -dmenu -i -p "Select config file to edit:")

# If a valid option was selected, open the config file
if [[ -n "$chosen" && -n "${configs[$chosen]}" ]]; then
  kitty -e nvim "${configs[$chosen]}"
elif [[ "$chosen" == "7. Exit" ]]; then
  exit 0
else
  notify-send "Invalid selection or cancelled"
fi
