if [ -z "$JAPLOADED" ]
then
	export JAPLOADED="YES"
	export PATH="$PATH:$HOME/bin"
	export EDITOR="$HOME/bin/gomacs"
	export VISUAL="$HOME/bin/gomacs"
fi
alias em=gomacs
export PROMPT_COMMAND='echo -en "\033]0; [ssh] ($(hostname -s)) $(dirs -0)\a"'
source "$HOME/bin/bash_prompt.bash"
