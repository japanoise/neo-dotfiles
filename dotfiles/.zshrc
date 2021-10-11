# -*- indent-tabs-mode: t; sh-indentation: 8; sh-basic-offset: 8; -*-

# Add $HOME/bin into the path - do this first so it'll be available in tramp.
if [[ "$PATH" != *"$HOME/bin"* ]]
then
	export PATH="$PATH:$HOME/bin"
fi

# Fix for tramp - see https://www.emacswiki.org/emacs/TrampMode#toc9
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ ' && return

# Make M-DEL and friends a bit more useful
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# do this before compinit
# explicitly set LS_COLORS to something sane (changed is ow, to sth readable)
LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=95:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:';
export LS_COLORS

fpath=( "$HOME/.zfunctions" $fpath )
# Various fixes/magic
autoload -U promptinit && promptinit
autoload -Uz compinit
# Colors - arch wiki
autoload -Uz colors && colors
zmodload -i zsh/complist
# Compinstall and zsh-newuser-install
zstyle ':completion:*' completer _expand _complete _ignored _match _correct _approximate _prefix
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select=1
zstyle ':completion:*' original true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename "$HOME/.zshrc"

compinit -i
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

# Get "plugins" and such installed
if ! prompt -l | grep -q pure
then
	mkdir -pv "$HOME/.zfunctions"
	git clone https://github.com/sindresorhus/pure "$HOME/builds/pure"
	ln -v -s "$HOME/builds/pure/pure.zsh" "$HOME/.zfunctions/prompt_pure_setup"
	ln -v -s "$HOME/builds/pure/async.zsh" "$HOME/.zfunctions/async"
fi
if [ ! -d $HOME/builds/zsh-syntax-highlighting ]
then
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/builds/zsh-syntax-highlighting"
fi

# Setup prompt
autoload -U promptinit; promptinit
PS2="%{$fg[yellow]%}%_ %{%B$fg[blue]%b%}>%{$reset_color%}"
if [ "$TERM" = "linux" ]
then
	PURE_PROMPT_SYMBOL='>'
	PURE_PROMPT_VICMD_SYMBOL='<'
	PURE_GIT_DOWN_ARROW='V'
	PURE_GIT_UP_ARROW='^'
fi
prompt pure
RPROMPT=$'%(?..%{$fg_bold[red]%}%?%{$reset_color%})'

# Nice aliases and functions
stty -ixon
# Ubuntu - if command_not_found is installed, this helps us find packages for
# commands we don't yet have installed.
if [[ -s '/etc/zsh_command_not_found' ]]; then
	source '/etc/zsh_command_not_found'
fi
# Arch - Same thing with pkgfile
if [[ -s '/usr/share/doc/pkgfile/command-not-found.zsh' ]]; then
	source '/usr/share/doc/pkgfile/command-not-found.zsh'
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
	# so, se: reverse-video for status line
	# mb, md, me: blue for titles
	# us, ue: underline for highlights
	LESS_TERMCAP_so=$(printf "\e[1;7m") \
	LESS_TERMCAP_se=$(printf "\e[0m") \
	LESS_TERMCAP_mb=$(printf "\e[1;34m") \
	LESS_TERMCAP_md=$(printf "\e[1;34m") \
	LESS_TERMCAP_me=$(printf "\e[0m") \
	LESS_TERMCAP_us=$(printf "\e[4;36m") \
	LESS_TERMCAP_ue=$(printf "\e[0m") \
	/usr/bin/man "$@"
}

alias clip-copy="xsel -b -i"
alias clip-paste="xsel -b -o"
alias grep="grep --color=auto"

if [ "$(uname)" = Darwin ]
then
	alias ls="gls --color"
	export MAKEFLAGS=-j$(($(sysctl -n hw.physicalcpu) + 1))
	# in case that doesn't work:
	alias fastmake="make -j$(($(sysctl -n hw.physicalcpu) + 1))"
	# oh fine
	alias nproc="sysctl -n hw.physicalcpu"
else
	alias ls="ls --color"
	export MAKEFLAGS=-j$(($(nproc) + 1))
	# in case that doesn't work:
	alias fastmake="make -j$(($(nproc) + 1))"
fi

alias l="ls -l"
alias lh="ls -lh"
alias adb="sudo adb"
alias em="gomacs"
alias gti="git"
alias gam='VISUAL=true git commit --amend'
alias prettyjson='jq .'
alias wg="wordgrinder"
alias tb="nc termbin.com 9999"

mkcd() {
	mkdir "$1" && cd "$1"
}

jsonvalid() {
	jq . < "$1" >/dev/null
}

jsonfmt() {
	for arg in "$@"
	do
		jsonvalid "$arg" || return 1
		prettyjson < "$arg" | sponge "$arg"
	done
}

minjson() {
	for arg in "$@"
	do
		jsonvalid "$arg" || return 1
		jq -c . < "$arg" | sponge "$arg"
	done
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
			*.bak) mv -v "$arg" "$(basename -s.bak $arg)";;
			*) mv -v "$arg"{.bak,};;
		esac
	done
}

findbyshebang() {
	if [ -z "$1" ] || [ -z "$2" ]
	then
		echo "Usage: $0 <path> <filetype>" >&2
		return 1
	fi
	find "$1" -type f -exec awk '
	  /^#!.*\/'"$2"'/{print FILENAME}
	  {nextfile}' {} +
}

pass() {
	case $1 in
		pull) rsync -u -h --progress gotama:~/Passwords.kdbx "$HOME"/Passwords.kdbx;;
		push) rsync -u -h --progress "$HOME"/Passwords.kdbx gotama:~/Passwords.kdbx;;
		bak) cp -v "$HOME"/Passwords.kdbx "$HOME"/Passwords.kdbx.bak;;
		unbak) mv -v -i "$HOME"/Passwords.kdbx.bak "$HOME"/Passwords.kdbx;;
		*) echo "Unknown command $1"; return 1;;
	esac
}

wiki() {
	mkdir -pv "$HOME"/Downloads/wiki
	mkdir -pv "$HOME"/Downloads/campaign-wiki
	case $1 in
		pull)
			rsync -u -r -h --progress gotama:/var/www/wiki/campaign "$HOME"/Downloads/campaign-wiki
			rsync -u -r -h --progress gotama:/var/www/wiki/ "$HOME"/Downloads/wiki/;;
		push)
			rsync -u -r -h --progress "$HOME"/Downloads/campaign-wiki/ gotama:/var/www/wiki/campaign/
			rsync -u -r -h --progress "$HOME"/Downloads/wiki/ gotama:/var/www/wiki/;;
		open) xdg-open file://"$HOME"/Downloads/wiki/index.html;;
		size) ls -lh "$HOME"/Downloads/wiki/index.html;;
		*) echo "Unknown command $1"; return 1;;
	esac
}

ao3up() {
	markdown "$1" | clip-copy
	echo "OK, rendered HTML copied to clipboard"
}

md5nam() {
	for file in "$@"
	do
		if ! [ -f "$file" ]
		then
			continue
		fi
		md5=$(md5sum "$file" | sed -e 's/\(\[A-Fa-f0-9\]\)* .*/\1/')
		ext="bin"
		case "$(file -bi "$file")" in
			image/jpeg* )
				ext="jpg";;
			image/png* )
				ext="png";;
			image/gif* )
				ext="gif";;
			video/webm* )
				ext="webm";;
			video/mp4* )
				ext="mp4";;
			*)
				# unsupported
				echo "Warning: no extension for file $file ($md5) was found, so not bothering."
				echo "Output of file -bi: $(file -bi "$file")"
				continue;;
		esac
		mv -i "$file" "$(dirname "$file")/${md5}.${ext}"
	done
}

# gomacs doesn't support the +ln syntax, so simplify LESSEDIT
export LESSEDIT="%E %f"

if [ -f ~/.zshrc-local ]; then source ~/.zshrc-local; fi #put machine-specific path, aliases etc. here
# Upstream will whinge if this isn't last ;)
source "$HOME/builds/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
