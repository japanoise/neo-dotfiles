# Add $HOME/bin into the path - do this first so it'll be available in tramp.
if [[ "$PATH" != *"$HOME/bin"* ]]
then
	export PATH="$PATH:$HOME/bin"
fi

# Fix for tramp - see https://www.emacswiki.org/emacs/TrampMode#toc9
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ ' && return

# Make M-DEL and friends a bit more useful
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

fpath=( "$HOME/.zfunctions" $fpath )
# Various fixes/magic
autoload -U promptinit && promptinit
autoload -Uz compinit
# Colors - arch wiki
autoload -Uz colors && colors
zmodload -i zsh/complist
# Compinstall and zsh-newuser-install
zstyle ':completion:*' completer _expand _complete _ignored _match _correct _approximate _prefix
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select=1
zstyle ':completion:*' original true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename "$HOME/.zshrc"

compinit
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd PROMPT_SUBST
unsetopt beep extendedglob nomatch notify
# Keys - oh-my-zsh + modifications
# includes home and end :^)
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init() {
    echoti smkx
  }
  function zle-line-finish() {
    echoti rmkx
  }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

bindkey -e                                            # Use emacs key bindings

bindkey '\ew' kill-region                             # [Esc-w] - Kill from the cursor to the mark
bindkey '^r' history-incremental-search-backward      # [Ctrl-r] - Search backward incrementally for a specified string. The string may begin with ^ to anchor the search to the beginning of the line.
# I don't like fuzzyfind so I've removed it
# [Up-Arrow] - history up
if [[ "${terminfo[kcuu1]}" != "" ]]; then
  bindkey "${terminfo[kcuu1]}" up-line-or-history
fi
# [Down-Arrow] - history down
if [[ "${terminfo[kcud1]}" != "" ]]; then
  bindkey "${terminfo[kcud1]}" down-line-or-history
fi

if [[ "${terminfo[khome]}" != "" ]]; then
  bindkey "${terminfo[khome]}" beginning-of-line      # [Home] - Go to beginning of line
fi
if [[ "${terminfo[kend]}" != "" ]]; then
  bindkey "${terminfo[kend]}"  end-of-line            # [End] - Go to end of line
fi

bindkey ' ' magic-space                               # [Space] - do history expansion

bindkey '^[[1;5C' forward-word                        # [Ctrl-RightArrow] - move forward one word
bindkey '^[[1;5D' backward-word                       # [Ctrl-LeftArrow] - move backward one word

bindkey "${terminfo[kbs]}" backward-delete-char                     # [Backspace] - delete backward
bindkey  '^[[3~' delete-char            # [Delete] - delete forward
PS2="%{$fg[yellow]%}%_ %{%B$fg[blue]%b%}>%{$reset_color%}"
autoload -U promptinit; promptinit
prompt pure
RPROMPT=$'%(?..%{$fg_bold[red]%}%?%{$reset_color%})'
# Nice aliases and functions
stty -ixon
# Ubuntu - if command_not_found is installed, this helps us find packages for
# commands we don't yet have installed.
if [[ -s '/etc/zsh_command_not_found' ]]; then
    source '/etc/zsh_command_not_found'
fi
pastebin () {
    if [ "$*" ]; then
        local prompt="$(PS1="$PS1" bash -i <<<$'\nexit' 2>&1 | head -n1)"
        ( echo "$(sed 's/\o033\[[0-9]*;[0-9]*m//g'  <<<"$prompt")$@"; exec $@; )
    else
        cat
    fi | curl -F 'sprunge=<-' http://sprunge.us
}
uguu(){
	curl -i -F name="$1" -F file=@"$1" https://lewd.se/api.php?d=upload-tool
	printf "\n"
}
man() {
	# First line: reverse-video for status line
	# Second line: blue for titles
	# Third line: cyan underline for highlights
	LESS_TERMCAP_se=$(printf "\e[0m") LESS_TERMCAP_so=$(printf "\e[1;7m") \
	LESS_TERMCAP_mb=$(printf "\e[1;34m") LESS_TERMCAP_md=$(printf "\e[1;34m") LESS_TERMCAP_me=$(printf "\e[0m")\
	LESS_TERMCAP_us=$(printf "\e[4;36m") LESS_TERMCAP_ue=$(printf "\e[0m") \
	/usr/bin/man "$@"
}
alias ls="ls --color"
alias l="ls -l"
alias lh="ls -lh"
alias adb="sudo adb"
alias em="gomacs"
alias gti="git"
alias gam='VISUAL=/bin/true git commit --amend'
alias prettyjson='python -m json.tool'
alias wg="wordgrinder"
jsonfmt() {
    prettyjson < "$1" | sponge "$1"
}
minjson() {
    jq -c . < "$1" | sponge "$1"
}
bak() {
    for arg in "$@"
    do
	mv -v "$arg"{,.bak}
    done
}
unbak() {
    for arg in "$@"
    do
	case "$arg" in
	    *.bak) mv -v "$arg" $(basename -s.bak $arg);;
	    *) mv -v "$arg"{.bak,};;
	esac
    done
}
# gomacs doesn't support the +ln syntax, so simplify LESSEDIT
export LESSEDIT="%E %f"
if [ -f ~/.zshrc-local ]; then source ~/.zshrc-local; fi #put machine-specific path, aliases etc. here
alias tb="nc termbin.com 9999"
