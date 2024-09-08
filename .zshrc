# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=110000
SAVEHIST=100000
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/suyash/.zshrc'

. "$HOME/.asdf/asdf.sh"

# Optimize compinit
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
# End of lines added by compinstall

[ -f "${ZDOTDIR}/home/${USER}/zsh/optionrc" ] && source "${ZDOTDIR}/home/${USER}/zsh/optionrc"
[ -f "${ZDOTDIR}/home/${USER}/zsh/pluginrc" ] && source "${ZDOTDIR}/home/${USER}/zsh/pluginrc"

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases 
alias lg="lazygit"
alias ai="mods --no-cache"
alias ais="mods"
alias aic="mods -m codellama:7b --no-cache -f"
alias aigpt="mods -m gpt-3.5-turbo --no-cache -f"
alias prisma-migrate="npx prisma migrate dev --name init"
alias fman='compgen -c | fzf | xargs man'
alias n="nvim"
alias ls="exa --icons --color=always --group-directories-first"
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
alias dotfiles='cd ~/Desktop/dotfiles/'
alias nvim-adib="NVIM_APPNAME=nvim-adib nvim"
alias nvim-d="NVIM_APPNAME=nvim-d nvim"
alias countlines="tokei ."
alias ta="tmux attach"
alias tkill="tmux kill-session -t"
alias tl="tmux list-sessions"
alias brightup="sudo brightnessctl set +10%"
alias brightdown="sudo brightnessctl set 10%-"
alias work="timer 60m && notify-send 'Pomodoro' 'Work Timer is up! Take a Break 😊'"
alias rest="timer 10m && notify-send 'Pomodoro' 'Break is over! Get back to work 😬'"

##install logo-ls from https://terminalroot.com/install-a-ls-command-that-shows-file-icons/
# alias ls="logo-ls"
##https://www.omgubuntu.co.uk/2017/07/add-bling-ls-bash-command-colorls
# alias ls="colorls -r --group-directories-first --color=always"

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

function sesh-sessions() {
  {
    exec </dev/tty
    exec <&1
    local session
    session=$(sesh list -t -c | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
    [[ -z "$session" ]] && return
    sesh connect $session
  }
}

zle     -N             sesh-sessions
bindkey -M emacs '\es' sesh-sessions
bindkey -M vicmd '\es' sesh-sessions
bindkey -M viins '\es' sesh-sessions

function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# IP address lookup
alias whatismyip="whatsmyip"
function whatsmyip ()
{
    # Internal IP Lookup
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
export PATH="/usr/bin/git:$PATH"
export PATH="/usr/bin/curl:$PATH"
export PATH="$PATH:/opt/nvim-linux64/bin"

# This is for go tour locally
export PATH=$PATH:~/go/bin

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

# Lazy-load NVM for potential performance improvement
export NVM_DIR="$HOME/.nvm"

# Add the npm and node binaries to the PATH
# Replace v14.17.0 with the version you have installed
export PATH="$NVM_DIR/versions/node/v20.14.0/bin:$PATH"

nvm() {
    unset -f nvm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    nvm "$@"
}

# neofetch --ascii ~/.config/neofetch/ascii.txt
# neofetch
source ~/.secrets
# # Start SSH agent
# eval "$(ssh-agent -s)"
#
# # Add your SSH private key
# ssh-add ~/.ssh/id_ed25519
