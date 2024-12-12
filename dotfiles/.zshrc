# -*- indent-tabs-mode: t; sh-indentation: 8; sh-basic-offset: 8; -*-

# Add $HOME/bin into the path - do this first so it'll be available in tramp.
if [[ "$PATH" != *"$HOME/bin"* ]]
then
	export PATH="$PATH:$HOME/bin"
fi
# Same with cargo
if [[ "$PATH" != *"$HOME/.cargo/bin"* ]]
then
	export PATH="$PATH:$HOME/.cargo/bin"
fi

# Fix for tramp - see https://www.emacswiki.org/emacs/TrampMode#toc9
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ ' && return

# Fuck flow control, all my homies hate flow control
stty -ixon

# Make M-DEL and friends a bit more useful
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# do this before compinit
# explicitly set LS_COLORS to something sane
LS_COLORS='rs=0:di=00;94:ln=00;96:mh=00:pi=40;93:so=00;95:do=00;95:bd=40;93;01:cd=40;93;01:or=40;91;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=95:st=37;44:ex=00;92:*.tar=00;91:*.tgz=00;91:*.arc=00;91:*.arj=00;91:*.taz=00;91:*.lha=00;91:*.lz4=00;91:*.lzh=00;91:*.lzma=00;91:*.tlz=00;91:*.txz=00;91:*.tzo=00;91:*.t7z=00;91:*.zip=00;91:*.z=00;91:*.Z=00;91:*.dz=00;91:*.gz=00;91:*.lrz=00;91:*.lz=00;91:*.lzo=00;91:*.xz=00;91:*.zst=00;91:*.tzst=00;91:*.bz2=00;91:*.bz=00;91:*.tbz=00;91:*.tbz2=00;91:*.tz=00;91:*.deb=00;91:*.rpm=00;91:*.jar=00;91:*.war=00;91:*.ear=00;91:*.sar=00;91:*.rar=00;91:*.alz=00;91:*.ace=00;91:*.zoo=00;91:*.cpio=00;91:*.7z=00;91:*.rz=00;91:*.cab=00;91:*.wim=00;91:*.swm=00;91:*.dwm=00;91:*.esd=00;91:*.jpg=00;95:*.jpeg=00;95:*.mjpg=00;95:*.mjpeg=00;95:*.gif=00;95:*.bmp=00;95:*.pbm=00;95:*.pgm=00;95:*.ppm=00;95:*.tga=00;95:*.xbm=00;95:*.xpm=00;95:*.tif=00;95:*.tiff=00;95:*.png=00;95:*.svg=00;95:*.svgz=00;95:*.mng=00;95:*.pcx=00;95:*.mov=00;95:*.mpg=00;95:*.mpeg=00;95:*.m2v=00;95:*.mkv=00;95:*.webm=00;95:*.ogm=00;95:*.mp4=00;95:*.m4v=00;95:*.mp4v=00;95:*.vob=00;95:*.qt=00;95:*.nuv=00;95:*.wmv=00;95:*.asf=00;95:*.rm=00;95:*.rmvb=00;95:*.flc=00;95:*.avi=00;95:*.fli=00;95:*.flv=00;95:*.gl=00;95:*.dl=00;95:*.xcf=00;95:*.xwd=00;95:*.yuv=00;95:*.cgm=00;95:*.emf=00;95:*.ogv=00;95:*.ogx=00;95:*.aac=00;96:*.au=00;96:*.flac=00;96:*.m4a=00;96:*.mid=00;96:*.midi=00;96:*.mka=00;96:*.mp3=00;96:*.mpc=00;96:*.ogg=00;96:*.ra=00;96:*.wav=00;96:*.oga=00;96:*.opus=00;96:*.spx=00;96:*.xspf=00;96:';
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

# Terminals that only support 8 colors (and, usually, no unicode)
if [ "$(echotc Co)" = 8 ]
then
	# Use bright colors - needs to work around a hack zsh does
	# with the default color.
	zle_highlight=(fg_default_code:"2m\e[39"; fg_start_code:"\e[9")
	# ascii prompt(s)
	PURE_PROMPT_SYMBOL='>'
	PURE_PROMPT_VICMD_SYMBOL='<'
	PURE_GIT_DOWN_ARROW='v'
	PURE_GIT_UP_ARROW='^'
	# IT'S PINK!
	zstyle :prompt:pure:git:dirty color 5
	# These are grey
	zstyle :prompt:pure:git:action color 0
	zstyle :prompt:pure:git:branch color 0
	zstyle :prompt:pure:host color 0
	zstyle :prompt:pure:user color 0
	zstyle :prompt:pure:virtualenv color 0
	zstyle :prompt:pure:prompt:continuation color 0
	# add missing highlighting
	typeset -A ZSH_HIGHLIGHT_STYLES
	ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=1'
	ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=1'
	ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg=1'
	ZSH_HIGHLIGHT_STYLES[assign]='fg=6'
	ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=6'
else
	# make prompt/highlight more readable on dark terminals with VGA colors
	# https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg
	zstyle :prompt:pure:prompt:success color 13
	zstyle :prompt:pure:prompt:error color 9
	zstyle :prompt:pure:path color 12
	zstyle :prompt:pure:git:action color 8
	zstyle :prompt:pure:git:branch color 8
	zstyle :prompt:pure:git:arrow color 14
	zstyle :prompt:pure:git:action color 8
	zstyle :prompt:pure:git:dirty color 13
	typeset -A ZSH_HIGHLIGHT_STYLES
	ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=9'
	ZSH_HIGHLIGHT_STYLES[redirection]='fg=11'
	ZSH_HIGHLIGHT_STYLES[globbing]='fg=12'
	ZSH_HIGHLIGHT_STYLES[command]='fg=10'
	ZSH_HIGHLIGHT_STYLES[alias]='fg=10,bold'
	ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=11'
	ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=11'
	ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=11'
	# Generally useful - highlight unclosed arguments
	ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=9'
	ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=9'
	ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg=9'
	# Other stuff not highlighted by default
	ZSH_HIGHLIGHT_STYLES[assign]='fg=14'
	ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=6'
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
	LESS_TERMCAP_so=$(printf "\e[7m") \
	LESS_TERMCAP_se=$(printf "\e[0m") \
	LESS_TERMCAP_mb=$(printf "\e[94m") \
	LESS_TERMCAP_md=$(printf "\e[94m") \
	LESS_TERMCAP_me=$(printf "\e[0m") \
	LESS_TERMCAP_us=$(printf "\e[4;96m") \
	LESS_TERMCAP_ue=$(printf "\e[0m") \
	GROFF_NO_SGR=1 \
	command man "$@"
}

alias clip-copy="xsel -b -i"
alias clip-paste="xsel -b -o"
alias grep="grep --color=auto"

# Make MacOS feel more comfortable
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

	# Believe it or not, I ended up basically re-inventing the
	# homebrew UX from first principles.  cmd subcmd is just a
	# good way to design a package manager.  So, aliasing brew
	# to my own omniversal package manager works nicely.
	alias brew="brew.sh"
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

# ed - I use it once in a while, nice to have line editing if available.
command -v rlwrap > /dev/null && alias ed="rlwrap ed"

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
	wikidir="$HOME"/tiddly
	wikidest=/home/chameleon/
	mkdir -pv "$wikidir"
	#mkdir -pv "$HOME"/Downloads/campaign-wiki
	case $1 in
		pull)
			#rsync -u -r -h --progress gotama:/var/www/wiki/campaign "$HOME"/Downloads/campaign-wiki
			rsync -u -r -h --progress gotama:"$wikidest"/tiddly "$wikidir";;
		push)
			#rsync -u -r -h --progress "$HOME"/Downloads/campaign-wiki/ gotama:/var/www/wiki/campaign/
			rsync -u -r -h --progress "$wikidir" gotama:"$wikidest";;
		open) xdg-open file://"$wikidir"/wiki/private/index.html;;
		size) ls -lh "$wikidir"/wiki/private/index.html;;
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
		case "$(file -b --mime "$file")" in
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
				echo "Output of file -b --mime: $(file -b --mime "$file")"
				continue;;
		esac
		mv -i "$file" "$(dirname "$file")/${md5}.${ext}"
	done
}

# gomacs doesn't support the +ln syntax, so simplify LESSEDIT
export LESSEDIT="%E %f"

# Make sure rlwrap doesn't drop turds in home directory
export RLWRAP_HOME="$HOME/.config/rlwrap/"

# Using bat more and more, might as well make the theme friendly
export BAT_THEME=ansi

if [ -f ~/.zshrc-local ]; then source ~/.zshrc-local; fi #put machine-specific path, aliases etc. here
# Upstream will whinge if this isn't last ;)
source "$HOME/builds/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
