#!/bin/sh
for dep in go emacs git
do
	if ! command -v "$dep"
	then
		echo "$dep not found. You can use 'just', or your distro's package manager, to install it."
		exit 1
	fi
done

echo "go-mode dependencies..."
go get -u -v github.com/nsf/gocode github.com/godoctor/godoctor golang.org/x/tools/cmd/goimports github.com/rogpeppe/godef golang.org/x/tools/cmd/gorename

echo "cloning dotemacs..."
git clone ssh://git@github.com/japanoise/neo-dotemacs "$HOME"/.emacs.d

echo "first run, exit once packages are installed (C-x C-c)"
emacs

echo "checking for systemd..."
if file "$(which init)" | grep -q systemd
then
	echo "installing systemd startup hook..."
	mkdir -pv "$HOME"/.config/systemd/user/
	cat > "$HOME"/.config/systemd/user/emacsd.service <<EOF
[Unit]
Description=Emacs: the extensible, self-documenting text editor
Documentation=man:emacs(1) info:Emacs

[Service]
Type=forking
ExecStart=/usr/bin/emacs --daemon
ExecStop=/usr/bin/emacsclient --eval "(progn (setq kill-emacs-hook nil) (kill-emacs))"
Restart=on-failure
Environment=DISPLAY=:%i
TimeoutStartSec=0

[Install]
WantedBy=default.target
EOF
	systemctl --user enable emacsd
	systemctl --user start emacsd
	echo "OK, if that all went well, you should now have an emacs server running."
	echo "'systemctl --user restart emacsd' to restart it."

else
	echo "congratulations, your system isn't infected!"
	echo "however, this means you're on your own installing the init script."
	echo "the start command should be:"
	echo "/usr/bin/emacs --daemon"
	echo "and the stop command:"
	echo '/usr/bin/emacsclient --eval "(progn (setq kill-emacs-hook nil) (kill-emacs))"'
fi
