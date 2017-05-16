#!/bin/sh
message () {
	printf "\n"
	printf "### %s ###\n" "$*"
}
fatal() {
	message "$*"
	exit 1
}
dependency() {
	if ! which "$1"; then
		fatal "Please install $1"
	fi
}

message "Creating directories..."
mkdir -pv "$HOME/builds"
mkdir -pv "$HOME/repos"
mkdir -pv "$HOME/bin"

message "Checking dependencies..."
DEPS="git zsh emacs emacsclient fortune curl make"
for DEP in $DEPS
do
	dependency "$DEP"
done

message "Installing zsh..."
mkdir -pv "$HOME/.zfunctions"
git clone https://github.com/sindresorhus/pure "$HOME/builds/pure"
ln -v -s "$HOME/builds/pure/pure.zsh" "$HOME/.zfunctions/prompt_pure_setup"
ln -v -s "$HOME/builds/pure/async.zsh" "$HOME/.zfunctions/async"
if [ ! -f "$HOME/.zshrc-local" ]
then
	echo 'export PATH=$PATH:'"$HOME"'/bin/' >> "$HOME/.zshrc-local"
	echo 'fortune login' >> "$HOME/.zshrc-local"
fi
cp -v dotfiles/.zshrc "$HOME/.zshrc"
echo "Changing shell to $(which zsh) (password required)"
chsh -s "$(which zsh)"

message "Installing fortune files..."
git clone https://github.com/japanoise/textfiles "$HOME/repos/textfiles"
cd "$HOME/repos/textfiles/fortunes"
sudo ./install.sh
cd -

message "Installing scripts..."
cp -v bin/* "$HOME/bin"

if [ -f "$HOME/.spacemacs" ]
then
	message "Skipping spacemacs (probably already installed)"
else
	message "Installing spacemacs..."
	if [ -d "$HOME/.emacs.d" ]
	then
		mv -v "$HOME/.emacs.d" "$HOME/.emacs.d.bak"
	fi
	git clone https://github.com/syl20bnr/spacemacs "$HOME/.emacs.d"
	cp -v dotfiles/.spacemacs "$HOME/.spacemacs"
fi

message "Installing micro..."
if ! which micro
then
	message "Compiling micro from source..."
	(
	go get -d github.com/zyedidia/micro/...
	cd "$GOPATH/src/github.com/zyedidia/micro"
	make install
	)
fi
mkdir -pv "$HOME/.config/micro"
cp -v -R -n dotfiles/micro/* "$HOME/.config/micro/"
