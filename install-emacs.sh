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
go install github.com/rogpeppe/godef@latest
go install golang.org/x/tools/cmd/goimports@latest
go install golang.org/x/tools/cmd/gorename@latest
go install golang.org/x/tools/gopls@latest
go install github.com/nsf/gocode@latest

echo "cloning dotemacs..."
git clone ssh://git@github.com/japanoise/neo-dotemacs "$HOME"/.emacs.d

echo "first run, exit once packages are installed (C-x C-c)"
emacs

configDir="$XDG_CONFIG_HOME"
if [ -z "$configDir" ]
then
    configDir="$HOME"/.config
fi

echo "checking init..."
if file "$(which init)" | grep -q systemd
then
	echo "installing systemd startup hook..."
	mkdir -pv "$configDir"/systemd/user/
	cat > "$configDir"/systemd/user/emacsd.service <<EOF
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
elif file "$(which init)" | grep -q openrc
then
    echo "installing openrc user script..."
    mkdir -pv "$configDir"/rc/init.d/
    cat > "$configDir"/rc/init.d/emacsd <<'EOF'
#!/sbin/openrc-run

name=$RC_SVCNAME
description="Emacs: the extensible, self-documenting text editor"
command="/usr/bin/emacs"
command_args="--daemon"
pidfile="undefined"

stop() {
	ebegin "Stopping $RC_SVCNAME"
	/usr/bin/emacsclient --eval "(progn (setq kill-emacs-hook nil) (kill-emacs))"
	eend $?
}
EOF
    chmod +x "$configDir"/rc/init.d/emacsd
    rc-update --user add emacsd default
    rc-service --user emacsd start
    echo "OK, if that all went well, you should now have an emacs server running."
    echo "'rc-service --user emacsd restart' to restart it."
else
	echo "congratulations, your system isn't infected with systemd!"
	echo "unfortunately, you're not using openrc either."
	echo "this means you're on your own installing the init script."
	echo "the start command should be:"
	echo "/usr/bin/emacs --daemon"
	echo "and the stop command:"
	echo '/usr/bin/emacsclient --eval "(progn (setq kill-emacs-hook nil) (kill-emacs))"'
fi
