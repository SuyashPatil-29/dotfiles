# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=110000
SAVEHIST=100000
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/suyash/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

[ -f "${ZDOTDIR}/home/suyash/zsh/optionrc" ] && source "${ZDOTDIR}/home/suyash/zsh/optionrc"
[ -f "${ZDOTDIR}/home/suyash/zsh/pluginrc" ] && source "${ZDOTDIR}/home/suyash/zsh/pluginrc"

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases 
alias prisma-migrate="npx prisma migrate dev --name init"
alias fman='compgen -c | fzf | xargs man'
alias n="nvim ."
alias ls="exa"
alias tmux="tmux -u"
alias c="clear"
alias compile='function compile() { unsetopt promptcr; g++ "$1" -o "${1:r}" && ./"${1:r}" && rm -f "${1:r}" 2>/dev/null; }; compile'
alias tmux="tmux -u"
alias tn="tmux new -As \$(basename \$(pwd))"
alias entersql="sudo mysql -u root -p"
alias nv='fd --type f --hidden --exclude .git | fzf-tmux -p | xargs nvim'
alias nvconf="nvim ~/.config/nvim/"
alias kconf="nvim ~/.config/kitty/kitty.conf"
alias tconf="nvim ~/.tmux.conf"
alias zconf="nvim ~/.zshrc"
alias tkill="tmux kill-session -t"
alias tlist="tmux list-sessions"
alias tattach="tmux attach"
alias dotfiles='cd ~/Desktop/dotfiles/'
alias nvim-adib="NVIM_APPNAME=nvim-adib nvim"
alias countlines="tokei ."
alias ta="tmux attach"

# Replace batcat with cat on Fedora as batcat is not available as a RPM in any form
if command -v lsb_release > /dev/null; then
    DISTRIBUTION=$(lsb_release -si)

    if [ "$DISTRIBUTION" = "Fedora" ]; then
        alias cat='bat'
    else
        alias cat='batcat'
    fi
fi


jrun() {
    # Check if a Java file is provided as an argument
    if [ $# -eq 0 ]; then
        echo "Usage: jrun filename.java"
        return 1
    fi

    # Extract the filename without extension
    filename=$(basename "$1" .java)

    # Compile the Java file
    javac "$1" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Compilation failed."
        return 1
    fi

    # Run the compiled Java program, filtering out messages related to trashing the .class file
    java "$filename" 2>&1 | grep -v 'trash:'

    # Remove the compiled .class file, suppressing the "trash" message
    rm "$filename.class" > /dev/null 2>&1
}

# IP address lookup
alias whatismyip="whatsmyip"
function whatsmyip ()
{
	# Dumps a list of all IP addresses for every device
	# /sbin/ifconfig |grep -B1 "inet addr" |awk '{ if ( $1 == "inet" ) { print $2 } else if ( $2 == "Link" ) { printf "%s:" ,$1 } }' |awk -F: '{ print $1 ": " $3 }';
	
	### Old commands
	# Internal IP Lookup
	#echo -n "Internal IP: " ; /sbin/ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'
#
#	# External IP Lookup
	#echo -n "External IP: " ; wget http://smart-ip.net/myip -O - -q
	
	# Internal IP Lookup.
	if [ -e /sbin/ip ];
	then
		echo -n "Internal IP: " ; /sbin/ip addr show wlan0 | grep "inet " | awk -F: '{print $1}' | awk '{print $2}'
	else
		echo -n "Internal IP: " ; /sbin/ifconfig wlan0 | grep "inet " | awk -F: '{print $1} |' | awk '{print $2}'
	fi

	# External IP Lookup 
	echo -n "External IP: " ; curl -s ifconfig.me
}

# Copy and go to the directory
cpg ()
{
	if [ -d "$2" ];then
		cp "$1" "$2" && cd "$2"
	else
		cp "$1" "$2"
	fi
}

# Move and go to the directory
mvg ()
{
	if [ -d "$2" ];then
		mv "$1" "$2" && cd "$2"
	else
		mv "$1" "$2"
	fi
}

# Create and go to the directory
mkdirg ()
{
	mkdir -p "$1"
	cd "$1"
}

# List all the available wifi networks using nmcli
wifi_list() {
    nmcli dev wifi list
}

# Connect to a wifi network using nmcli
wifi_connect() {
  if [ -z "$1" ]; then
    echo "Usage: wifi_connect wifi-name wifi-password"
    return 1
  fi
    nmcli dev wifi connect "$1" password "$2"
}

# Disconnect from the current wifi network using nmcli
wifi_disconnect() {
    nmcli dev wifi disconnect
}

# Exports
export XDG_DATA_DIRS="$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:/home/suyash/.local/share/flatpak/exports/share"
export PATH="/usr/local/go/bin:$PATH"
export PATH="$PATH:$HOME/.local/bin"
export OPENAI_API_KEY="Your OpenAI API KEY"
export PATH="/usr/bin/git:$PATH"
export PATH="/usr/bin/curl:$PATH"

eval "$(atuin init zsh)"
eval "$(/home/homebrew/bin/brew shellenv)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# pnpm
export PNPM_HOME="/home/suyash/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
